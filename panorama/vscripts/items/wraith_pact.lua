item_wraith_pact_lua = class({})

LinkLuaModifier("modifier_item_wraith_pact_lua", "items/wraith_pact", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_wraith_pact_emitter", "items/wraith_pact", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_wraith_pact_dps", "items/wraith_pact", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_wraith_pact_debuff", "items/wraith_pact", LUA_MODIFIER_MOTION_NONE)


function item_wraith_pact_lua:GetIntrinsicModifierName()
	return "modifier_item_wraith_pact_lua"
end

function item_wraith_pact_lua:OnSpellStart()
	if not IsServer() then return end
	
	self.target_point			= self:GetCursorPosition()
	local caster				= self:GetCaster()
	local duration				= self:GetDuration()
	local aura_radius			= self:GetSpecialValueFor("pact_aura_radius")
	local aura_dps				= self:GetSpecialValueFor("aura_dps")

	if not caster or caster:IsNull() then return end

	if IsValidEntity(self.totem_unit) and self.totem_unit:IsAlive() then
		self.totem_unit:ForceKill(false)
	end

	-- spawn the totem
	self.totem_unit = CreateUnitByName("npc_dota_item_wraith_pact_totem", self.target_point, false, caster, nil, caster:GetTeam())
	self.totem_unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	self.totem_unit:SetOwner(caster)
	self.totem_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = duration})

	-- summons buff
	-- affects damage per second, model scale and max hp
	self.totem_unit:AddAbility("summon_buff")
	local modifier = self.totem_unit:FindModifierByName("modifier_summon_buff")
	if modifier then
		aura_dps = aura_dps * (1 + modifier:GetModifierDamageOutgoing_Percentage() / 100)  -- returns bonus_dmg from summon_buff.lua, probably needs adjusting
	end
	
	-- multicast
	-- affects damage per second, model scale and max hp
	-- timer is because summon buff overrides hp
	Timers:CreateTimer(0.05, function()

		if not IsValidEntity(self.totem_unit) then return end

		local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
		local multicast = 1
		
		if multicast_modifier then
			multicast = multicast_modifier:GetMulticastFactor(self)
			multicast_modifier:PlayMulticastFX(multicast)
		end
		
		self.totem_unit:SetBaseMaxHealth(self.totem_unit:GetBaseMaxHealth() * multicast)
		self.totem_unit:SetHealth(self.totem_unit:GetBaseMaxHealth() * multicast)
		self.totem_unit:SetModelScale(1.0 + 0.25 * multicast)
		aura_dps = aura_dps * multicast

		self.totem_unit:AddNewModifier(self.totem_unit, self, "modifier_item_wraith_pact_emitter", {aura_radius = aura_radius})
		self.totem_unit:AddNewModifier(self.totem_unit, self, "modifier_item_wraith_pact_dps", {aura_radius = aura_radius, aura_dps = aura_dps})
		
	end)

end


-- Item stats for the hero
modifier_item_wraith_pact_lua = class({})

function modifier_item_wraith_pact_lua:IsDebuff() return false end
function modifier_item_wraith_pact_lua:IsHidden() return true end
function modifier_item_wraith_pact_lua:IsPurgable() return false end
function modifier_item_wraith_pact_lua:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_wraith_pact_lua:IsAura() return self:GetElapsedTime() > 1 end
function modifier_item_wraith_pact_lua:GetAuraRadius() return self.aura_radius end
function modifier_item_wraith_pact_lua:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_INVULNERABLE end
function modifier_item_wraith_pact_lua:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_FRIENDLY end
function modifier_item_wraith_pact_lua:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_wraith_pact_lua:GetModifierAura() return "modifier_item_vladmir_aura" end

function modifier_item_wraith_pact_lua:OnCreated(keys)
	local parent = self:GetParent()
	local ability = self:GetAbility()
	
	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	self.bonus_health = ability:GetSpecialValueFor("bonus_health")
	self.bonus_mana = ability:GetSpecialValueFor("bonus_mana")
	self.aura_radius = ability:GetSpecialValueFor("aura_radius")
end

function modifier_item_wraith_pact_lua:OnRefresh(keys)
	self:OnCreated(keys)
end


function modifier_item_wraith_pact_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_MANA_BONUS,
	}
end

function modifier_item_wraith_pact_lua:GetModifierHealthBonus()
	return self.bonus_health
end

function modifier_item_wraith_pact_lua:GetModifierManaBonus()
	return self.bonus_mana
end


-- DPS
modifier_item_wraith_pact_dps = class({})

function modifier_item_wraith_pact_dps:IsHidden() return false end
function modifier_item_wraith_pact_dps:IsDebuff() return false end
function modifier_item_wraith_pact_dps:IsPurgable() return false end
function modifier_item_wraith_pact_dps:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_wraith_pact_dps:OnCreated(keys)
	if not IsServer() then return end
	self.parent = self:GetParent()
	if not self.parent or self.parent:IsNull() then return end

	self.aura_radius = keys.aura_radius
	local aura_dps = keys.aura_dps

	self.damage_table = {
		damage 			= aura_dps,
		damage_type		= DAMAGE_TYPE_MAGICAL,
		damage_flags 	= DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		attacker 		= self.parent,
		ability 		= self.ability,
	}

	-- Particles
	local ambient_pfx = ParticleManager:CreateParticle("particles/items5_fx/wraith_pact_ambient.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
	ParticleManager:ReleaseParticleIndex(ambient_pfx)

	self:StartIntervalThink(1.0)
end

function modifier_item_wraith_pact_dps:OnRefresh(keys)
	self:OnCreated(keys)
end

function modifier_item_wraith_pact_dps:OnIntervalThink()
	if not self or self:IsNull() then return end
	local pulse_pfx = ParticleManager:CreateParticle("particles/items5_fx/wraith_pact_pulses.vpcf", PATTACH_CUSTOMORIGIN, self.parent)
	ParticleManager:SetParticleControl(pulse_pfx, 0, self.parent:GetOrigin())
	ParticleManager:ReleaseParticleIndex(pulse_pfx)
	local enemies = FindUnitsInRadius(self.parent:GetTeamNumber(), self.parent:GetOrigin(), nil, self.aura_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(enemies) do
		if enemy and not enemy:IsNull() and enemy:IsAlive() then
			local target_pfx = ParticleManager:CreateParticle("particles/items5_fx/wraith_pact_pulses_target.vpcf", PATTACH_CUSTOMORIGIN, enemy)
			ParticleManager:SetParticleControl(target_pfx, 0, enemy:GetOrigin())
			ParticleManager:ReleaseParticleIndex(target_pfx)
			self.damage_table.victim = enemy
			ApplyDamage(self.damage_table)
		end
	end
end

function modifier_item_wraith_pact_dps:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end

function modifier_item_wraith_pact_dps:GetModifierAvoidDamage(params)
	local health = self.parent:GetHealth()

	if params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then 
		return 1
	end

	local damage = 1
	if params.attacker:IsRealHero() then damage = 2 end

	if health > damage then
		self.parent:SetHealth(health - damage)
	else
		self.parent:Kill(nil, params.attacker)
	end

	return 1
end



-- Outgoing damage reduction
modifier_item_wraith_pact_emitter = class({})

function modifier_item_wraith_pact_emitter:IsHidden() return true end
function modifier_item_wraith_pact_emitter:IsDebuff() return false end
function modifier_item_wraith_pact_emitter:IsPurgable() return false end
function modifier_item_wraith_pact_emitter:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_wraith_pact_emitter:IsAura() return true end
function modifier_item_wraith_pact_emitter:GetAuraRadius() return self.aura_radius end
function modifier_item_wraith_pact_emitter:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_item_wraith_pact_emitter:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_item_wraith_pact_emitter:GetAuraSearchType() return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_item_wraith_pact_emitter:GetModifierAura() return "modifier_item_wraith_pact_debuff" end

function modifier_item_wraith_pact_emitter:OnCreated(keys)
	if not IsServer() then return end
	self.aura_radius = keys.aura_radius or 0
end

function modifier_item_wraith_pact_emitter:OnRefresh(keys)
	self:OnCreated(keys)
end

modifier_item_wraith_pact_debuff = class({})

function modifier_item_wraith_pact_debuff:IsHidden() return false end
function modifier_item_wraith_pact_debuff:IsDebuff() return true end
function modifier_item_wraith_pact_debuff:IsPurgable() return false end

function modifier_item_wraith_pact_debuff:OnCreated(keys)
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end

	self.damage_penalty_aura = ability:GetSpecialValueFor("damage_penalty_aura")
end

function modifier_item_wraith_pact_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_item_wraith_pact_debuff:GetModifierTotalDamageOutgoing_Percentage()
	return -(self.damage_penalty_aura or 0)
end

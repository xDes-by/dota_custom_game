LinkLuaModifier( "modifier_spectre_dispersion_lua", "heroes/hero_spectre/spectre_dispersion_lua/spectre_dispersion_lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_debuff_disp", "heroes/hero_spectre/spectre_dispersion_lua/spectre_dispersion_lua", LUA_MODIFIER_MOTION_NONE )

spectre_dispersion_lua = class({})


function spectre_dispersion_lua:GetIntrinsicModifierName()
	return "modifier_spectre_dispersion_lua"
end

function spectre_dispersion_lua:OnSpellStart()	
	local modifier = self:GetCaster():FindModifierByName("modifier_spectre_dispersion_lua")
	if modifier then
		-- dmg = math.floor(modifier:GetStackCount() / 4)
		dmg = modifier:GetStackCount()
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_spectre_str50") then
			dmg = dmg * 2
		end
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
		for _,enemy in pairs(enemies) do
			local damageTable = {
				victim = enemy,
				attacker = self:GetCaster(),
				damage = dmg,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
				ability = self,
			}
			if self:GetCaster():HasModifier("modifier_step_buff") then
				damageTable.damage = damageTable.damage * 2
			end
			ApplyDamage(damageTable)
		end
		modifier:SetStackCount(0)
	end
end

--------------------------------------------------------------------------------

modifier_spectre_dispersion_lua = class({})

function modifier_spectre_dispersion_lua:OnCreated()
	self:StartIntervalThink(0.2)
end

function modifier_spectre_dispersion_lua:IsHidden()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str10") then
		return false
	end
	return true
end

function modifier_spectre_dispersion_lua:IsPurgable() 			
	return false 
end

function modifier_spectre_dispersion_lua:RemoveOnDeath() 	
	return false 
end

function modifier_spectre_dispersion_lua:DeclareFunctions()
    return {
	MODIFIER_EVENT_ON_TAKEDAMAGE, 
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_EVENT_ON_DEATH,
	MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE_UNIQUE,
	}
end

function modifier_spectre_dispersion_lua:GetModifierHealthRegenPercentageUnique(params)
	local caster = self:GetCaster()
	if caster:FindAbilityByName("npc_dota_hero_spectre_str7") and caster:GetHealth() <= caster:GetMaxHealth() * 0.4 then
		return 7
	end
    return 0
end

function modifier_spectre_dispersion_lua:OnIntervalThink()
	if not IsServer() then return end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str10") then
		self:GetAbility():OnSpellStart()
	end
end

function modifier_spectre_dispersion_lua:OnDeath( params )
	if IsServer() then
		-- dmg = math.ceil(self:GetStackCount() / 4 )
		-- local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
		-- for _,enemy in pairs(enemies) do
		-- 	local damageTable = {
		-- 		victim = enemy,
		-- 		attacker = self:GetParent(),
		-- 		damage = dmg,
		-- 		damage_type = DAMAGE_TYPE_PURE,
		-- 	}
		-- 	ApplyDamage(damageTable)
		-- end
		-- self:SetStackCount(0)
	end
end

function modifier_spectre_dispersion_lua:OnTakeDamage(params)
	if params.unit == self:GetParent() then
		if self:GetParent():PassivesDisabled() or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end
		if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "spectre_dispersion" then return end
		if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "frostivus2018_spectre_active_dispersion"  then return end
		if self:GetParent():HasModifier("modifier_dazzle_shallow_grave_lua") then return end

		local damage_reflection_pct = self:GetAbility():GetSpecialValueFor("damage_reflection_pct")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str_last") then
			damage_reflection_pct = damage_reflection_pct + 35
		end
		if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str10") ~= nil then
			local damage = math.ceil(params.damage / (100 - damage_reflection_pct) * 100)
			self:SetStackCount(self:GetStackCount() + damage)
		end
	end
end

function modifier_spectre_dispersion_lua:GetModifierIncomingDamage_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str_last") then
		self.block = self:GetAbility():GetSpecialValueFor("damage_reflection_pct") + 35
	else
		self.block = self:GetAbility():GetSpecialValueFor("damage_reflection_pct")
	end
	return -self.block
end


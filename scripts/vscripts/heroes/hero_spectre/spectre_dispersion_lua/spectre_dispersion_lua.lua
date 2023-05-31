LinkLuaModifier( "modifier_spectre_dispersion_lua", "heroes/hero_spectre/spectre_dispersion_lua/spectre_dispersion_lua" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_debuff_disp", "heroes/hero_spectre/spectre_dispersion_lua/spectre_dispersion_lua", LUA_MODIFIER_MOTION_NONE )

spectre_dispersion_lua = class({})

modifier_spectre_dispersion_pulse_lua = {}


function spectre_dispersion_lua:GetIntrinsicModifierName()
	return "modifier_spectre_dispersion_lua"
end

function spectre_dispersion_lua:OnSpellStart()
	local modifier = self:GetCaster():FindModifierByName("modifier_spectre_dispersion_lua")
	if modifier then
		-- dmg = math.floor(modifier:GetStackCount() / 4)
		dmg = modifier:GetStackCount()
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
		for _,enemy in pairs(enemies) do
			local damageTable = {
				victim = enemy,
				attacker = self:GetCaster(),
				damage = dmg,
				damage_type = DAMAGE_TYPE_PURE,
				damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
			}
			ApplyDamage(damageTable)
		end
		modifier:SetStackCount(0)
	end
end

--------------------------------------------------------------------------------

modifier_spectre_dispersion_lua = class({})

function modifier_spectre_dispersion_lua:OnCreated()
	self:StartIntervalThink(1.0)
end

function modifier_spectre_dispersion_lua:IsPurgable() 			
	return false 
end

function modifier_spectre_dispersion_lua:RemoveOnDeath() 	
	return false 
end

function modifier_spectre_dispersion_lua:IsPurgeException() 	
	return false 
end

function modifier_spectre_dispersion_lua:IsAura() 
	return true 
end

function modifier_spectre_dispersion_lua:GetModifierAura() 
	return "modifier_spectre_dispersion_lua_debuff" 
end

function modifier_spectre_dispersion_lua:GetAuraRadius()
	return self:GetAbility():GetSpecialValueFor("radius") 
end

function modifier_spectre_dispersion_lua:GetAuraSearchFlags() 
	return DOTA_UNIT_TARGET_FLAG_NONE 
end

function modifier_spectre_dispersion_lua:GetAuraSearchTeam() 
	return DOTA_UNIT_TARGET_TEAM_ENEMY 
end

function modifier_spectre_dispersion_lua:GetAuraSearchType() 
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_spectre_dispersion_lua:DeclareFunctions()
    return {
	MODIFIER_EVENT_ON_TAKEDAMAGE, 
    MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	MODIFIER_EVENT_ON_DEATH
	}
end

function modifier_spectre_dispersion_lua:OnIntervalThink()
	self:GetAbility():OnSpellStart()
end

function modifier_spectre_dispersion_lua:OnDeath( params )
	if IsServer() then
		dmg = math.ceil(self:GetStackCount() / 4 )
		local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetAbility():GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
		for _,enemy in pairs(enemies) do
			local damageTable = {
				victim = enemy,
				attacker = self:GetParent(),
				damage = dmg,
				damage_type = DAMAGE_TYPE_PURE,
			}
			ApplyDamage(damageTable)
		end
		self:SetStackCount(0)
	end
end

function modifier_spectre_dispersion_lua:OnTakeDamage(params)
	if params.unit == self:GetParent() then
		if self:GetParent():PassivesDisabled() or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) == DOTA_DAMAGE_FLAG_REFLECTION or bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) == DOTA_DAMAGE_FLAG_HPLOSS then return end
		
		if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "spectre_dispersion" then return end
		if params.inflictor ~= nil and params.inflictor:GetAbilityName() == "frostivus2018_spectre_active_dispersion"  then return end
		local damage_reflection_pct = self:GetAbility():GetSpecialValueFor("damage_reflection_pct")
		if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str_last") then
			damage_reflection_pct = damage_reflection_pct + 10
		end
		local talent = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int10")
		if talent ~= nil then
			self:SetStackCount(self:GetStackCount() + math.ceil(params.damage / (100 - damage_reflection_pct) * damage_reflection_pct * 2))
		else
			self:SetStackCount(self:GetStackCount() + math.ceil(params.damage / (100 - damage_reflection_pct) * damage_reflection_pct))
		end
	end
end

function modifier_spectre_dispersion_lua:GetModifierIncomingDamage_Percentage()
	local talent = self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_str_last")
	if talent ~= nil and talent:GetLevel() > 0 then
		self.block = (self:GetAbility():GetSpecialValueFor("damage_reflection_pct") + 10) * -1
	else
		self.block = self:GetAbility():GetSpecialValueFor("damage_reflection_pct") * -1
	end
	return self.block
end

modifier_spectre_dispersion_lua_debuff = {}

function modifier_spectre_dispersion_lua_debuff:IsDebuff()
	return true
end

function modifier_spectre_dispersion_lua_debuff:IsHidden()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int11") then
		return false
	end
	return true
end

function modifier_spectre_dispersion_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_spectre_dispersion_lua_debuff:GetModifierMagicalResistanceBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spectre_int11") then
		return -15
	end
	return 0
end
axe_blood_lua = class({})
LinkLuaModifier( "modifier_axe_blood_lua", "heroes/hero_axe/axe_blood_lua/axe_blood_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_blood_lua_armor", "heroes/hero_axe/axe_blood_lua/axe_blood_lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function axe_blood_lua:GetIntrinsicModifierName()
	return "modifier_axe_blood_lua"
end

modifier_axe_blood_lua = class({})

--------------------------------------------------------------------------------
function modifier_axe_blood_lua:IsHidden()
	return true
end

function modifier_axe_blood_lua:IsPurgable()
	return false
end

function modifier_axe_blood_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.mag_armor = self:GetAbility():GetSpecialValueFor( "mag_armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )
	self:StartIntervalThink(1)
end

function modifier_axe_blood_lua:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.mag_armor = self:GetAbility():GetSpecialValueFor( "mag_armor" )
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" )	
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_axe_str7") ~= nil then 
		bonus = abil:GetSpecialValueFor( "value" )
		self.regen = self.regen + bonus
	end
end

function modifier_axe_blood_lua:OnIntervalThink()
	self:OnRefresh()
end

--------------------------------------------------------------------------------

function modifier_axe_blood_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE
	}
	return funcs
end

function modifier_axe_blood_lua:GetModifierHealthRegenPercentage()
	if not self:GetParent():PassivesDisabled() then
		return self.regen
	end
end

function modifier_axe_blood_lua:GetModifierMagicalResistanceBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_axe_str10") ~= nil then 
		return 99
	end
	if not self:GetParent():PassivesDisabled() then
		return self.mag_armor
	end
end

function modifier_axe_blood_lua:GetModifierStatusResistance()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_axe_str10") ~= nil then 
		return 100
	end
	return 0
end



hp_per_level = class({})
LinkLuaModifier( "modifier_hp_per_level", "abilities/talents/hp_per_level", LUA_MODIFIER_MOTION_NONE )

function hp_per_level:GetIntrinsicModifierName()
	return "modifier_hp_per_level"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_hp_per_level = class({})

function modifier_hp_per_level:IsHidden()
	return true
end

function modifier_hp_per_level:IsPurgable()
	return false
end

function modifier_hp_per_level:RemoveOnDeath()
	return false
end

function modifier_hp_per_level:OnCreated( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.hp_per_level = self:GetAbility():GetSpecialValueFor( "hp_per_level" ) * level
	self:StartIntervalThink(1)
end

function modifier_hp_per_level:OnRefresh( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.hp_per_level = self:GetAbility():GetSpecialValueFor( "hp_per_level" ) * level	
end

function modifier_hp_per_level:OnIntervalThink()
self:OnRefresh()
end

function modifier_hp_per_level:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}
	return funcs
end

function modifier_hp_per_level:GetModifierExtraHealthBonus()
	return self.hp_per_level
end
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

function modifier_hp_per_level:OnCreated()
	self.caster = self:GetCaster()
	self.hp_per_level = self:GetAbility():GetSpecialValueFor( "hp_per_level" ) * self.caster:GetLevel()
end

function modifier_hp_per_level:OnRefresh()
	self.caster = self:GetCaster()
	self.hp_per_level = self:GetAbility():GetSpecialValueFor( "hp_per_level" ) * self.caster:GetLevel()	
end

function modifier_hp_per_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}
end

function modifier_hp_per_level:GetModifierExtraHealthBonus()
	return self.hp_per_level
end
hp_regen_level = class({})
LinkLuaModifier( "modifier_hp_regen_level", "abilities/talents/hp_regen_level", LUA_MODIFIER_MOTION_NONE )

function hp_regen_level:GetIntrinsicModifierName()
	return "modifier_hp_regen_level"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_hp_regen_level = class({})

function modifier_hp_regen_level:IsHidden()
	return true
end

function modifier_hp_regen_level:IsPurgable()
	return false
end

function modifier_hp_regen_level:RemoveOnDeath()
	return false
end

function modifier_hp_regen_level:OnCreated( kv )
	self.caster = self:GetCaster()
	self.hp_regen_level = self:GetAbility():GetSpecialValueFor( "hp_regen_level" ) * self.caster:GetLevel()
end

function modifier_hp_regen_level:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.hp_regen_level = self:GetAbility():GetSpecialValueFor( "hp_regen_level" ) * self.caster:GetLevel()	
end

function modifier_hp_regen_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
end

function modifier_hp_regen_level:GetModifierConstantHealthRegen()
	return self.hp_regen_level
end
base_attack_time = class({})
LinkLuaModifier( "modifier_base_attack_time", "abilities/talents/base_attack_time", LUA_MODIFIER_MOTION_NONE )

function base_attack_time:GetIntrinsicModifierName()
	return "modifier_base_attack_time"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_base_attack_time = class({})

function modifier_base_attack_time:IsHidden()
	return true
end

function modifier_base_attack_time:IsPurgable()
	return false
end

function modifier_base_attack_time:RemoveOnDeath()
	return false
end

function modifier_base_attack_time:OnCreated( kv )
	self.caster = self:GetCaster()
	self.base_attack_time = self.caster:GetBaseAttackTime()
	self.caster:SetBaseAttackTime(self.base_attack_time - self:GetAbility():GetSpecialValueFor("base_attack_time"))
end

function modifier_base_attack_time:OnRefresh( kv )
	self.caster:SetBaseAttackTime(self.base_attack_time - self:GetAbility():GetSpecialValueFor("base_attack_time"))
end


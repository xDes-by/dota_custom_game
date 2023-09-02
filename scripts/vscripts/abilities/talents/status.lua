status = class({})
LinkLuaModifier( "modifier_status", "abilities/talents/status", LUA_MODIFIER_MOTION_NONE )

function status:GetIntrinsicModifierName()
	return "modifier_status"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_status = class({})

function modifier_status:IsHidden()
	return true
end

function modifier_status:IsPurgable()
	return false
end

function modifier_status:RemoveOnDeath()
	return false
end

function modifier_status:OnCreated( kv )
	self.caster = self:GetCaster()
	self.status = self:GetAbility():GetSpecialValueFor( "status" )
end

function modifier_status:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.status = self:GetAbility():GetSpecialValueFor( "status" )
end

function modifier_status:OnIntervalThink()
self:OnRefresh()
end

function modifier_status:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE ,
	}
	return funcs
end

function modifier_status:GetModifierHPRegenAmplify_Percentage()
	return self.status
end
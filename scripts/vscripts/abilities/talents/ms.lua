movespeed = class({})
LinkLuaModifier( "modifier_ms", "abilities/talents/ms", LUA_MODIFIER_MOTION_NONE )

function movespeed:GetIntrinsicModifierName()
	return "modifier_ms"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_ms = class({})

function modifier_ms:IsHidden()
	return true
end

function modifier_ms:IsPurgable()
	return false
end

function modifier_ms:RemoveOnDeath()
	return false
end

function modifier_ms:OnCreated( kv )
	self.caster = self:GetCaster()
	self.ms = self:GetAbility():GetSpecialValueFor( "ms" )
end

function modifier_ms:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.ms = self:GetAbility():GetSpecialValueFor( "ms" )
end

function modifier_ms:OnIntervalThink()
self:OnRefresh()
end

function modifier_ms:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_ms:GetModifierMoveSpeedBonus_Percentage()
	return self.ms
end
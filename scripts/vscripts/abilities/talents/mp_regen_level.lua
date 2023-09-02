mp_regen_level = class({})
LinkLuaModifier( "modifier_mp_regen_level", "abilities/talents/mp_regen_level", LUA_MODIFIER_MOTION_NONE )

function mp_regen_level:GetIntrinsicModifierName()
	return "modifier_mp_regen_level"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_mp_regen_level = class({})

function modifier_mp_regen_level:IsHidden()
	return true
end

function modifier_mp_regen_level:IsPurgable()
	return false
end

function modifier_mp_regen_level:RemoveOnDeath()
	return false
end

function modifier_mp_regen_level:OnCreated( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.mp_regen_level = self:GetAbility():GetSpecialValueFor( "mp_regen_level" ) * level
	self:StartIntervalThink(1)
end

function modifier_mp_regen_level:OnRefresh( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.mp_regen_level = self:GetAbility():GetSpecialValueFor( "mp_regen_level" ) * level	
end

function modifier_mp_regen_level:OnIntervalThink()
self:OnRefresh()
end

function modifier_mp_regen_level:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end

function modifier_mp_regen_level:GetModifierConstantManaRegen()
	return self.mp_regen_level
end
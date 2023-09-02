mp_per_level = class({})
LinkLuaModifier( "modifier_mp_per_level", "abilities/talents/mp_per_level", LUA_MODIFIER_MOTION_NONE )

function mp_per_level:GetIntrinsicModifierName()
	return "modifier_mp_per_level"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_mp_per_level = class({})

function modifier_mp_per_level:IsHidden()
	return true
end

function modifier_mp_per_level:IsPurgable()
	return false
end

function modifier_mp_per_level:RemoveOnDeath()
	return false
end

function modifier_mp_per_level:OnCreated()
	self.caster = self:GetCaster()
	self.magic_damage_level = self:GetAbility():GetSpecialValueFor( "magic_damage_level" ) * self.caster:GetLevel()
end

function modifier_mp_per_level:OnRefresh()
	self.magic_damage_level = self:GetAbility():GetSpecialValueFor( "magic_damage_level" ) * self.caster:GetLevel()	
end

function modifier_mp_per_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
end

function modifier_mp_per_level:GetModifierSpellAmplify_Percentage()
	return self.magic_damage_level
end
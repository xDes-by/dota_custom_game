dmg_per_level = class({})
LinkLuaModifier( "modifier_dmg_per_level", "abilities/talents/dmg_per_level", LUA_MODIFIER_MOTION_NONE )

function dmg_per_level:GetIntrinsicModifierName()
	return "modifier_dmg_per_level"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_dmg_per_level = class({})

function modifier_dmg_per_level:IsHidden()
	return true
end

function modifier_dmg_per_level:IsPurgable()
	return false
end

function modifier_dmg_per_level:RemoveOnDeath()
	return false
end

function modifier_dmg_per_level:OnCreated( kv )
	self.caster = self:GetCaster()
	self.dmg_per_level = self:GetAbility():GetSpecialValueFor( "dmg_per_level" ) * self.caster:GetLevel()
end

function modifier_dmg_per_level:OnRefresh( kv )
	self.dmg_per_level = self:GetAbility():GetSpecialValueFor( "dmg_per_level" ) * self.caster:GetLevel()	
end

function modifier_dmg_per_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end

function modifier_dmg_per_level:GetModifierBaseAttack_BonusDamage()
	return self.dmg_per_level
end
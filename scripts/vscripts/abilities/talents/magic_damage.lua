magic_damage = class({})
LinkLuaModifier( "modifier_magic_damage", "abilities/talents/magic_damage", LUA_MODIFIER_MOTION_NONE )

function magic_damage:GetIntrinsicModifierName()
	return "modifier_magic_damage"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_magic_damage = class({})

function modifier_magic_damage:IsHidden()
	return true
end

function modifier_magic_damage:IsPurgable()
	return false
end

function modifier_magic_damage:RemoveOnDeath()
	return false
end

function modifier_magic_damage:OnCreated( kv )
	self.caster = self:GetCaster()
	self.manacost_level = self:GetAbility():GetSpecialValueFor( "manacost_level" ) * self.caster:GetLevel()
end

function modifier_magic_damage:OnRefresh( kv )
	self.manacost_level = self:GetAbility():GetSpecialValueFor( "manacost_level" ) * self.caster:GetLevel()	
end

function modifier_magic_damage:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
end

function modifier_magic_damage:GetModifierSpellAmplify_Percentage()
	return self.manacost_level
end
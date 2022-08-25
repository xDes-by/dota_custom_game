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
	local level = self.caster:GetLevel()
	self.magic_damage = self:GetAbility():GetSpecialValueFor( "magic_damage" ) * level
	self:StartIntervalThink(1)
end

function modifier_magic_damage:OnRefresh( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.magic_damage = self:GetAbility():GetSpecialValueFor( "magic_damage" ) * level	
end

function modifier_magic_damage:OnIntervalThink()
self:OnRefresh()
end

function modifier_magic_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifier_magic_damage:GetModifierSpellAmplify_Percentage()
	return self.magic_damage
end
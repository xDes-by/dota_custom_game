armor_per_level = class({})
LinkLuaModifier( "modifier_armor_per_level", "abilities/talents/armor_per_level", LUA_MODIFIER_MOTION_NONE )

function armor_per_level:GetIntrinsicModifierName()
	return "modifier_armor_per_level"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_armor_per_level = class({})

function modifier_armor_per_level:IsHidden()
	return true
end

function modifier_armor_per_level:IsPurgable()
	return false
end

function modifier_armor_per_level:RemoveOnDeath()
	return false
end

function modifier_armor_per_level:OnCreated( kv )
	self.caster = self:GetCaster()
	self.armor_per_level = self:GetAbility():GetSpecialValueFor( "armor_per_level" ) * self.caster:GetLevel()
end

function modifier_armor_per_level:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.armor_per_level = self:GetAbility():GetSpecialValueFor( "armor_per_level" ) * self.caster:GetLevel()	
end

function modifier_armor_per_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_armor_per_level:GetModifierPhysicalArmorBonus()
	return self.armor_per_level
end
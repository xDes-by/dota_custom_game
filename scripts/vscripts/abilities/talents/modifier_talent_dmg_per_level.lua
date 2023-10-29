modifier_talent_dmg_per_level = class({})

function modifier_talent_dmg_per_level:IsHidden()
	return true
end

function modifier_talent_dmg_per_level:IsPurgable()
	return false
end

function modifier_talent_dmg_per_level:RemoveOnDeath()
	return false
end

function modifier_talent_dmg_per_level:OnCreated( kv )
	self.value = {6, 8, 10, 12, 14, 16}
	self.parent = self:GetParent()
end

function modifier_talent_dmg_per_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
end

function modifier_talent_dmg_per_level:GetModifierBaseAttack_BonusDamage()
	return self.value[self:GetStackCount()] * self.parent:GetLevel()
end
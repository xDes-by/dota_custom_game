modifier_talent_hp_per_level = class({})

function modifier_talent_hp_per_level:IsHidden()
	return true
end

function modifier_talent_hp_per_level:IsPurgable()
	return false
end

function modifier_talent_hp_per_level:RemoveOnDeath()
	return false
end

function modifier_talent_hp_per_level:OnCreated()
	self.value = {150, 200, 250, 300, 350, 400}
	self:SetStackCount(1)
	self.parent = self:GetParent()
end

function modifier_talent_hp_per_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
	}
end

function modifier_talent_hp_per_level:GetModifierExtraHealthBonus()
	return self.value[self:GetStackCount()] * self.parent:GetLevel()
end
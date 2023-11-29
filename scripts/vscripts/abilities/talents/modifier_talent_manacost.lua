modifier_talent_manacost = class({})

function modifier_talent_manacost:IsHidden()
	return true
end

function modifier_talent_manacost:IsPurgable()
	return false
end

function modifier_talent_manacost:RemoveOnDeath()
	return false
end

function modifier_talent_manacost:OnCreated( kv )
	self.value = {0.075, 0.1, 0.125, 0.15, 0.175, 0.2}
	self:SetStackCount(1)
	self.parent = self:GetParent()
end

function modifier_talent_manacost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
	}
end

function modifier_talent_manacost:GetModifierSpellAmplify_Percentage()
	return self.value[self:GetStackCount()]
end
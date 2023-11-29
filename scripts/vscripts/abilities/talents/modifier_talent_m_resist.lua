modifier_talent_m_resist = class({})

function modifier_talent_m_resist:IsHidden()
	return true
end

function modifier_talent_m_resist:IsPurgable()
	return false
end

function modifier_talent_m_resist:RemoveOnDeath()
	return false
end

function modifier_talent_m_resist:OnCreated( kv )
	self.value = {10, 15, 20, 25, 30, 35}
	self:SetStackCount(1)
	self.parent = self:GetParent()
end

function modifier_talent_m_resist:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_talent_m_resist:GetModifierMagicalResistanceBonus()
	return self.value[self:GetStackCount()]
end
modifier_talent_mp_regen_level = class({})

function modifier_talent_mp_regen_level:IsHidden()
	return true
end

function modifier_talent_mp_regen_level:IsPurgable()
	return false
end

function modifier_talent_mp_regen_level:RemoveOnDeath()
	return false
end

function modifier_talent_mp_regen_level:OnCreated( kv )
	self.value = {0.05, 0.1, 0.15, 0.2, 0.25, 0.3}
	self:SetStackCount(1)
	self.parent = self:GetParent()
end

function modifier_talent_mp_regen_level:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end

function modifier_talent_mp_regen_level:GetModifierConstantManaRegen()
	return self.value[self:GetStackCount()] * self:GetParent():GetLevel()
end
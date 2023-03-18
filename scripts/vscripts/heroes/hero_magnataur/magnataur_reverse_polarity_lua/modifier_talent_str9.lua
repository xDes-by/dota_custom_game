modifier_talent_str9 = {}

function modifier_talent_str9:OnCreated(kv)
    self.damage_reduction = -kv.damage_reduction
end

function modifier_talent_str9:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_talent_str9:GetModifierIncomingDamage_Percentage()
    return self.damage_reduction
end
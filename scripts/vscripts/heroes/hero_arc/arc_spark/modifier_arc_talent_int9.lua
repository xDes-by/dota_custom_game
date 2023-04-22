modifier_arc_talent_int9 = class({})

function modifier_arc_talent_int9:IsDebuff()
    return true
end

function modifier_arc_talent_int9:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_arc_talent_int9:GetModifierMagicalResistanceBonus()
    return -15
end
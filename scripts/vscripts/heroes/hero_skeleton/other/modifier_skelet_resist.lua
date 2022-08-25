modifier_skelet_resist = class({})

function modifier_skelet_resist:IsHidden()
	return false
end

function modifier_skelet_resist:IsPurgable()
	return false
end

function modifier_skelet_resist:OnCreated( kv )
end

function modifier_skelet_resist:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
end

function modifier_skelet_resist:GetModifierMagicalResistanceBonus()
	return 50
end
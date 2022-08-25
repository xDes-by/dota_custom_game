modifier_debuff_resist = class({})

function modifier_debuff_resist:IsHidden()
	return true
end

function modifier_debuff_resist:IsDebuff()
	return false
end

function modifier_debuff_resist:IsPurgable()
	return false
end

function modifier_debuff_resist:OnCreated( kv )

end

function modifier_debuff_resist:OnRefresh( kv )

end

function modifier_debuff_resist:OnIntervalThink()

end


function modifier_debuff_resist:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_debuff_resist:GetModifierMagicalResistanceBonus()
	return -25
end
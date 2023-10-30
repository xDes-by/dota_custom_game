modifier_spirit_breaker_charge_of_darkness_m_resist_debuff = class({})


function modifier_spirit_breaker_charge_of_darkness_m_resist_debuff:IsHidden()
	return false
end

function modifier_spirit_breaker_charge_of_darkness_m_resist_debuff:IsDebuff()
	return true
end

function modifier_spirit_breaker_charge_of_darkness_m_resist_debuff:IsPurgable()
	return false
end

function modifier_spirit_breaker_charge_of_darkness_m_resist_debuff:RemoveOnDeath()
	return false
end

function modifier_spirit_breaker_charge_of_darkness_m_resist_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_spirit_breaker_charge_of_darkness_m_resist_debuff:GetModifierMagicalResistanceBonus()
	return -20
end
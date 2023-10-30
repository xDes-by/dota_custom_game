modifier_spirit_breaker_nether_strike_as_lua = class({})

function modifier_spirit_breaker_nether_strike_as_lua:IsHidden()
	return false
end

function modifier_spirit_breaker_nether_strike_as_lua:IsDebuff()
	return false
end

function modifier_spirit_breaker_nether_strike_as_lua:IsPurgable()
	return false
end

function modifier_spirit_breaker_nether_strike_as_lua:RemoveOnDeath()
	return false
end

function modifier_spirit_breaker_nether_strike_as_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_spirit_breaker_nether_strike_as_lua:GetModifierAttackSpeedBonus_Constant()
    return 600
end
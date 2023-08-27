modifier_blink_strike_lua_talent = modifier_blink_strike_lua_talent or class({})

function modifier_blink_strike_lua_talent:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_blink_strike_lua_talent:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_blink_strike_lua_talent:GetModifierBaseDamageOutgoing_Percentage()
    return 30
end
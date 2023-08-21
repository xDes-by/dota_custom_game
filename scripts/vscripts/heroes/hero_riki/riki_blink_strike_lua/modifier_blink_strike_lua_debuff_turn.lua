modifier_blink_strike_lua_debuff_turn = modifier_blink_strike_lua_debuff_turn or class({})
function modifier_blink_strike_lua_debuff_turn:IsPurgable() return true end
function modifier_blink_strike_lua_debuff_turn:IsHidden() return false end
function modifier_blink_strike_lua_debuff_turn:IsDebuff() return true end

function modifier_blink_strike_lua_debuff_turn:DeclareFunctions()
	local funcs = { MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE, }
	return funcs
end

function modifier_blink_strike_lua_debuff_turn:OnCreated()
	if self:GetAbility() then
		self.slow_pct = self:GetAbility():GetSpecialValueFor("turn_rate_slow_pct")
	else
		self.slow_pct = 0
	end
end

function modifier_blink_strike_lua_debuff_turn:GetModifierTurnRate_Percentage()
	return self.slow_pct * (-1)
end
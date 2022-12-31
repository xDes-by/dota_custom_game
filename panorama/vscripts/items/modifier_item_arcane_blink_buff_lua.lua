
modifier_item_arcane_blink_buff_lua = class({})

function modifier_item_arcane_blink_buff_lua:IsHidden() return false end
function modifier_item_arcane_blink_buff_lua:IsPurgable() return true end
function modifier_item_arcane_blink_buff_lua:IsDebuff() return false end
function modifier_item_arcane_blink_buff_lua:GetAbilityTextureName() return "item_arcane_blink" end

function modifier_item_arcane_blink_buff_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_CASTTIME_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_item_arcane_blink_buff_lua:OnCreated()
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then self:Destroy() return end
	self.cast_pct_improvement = ability:GetSpecialValueFor("cast_pct_improvement") or 0
	self.manacost_reduction = ability:GetSpecialValueFor("manacost_reduction") or 0
	self.debuff_amp = (-1) * (ability:GetSpecialValueFor("debuff_amp") or 0)
end

-- fake cast time modifier, all calculations are done in modifier_casttime_handler
function modifier_item_arcane_blink_buff_lua:_GetModifierPercentageCasttime()
	return self.cast_pct_improvement
end

function modifier_item_arcane_blink_buff_lua:GetModifierPercentageManacostStacking()
	return self.manacost_reduction
end

function modifier_item_arcane_blink_buff_lua:GetModifierStatusResistanceCaster()
	return self.debuff_amp
end

function modifier_item_arcane_blink_buff_lua:OnTooltip()
	return self.cast_pct_improvement
end

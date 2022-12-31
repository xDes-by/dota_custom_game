modifier_slark_essence_shift_debuff_custom = class({})

function modifier_slark_essence_shift_debuff_custom:IsPurgable() return false end

function modifier_slark_essence_shift_debuff_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

function modifier_slark_essence_shift_debuff_custom:GetModifierBonusStats_Agility()
	return -self:GetStackCount() * (self.stat_loss or 0)
end

function modifier_slark_essence_shift_debuff_custom:GetModifierBonusStats_Strength()
	return -self:GetStackCount() * (self.stat_loss or 0)
end

function modifier_slark_essence_shift_debuff_custom:GetModifierBonusStats_Intellect()
	return -self:GetStackCount() * (self.stat_loss or 0)
end

function modifier_slark_essence_shift_debuff_custom:OnTooltip()
	return self:GetStackCount()
end

function modifier_slark_essence_shift_debuff_custom:OnCreated(kv)
	self.stat_loss = self:GetAbility():GetSpecialValueFor("stat_loss")

	if IsClient() then return end

	self:IncrementStackCount()

	Timers:CreateTimer(self:GetDuration(), function() 
		if self:IsNull() then return end
		self:DecrementStackCount()
	end)
end

function modifier_slark_essence_shift_debuff_custom:OnRefresh(kv)
	self:OnCreated(kv)
end
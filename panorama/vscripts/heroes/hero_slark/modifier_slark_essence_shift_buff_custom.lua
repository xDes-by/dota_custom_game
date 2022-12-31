modifier_slark_essence_shift_buff_custom = class({})

function modifier_slark_essence_shift_buff_custom:IsPurgable() return false end

function modifier_slark_essence_shift_buff_custom:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
	return funcs
end

function modifier_slark_essence_shift_buff_custom:GetModifierBonusStats_Agility()
	return self:GetStackCount() * (self.agi_gain or 0)
end

function modifier_slark_essence_shift_buff_custom:OnCreated(kv)
	self.agi_gain = self:GetAbility():GetSpecialValueFor("agi_gain") + self:GetCaster():FindTalentValue("special_bonus_unique_slark_5")

	if IsClient() then return end

	self:IncrementStackCount()

	Timers:CreateTimer(self:GetDuration(), function() 
		if self:IsNull() then return end
		self:DecrementStackCount()
		self:GetParent():CalculateStatBonus(true)
	end)
end

function modifier_slark_essence_shift_buff_custom:OnRefresh(kv)
	self:OnCreated(kv)
end


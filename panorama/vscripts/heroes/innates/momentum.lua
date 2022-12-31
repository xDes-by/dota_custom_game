innate_momentum = class({})

LinkLuaModifier("modifier_innate_momentum", "heroes/innates/momentum", LUA_MODIFIER_MOTION_NONE)

function innate_momentum:GetIntrinsicModifierName()
	return "modifier_innate_momentum"
end



modifier_innate_momentum = class({})

function modifier_innate_momentum:IsHidden() return false end
function modifier_innate_momentum:IsDebuff() return false end
function modifier_innate_momentum:IsPurgable() return false end
function modifier_innate_momentum:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_momentum:OnCreated(keys)
	self:OnRefresh(keys)

	if IsClient() then return end

	self.main_attribute = self:GetParent():GetPrimaryAttribute()
	self.consecutive_wins = 0
end

function modifier_innate_momentum:OnRefresh(keys)
	self.main_stat_bonus = self:GetAbility():GetSpecialValueFor("main_stat_bonus")
	self.other_stat_bonus = self:GetAbility():GetSpecialValueFor("other_stat_bonus")

	if IsClient() then return end

	self.str_bonus = (self.main_attribute == DOTA_ATTRIBUTE_STRENGTH and self.main_stat_bonus) or self.other_stat_bonus
	self.agi_bonus = (self.main_attribute == DOTA_ATTRIBUTE_AGILITY and self.main_stat_bonus) or self.other_stat_bonus
	self.int_bonus = (self.main_attribute == DOTA_ATTRIBUTE_INTELLECT and self.main_stat_bonus) or self.other_stat_bonus

	self:GetParent():CalculateStatBonus(false)
end

function modifier_innate_momentum:OnPvpEndedForDuelists(keys)
	if IsClient() then return end

	local team = self:GetParent():GetTeam()
	if team == keys.winner_team then
		self.consecutive_wins = (self.consecutive_wins or 0) + 1
		self:SetStackCount(self:GetStackCount() + self.consecutive_wins)
		self:OnRefresh()
	elseif team == keys.loser_team then
		self.consecutive_wins = 0
	end
end

function modifier_innate_momentum:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
			MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
			MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
			MODIFIER_PROPERTY_TOOLTIP,
			MODIFIER_PROPERTY_TOOLTIP2
		}
	else
		return {
			MODIFIER_PROPERTY_TOOLTIP,
			MODIFIER_PROPERTY_TOOLTIP2
		}
	end
end

function modifier_innate_momentum:GetModifierBonusStats_Strength()
	return self.str_bonus * self:GetStackCount()
end

function modifier_innate_momentum:GetModifierBonusStats_Agility()
	return self.agi_bonus * self:GetStackCount()
end

function modifier_innate_momentum:GetModifierBonusStats_Intellect()
	return self.int_bonus * self:GetStackCount()
end

function modifier_innate_momentum:OnTooltip()
	return self.main_stat_bonus * self:GetStackCount()
end

function modifier_innate_momentum:OnTooltip2()
	return self.other_stat_bonus * self:GetStackCount()
end

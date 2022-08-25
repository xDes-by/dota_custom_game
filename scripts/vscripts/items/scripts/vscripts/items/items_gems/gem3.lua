modifier_gem3 = class ({})

function modifier_gem3:GetTexture()
	return "gem_icon/stats"
end

function modifier_gem3:IsHidden()
	return true
end

function modifier_gem3:RemoveOnDeath()
	return false
end

function modifier_gem3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_gem3:GetModifierBonusStats_Agility()
	return 1 * self:GetCaster():GetModifierStackCount("modifier_gem3", self:GetCaster())
end

function modifier_gem3:GetModifierBonusStats_Strength()
	return 1 * self:GetCaster():GetModifierStackCount("modifier_gem3", self:GetCaster())
end

function modifier_gem3:GetModifierBonusStats_Intellect()
	return 1 * self:GetCaster():GetModifierStackCount("modifier_gem3", self:GetCaster())
end
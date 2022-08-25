modifier_don_last = class({})

function modifier_don_last:IsHidden()
	return true
end

function modifier_don_last:IsPurgable()
	return false
end

function modifier_don_last:RemoveOnDeath()
	return false
end

function modifier_don_last:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_don_last:GetModifierBonusStats_Strength()
	return 5 * self:GetCaster():GetLevel()
end

function modifier_don_last:GetModifierBonusStats_Agility()
	return 5 * self:GetCaster():GetLevel()
end

function modifier_don_last:GetModifierBonusStats_Intellect()
	return 5 * self:GetCaster():GetLevel()
end
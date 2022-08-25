modifier_gem5 = class ({})

function modifier_gem5:GetTexture()
	return "gem_icon/regen"
end

function modifier_gem5:IsHidden()
	return true
end

function modifier_gem5:RemoveOnDeath()
	return false
end

function modifier_gem5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_gem5:GetModifierTotalPercentageManaRegen()
	return 0.1 * self:GetCaster():GetModifierStackCount("modifier_gem5", self:GetCaster())
end

function modifier_gem5:GetModifierHealthRegenPercentage()
	return 0.1 * self:GetCaster():GetModifierStackCount("modifier_gem5", self:GetCaster())
end

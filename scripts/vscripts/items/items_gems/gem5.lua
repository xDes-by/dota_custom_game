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

function modifier_gem5:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_gem5:OnCreated(kv)
	self.stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")
end

function modifier_gem5:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_gem5:GetModifierTotalPercentageManaRegen()
	return self.stacks
end

function modifier_gem5:GetModifierHealthRegenPercentage()
	return self.stacks
end

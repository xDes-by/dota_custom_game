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

function modifier_gem3:OnCreated(data)
	self.stacks = 0
	if data.value then
		self.stacks = self.stacks + data.value
	end
end

function modifier_gem3:OnRefresh(data)
	if data.value then
		self.stacks = self.stacks + data.value
	end
end

function modifier_gem3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_gem3:GetModifierBonusStats_Agility()
	return self.stacks
end

function modifier_gem3:GetModifierBonusStats_Strength()
	return self.stacks
end

function modifier_gem3:GetModifierBonusStats_Intellect()
	return self.stacks
end
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
	self.parent = self:GetParent()
	self.lvlup = {25, 50, 100, 200, 300, 400, 500, 600}
	if not IsServer() then
		return
	end
	self:StartIntervalThink(1)
end

function modifier_gem3:OnIntervalThink()
	self.stacks = 0 
	for i=0,5 do
		local item = self.parent:GetItemInSlot(i)
		if item then
			self.stacks = self.stacks + self.lvlup[item:GetLevel()]
		end
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
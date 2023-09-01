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

function modifier_gem5:OnCreated(data)
	self.parent = self:GetParent()
	self.lvlup = {0.3, 0.6, 0.9, 1.2, 1.5, 1.8, 2.1, 2.4}
	if not IsServer() then
		return
	end
	self:StartIntervalThink(1)
end

function modifier_gem5:OnIntervalThink()
	self.stacks = 0 
	for i=0,5 do
		local item = self.parent:GetItemInSlot(i)
		if item then
			if string.sub(item:GetAbilityName(),-4) == "gem5" then
				self.stacks = self.stacks + self.lvlup[item:GetLevel()]
			end
		end
	end
	if self.stacks == 0 then 
		self:Destroy()
	end
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

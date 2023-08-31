modifier_gem4 = class ({})

function modifier_gem4:GetTexture()
	return "gem_icon/damage"
end

function modifier_gem4:IsHidden()
	return true
end

function modifier_gem4:RemoveOnDeath()
	return false
end

function modifier_gem4:OnCreated(data)
	self.parent = self:GetParent()
	self.lvlup = {35, 100, 300, 1000, 2250, 4000, 7000, 10000}
	if not IsServer() then
		return
	end
	self:StartIntervalThink(1)
end

function modifier_gem4:OnIntervalThink()
	self.stacks = 0 
	for i=0,5 do
		local item = self.parent:GetItemInSlot(i)
		if item then
			self.stacks = self.stacks + self.lvlup[item:GetLevel()]
		end
	end
end

function modifier_gem4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end

function modifier_gem4:GetModifierBaseAttack_BonusDamage()
	return self.stacks
end
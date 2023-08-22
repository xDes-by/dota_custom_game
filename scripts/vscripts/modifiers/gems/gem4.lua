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
	self.stacks = 0
	if data.value then
		self.stacks = self.stacks + data.value
	end
end

function modifier_gem4:OnRefresh(data)
	if data.value then
		self.stacks = self.stacks + data.value
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
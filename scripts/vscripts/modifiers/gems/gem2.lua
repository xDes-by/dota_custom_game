modifier_gem2 = class ({})

function modifier_gem2:GetTexture()
	return "gem_icon/spell"
end

function modifier_gem2:IsHidden()
	return true
end

function modifier_gem2:RemoveOnDeath()
	return false
end

function modifier_gem2:OnCreated(data)
	self.stacks = 0
	if data.value then
		self.stacks = self.stacks + data.value
	end
end

function modifier_gem2:OnRefresh(data)
	if data.value then
		self.stacks = self.stacks + data.value
	end
end

function modifier_gem2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_gem2:GetModifierSpellAmplify_Percentage()
	return self.stacks
end
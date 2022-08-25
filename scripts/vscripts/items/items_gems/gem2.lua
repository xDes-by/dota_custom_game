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

function modifier_gem2:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_gem2:OnCreated(kv)
	self.stacks = self:GetAbility():GetSpecialValueFor("bonus_gem")
end

function modifier_gem2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_gem2:GetModifierSpellAmplify_Percentage()
	return self.stacks
end
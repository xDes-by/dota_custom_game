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

function modifier_gem2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
	}
end

function modifier_gem2:GetModifierSpellAmplify_Percentage()
	return 1 * self:GetCaster():GetModifierStackCount("modifier_gem2", self:GetCaster())
end
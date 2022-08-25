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

function modifier_gem4:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE
	}
end

function modifier_gem4:GetModifierBaseAttack_BonusDamage()
	return 1 * self:GetCaster():GetModifierStackCount("modifier_gem4", self:GetCaster())
end
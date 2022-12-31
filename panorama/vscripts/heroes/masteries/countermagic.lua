modifier_chc_mastery_countermagic = class({})

function modifier_chc_mastery_countermagic:IsHidden() return true end
function modifier_chc_mastery_countermagic:IsDebuff() return false end
function modifier_chc_mastery_countermagic:IsPurgable() return false end
function modifier_chc_mastery_countermagic:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_countermagic:GetTexture() return "masteries/countermagic" end

function modifier_chc_mastery_countermagic:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end



modifier_chc_mastery_countermagic_1 = class(modifier_chc_mastery_countermagic)
modifier_chc_mastery_countermagic_2 = class(modifier_chc_mastery_countermagic)
modifier_chc_mastery_countermagic_3 = class(modifier_chc_mastery_countermagic)

function modifier_chc_mastery_countermagic_1:GetModifierMagicalResistanceBonus()
	local int = self:GetParent():GetIntellect() or 0
	return 100 * (int + 100) / (int + 900)
end

function modifier_chc_mastery_countermagic_2:GetModifierMagicalResistanceBonus()
	local int = self:GetParent():GetIntellect() or 0
	return 100 * (int + 100) / (int + 500)
end

function modifier_chc_mastery_countermagic_3:GetModifierMagicalResistanceBonus()
	local int = self:GetParent():GetIntellect() or 0
	return 100 * (int + 100) / (int + 300)
end

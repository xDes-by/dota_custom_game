modifier_magnataur_talent_str10 = class({})

function modifier_magnataur_talent_str10:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end


function modifier_magnataur_talent_str10:GetModifierPhysicalArmorBonusUnique()
    return 2 * self:GetParent():GetLevel()
end

function modifier_magnataur_talent_str10:OnTooltip()
	return 2 * self:GetParent():GetLevel()
end
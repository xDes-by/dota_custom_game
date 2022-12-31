modifier_chc_mastery_acrobatics = class({})

function modifier_chc_mastery_acrobatics:IsHidden() return true end
function modifier_chc_mastery_acrobatics:IsDebuff() return false end
function modifier_chc_mastery_acrobatics:IsPurgable() return false end
function modifier_chc_mastery_acrobatics:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_acrobatics:GetTexture() return "masteries/acrobatics" end

function modifier_chc_mastery_acrobatics:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end



modifier_chc_mastery_acrobatics_1 = class(modifier_chc_mastery_acrobatics)
modifier_chc_mastery_acrobatics_2 = class(modifier_chc_mastery_acrobatics)
modifier_chc_mastery_acrobatics_3 = class(modifier_chc_mastery_acrobatics)

function modifier_chc_mastery_acrobatics_1:GetModifierEvasion_Constant()
	local agi = self:GetParent():GetAgility() or 0
	return 100 * (agi + 120) / (agi + 1120)
end

function modifier_chc_mastery_acrobatics_2:GetModifierEvasion_Constant()
	local agi = self:GetParent():GetAgility() or 0
	return 100 * (agi + 120) / (agi + 620)
end

function modifier_chc_mastery_acrobatics_3:GetModifierEvasion_Constant()
	local agi = self:GetParent():GetAgility() or 0
	return 100 * (agi + 120) / (agi + 370)
end

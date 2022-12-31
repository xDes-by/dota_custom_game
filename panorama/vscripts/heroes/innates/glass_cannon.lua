innate_glass_cannon = class({})

LinkLuaModifier("modifier_innate_glass_cannon", "heroes/innates/glass_cannon", LUA_MODIFIER_MOTION_NONE)

function innate_glass_cannon:GetIntrinsicModifierName()
	return "modifier_innate_glass_cannon"
end

modifier_innate_glass_cannon = class({})

function modifier_innate_glass_cannon:IsHidden() return true end
function modifier_innate_glass_cannon:IsDebuff() return false end
function modifier_innate_glass_cannon:IsPurgable() return false end
function modifier_innate_glass_cannon:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_glass_cannon:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_innate_glass_cannon:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("outgoing_amp")
end

function modifier_innate_glass_cannon:GetModifierIncomingDamage_Percentage()
	return self:GetAbility():GetSpecialValueFor("incoming_amp")
end

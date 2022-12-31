innate_war_veteran = class({})

LinkLuaModifier("modifier_innate_war_veteran", "heroes/innates/war_veteran", LUA_MODIFIER_MOTION_NONE)

function innate_war_veteran:GetIntrinsicModifierName()
	return "modifier_innate_war_veteran"
end





modifier_innate_war_veteran = class({})

function modifier_innate_war_veteran:IsHidden() return true end
function modifier_innate_war_veteran:IsDebuff() return false end
function modifier_innate_war_veteran:IsPurgable() return false end
function modifier_innate_war_veteran:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_war_veteran:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE 
	}
	return funcs
end

function modifier_innate_war_veteran:GetModifierTotalDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

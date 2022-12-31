innate_extra_delivery = class({})

LinkLuaModifier("modifier_innate_extra_delivery", "heroes/innates/extra_delivery", LUA_MODIFIER_MOTION_NONE)

function innate_extra_delivery:GetIntrinsicModifierName()
	return "modifier_innate_extra_delivery"
end



modifier_innate_extra_delivery = class({})

function modifier_innate_extra_delivery:IsHidden() return true end
function modifier_innate_extra_delivery:IsDebuff() return false end
function modifier_innate_extra_delivery:IsPurgable() return false end
function modifier_innate_extra_delivery:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

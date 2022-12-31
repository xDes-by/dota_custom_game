innate_assassin = class({})

LinkLuaModifier("modifier_innate_assassin", "heroes/innates/assassin", LUA_MODIFIER_MOTION_NONE)

function innate_assassin:GetIntrinsicModifierName()
	return "modifier_innate_assassin"
end





modifier_innate_assassin = class({})

function modifier_innate_assassin:IsHidden() return true end
function modifier_innate_assassin:IsDebuff() return false end
function modifier_innate_assassin:IsPurgable() return false end
function modifier_innate_assassin:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

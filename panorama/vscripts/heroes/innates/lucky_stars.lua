innate_lucky_stars = class({})

LinkLuaModifier("modifier_innate_lucky_stars", "heroes/innates/lucky_stars", LUA_MODIFIER_MOTION_NONE)

function innate_lucky_stars:GetIntrinsicModifierName()
	return "modifier_innate_lucky_stars"
end





modifier_innate_lucky_stars = class({})

function modifier_innate_lucky_stars:IsHidden() return true end
function modifier_innate_lucky_stars:IsDebuff() return false end
function modifier_innate_lucky_stars:IsPurgable() return false end
function modifier_innate_lucky_stars:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

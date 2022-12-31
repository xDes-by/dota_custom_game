innate_warrior = class({})

LinkLuaModifier("modifier_innate_warrior", "heroes/innates/warrior", LUA_MODIFIER_MOTION_NONE)

function innate_warrior:GetIntrinsicModifierName()
	return "modifier_innate_warrior"
end





modifier_innate_warrior = class({})

function modifier_innate_warrior:IsHidden() return true end
function modifier_innate_warrior:IsDebuff() return false end
function modifier_innate_warrior:IsPurgable() return false end
function modifier_innate_warrior:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_warrior:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE 
	}
	return funcs
end

function modifier_innate_warrior:GetModifierDamageOutgoing_Percentage()
	return self:GetAbility():GetSpecialValueFor("bonus_dmg")
end

function modifier_innate_warrior:CheckState()
	return {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
end

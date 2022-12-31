innate_iron_body = class({})

LinkLuaModifier("modifier_innate_iron_body", "heroes/innates/iron_body", LUA_MODIFIER_MOTION_NONE)

function innate_iron_body:GetIntrinsicModifierName()
	return "modifier_innate_iron_body"
end

modifier_innate_iron_body = class({})

function modifier_innate_iron_body:IsHidden() return true end
function modifier_innate_iron_body:IsDebuff() return false end
function modifier_innate_iron_body:IsPurgable() return false end
function modifier_innate_iron_body:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_iron_body:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
	}
	return funcs
end

function modifier_innate_iron_body:GetModifierPhysicalArmorBonus()
	return self:GetAbility():GetSpecialValueFor("bonus_armor")
end

function modifier_innate_iron_body:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("bonus_resist")
end 

LinkLuaModifier("modifier_creature_reflexes", "creatures/abilities/regular/creature_reflexes", LUA_MODIFIER_MOTION_NONE)

creature_reflexes = class({})

function creature_reflexes:GetIntrinsicModifierName()
	return "modifier_creature_reflexes"
end



modifier_creature_reflexes = class({})

function modifier_creature_reflexes:IsHidden() return true end
function modifier_creature_reflexes:IsDebuff() return false end
function modifier_creature_reflexes:IsPurgable() return false end
function modifier_creature_reflexes:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_reflexes:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT 
	}
	return funcs
end

function modifier_creature_reflexes:GetModifierEvasion_Constant()
	return self:GetAbility():GetSpecialValueFor("evasion")
end

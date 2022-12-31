LinkLuaModifier("modifier_creature_construct", "creatures/abilities/regular/creature_construct", LUA_MODIFIER_MOTION_NONE)

creature_construct = class({})

function creature_construct:GetIntrinsicModifierName()
	return "modifier_creature_construct"
end



modifier_creature_construct = class({})

function modifier_creature_construct:IsHidden() return true end
function modifier_creature_construct:IsDebuff() return false end
function modifier_creature_construct:IsPurgable() return false end
function modifier_creature_construct:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_construct:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
	return funcs
end

function modifier_creature_construct:GetModifierMagicalResistanceBonus()
	return self:GetAbility():GetSpecialValueFor("magic_resist")
end

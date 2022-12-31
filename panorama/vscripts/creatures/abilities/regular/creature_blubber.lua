LinkLuaModifier("modifier_creature_blubber", "creatures/abilities/regular/creature_blubber", LUA_MODIFIER_MOTION_NONE)

creature_blubber = class({})

function creature_blubber:GetIntrinsicModifierName()
	return "modifier_creature_blubber"
end



modifier_creature_blubber = class({})

function modifier_creature_blubber:IsHidden() return true end
function modifier_creature_blubber:IsDebuff() return false end
function modifier_creature_blubber:IsPurgable() return false end
function modifier_creature_blubber:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_blubber:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
	return funcs
end

function modifier_creature_blubber:GetModifierStatusResistanceStacking()
	return self:GetAbility():GetSpecialValueFor("status_resist")
end

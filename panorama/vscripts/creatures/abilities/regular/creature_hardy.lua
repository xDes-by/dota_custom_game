LinkLuaModifier("modifier_creature_hardy", "creatures/abilities/regular/creature_hardy", LUA_MODIFIER_MOTION_NONE)

creature_hardy = class({})

function creature_hardy:GetIntrinsicModifierName()
	return "modifier_creature_hardy"
end



modifier_creature_hardy = class({})

function modifier_creature_hardy:IsHidden() return true end
function modifier_creature_hardy:IsDebuff() return false end
function modifier_creature_hardy:IsPurgable() return false end
function modifier_creature_hardy:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_hardy:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
	return funcs
end

function modifier_creature_hardy:GetModifierPhysicalArmorBonus()
	return 2 * math.min(0.5, (1 - 0.01 * self:GetParent():GetHealthPercent())) * self:GetAbility():GetSpecialValueFor("max_armor")
end

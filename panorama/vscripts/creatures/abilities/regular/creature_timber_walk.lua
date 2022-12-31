LinkLuaModifier("modifier_creature_timber_walk", "creatures/abilities/regular/creature_timber_walk", LUA_MODIFIER_MOTION_NONE)

creature_timber_walk = class({})

function creature_timber_walk:GetIntrinsicModifierName()
	return "modifier_creature_timber_walk"
end



modifier_creature_timber_walk = class({})

function modifier_creature_timber_walk:IsHidden() return true end
function modifier_creature_timber_walk:IsDebuff() return false end
function modifier_creature_timber_walk:IsPurgable() return false end
function modifier_creature_timber_walk:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_creature_timber_walk:CheckState()
	local state = {
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_TREES] = true,
	}

	return state
end

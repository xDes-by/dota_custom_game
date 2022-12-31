LinkLuaModifier("modifier_enfos_treasure_platform", "creatures/abilities/5v5/enfos_treasure_platform", LUA_MODIFIER_MOTION_NONE)

enfos_treasure_platform = class({})

function enfos_treasure_platform:GetIntrinsicModifierName()
	return "modifier_enfos_treasure_platform"
end



modifier_enfos_treasure_platform = class({})

function modifier_enfos_treasure_platform:IsHidden() return true end
function modifier_enfos_treasure_platform:IsDebuff() return false end
function modifier_enfos_treasure_platform:IsPurgable() return false end
function modifier_enfos_treasure_platform:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_enfos_treasure_platform:CheckState()
	local state = {
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_FISSURE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	return state
end

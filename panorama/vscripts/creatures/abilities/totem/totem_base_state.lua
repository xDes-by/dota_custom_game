LinkLuaModifier("modifier_totem_base_state", "creatures/abilities/totem/totem_base_state", LUA_MODIFIER_MOTION_NONE)

totem_base_state = class({})

function totem_base_state:GetIntrinsicModifierName()
	return "modifier_totem_base_state"
end

modifier_totem_base_state = class({})

function modifier_totem_base_state:IsHidden() return true end
function modifier_totem_base_state:IsDebuff() return false end
function modifier_totem_base_state:IsPurgable() return false end
function modifier_totem_base_state:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_totem_base_state:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_LOW_ATTACK_PRIORITY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true
	}
	return state
end

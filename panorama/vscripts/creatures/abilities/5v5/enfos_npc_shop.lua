LinkLuaModifier("modifier_enfos_npc_shop", "creatures/abilities/5v5/enfos_npc_shop", LUA_MODIFIER_MOTION_NONE)

enfos_npc_shop = class({})

function enfos_npc_shop:GetIntrinsicModifierName()
	return "modifier_enfos_npc_shop"
end



modifier_enfos_npc_shop = class({})

function modifier_enfos_npc_shop:IsHidden() return true end
function modifier_enfos_npc_shop:IsDebuff() return false end
function modifier_enfos_npc_shop:IsPurgable() return false end
function modifier_enfos_npc_shop:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_enfos_npc_shop:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true
	}
	return state
end

function modifier_enfos_npc_shop:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_DISABLE_TURNING,
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE
	}
	return funcs
end

function modifier_enfos_npc_shop:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_enfos_npc_shop:GetModifierDisableTurning()
	return 1
end

function modifier_enfos_npc_shop:GetModifierIgnoreCastAngle()
	return 1
end

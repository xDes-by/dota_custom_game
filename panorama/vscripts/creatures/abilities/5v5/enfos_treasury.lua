LinkLuaModifier("modifier_enfos_treasury", "creatures/abilities/5v5/enfos_treasury", LUA_MODIFIER_MOTION_NONE)

enfos_treasury = class({})

function enfos_treasury:GetIntrinsicModifierName()
	return "modifier_enfos_treasury"
end



modifier_enfos_treasury = class({})

function modifier_enfos_treasury:IsHidden() return true end
function modifier_enfos_treasury:IsDebuff() return false end
function modifier_enfos_treasury:IsPurgable() return false end
function modifier_enfos_treasury:GetAttributes() return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_enfos_treasury:CheckState()
	local state = {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		[MODIFIER_STATE_ALLOW_PATHING_THROUGH_FISSURE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
	return state
end

function modifier_enfos_treasury:GetOverrideAnimation()
	return ACT_DOTA_IDLE
end

function modifier_enfos_treasury:GetModifierIgnoreCastAngle()
	return 1
end

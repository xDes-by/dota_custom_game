modifier_silent2 = class({})

function modifier_silent2:IsHidden()
    return true
end

function modifier_silent2:IsPurgable()
    return false
end

function modifier_silent2:OnCreated( kv )
end

function modifier_silent2:CheckState()
	local state = {
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_NIGHTMARED] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
	}
	return state
end

function modifier_silent2:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end

function modifier_silent2:GetModifierModelChange(params)
 return "models/props_gameplay/pig.vmdl"
end

function modifier_silent2:GetModifierMoveSpeed_Absolute()
	return 250
end

function modifier_silent2:GetModifierIncomingDamage_Percentage()
	return 300
end
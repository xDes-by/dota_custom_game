modifier_generic_disarm = class({})

--------------------------------------------------------------------------------

function modifier_generic_disarm:IsDebuff()
	return true
end

function modifier_generic_disarm:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_disarm:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_generic_disarm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

function modifier_generic_disarm:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------

function modifier_generic_disarm:GetEffectName()
	return "particles/generic_gameplay/generic_disarm.vpcf"
end

function modifier_generic_disarm:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

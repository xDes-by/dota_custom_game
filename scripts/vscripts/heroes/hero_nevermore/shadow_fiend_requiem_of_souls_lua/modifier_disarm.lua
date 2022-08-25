modifier_disarm = class({})

function modifier_disarm:IsHidden()
	return true
end

function modifier_disarm:IsPurgable()
	return false
end

function modifier_disarm:CheckState()
	local state = {
		[MODIFIER_STATE_DISARMED] = true,
	}
	return state
end


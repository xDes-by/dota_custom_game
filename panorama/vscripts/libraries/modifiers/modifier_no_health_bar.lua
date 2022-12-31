modifier_no_health_bar = class({})

function modifier_no_health_bar:IsPurgable() 
	return false 
end

function modifier_no_health_bar:IsPermanent( ... )
	return true
end

function modifier_no_health_bar:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
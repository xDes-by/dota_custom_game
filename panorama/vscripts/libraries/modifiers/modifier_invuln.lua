modifier_invuln = class({})

function modifier_invuln:IsPurgable() 
	return false 
end

function modifier_invuln:IsHidden()
	return true
end

function modifier_invuln:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end
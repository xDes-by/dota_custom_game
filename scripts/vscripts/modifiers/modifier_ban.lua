modifier_ban = class({})

function modifier_ban:IsHidden()
    return true
end


function modifier_ban:IsPurgable()
    return false
end
function modifier_ban:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_ROOTED] = true,		
		[MODIFIER_STATE_DISARMED] = true,		
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,		
		[MODIFIER_STATE_SILENCED] = true,		
		[MODIFIER_STATE_MUTED] = true,		
		[MODIFIER_STATE_STUNNED] = true,		
		[MODIFIER_STATE_HEXED] = true,		
		[MODIFIER_STATE_OUT_OF_GAME] = true,		
	}
	return state
end


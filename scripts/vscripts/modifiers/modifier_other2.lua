modifier_other2 = class({})

function modifier_other2:IsHidden()
    return true
end


function modifier_other2:IsPurgable()
    return false
end
function modifier_other2:CheckState()
	local state = {
	--	[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end

function modifier_other2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	}
	return funcs
end

function modifier_other2:GetModifierIgnoreCastAngle()
	return 1
end


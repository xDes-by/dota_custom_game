modifier_tomb = class({})


function modifier_tomb:IsHidden()
    return true
end


function modifier_tomb:IsPurgable()
    return false
end
function modifier_tomb:CheckState()
	local state = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		--[MODIFIER_STATE_UNSELECTABLE] = true,
		--[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
	}
	return state
end

function modifier_tomb:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_IGNORE_CAST_ANGLE,
	}
	return funcs
end

function modifier_tomb:GetModifierIgnoreCastAngle()
	return 1
end


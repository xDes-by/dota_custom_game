modifier_silence_mute = class({})

function modifier_silence_mute:IsPurgable() 
	return false 
end

function modifier_silence_mute:IsHidden()
	return true
end

function modifier_silence_mute:CheckState()
	return {
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_SILENCED] = true
	}
end

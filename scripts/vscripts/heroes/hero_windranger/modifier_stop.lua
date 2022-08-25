modifier_stop = class({})

function modifier_stop:IsHidden()
	return true
end

function modifier_stop:IsDebuff()
	return false
end

function modifier_stop:IsPurgable()
	return false
end

function modifier_stop:OnCreated( kv )

end

function modifier_stop:OnRefresh( kv )

end

function modifier_stop:OnIntervalThink()

end

function modifier_stop:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}
	return state
end
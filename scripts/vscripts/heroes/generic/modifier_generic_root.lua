modifier_generic_root = class({})

--------------------------------------------------------------------------------

function modifier_generic_root:IsDebuff()
	return true
end

function modifier_generic_root:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_generic_root:CheckState()
	local state = {
	[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end


function modifier_generic_root:GetEffectName()
	return "particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_chakram_immortal_bramble_root.vpcf"
end

function modifier_generic_root:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

--------------------------------------------------------------------------------

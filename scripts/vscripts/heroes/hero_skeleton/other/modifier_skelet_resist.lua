modifier_skelet_resist = class({})

function modifier_skelet_resist:IsHidden()
	return false
end

function modifier_skelet_resist:IsPurgable()
	return false
end

function modifier_skelet_resist:OnCreated( kv )
end

function modifier_skelet_resist:CheckState()
    local state = {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
    return state
end

function modifier_skelet_resist:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_skelet_resist:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
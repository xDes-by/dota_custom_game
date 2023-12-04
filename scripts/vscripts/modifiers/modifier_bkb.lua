modifier_bkb = class({})

function modifier_bkb:IsHidden()
    return false
end

function modifier_bkb:IsDebuff()
    return false
end

function modifier_bkb:IsPurgable()
    return false
end

function modifier_bkb:GetTexture()
    return "item_black_king_bar"
end

function modifier_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_bkb:CheckState()
    local state = {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
    return state
end

function modifier_bkb:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end
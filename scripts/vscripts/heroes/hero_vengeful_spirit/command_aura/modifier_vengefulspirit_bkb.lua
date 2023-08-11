modifier_vengefulspirit_bkb = class({})

function modifier_vengefulspirit_bkb:IsHidden()
    return false
end

function modifier_vengefulspirit_bkb:IsDebuff()
    return false
end

function modifier_vengefulspirit_bkb:IsPurgable()
    return false
end

function modifier_vengefulspirit_bkb:GetTexture()
    return "item_black_king_bar"
end

function modifier_vengefulspirit_bkb:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_vengefulspirit_bkb:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_vengefulspirit_bkb:CheckState()
    local state = {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
    return state
end

function modifier_vengefulspirit_bkb:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_vengefulspirit_bkb:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
modifier_magnataur_talent_str9 = class({})

function modifier_magnataur_talent_str9:IsHidden()
    return false
end

function modifier_magnataur_talent_str9:IsDebuff()
    return false
end

function modifier_magnataur_talent_str9:IsPurgable()
    return false
end

function modifier_magnataur_talent_str9:GetTexture()
    return "item_black_king_bar"
end

function modifier_magnataur_talent_str9:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_magnataur_talent_str9:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_magnataur_talent_str9:CheckState()
    local state = {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
    return state
end

function modifier_magnataur_talent_str9:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_magnataur_talent_str9:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
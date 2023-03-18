modifier_talent_str12 = class({})

function modifier_talent_str12:IsHidden()
    return false
end

function modifier_talent_str12:IsDebuff()
    return false
end

function modifier_talent_str12:IsPurgable()
    return false
end

function modifier_talent_str12:GetTexture()
    return "item_black_king_bar"
end

function modifier_talent_str12:GetEffectName()
    return "particles/items_fx/black_king_bar_avatar.vpcf"
end

function modifier_talent_str12:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_talent_str12:CheckState()
    local state = {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true,
    }
    return state
end

function modifier_talent_str12:GetPriority()
    return MODIFIER_PRIORITY_SUPER_ULTRA
end

function modifier_talent_str12:GetAttributes()
    return MODIFIER_ATTRIBUTE_MULTIPLE
end
modifier_earthshaker_enchant_totem_debuff1_lua = class({})

function modifier_earthshaker_enchant_totem_debuff1_lua:IsDebuff()
    return true
end

function modifier_earthshaker_enchant_totem_debuff1_lua:IsPurgable()
    return false
end

function modifier_earthshaker_enchant_totem_debuff1_lua:CheckState()
    local state = {
        [MODIFIER_STATE_PASSIVES_DISABLED] = true,
    }
    return state
end

function modifier_earthshaker_enchant_totem_debuff1_lua:OnDestroy()
    if not IsServer() then return end
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_earthshaker_enchant_totem_debuff2_lua", {duration = 3})
end

modifier_earthshaker_enchant_totem_debuff2_lua = class({})

function modifier_earthshaker_enchant_totem_debuff2_lua:IsDebuff()
    return true
end

function modifier_earthshaker_enchant_totem_debuff2_lua:IsPurgable()
    return true
end

function modifier_earthshaker_enchant_totem_debuff2_lua:CheckState()
    local state = {
        [MODIFIER_STATE_SILENCED] = true,
    }
    return state
end
modifier_rune_all_damage_increace = class({})
--Classifications template
function modifier_rune_all_damage_increace:IsHidden()
    return false
end

function modifier_rune_all_damage_increace:IsDebuff()
    return false
end

function modifier_rune_all_damage_increace:IsPurgable()
    return false
end

function modifier_rune_all_damage_increace:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_rune_all_damage_increace:IsStunDebuff()
    return false
end

function modifier_rune_all_damage_increace:RemoveOnDeath()
    return true
end

function modifier_rune_all_damage_increace:DestroyOnExpire()
    return true
end

function modifier_rune_all_damage_increace:OnCreated()
    self.parent = self:GetParent()
end

function modifier_rune_all_damage_increace:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_rune_all_damage_increace:GetModifierDamageOutgoing_Percentage(data)
    return 110
end
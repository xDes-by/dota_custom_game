modifier_rune_crit = class({})
--Classifications template
function modifier_rune_crit:IsHidden()
    return false
end

function modifier_rune_crit:IsDebuff()
    return false
end

function modifier_rune_crit:IsPurgable()
    return false
end

function modifier_rune_crit:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_rune_crit:IsStunDebuff()
    return false
end

function modifier_rune_crit:RemoveOnDeath()
    return true
end

function modifier_rune_crit:DestroyOnExpire()
    return true
end

function modifier_rune_crit:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
end

function modifier_rune_crit:GetModifierPreAttack_CriticalStrike(data)
    if RandomFloat(1,100) <= 5 then 
        return 200
    end
end
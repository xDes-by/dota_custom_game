modifier_boss_no_ancient_attack = class({})

function modifier_boss_no_ancient_attack:IsHidden()
    return true
end

function modifier_boss_no_ancient_attack:IsPurgable()
    return false
end

function modifier_boss_no_ancient_attack:RemoveOnDeath()
    return false
end

function modifier_boss_no_ancient_attack:CheckState()
    local state = {
        [MODIFIER_STATE_CANNOT_TARGET_BUILDINGS] = true
    }
    return state
end

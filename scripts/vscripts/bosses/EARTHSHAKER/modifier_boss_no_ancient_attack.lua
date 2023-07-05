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

modifier_boss_invoker_active = class({})

function modifier_boss_invoker_active:IsHidden()
    return false
end

function modifier_boss_invoker_active:IsPurgable()
    return false
end

function modifier_boss_invoker_active:RemoveOnDeath()
    return false
end

function modifier_boss_invoker_active:CheckState()
    local state = {
        [MODIFIER_STATE_STUNNED] = true,
        [MODIFIER_STATE_ATTACK_IMMUNE] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
    }
    return state
end

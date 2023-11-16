effect_projectile_change2 = class({})
--Classifications template
function effect_projectile_change2:IsHidden()
    return true
end

function effect_projectile_change2:IsDebuff()
    return false
end

function effect_projectile_change2:IsPurgable()
    return false
end

function effect_projectile_change2:IsPurgeException()
    return false
end

-- Optional Classifications
function effect_projectile_change2:IsStunDebuff()
    return false
end

function effect_projectile_change2:RemoveOnDeath()
    return false
end

function effect_projectile_change2:DestroyOnExpire()
    return false
end

function effect_projectile_change2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function effect_projectile_change2:GetModifierProjectileName()
    return "particles/econ/events/diretide_2020/attack_modifier/attack_modifier_v2_fall20.vpcf"
end
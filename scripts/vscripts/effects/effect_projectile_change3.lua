effect_projectile_change3 = class({})
--Classifications template
function effect_projectile_change3:IsHidden()
    return true
end

function effect_projectile_change3:IsDebuff()
    return false
end

function effect_projectile_change3:IsPurgable()
    return false
end

function effect_projectile_change3:IsPurgeException()
    return false
end

-- Optional Classifications
function effect_projectile_change3:IsStunDebuff()
    return false
end

function effect_projectile_change3:RemoveOnDeath()
    return false
end

function effect_projectile_change3:DestroyOnExpire()
    return false
end

function effect_projectile_change3:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function effect_projectile_change3:GetModifierProjectileName()
    return "particles/econ/events/diretide_2020/attack_modifier/attack_modifier_v3_fall20.vpcf"
end
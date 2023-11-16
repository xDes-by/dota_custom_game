effect_projectile_change1 = class({})
--Classifications template
function effect_projectile_change1:IsHidden()
    return true
end

function effect_projectile_change1:IsDebuff()
    return false
end

function effect_projectile_change1:IsPurgable()
    return false
end

function effect_projectile_change1:IsPurgeException()
    return false
end

-- Optional Classifications
function effect_projectile_change1:IsStunDebuff()
    return false
end

function effect_projectile_change1:RemoveOnDeath()
    return false
end

function effect_projectile_change1:DestroyOnExpire()
    return false
end

function effect_projectile_change1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function effect_projectile_change1:GetModifierProjectileName()
    return "particles/econ/attack/attack_modifier_ti9.vpcf"
end
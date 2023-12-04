modifier_projectile_effect_2 = class({})
--Classifications template
function modifier_projectile_effect_2:IsHidden()
    return true
end

function modifier_projectile_effect_2:IsDebuff()
    return false
end

function modifier_projectile_effect_2:IsPurgable()
    return false
end

function modifier_projectile_effect_2:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_projectile_effect_2:IsStunDebuff()
    return false
end

function modifier_projectile_effect_2:RemoveOnDeath()
    return false
end

function modifier_projectile_effect_2:DestroyOnExpire()
    return false
end

function modifier_projectile_effect_2:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function modifier_projectile_effect_2:GetModifierProjectileName()
    return "particles/econ/events/diretide_2020/attack_modifier/attack_modifier_v2_fall20.vpcf"
end
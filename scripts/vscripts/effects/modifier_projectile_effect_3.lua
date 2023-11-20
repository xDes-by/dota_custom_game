modifier_projectile_effect_3 = class({})
--Classifications template
function modifier_projectile_effect_3:IsHidden()
    return true
end

function modifier_projectile_effect_3:IsDebuff()
    return false
end

function modifier_projectile_effect_3:IsPurgable()
    return false
end

function modifier_projectile_effect_3:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_projectile_effect_3:IsStunDebuff()
    return false
end

function modifier_projectile_effect_3:RemoveOnDeath()
    return false
end

function modifier_projectile_effect_3:DestroyOnExpire()
    return false
end

function modifier_projectile_effect_3:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function modifier_projectile_effect_3:GetModifierProjectileName()
    return "particles/econ/events/diretide_2020/attack_modifier/attack_modifier_v3_fall20.vpcf"
end
modifier_projectile_effect_1 = class({})
--Classifications template
function modifier_projectile_effect_1:IsHidden()
    return true
end

function modifier_projectile_effect_1:IsDebuff()
    return false
end

function modifier_projectile_effect_1:IsPurgable()
    return false
end

function modifier_projectile_effect_1:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_projectile_effect_1:IsStunDebuff()
    return false
end

function modifier_projectile_effect_1:RemoveOnDeath()
    return false
end

function modifier_projectile_effect_1:DestroyOnExpire()
    return false
end

function modifier_projectile_effect_1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROJECTILE_NAME
    }
end

function modifier_projectile_effect_1:GetModifierProjectileName()
    return "particles/econ/attack/attack_modifier_ti9.vpcf"
end
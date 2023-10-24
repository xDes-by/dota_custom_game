magma_boss_damage_reduction_aura = class({})

function magma_boss_damage_reduction_aura:GetIntrinsicModifierName()
    return "modifier_magma_boss_damage_reduction_aura"
end

modifier_magma_boss_damage_reduction_aura = class({})

LinkLuaModifier("modifier_magma_boss_damage_reduction_aura", "abilities/bosses/magma/magma_boss_damage_reduction_aura", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_magma_boss_damage_reduction_aura:IsHidden()
    return true
end

function modifier_magma_boss_damage_reduction_aura:IsDebuff()
    return false
end

function modifier_magma_boss_damage_reduction_aura:IsPurgable()
    return false
end

function modifier_magma_boss_damage_reduction_aura:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_magma_boss_damage_reduction_aura:IsStunDebuff()
    return false
end

function modifier_magma_boss_damage_reduction_aura:RemoveOnDeath()
    return false
end

function modifier_magma_boss_damage_reduction_aura:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_magma_boss_damage_reduction_aura:IsAura()
    return true
end

function modifier_magma_boss_damage_reduction_aura:GetModifierAura()
    return "modifier_magma_boss_damage_reduction_aura_aura_effect"
end

function modifier_magma_boss_damage_reduction_aura:GetAuraRadius()
    return 300
end

function modifier_magma_boss_damage_reduction_aura:GetAuraDuration()
    return 0.5
end

function modifier_magma_boss_damage_reduction_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_magma_boss_damage_reduction_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_magma_boss_damage_reduction_aura:GetAuraSearchFlags()
    return 0
end

function modifier_magma_boss_damage_reduction_aura:OnCreated()
    self.damage_reduction = self:GetAbility():GetSpecialValueFor("damage_reduction")
end

function modifier_magma_boss_damage_reduction_aura:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_magma_boss_damage_reduction_aura:GetModifierDamageOutgoing_Percentage()
    return 100 - self.damage_reduction
end

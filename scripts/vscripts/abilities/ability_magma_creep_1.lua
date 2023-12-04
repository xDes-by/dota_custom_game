ability_magma_creep_1 = class({})

function ability_magma_creep_1:GetIntrinsicModifierName()
    return "modifier_ability_magma_creep_1"
end

LinkLuaModifier("modifier_ability_magma_creep_1", "abilities/ability_magma_creep_1", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_magma_creep_1_aura_effect", "abilities/ability_magma_creep_1", LUA_MODIFIER_MOTION_NONE)

modifier_ability_magma_creep_1 = class({})
--Classifications template
function modifier_ability_magma_creep_1:IsHidden()
    if self:GetStackCount() == 0 then
        return true
    end
    return false
end

function modifier_ability_magma_creep_1:IsDebuff()
    return false
end

function modifier_ability_magma_creep_1:IsPurgable()
    return false
end

function modifier_ability_magma_creep_1:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_magma_creep_1:IsStunDebuff()
    return false
end

function modifier_ability_magma_creep_1:RemoveOnDeath()
    return false
end

function modifier_ability_magma_creep_1:DestroyOnExpire()
    return false
end

function modifier_ability_magma_creep_1:OnCreated()
    if not IsServer() then
        return
    end
    self:SetStackCount(0)
end

function modifier_ability_magma_creep_1:CheckState()
    return {
        [MODIFIER_STATE_MAGIC_IMMUNE] = true
    }
end

function modifier_ability_magma_creep_1:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
        MODIFIER_EVENT_ON_ATTACK_LANDED
    }
end

function modifier_ability_magma_creep_1:GetModifierAttackSpeedBonus_Constant()
    return self:GetStackCount() * 15
end

function modifier_ability_magma_creep_1:OnAttackLanded(data)
    if self:GetParent() ~= data.attacker then
        return
    end
    if self:GetStackCount() < 12 and self.last_target == data.target then
        self:IncrementStackCount()
    else
        self.last_target = data.target
        self:SetStackCount(1)
    end
end

function modifier_ability_magma_creep_1:GetEffectName()
    return "particles/econ/events/fall_2022/radiance/radiance_owner_fall2022.vpcf"
end

function modifier_ability_magma_creep_1:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_ability_magma_creep_1:IsAura()
    return true
end

function modifier_ability_magma_creep_1:GetModifierAura()
    return "modifier_ability_magma_creep_1_aura_effect"
end

function modifier_ability_magma_creep_1:GetAuraRadius()
    return 700
end

function modifier_ability_magma_creep_1:GetAuraDuration()
    return 0.5
end

function modifier_ability_magma_creep_1:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_magma_creep_1:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_magma_creep_1:GetAuraSearchFlags()
    return 0
end

modifier_ability_magma_creep_1_aura_effect = class({})
--Classifications template
function modifier_ability_magma_creep_1_aura_effect:IsHidden()
    return false
end

function modifier_ability_magma_creep_1_aura_effect:IsDebuff()
    return true
end

function modifier_ability_magma_creep_1_aura_effect:IsPurgable()
    return false
end

function modifier_ability_magma_creep_1_aura_effect:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_magma_creep_1_aura_effect:IsStunDebuff()
    return false
end

function modifier_ability_magma_creep_1_aura_effect:RemoveOnDeath()
    return true
end

function modifier_ability_magma_creep_1_aura_effect:DestroyOnExpire()
    return true
end

function modifier_ability_magma_creep_1_aura_effect:OnCreated()
    if not IsServer() then
        return
    end
    self.multip = 1
    self.damage = self:GetParent():GetMaxHealth() * 0.03
    self:StartIntervalThink(0.2)
end

function modifier_ability_magma_creep_1_aura_effect:OnIntervalThink()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.damage * self.multip,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = 0,
        ability = self:GetAbility()
    })
    self.multip = self.multip + 0.1
end

function modifier_ability_magma_creep_1_aura_effect:GetEffectName()
    return "particles/econ/events/fall_2022/radiance_target_fall2022.vpcf"
end

function modifier_ability_magma_creep_1_aura_effect:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
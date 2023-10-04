ability_npc_bara_boss_fire_shield = class({})

LinkLuaModifier("modifier_ability_npc_bara_boss_fire_shield", "abilities/bosses/bara/ability_npc_bara_boss_fire_shield", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_npc_bara_boss_fire_shield_aura", "abilities/bosses/bara/ability_npc_bara_boss_fire_shield", LUA_MODIFIER_MOTION_NONE)

function ability_npc_bara_boss_fire_shield:GetIntrinsicModifierName()
    return "modifier_ability_npc_bara_boss_fire_shield_aura"
end

modifier_ability_npc_bara_boss_fire_shield_aura = class({})
--Classifications template
function modifier_ability_npc_bara_boss_fire_shield_aura:IsHidden()
    return true
end

function modifier_ability_npc_bara_boss_fire_shield_aura:IsDebuff()
    return false
end

function modifier_ability_npc_bara_boss_fire_shield_aura:IsPurgable()
    return false
end

function modifier_ability_npc_bara_boss_fire_shield_aura:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_bara_boss_fire_shield_aura:IsStunDebuff()
    return false
end

function modifier_ability_npc_bara_boss_fire_shield_aura:RemoveOnDeath()
    return true
end

function modifier_ability_npc_bara_boss_fire_shield_aura:DestroyOnExpire()
    return true
end

function modifier_ability_npc_bara_boss_fire_shield_aura:OnCreated()
    self.sheeld_max = self:GetAbility():GetSpecialValueFor("sheeld_max")
    self.current_sheeld_health = self.sheeld_max
end

function modifier_ability_npc_bara_boss_fire_shield_aura:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_INCOMING_SPELL_DAMAGE_CONSTANT
    }
end

function modifier_ability_npc_bara_boss_fire_shield_aura:GetModifierIncomingSpellDamageConstant(data)
    if IsClient() then
        if data.report_max then
            return 1
        else
            return self.current_sheeld_health
        end
    end
    local remain = self.current_sheeld_health - data.damage
    if remain > 0 then
        self.current_sheeld_health = self.current_sheeld_health - data.damage
        return -data.damage
    else
        local p = self.current_sheeld_health
        self.current_sheeld_health = 0
        self:Destroy()
        return -p
    end
end
--------------------------------------------------------------------------------
-- Aura Effects
function modifier_ability_npc_bara_boss_fire_shield_aura:IsAura()
    return true
end

function modifier_ability_npc_bara_boss_fire_shield_aura:GetModifierAura()
    return "modifier_ability_npc_bara_boss_fire_shield"
end

function modifier_ability_npc_bara_boss_fire_shield_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_ability_npc_bara_boss_fire_shield_aura:GetAuraDuration()
    return 0.5
end

function modifier_ability_npc_bara_boss_fire_shield_aura:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_npc_bara_boss_fire_shield_aura:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_npc_bara_boss_fire_shield_aura:GetAuraSearchFlags()
    return 0
end

modifier_ability_npc_bara_boss_fire_shield = class({})

--Classifications template
function modifier_ability_npc_bara_boss_fire_shield:IsHidden()
    return false
end

function modifier_ability_npc_bara_boss_fire_shield:IsDebuff()
    return true
end

function modifier_ability_npc_bara_boss_fire_shield:IsPurgable()
    return true
end

function modifier_ability_npc_bara_boss_fire_shield:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_bara_boss_fire_shield:IsStunDebuff()
    return false
end

function modifier_ability_npc_bara_boss_fire_shield:RemoveOnDeath()
    return true
end

function modifier_ability_npc_bara_boss_fire_shield:DestroyOnExpire()
    return true
end

function modifier_ability_npc_bara_boss_fire_shield:OnCreated()
    self.health = self:GetParent():GetMaxHealth() * self:GetAbility():GetSpecialValueFor("health") / 100 / 5
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.2)
end

function modifier_ability_npc_bara_boss_fire_shield:OnIntervalThink()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.health,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        ability = self:GetAbility()
    })
end
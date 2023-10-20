ability_crystal_boss_mana_leak = class({})

function ability_crystal_boss_mana_leak:GetIntrinsicModifierName()
    return "modifier_ability_crystal_boss_mana_leak"
end

modifier_ability_crystal_boss_mana_leak = class({})

LinkLuaModifier("modifier_ability_crystal_boss_mana_leak", "abilities/bosses/crystal/ability_crystal_boss_mana_leak", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_crystal_boss_mana_leak_aura_effect", "abilities/bosses/crystal/ability_crystal_boss_mana_leak", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_crystal_boss_mana_leak:IsHidden()
    return true
end

function modifier_ability_crystal_boss_mana_leak:IsDebuff()
    return false
end

function modifier_ability_crystal_boss_mana_leak:IsPurgable()
    return false
end

function modifier_ability_crystal_boss_mana_leak:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_crystal_boss_mana_leak:IsStunDebuff()
    return false
end

function modifier_ability_crystal_boss_mana_leak:RemoveOnDeath()
    return false
end

function modifier_ability_crystal_boss_mana_leak:DestroyOnExpire()
    return false
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_ability_crystal_boss_mana_leak:IsAura()
    return true
end

function modifier_ability_crystal_boss_mana_leak:GetModifierAura()
    return "modifier_ability_crystal_boss_mana_leak_aura_effect"
end

function modifier_ability_crystal_boss_mana_leak:GetAuraRadius()
    return 300
end

function modifier_ability_crystal_boss_mana_leak:GetAuraDuration()
    return 0.5
end

function modifier_ability_crystal_boss_mana_leak:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_crystal_boss_mana_leak:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

function modifier_ability_crystal_boss_mana_leak:GetAuraSearchFlags()
    return 0
end

modifier_ability_crystal_boss_mana_leak_aura_effect = class({})
--Classifications template
function modifier_ability_crystal_boss_mana_leak_aura_effect:IsHidden()
    return false
end

function modifier_ability_crystal_boss_mana_leak_aura_effect:IsDebuff()
    return true
end

function modifier_ability_crystal_boss_mana_leak_aura_effect:IsPurgable()
    return false
end

function modifier_ability_crystal_boss_mana_leak_aura_effect:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_crystal_boss_mana_leak_aura_effect:IsStunDebuff()
    return true
end

function modifier_ability_crystal_boss_mana_leak_aura_effect:RemoveOnDeath()
    return true
end

function modifier_ability_crystal_boss_mana_leak_aura_effect:DestroyOnExpire()
    return true
end

function modifier_ability_crystal_boss_mana_leak_aura_effect:OnCreated()
    if not IsServer() then
        return
    end
    self.parent = self:GetParent()
    self.interval = self.parent:GetMaxMana() * 0.005
    self:StartIntervalThink(0.1)
end

function modifier_ability_crystal_boss_mana_leak_aura_effect:OnIntervalThink()
    self.parent:SetMana(math.max((self.parent:GetMana() - self.interval), 0))
    if self:GetParent():GetMana() <= 0 then
        ApplyDamage({
            victim = self.parent,
            attacker = self:GetCaster(),
            damage = self.parent:GetMaxHealth() * 0.005,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags = 0,
            ability = self:GetAbility()
        })
    end
end
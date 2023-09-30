ability_npc_boss_barrack2_spell4 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_barrack2_spell4","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_barrack2_spell4_aura_effect","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_barrack2_spell4_thinker","abilities/bosses/npc_boss_barrack2/ability_npc_boss_barrack2_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )

function ability_npc_boss_barrack2_spell4:GetIntrinsicModifierName()
    return "modifier_ability_npc_boss_barrack2_spell4"
end

modifier_ability_npc_boss_barrack2_spell4 = class({})

--Classifications template
function modifier_ability_npc_boss_barrack2_spell4:IsHidden()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4:IsPurgable()
    return false
end

function modifier_ability_npc_boss_barrack2_spell4:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4:OnCreated()
    if IsClient() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_ability_npc_boss_barrack2_spell4:OnIntervalThink()
    CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_ability_npc_boss_barrack2_spell4_thinker", {duration = 1.6}, self:GetCaster():GetOrigin() + RandomVector(RandomInt(150, 500)), self:GetCaster():GetTeamNumber(), false)
end

-- Aura template
function modifier_ability_npc_boss_barrack2_spell4:IsAura()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4:GetModifierAura()
    return "modifier_ability_npc_boss_barrack2_spell4_aura_effect"
end

function modifier_ability_npc_boss_barrack2_spell4:GetAuraRadius()
    return 1000
end

function modifier_ability_npc_boss_barrack2_spell4:GetAuraDuration()
    return 0.5
end

function modifier_ability_npc_boss_barrack2_spell4:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_npc_boss_barrack2_spell4:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_npc_boss_barrack2_spell4:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

modifier_ability_npc_boss_barrack2_spell4_thinker = class({})

function modifier_ability_npc_boss_barrack2_spell4_thinker:OnCreated()
    local pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf", PATTACH_POINT, self:GetParent())
    ParticleManager:ReleaseParticleIndex(pfx)
end

function modifier_ability_npc_boss_barrack2_spell4_thinker:OnDestroy()
    local pfx = ParticleManager:CreateParticle("particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(pfx, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(pfx)
    if IsClient() then
        return
    end
    local enemies = FindUnitsInRadius(DOTA_TEAM_BADGUYS, self:GetParent():GetAbsOrigin(), nil, 225, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0,false)
    for _,unit in pairs(enemies) do
        unit:AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_generic_arc_lua", {
        height = 500, duration = 1.6, isStun = true, activity = ACT_DOTA_FLAIL})
    end
    UTIL_Remove(self:GetParent())
end

modifier_ability_npc_boss_barrack2_spell4_aura_effect = class({})
--Classifications template
function modifier_ability_npc_boss_barrack2_spell4_aura_effect:IsHidden()
    return false
end

function modifier_ability_npc_boss_barrack2_spell4_aura_effect:IsDebuff()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4_aura_effect:IsPurgable()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4_aura_effect:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_barrack2_spell4_aura_effect:OnCreated()
    if IsClient() then
        return
    end
    self.persent = self:GetAbility():GetSpecialValueFor("persent") * 0.01
    self:SetStackCount(0)
    self:StartIntervalThink(1)
end

function modifier_ability_npc_boss_barrack2_spell4_aura_effect:OnIntervalThink()
    self:IncrementStackCount()
    if self:GetStackCount() >= 4 then
        ApplyDamage({victim = self:GetParent(),
        damage = self:GetParent():GetHealth() * self.persent,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self:GetAbility()})
    end
end















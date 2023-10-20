ability_npc_titan_boss_stomp = class({})

LinkLuaModifier("modifier_ability_npc_titan_boss_stomp", "abilities/bosses/titan/ability_npc_titan_boss_stomp", LUA_MODIFIER_MOTION_NONE)

function ability_npc_titan_boss_stomp:Precache(context)
    PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", context )
    PrecacheResource( "particle", "particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", context )
end

function ability_npc_titan_boss_stomp:OnSpellStart()
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ability_npc_titan_boss_stomp", {duration = 1.3})
end

modifier_ability_npc_titan_boss_stomp = class({})
--Classifications template
function modifier_ability_npc_titan_boss_stomp:IsHidden()
    return true
end

function modifier_ability_npc_titan_boss_stomp:IsDebuff()
    return false
end

function modifier_ability_npc_titan_boss_stomp:IsPurgable()
    return false
end

function modifier_ability_npc_titan_boss_stomp:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_titan_boss_stomp:IsStunDebuff()
    return false
end

function modifier_ability_npc_titan_boss_stomp:RemoveOnDeath()
    return true
end

function modifier_ability_npc_titan_boss_stomp:DestroyOnExpire()
    return true
end

function modifier_ability_npc_titan_boss_stomp:OnCreated()
    if not IsServer() then
        return
    end
    self.parent = self:GetParent()
    self.parent:StartGesture(ACT_DOTA_CAST_ABILITY_1)
    EmitSoundOn("Hero_ElderTitan.EchoStomp.Channel", self.parent)
end

function modifier_ability_npc_titan_boss_stomp:OnDestroy()
    if not IsServer() then
        return
    end
    self.parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
    EmitSoundOn("Hero_ElderTitan.EchoStomp", self.parent)
    if self.parent.stomp_type == "magic" then
        damage_type = DAMAGE_TYPE_MAGICAL
    else
        damage_type = DAMAGE_TYPE_PHYSICAL
    end
    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 500,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _, unit in pairs(units) do
        unit:AddNewModifier(self.parent, self:GetAbility(), "modifier_stunned", {duration = 5})
        ApplyDamage({
            victim = unit,
            attacker = self.parent,
            damage = self.parent:GetMaxHealth() * 0.15,
            damage_type = damage_type,
            damage_flags = 0,
            ability = self:GetAbility()
        })
    end
    if self.parent.stomp_type == "physical" then
        local particle_stomp_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_physical.vpcf", PATTACH_ABSORIGIN, self.parent)
        ParticleManager:SetParticleControl(particle_stomp_fx, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(500, 1, 1))
        ParticleManager:SetParticleControl(particle_stomp_fx, 2, self.parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle_stomp_fx)
    else
        local particle_stomp_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_elder_titan/elder_titan_echo_stomp_magical.vpcf", PATTACH_ABSORIGIN, self.parent)
        ParticleManager:SetParticleControl(particle_stomp_fx, 0, self.parent:GetAbsOrigin())
        ParticleManager:SetParticleControl(particle_stomp_fx, 1, Vector(500, 1, 1))
        ParticleManager:SetParticleControl(particle_stomp_fx, 2, self.parent:GetAbsOrigin())
        ParticleManager:ReleaseParticleIndex(particle_stomp_fx)
    end
    if self:GetParent():GetUnitName() == "npc_elder_spirit" then
        UTIL_Remove(self:GetParent())
    end
end

function modifier_ability_npc_titan_boss_stomp:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_STUNNED] = true
    }
end

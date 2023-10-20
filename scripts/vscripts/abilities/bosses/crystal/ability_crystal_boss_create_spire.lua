ability_crystal_boss_create_spire = class({})

function ability_crystal_boss_create_spire:OnSpellStart()
    local pos = self:GetCursorPosition()
    self.unit = CreateUnitByName("npc_crystal_spire", pos, false, nil, nil, self:GetCaster():GetTeamNumber())
    self.unit:AddNewModifier(self:GetCaster(), self, "modifier_crystal_boss_laser_spire", {duration = 5})
end

LinkLuaModifier("modifier_crystal_boss_laser_spire", "abilities/bosses/crystal/ability_crystal_boss_create_spire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_crystal_boss_laser_spire_thinker", "abilities/bosses/crystal/ability_crystal_boss_create_spire", LUA_MODIFIER_MOTION_NONE )

modifier_crystal_boss_laser_spire = class({})
--Classifications template
function modifier_crystal_boss_laser_spire:IsHidden()
    return true
end

function modifier_crystal_boss_laser_spire:IsDebuff()
    return false
end

function modifier_crystal_boss_laser_spire:IsPurgable()
    return false
end

function modifier_crystal_boss_laser_spire:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_crystal_boss_laser_spire:IsStunDebuff()
    return false
end

function modifier_crystal_boss_laser_spire:RemoveOnDeath()
    return true
end

function modifier_crystal_boss_laser_spire:DestroyOnExpire()
    return true
end

function modifier_crystal_boss_laser_spire:OnCreated()
    if not IsServer() then
        return
    end
    self.parent = self:GetParent()
    for i=1, 4 do
        self.thinker = CreateModifierThinker(self.parent, self:GetAbility(), "modifier_crystal_boss_laser_spire_thinker", {}, self.parent:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), false)
        self.particle = ParticleManager:CreateParticle("particles/boses/laser_blue.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControlEnt(self.particle, 0, self.parent, PATTACH_POINT_FOLLOW, "attach_hitloc", self.parent:GetAbsOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.particle, 3, self.thinker, PATTACH_POINT_FOLLOW, "attach_hitloc", self.thinker:GetAbsOrigin(), true)
        self:AddParticle(self.particle, false, false, -1, false, false)
    end
    EmitSoundOn("Hero_Phoenix.SunRay.Cast", self.parent)
    EmitSoundOn("Hero_Phoenix.SunRay.Loop", self.parent)
end

function modifier_crystal_boss_laser_spire:OnDestroy()
    if not IsServer() then
        return
    end
    StopSoundOn("Hero_Phoenix.SunRay.Loop", self.parent)
    EmitSoundOn("Hero_Phoenix.SunRay.Stop", self.parent)
    UTIL_Remove(self.thinker)
    UTIL_Remove(self:GetParent())
end

function modifier_crystal_boss_laser_spire:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
end

modifier_crystal_boss_laser_spire_thinker = class({})

function modifier_crystal_boss_laser_spire_thinker:OnCreated()
    if not IsServer() then
        return
    end
    self.parent = self:GetParent()
    self.pos = self:GetAbility().unit:GetAbsOrigin()
    self.new_pos = self.pos + RandomVector(RandomInt(300, 600))
    self.direction = Vector(RandomFloat(-1,1), RandomFloat(-1,1), 0)
    self.direction.z = 0
    self.direction = self.direction:Normalized()
    self:StartIntervalThink(FrameTime())
end

function modifier_crystal_boss_laser_spire_thinker:OnIntervalThink()
    local pos = self.parent:GetAbsOrigin() + self.direction * 8
    self.parent:SetAbsOrigin(pos)
    local units = FindUnitsInRadius(self.parent:GetTeamNumber(), pos, nil, 50, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,unit in pairs(units) do
        ApplyDamage({
            victim = unit,
            attacker = self:GetCaster(),
            damage = unit:GetMaxHealth() * 0.2 * FrameTime(),
            damage_type = DAMAGE_TYPE_PURE,
            damage_flags = 0,
            ability = self:GetAbility()
        })
    end
end
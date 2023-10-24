mega_boss_rupture = class({})

LinkLuaModifier( "modifier_mega_boss_rupture", "abilities/bosses/mega/mega_boss_rupture" ,LUA_MODIFIER_MOTION_NONE )

function mega_boss_rupture:OnSpellStart()
    local duration = self:GetSpecialValueFor("duration")
    EmitSoundOn("hero_bloodseeker.rupture.cast", self:GetCaster())
    EmitSoundOn("hero_bloodseeker.rupture", self:GetCursorTarget())
    local particle = ParticleManager:CreateParticle("particles/abilities/rupture_burst.vpcf", PATTACH_POINT, self:GetCursorTarget())
    ParticleManager:SetParticleControl(particle, 0, self:GetCursorTarget():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)
    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_mega_boss_rupture", {duration=duration})
end

modifier_mega_boss_rupture = class({})
--Classifications template
function modifier_mega_boss_rupture:IsHidden()
    return false
end

function modifier_mega_boss_rupture:IsDebuff()
    return true
end

function modifier_mega_boss_rupture:IsPurgable()
    return false
end

function modifier_mega_boss_rupture:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_mega_boss_rupture:IsStunDebuff()
    return false
end

function modifier_mega_boss_rupture:RemoveOnDeath()
    return true
end

function modifier_mega_boss_rupture:DestroyOnExpire()
    return true
end

function modifier_mega_boss_rupture:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(0.25)
    self:OnIntervalThink()
    EmitSoundOn("hero_bloodseeker.rupture_FP", self:GetParent())
end

function modifier_mega_boss_rupture:OnDestroy()
    if not IsServer() then
        return
    end
    StopSoundOn("hero_bloodseeker.rupture_FP", self:GetParent())
end

function modifier_mega_boss_rupture:OnIntervalThink()
    local newPos = self:GetParent():GetAbsOrigin()
    if self.oldPos == nil then
        self.oldPos = newPos
    end

    local distance = (newPos - self.oldPos):Length2D()
    if distance > 0 and distance < 1300 then
        local particle = ParticleManager:CreateParticle("particles/abilities/rupture_burst.vpcf", PATTACH_POINT, self:GetParent())
        ParticleManager:SetParticleControl(particle, 0, newPos)
        ParticleManager:ReleaseParticleIndex(particle)
        local damage = distance / 100 * self:GetAbility():GetSpecialValueFor("movement_damage_pct")
        ApplyDamage({
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = self:GetAbility():GetAbilityDamageType(),
            ability = self:GetAbility()
        })
    end
    self.oldPos = newPos
end

function modifier_mega_boss_rupture:GetStatusEffectName()
    return "particles/status_fx/status_effect_rupture.vpcf"
end

function modifier_mega_boss_rupture:HeroEffectPriority()
    return MODIFIER_PRIORITY_HIGH
end

function modifier_mega_boss_rupture:GetEffectName()
    return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf"
end

function modifier_mega_boss_rupture:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end
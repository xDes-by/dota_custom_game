LinkLuaModifier( "modifier_npc_dota_hero_bloodseeker_str9", "heroes/hero_bloodseeker/rapture_lua" ,LUA_MODIFIER_MOTION_NONE )

if npc_dota_hero_bloodseeker_str9 == nil then
    npc_dota_hero_bloodseeker_str9 = class({})
end

--------------------------------------------------------------------------------

function npc_dota_hero_bloodseeker_str9:OnSpellStart(target)
    local caster = self:GetCaster()

    if target:TriggerSpellAbsorb(self) then return end

    EmitSoundOn("hero_bloodseeker.rupture.cast", caster)
    EmitSoundOn("hero_bloodseeker.rupture", target)

    local particle = ParticleManager:CreateParticle("particles/abilities/rupture_burst.vpcf", PATTACH_POINT, target)
    ParticleManager:SetParticleControl(particle, 0, target:GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(particle)

    target:AddNewModifier(caster, self, "modifier_npc_dota_hero_bloodseeker_str9", {duration=3})
end

--------------------------------------------------------------------------------


modifier_npc_dota_hero_bloodseeker_str9 = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return true end,
    IsBuff                  = function(self) return false end,
    RemoveOnDeath           = function(self) return true end,
    GetStatusEffectName     = function(self) return "particles/status_fx/status_effect_rupture.vpcf" end,
    HeroEffectPriority      = function(self) return 100 end,
    GetEffectName           = function(self) return "particles/units/heroes/hero_bloodseeker/bloodseeker_rupture.vpcf" end,
    GetEffectAttachType     = function(self) return PATTACH_ABSORIGIN_FOLLOW end,
})


--------------------------------------------------------------------------------

if IsServer() then
function modifier_npc_dota_hero_bloodseeker_str9:OnCreated()
    self:StartIntervalThink(0.25)
    EmitSoundOn("hero_bloodseeker.rupture_FP", self:GetParent())
end

function modifier_npc_dota_hero_bloodseeker_str9:OnDestroy()
    StopSoundOn("hero_bloodseeker.rupture_FP", self:GetParent())
end

function modifier_npc_dota_hero_bloodseeker_str9:OnIntervalThink()
    local caster = self:GetCaster()
    local target = self:GetParent()
        
    local newPos = target:GetAbsOrigin()
    if self.oldPos == nil then
        self.oldPos = newPos
    end

    local distance = (newPos - self.oldPos):Length2D()
    if distance > 0 and distance < 1300 then
        local particle = ParticleManager:CreateParticle("particles/abilities/rupture_burst.vpcf", PATTACH_POINT, target)
        ParticleManager:SetParticleControl(particle, 0, newPos)
        ParticleManager:ReleaseParticleIndex(particle)
        local damage = distance / 100 * 60
        ApplyDamage({
            victim = target,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility()
        })
    end
    self.oldPos = newPos
end
end
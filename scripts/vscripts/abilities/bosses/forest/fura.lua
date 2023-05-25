LinkLuaModifier( "modifier_penek_passive", "abilities/bosses/forest/fura.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_penek_passive_aura", "abilities/bosses/forest/fura.lua", LUA_MODIFIER_MOTION_NONE )

penek = class({})

function penek:GetCooldown(level)
    return self.BaseClass.GetCooldown( self, level )
end

function penek:GetCastRange(location, target)
    return self.BaseClass.GetCastRange(self, location, target)
end

function penek:GetManaCost(level)
    return self.BaseClass.GetManaCost(self, level)
end

function penek:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function penek:OnSpellStart()
    local caster = self:GetCaster()
    local point = self:GetCursorPosition()
    local duration = self:GetSpecialValueFor('duration')
    local radius = self:GetSpecialValueFor( "radius" )
    GridNav:DestroyTreesAroundPoint(point, radius, false)
    self.penek = CreateUnitByName("npc_pen", point, true, caster, nil, caster:GetTeamNumber())
    self.penek:SetOwner(caster)
    FindClearSpaceForUnit(self.penek, self.penek:GetAbsOrigin(), true)
    self.penek:AddNewModifier(self:GetCaster(), self, "modifier_kill", {duration = duration})
    self.penek:AddNewModifier(self:GetCaster(), self, "modifier_penek_passive", {duration = duration})
end

modifier_penek_passive = class({})

function modifier_penek_passive:IsHidden()
    return true
end

function modifier_penek_passive:IsPurgable()
    return false
end

function modifier_penek_passive:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(1)
    local duration = self:GetAbility():GetSpecialValueFor('duration')
    local radius = self:GetAbility():GetSpecialValueFor( "radius" )
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_treant/treant_eyesintheforest.vpcf", PATTACH_WORLDORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(particle, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle, 1, Vector(radius, radius, radius))

    Timers:CreateTimer(duration, function()
        ParticleManager:DestroyParticle(particle, false)
        ParticleManager:ReleaseParticleIndex(particle)
    end)
end

function modifier_penek_passive:OnIntervalThink()
    local radius = self:GetAbility():GetSpecialValueFor( "radius" ) 
    local units = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 0, 0, false)
    self:SpawnEffect()
    for i,unit in ipairs(units) do
        local radius = self:GetAbility():GetSpecialValueFor( "radius" )
        local heal_pct = self:GetAbility():GetSpecialValueFor( "pct_heal" )
        local heal = unit:GetMaxHealth() / 100 * heal_pct
        local damage_pct = self:GetAbility():GetSpecialValueFor( "pct_damage" )
        local target_health_percentage = unit:GetMaxHealth() / 100
        local damage_percentage = target_health_percentage * damage_pct
        local base_damage = self:GetAbility():GetSpecialValueFor( "base_damage" )
        local total_damage = damage_percentage + base_damage
        local caster_team = self:GetCaster():GetTeamNumber()
        if unit:IsAncient() then return end
        if unit:GetTeamNumber() ~= caster_team then
            ApplyDamage({ victim = unit, attacker = self:GetCaster(), damage = total_damage, ability = self:GetParent(), damage_type = DAMAGE_TYPE_MAGICAL })
        else
            unit:Heal(heal, self:GetCaster())
        end
    end
end

function modifier_penek_passive:SpawnEffect()
    local radius = self:GetAbility():GetSpecialValueFor( "radius" )
    local particle_pre_blast_fx = ParticleManager:CreateParticle("particles/pocik/penek_effect.vpcf", PATTACH_CUSTOMORIGIN, nil)
    ParticleManager:SetParticleControl(particle_pre_blast_fx, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_pre_blast_fx, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), 0.25, 1))
    ParticleManager:ReleaseParticleIndex(particle_pre_blast_fx)
    local particle_blast_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_pugna/pugna_netherblast.vpcf", PATTACH_ABSORIGIN, self:GetParent())
    ParticleManager:SetParticleControl(particle_blast_fx, 0, self:GetParent():GetAbsOrigin())
    ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(self:GetAbility():GetSpecialValueFor("radius"), 0, 0))
    ParticleManager:ReleaseParticleIndex(particle_blast_fx)
    EmitSoundOn("Hero_Pugna.NetherBlast", self:GetParent())
end

function modifier_penek_passive:CheckState()
    local state = { [MODIFIER_STATE_STUNNED] = true,
    [MODIFIER_STATE_MAGIC_IMMUNE] = true,
[MODIFIER_STATE_ATTACK_IMMUNE] = true,
[MODIFIER_STATE_SILENCED] = true,
[MODIFIER_STATE_MUTED] = true,
[MODIFIER_STATE_ROOTED] = true,
[MODIFIER_STATE_DISARMED] = true,
[MODIFIER_STATE_UNSELECTABLE] = true,
[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
[MODIFIER_STATE_NO_HEALTH_BAR] = true,
[MODIFIER_STATE_INVULNERABLE] = true,}
    return state
end

function modifier_penek_passive:IsAura() return true end

function modifier_penek_passive:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY end

function modifier_penek_passive:GetAuraSearchType()
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_penek_passive:GetModifierAura()
    return "modifier_penek_passive_aura"
end

function modifier_penek_passive:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

modifier_penek_passive_aura = class({})

function modifier_penek_passive_aura:IsHidden()
    return true
end

function modifier_penek_passive_aura:IsPurgable()
    return false
end

function modifier_penek_passive_aura:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.1)
end

function modifier_penek_passive_aura:OnIntervalThink()
    if self:GetParent():IsAncient() then return end
    local unit_location = self:GetParent():GetAbsOrigin()
    local vector_distance = self:GetAuraOwner():GetAbsOrigin() - unit_location
    local distance = (vector_distance):Length2D()
    local direction = (vector_distance):Normalized()
    if distance >= 50 then
        self:GetParent():SetAbsOrigin(unit_location + direction * 6)
    else
        self:GetParent():SetAbsOrigin(unit_location)
    end
end

function modifier_penek_passive_aura:CheckState()
    local state = { [MODIFIER_STATE_NO_UNIT_COLLISION] = true,}
    return state
end
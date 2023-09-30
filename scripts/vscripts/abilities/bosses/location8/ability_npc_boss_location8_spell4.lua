ability_npc_boss_location8_spell4 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_location8_spell4","abilities/bosses/location8/ability_npc_boss_location8_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_location8_spell4_effect","abilities/bosses/location8/ability_npc_boss_location8_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_location8_secont_phase","abilities/bosses/location8/ability_npc_boss_location8_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_location8_secont_phase_active","abilities/bosses/location8/ability_npc_boss_location8_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snap_second_phase","abilities/bosses/location8/ability_npc_boss_location8_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_snap_second_phase_target","abilities/bosses/location8/ability_npc_boss_location8_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )

function ability_npc_boss_location8_spell4:OnSpellStart()
    local trigger = self:GetSpecialValueFor("balls_count")
    Timers:CreateTimer(0.2,function()
        trigger = trigger - 1
        if trigger > 0 then
			local pos = self:GetCaster():GetOrigin()
            local npc = CreateModifierThinker(self:GetCaster(), self, "modifier_ability_npc_boss_location8_spell4", {duration = 3}, pos + RandomVector(RandomInt(50, 400)), self:GetCaster():GetTeamNumber(), false)
            ProjectileManager:CreateTrackingProjectile{
                Source = self:GetCaster(),
                Ability = self,	
                
                EffectName = "particles/units/heroes/hero_snapfire/snapfire_lizard_blobs_arced.vpcf",
                iMoveSpeed = 1300,
                bDodgeable = false,                           -- Optional
                Target = npc,
                vSourceLoc = self:GetCaster():GetOrigin(),                -- Optional (HOW)
                
                bDrawsOnMinimap = false,                          -- Optional
                bVisibleToEnemies = true,                         -- Optional
                bProvidesVision = true,                           -- Optional
                iVisionRadius = true,                              -- Optional
                iVisionTeamNumber = self:GetCaster():GetTeamNumber(),        -- Optional
            }
            return 0.2
        end
    end)
	EmitSoundOn( "Hero_Snapfire.MortimerBlob.Launch", self:GetCaster() )
end

function ability_npc_boss_location8_spell4:OnProjectileHit(hTarget, vLocation)
    hTarget:FindModifierByName("modifier_ability_npc_boss_location8_spell4"):Active()
end

function ability_npc_boss_location8_spell4:GetIntrinsicModifierName()
    return "modifier_ability_npc_boss_location8_secont_phase"
end

modifier_ability_npc_boss_location8_spell4 = class({})

function modifier_ability_npc_boss_location8_spell4:Active()
    local loc = self:GetParent():GetOrigin()
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), loc, nil, self:GetAbility():GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
    for _,unit in pairs(enemies) do
        ApplyDamage({victim = unit,
        damage = self:GetAbility():GetSpecialValueFor("damage_hit"),
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NONE,
        attacker = self:GetCaster(),
        ability = self:GetAbility()})
    end
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_impact.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 3, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_snapfire/hero_snapfire_ultimate_linger.vpcf", PATTACH_WORLDORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 0, loc )
	ParticleManager:SetParticleControl( effect_cast, 1, loc )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOnLocationWithCaster( loc, "Hero_Snapfire.MortimerBlob.Impact", self:GetCaster() )
    self.aura = true
end

function modifier_ability_npc_boss_location8_spell4:OnDestroy()
    UTIL_Remove(self:GetParent())
end

-- Aura template
function modifier_ability_npc_boss_location8_spell4:IsAura()
    return self.aura
end

function modifier_ability_npc_boss_location8_spell4:GetModifierAura()
    return "modifier_ability_npc_boss_location8_spell4_effect"
end

function modifier_ability_npc_boss_location8_spell4:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_ability_npc_boss_location8_spell4:GetAuraDuration()
    return 3
end

function modifier_ability_npc_boss_location8_spell4:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_npc_boss_location8_spell4:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_npc_boss_location8_spell4:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

-----------------------------------------------------------------

modifier_ability_npc_boss_location8_spell4_effect = class({})

function modifier_ability_npc_boss_location8_spell4_effect:IsHidden()
    return false
end

function modifier_ability_npc_boss_location8_spell4_effect:IsDebuff()
    return true
end

function modifier_ability_npc_boss_location8_spell4_effect:IsPurgable()
    return true
end

function modifier_ability_npc_boss_location8_spell4_effect:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_location8_spell4_effect:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_location8_spell4_effect:OnCreated()
    if IsClient() then
        return
    end
    self.slow = self:GetAbility():GetSpecialValueFor("slow")
    self:StartIntervalThink(1)
end

function modifier_ability_npc_boss_location8_spell4_effect:OnIntervalThink()
    ApplyDamage({victim = self:GetParent(),
    damage = self:GetParent():GetHealth() * 0.1,
    damage_type = DAMAGE_TYPE_MAGICAL,
    damage_flags = DOTA_DAMAGE_FLAG_NONE,
    attacker = self:GetCaster(),
    ability = self:GetAbility()})
end

function modifier_ability_npc_boss_location8_spell4_effect:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
    }
end

function modifier_ability_npc_boss_location8_spell4_effect:GetModifierMoveSpeedBonus_Percentage()
    return -self.slow
end

modifier_ability_npc_boss_location8_secont_phase = class({})
--Classifications template
function modifier_ability_npc_boss_location8_secont_phase:IsHidden()
    return true
end

function modifier_ability_npc_boss_location8_secont_phase:IsDebuff()
    return false
end

function modifier_ability_npc_boss_location8_secont_phase:IsPurgable()
    return false
end

function modifier_ability_npc_boss_location8_secont_phase:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_boss_location8_secont_phase:IsStunDebuff()
    return false
end

function modifier_ability_npc_boss_location8_secont_phase:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_location8_secont_phase:DestroyOnExpire()
    return true
end

function modifier_ability_npc_boss_location8_secont_phase:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MIN_HEALTH,
        MODIFIER_EVENT_ON_TAKEDAMAGE
    }
end

function modifier_ability_npc_boss_location8_secont_phase:GetMinHealth()
    if not self.secon_phase then
        return self:GetParent():GetMaxHealth() / 2.5
    end
end

function modifier_ability_npc_boss_location8_secont_phase:OnTakeDamage(data)
    if data.unit ~= self:GetParent() then
        return
    end
    -- if not self.secon_phase and self:GetParent():GetHealth() <= self:GetParent():GetMaxHealth() / 2 then
        -- self.secon_phase = true
        local pos = self:GetCaster():GetAbsOrigin()

        local direction_1 = RotatePosition(Vector(0,0,0), QAngle(0,30,0), self:GetCaster():GetForwardVector() * -1)
        local direction_2 = RotatePosition(Vector(0,0,0), QAngle(0,-30,0), self:GetCaster():GetForwardVector() * -1)

        local target = data.attacker:entindex()
        local unit = CreateUnitByName("npc_mortimer_second_phase", pos + direction_1 * 600, false, nil, nil, self:GetParent():GetTeamNumber())
        unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_snap_second_phase", {target = target})
        local unit = CreateUnitByName("npc_mortimer_second_phase", pos + direction_2 * 600, false, nil, nil, self:GetParent():GetTeamNumber())
        unit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_snap_second_phase", {delay = 1.5, target = target})

        local playerid = data.attacker:GetPlayerOwnerID()
        local hero = data.attacker
        local tab = CustomNetTables:GetTableValue("player_pets", tostring(playerid))
        if tab then
            if tab.pet ~= nil then
                local ability = hero:FindAbilityByName(tab.pet)
                ability:StartCooldown(5)
            end
        end
    -- end
end

modifier_snap_second_phase = class({})
--Classifications template
function modifier_snap_second_phase:IsHidden()
    return true
end

function modifier_snap_second_phase:IsDebuff()
    return false
end

function modifier_snap_second_phase:IsPurgable()
    return false
end

function modifier_snap_second_phase:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_snap_second_phase:IsStunDebuff()
    return false
end

function modifier_snap_second_phase:RemoveOnDeath()
    return true
end

function modifier_snap_second_phase:DestroyOnExpire()
    return true
end

function modifier_snap_second_phase:OnCreated(data)
    if not IsServer() then
        return
    end
    self.parent = self:GetParent()
    self.target = EntIndexToHScript(data.target)
    if data.delay then
        self:StartIntervalThink(1.5)
    else
        self:OnIntervalThink()
    end
end

function modifier_snap_second_phase:OnIntervalThink()
    if self.target == nil then
        self:Destroy()
        return
    end
    self.pos = self.target:GetAbsOrigin()
    local dir = self.pos - self.parent:GetAbsOrigin()
    dir.z = 0
    dir = dir:Normalized()
    self.parent:SetForwardVector(dir)
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_snap_second_phase_target", {})
    local arc = self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_generic_arc_lua",
            {dir_x = dir.x, dir_y = dir.y, duration = 1.5, distance = 1400, isForward = true, activity = ACT_DOTA_FLAIL})
    arc:SetEndCallback(function()
        UTIL_Remove(self:GetParent())
    end)
    self:StartIntervalThink(-1)
end

function modifier_snap_second_phase:OnDestroy()
    if not IsServer() then
        return
    end
    UTIL_Remove(self:GetParent())
end

function modifier_snap_second_phase:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NOT_ON_MINIMAP] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end

modifier_snap_second_phase_target = class({})
--Classifications template
function modifier_snap_second_phase_target:IsHidden()
    return true
end

function modifier_snap_second_phase_target:IsDebuff()
    return false
end

function modifier_snap_second_phase_target:IsPurgable()
    return false
end

function modifier_snap_second_phase_target:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_snap_second_phase_target:IsStunDebuff()
    return false
end

function modifier_snap_second_phase_target:RemoveOnDeath()
    return true
end

function modifier_snap_second_phase_target:DestroyOnExpire()
    return true
end

function modifier_snap_second_phase_target:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(FrameTime())
end

function modifier_snap_second_phase_target:OnIntervalThink()
    local pos = self:GetParent():GetAbsOrigin()
    local units = FindUnitsInRadius(self:GetParent():GetTeamNumber(), pos, nil, 150,  DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    for _,u in pairs(units) do
        if not u:HasModifier("modifier_stunned") then
            local dir = pos - u:GetAbsOrigin()
            dir.z = 0
            dir = dir:Normalized()
            u:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_generic_arc_lua",
                {dir_x = dir.x, dir_y = dir.y, duration = 0.5, distance = 150, height = 50, activity = ACT_DOTA_FLAIL})
            u:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = 1.7})
        end
    end
end
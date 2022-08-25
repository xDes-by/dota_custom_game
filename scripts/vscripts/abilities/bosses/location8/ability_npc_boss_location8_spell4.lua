ability_npc_boss_location8_spell4 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_location8_spell4","abilities/bosses/location8/ability_npc_boss_location8_spell4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_location8_spell4_effect","abilities/bosses/location8/ability_npc_boss_location8_spell4", LUA_MODIFIER_MOTION_NONE )

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

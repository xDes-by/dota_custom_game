LinkLuaModifier( "modifier_vengeful_spirit_magic_missile", "heroes/hero_vengeful_spirit/magic_missile/magic_missile" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vengeful_spirit_magic_missile_criticalstrike", "heroes/hero_vengeful_spirit/magic_missile/magic_missile" ,LUA_MODIFIER_MOTION_NONE )
if vengeful_spirit_magic_missile == nil then
    vengeful_spirit_magic_missile = class({})
end

function vengeful_spirit_magic_missile:GetIntrinsicModifierName()
    return "modifier_vengeful_spirit_magic_missile"
end

--------------------------------------------------------------------------------
function vengeful_spirit_magic_missile:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function vengeful_spirit_magic_missile:OnSpellStart(Target)
    speed = self:GetSpecialValueFor("magic_missile_speed")
    magic_missile_stun = self:GetSpecialValueFor("magic_missile_stun")

    local caster = self:GetCaster()
    local target = self:GetCursorTarget()
    if Target then 
        target = Target
        magic_missile_stun = 0
    end
    caster:EmitSound("Hero_VengefulSpirit.MagicMissile")

    proj = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf"

    info = {
        Target = target,
        Source = caster,
        Ability = self,
        EffectName = proj,
        bDodgeable = false,
        bIsAttack = false,
        bProvidesVision = true,
        iMoveSpeed = speed,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
        ExtraData = {
			usedByPlayer = 1,
            magic_missile_stun = magic_missile_stun,
		}
    }
    ProjectileManager:CreateTrackingProjectile( info )
end

function vengeful_spirit_magic_missile:OnProjectileHit_ExtraData(Target, Location, ExtraData)
    if Target ~= nil and not Target:IsInvulnerable() then
        local damage = self:GetSpecialValueFor("magic_missile_damage")
        local magic_missile_stun = ExtraData.magic_missile_stun

        if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_str6") then
            damage = damage + self:GetCaster():GetStrength() * 0.5
        end
        if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_int8") then
            damage = damage + self:GetCaster():GetIntellect() * 0.5
        end
        if Target:TriggerSpellAbsorb(self) then
            return false
        end

        ApplyDamage({
            victim = Target,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = self:GetAbilityDamageType(),
            ability = self
        })

        if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi10") then
            self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_vengeful_spirit_magic_missile_criticalstrike", {})
            self:GetCaster():PerformAttack(Target, true, true, true, false, false, false, true)
            self:GetCaster():RemoveModifierByName("modifier_vengeful_spirit_magic_missile_criticalstrike")
        end

        EmitSoundOn("Hero_VengefulSpirit.MagicMissileImpact", Target)

        Target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration=magic_missile_stun})
        if ExtraData.usedByPlayer == 1 and self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_int11") then
            local enemies = FindUnitsInRadius(
                self:GetCaster():GetTeamNumber(),	-- int, your team number
                Target:GetOrigin(),	-- point, center point
                nil,	-- handle, cacheUnit. (not known)
                300,	-- float, radius. or use FIND_UNITS_EVERYWHERE
                DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
                0,	-- int, flag filter
                0,	-- int, order filter
                false	-- bool, can grow cache
            )
            
            if #enemies > 1 then
                local enemie = enemies[1]
                if enemie == Target then
                    enemie = enemies[2]
                end
                Target:EmitSound("Hero_VengefulSpirit.MagicMissile")
                local projectile = {
                    Target = enemie,
                    Source = Target,
                    Ability = self,
                    EffectName = "particles/units/heroes/hero_vengeful/vengeful_magic_missle.vpcf",
                    bDodgable = false,
                    bProvidesVision = false,
                    iMoveSpeed = self:GetSpecialValueFor("magic_missile_speed"),
                    iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
                    ExtraData =
                    {
                        usedByPlayer			= 0,
                        magic_missile_stun = magic_missile_stun,
                    }
                }
                ProjectileManager:CreateTrackingProjectile(projectile)
            end
        end
    end
    return false
end




modifier_vengeful_spirit_magic_missile = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return false end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_EVENT_ON_ATTACK,
        }
    end,
})

function modifier_vengeful_spirit_magic_missile:OnAttack( params )
    caster = self:GetCaster()
    if params.attacker == self:GetParent() and not params.target:IsMagicImmune() and not params.target:IsBuilding() then
        if caster:FindAbilityByName("npc_dota_hero_vengefulspirit_int13") then
            if RollPercentage(9) and not caster:IsSilenced() and self:GetAbility():IsActivated() then
                self:GetAbility():OnSpellStart(params.target)
            end
        elseif caster:FindAbilityByName("npc_dota_hero_vengefulspirit_int12") then
            if RollPercentage(5) and not caster:IsSilenced() and self:GetAbility():IsActivated() then
                self:GetAbility():OnSpellStart(params.target)
            end
        end
    end
end

modifier_vengeful_spirit_magic_missile_criticalstrike = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
        }
    end,
    GetModifierPreAttack_CriticalStrike = function(self)
        return 100 + 75 * self:GetAbility():GetLevel()
    end,
})
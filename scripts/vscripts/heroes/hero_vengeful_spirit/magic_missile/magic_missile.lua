LinkLuaModifier( "modifier_vengeful_spirit_magic_missile", "heroes/hero_vengeful_spirit/magic_missile/magic_missile" ,LUA_MODIFIER_MOTION_NONE )
if vengeful_spirit_magic_missile == nil then
    vengeful_spirit_magic_missile = class({})
end

function vengeful_spirit_magic_missile:GetIntrinsicModifierName()
    return "modifier_vengeful_spirit_magic_missile"
end

--------------------------------------------------------------------------------

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
            local min_value = 35
            local max_value = 110
            local perc = min_value + self:GetLevel() * ((max_value - min_value) / 15)
            damage = damage + (perc * self:GetCaster():GetStrength()) -- талант 30->120 силы в урон
        end
        if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_int8") then
            local min_value = 35
            local max_value = 90
            local perc = min_value + self:GetLevel() * ((max_value - min_value) / 15)
            damage = damage + (perc * self:GetCaster():GetStrength()) -- талант 30->120 силы в урон
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

        EmitSoundOn("Hero_VengefulSpirit.MagicMissileImpact", Target)

        Target:AddNewModifier(self:GetCaster(), self, "modifier_stunned", {duration=magic_missile_stun})
        DeepPrintTable(ExtraData)
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
                        usedByPlayer			= 0
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
    if params.attacker == self:GetParent() then
        if caster:FindAbilityByName("npc_dota_hero_vengefulspirit_int_last") and RollPseudoRandomPercentage(9, caster:entindex(), caster) then
            self:GetAbility():OnSpellStart(params.target)
        end
    end
end
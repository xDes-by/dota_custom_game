LinkLuaModifier("modifier_muerta_gunslinger_lua", "heroes/hero_muerta/muerta_gunslinger_lua/muerta_gunslinger_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_lua_debuff", "heroes/hero_muerta/muerta_gunslinger_lua/muerta_gunslinger_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_lua_doubleshot", "heroes/hero_muerta/muerta_gunslinger_lua/muerta_gunslinger_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_muerta_gunslinger_lua_doubleshot_damage", "heroes/hero_muerta/muerta_gunslinger_lua/muerta_gunslinger_lua.lua", LUA_MODIFIER_MOTION_NONE)

local ItemBaseClass = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return false end,
    IsHidden = function(self) return true end,
    IsStackable = function(self) return false end,
}

local ItemBaseClassDebuff = {
    IsPurgable = function(self) return false end,
    RemoveOnDeath = function(self) return true end,
    IsHidden = function(self) return false end,
    IsStackable = function(self) return false end,
    IsDebuff = function(self) return true end,
}

muerta_gunslinger_lua = class(ItemBaseClass)
modifier_muerta_gunslinger_lua = class(muerta_gunslinger_lua)
modifier_muerta_gunslinger_lua_debuff = class(ItemBaseClassDebuff)
modifier_muerta_gunslinger_lua_doubleshot = class(ItemBaseClassDebuff)
modifier_muerta_gunslinger_lua_doubleshot_damage = class(ItemBaseClassDebuff)
-------------
function muerta_gunslinger_lua:GetIntrinsicModifierName()
    return "modifier_muerta_gunslinger_lua"
end

function muerta_gunslinger_lua:OnProjectileHit(target, location)
    if not target then return end	
    local caster = self:GetCaster()
    local ability = self

    target:AddNewModifier(caster, ability, "modifier_muerta_gunslinger_lua_debuff", {
        duration = ability:GetSpecialValueFor("duration")
    })

    caster:AddNewModifier(caster, ability, "modifier_muerta_gunslinger_lua_doubleshot_damage", {
        duration = 1
    })

    caster:PerformAttack(
        target,
        true,
        true,
        true,
        false,
        false,
        false,
        false
    )

    EmitSoundOn("Hero_Muerta.Attack.DoubleShot", target)
end
------------
function modifier_muerta_gunslinger_lua:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_muerta_gunslinger_lua:FireShot(target)
    local parent = self:GetParent()

    parent:AddNewModifier(parent, self:GetAbility(), "modifier_muerta_gunslinger_lua_doubleshot", {
        targetindex = target:entindex()
    })
end

function modifier_muerta_gunslinger_lua:OnAttackStart(event)
    if not IsServer() then return end
    local parent = self:GetParent()

    if event.attacker ~= parent then return end
    if parent:PassivesDisabled() then return end
    if parent:HasModifier("modifier_muerta_gunslinger_lua_doubleshot") then return end

    local ability = self:GetAbility()

    if not RollPercentage(ability:GetSpecialValueFor("chance")) then return end

    parent:StartGesture(ACT_DOTA_CAST_ABILITY_3)

    local radius = parent:Script_GetAttackRange()+150

    local victims = FindUnitsInRadius(parent:GetTeam(), parent:GetAbsOrigin(), nil,
        radius, DOTA_UNIT_TARGET_TEAM_ENEMY, bit.bor(DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_BASIC), DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_CLOSEST, false)
    for _,victim in ipairs(victims) do
        if victim:IsAlive() and not victim:IsAttackImmune() and not victim:IsInvulnerable() then 
            self:FireShot(victim)
            break
        end
    end
end
-------------
function modifier_muerta_gunslinger_lua_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS 
    }
end

function modifier_muerta_gunslinger_lua_debuff:GetModifierPhysicalArmorBonus()
    return self:GetAbility():GetSpecialValueFor("armor_reduction")
end
--------
function modifier_muerta_gunslinger_lua_doubleshot:IsHidden()
    return true 
end

function modifier_muerta_gunslinger_lua_doubleshot:OnDestroy()
    if not IsServer() then return end

    local parent = self:GetParent()

    parent:RemoveGesture(ACT_DOTA_CAST_ABILITY_3)
end

function modifier_muerta_gunslinger_lua_doubleshot:OnCreated(params)
    if not IsServer() then return end

    local parent = self:GetParent()

    self.target = EntIndexToHScript(params.targetindex)
    if self.target:IsNull() then self:Destroy() return end
    if not self.target:IsAlive() then self:Destroy() return end

    local effect_castLeft = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_gunslinger_left.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControlEnt(
        effect_castLeft,
        0,
        parent,
        PATTACH_CUSTOMORIGIN_FOLLOW,
        "attach_attack1",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )

    ParticleManager:ReleaseParticleIndex(effect_castLeft)

    local effect_castRight = ParticleManager:CreateParticle("particles/units/heroes/hero_muerta/muerta_gunslinger_right.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, parent)
    ParticleManager:SetParticleControlEnt(
        effect_castRight,
        0,
        parent,
        PATTACH_CUSTOMORIGIN_FOLLOW,
        "attach_attack2",
        Vector(0,0,0), -- unknown
        true -- unknown, true
    )

    ParticleManager:ReleaseParticleIndex(effect_castRight)

    self:StartIntervalThink(parent:GetAttackAnimationPoint())
end

function modifier_muerta_gunslinger_lua_doubleshot:OnIntervalThink()
    if not self.target then self:Destroy() end

    local parent = self:GetParent()

    local projName = parent:GetRangedProjectileName()
    local speed = parent:GetProjectileSpeed()

    local proj = {
        Target = self.target,
        iMoveSpeed = speed,
        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_2,
        bDodgeable = false,
        bVisibleToEnemies = true,
        EffectName = projName,
        Ability = self:GetAbility(),
        Source = parent,
        bProvidesVision = false,
    }

    ProjectileManager:CreateTrackingProjectile(proj)

    self:Destroy()
end
----------------
function modifier_muerta_gunslinger_lua_doubleshot_damage:IsHidden() return true end

function modifier_muerta_gunslinger_lua_doubleshot_damage:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY  
    }
end

function modifier_muerta_gunslinger_lua_doubleshot_damage:GetModifierDamageOutgoing_Percentage()
    if IsServer() then
        return self:GetAbility():GetSpecialValueFor("bonus_damage_pct")
    end
end

function modifier_muerta_gunslinger_lua_doubleshot_damage:OnAttackRecordDestroy(event)
    if event.attacker ~= self:GetParent() then return end

    self:Destroy()
end
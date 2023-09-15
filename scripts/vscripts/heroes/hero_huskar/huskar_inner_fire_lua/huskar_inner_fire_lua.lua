-- LinkLuaModifier("modifier_huskar_vitality_explosion_custom", "heroes/hero_huskar/vitality_explosion.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huskar_inner_fire_lua_debuff", "heroes/hero_huskar/huskar_inner_fire_lua/huskar_inner_fire_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_huskar_inner_fire_lua", "heroes/hero_huskar/huskar_inner_fire_lua/huskar_inner_fire_lua", LUA_MODIFIER_MOTION_NONE)

-- LinkLuaModifier( "modifier_huskar_burning_spear_custom", "heroes/hero_huskar/burning_spear_custom.lua", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_huskar_burning_spear_custom_stack", "heroes/hero_huskar/burning_spear_custom.lua", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_generic_orb_effect_lua", "modifiers/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )

-- local tempTable = require("libraries/tempTable")


huskar_inner_fire_lua = class({})

function huskar_inner_fire_lua:IsPurgable() return false end
function huskar_inner_fire_lua:RemoveOnDeath() return false end
function huskar_inner_fire_lua:IsHidden() return true end
function huskar_inner_fire_lua:IsStackable() return false end



-- modifier_huskar_vitality_explosion_custom = class(huskar_vitality_explosion_custom)

-------------
function huskar_inner_fire_lua:GetAOERadius()
    return self:GetSpecialValueFor("radius")
end

function huskar_inner_fire_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function huskar_inner_fire_lua:GetIntrinsicModifierName()
	return "modifier_huskar_inner_fire_lua"
end
function huskar_inner_fire_lua:OnSpellStart()

    EmitSoundOn("Hero_Huskar.Inner_Fire.Cast", self:GetCaster())
    self:PlayEffects(self:GetCaster())
    local damage = self:GetSpecialValueFor("base_damage")
    if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_int6") then
        damage = damage + self:GetCaster():GetIntellect()
    end
    local duration = self:GetSpecialValueFor("disarm_duration")
    local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), nil, self:GetSpecialValueFor( "radius" ), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)
    local count = self:GetSpecialValueFor("add_stack")
    local burning_spear = self:GetCaster():FindAbilityByName("huskar_burning_spear_lua")
    local burning_spear_duration = burning_spear:GetSpecialValueFor("duration")
    for _,enemy in pairs(enemies) do
        modifier = enemy:AddNewModifier(
            self:GetCaster(), -- player source
            burning_spear, -- ability source
            "modifier_huskar_burning_spear_lua", -- modifier name
            { duration = burning_spear_duration, auto_attack = true } -- kv
        )
        modifier:AddStack(2)
        ApplyDamage({
            victim = enemy,
            attacker = self:GetCaster(),
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
            ability 		= self
        })
    end
end

function huskar_inner_fire_lua:PlayEffects(target)
    -- Get Resources
    local particle_cast = "particles/units/heroes/hero_huskar/huskar_inner_fire.vpcf"

    -- Create Particle
    local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_POINT_FOLLOW, target )
    ParticleManager:SetParticleControl( effect_cast, 0, target:GetOrigin() )
    ParticleManager:ReleaseParticleIndex( effect_cast )
end
-------------
modifier_huskar_inner_fire_lua_debuff = class({})

function modifier_huskar_inner_fire_lua_debuff:IsPurgable() return false end
function modifier_huskar_inner_fire_lua_debuff:RemoveOnDeath() return false end
function modifier_huskar_inner_fire_lua_debuff:IsHidden() return false end
function modifier_huskar_inner_fire_lua_debuff:IsStackable() return true end
function modifier_huskar_inner_fire_lua_debuff:IsDebuff() return true end

function modifier_huskar_inner_fire_lua_debuff:CheckState()
    local state = {
        [MODIFIER_STATE_DISARMED] = true
    }

    return state
end




modifier_huskar_inner_fire_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_huskar_inner_fire_lua:IsHidden()
	return true
end

function modifier_huskar_inner_fire_lua:IsDebuff()
	return false
end

function modifier_huskar_inner_fire_lua:IsPurgable()
	return false
end

function modifier_huskar_inner_fire_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK
	}

	return funcs
end

function modifier_huskar_inner_fire_lua:OnAttack( keys )
	if keys.attacker == self:GetCaster() then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_int9") and RandomInt(1, 100) <= 10 then
            self:GetAbility():OnSpellStart()
        end
	end
end
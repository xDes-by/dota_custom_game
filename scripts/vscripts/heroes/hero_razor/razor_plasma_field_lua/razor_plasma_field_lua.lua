-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
razor_plasma_field_lua = class({})
LinkLuaModifier( "modifier_razor_plasma_field_lua", "heroes/hero_razor/razor_plasma_field_lua/modifier_razor_plasma_field_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_razor_plasma_field_lua_intrinsic", "heroes/hero_razor/razor_plasma_field_lua/razor_plasma_field_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_ring_lua", "heroes/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function razor_plasma_field_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_plasmafield.vpcf", context )
end
function razor_plasma_field_lua:GetIntrinsicModifierName()
	return "modifier_razor_plasma_field_lua_intrinsic"
end
function razor_plasma_field_lua:Spawn()
	if not IsServer() then return end
end
function razor_plasma_field_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
-- function razor_plasma_field_lua:GetCooldown( level )
-- 	if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_int8") then
-- 		return self.BaseClass.GetCooldown( self, level ) * 0.5
-- 	end
-- end

--------------------------------------------------------------------------------
-- Ability Start
function razor_plasma_field_lua:OnSpellStart(not_double)
	

	-- unit identifier
	local caster = self:GetCaster()
	if not not_double and self:GetCaster():FindAbilityByName("npc_dota_hero_razor_int11") ~= nil and not razor_plasma_field_lua.double_snake then
		Timers:CreateTimer(0.8, function()
			razor_plasma_field_lua.double_snake = true
			self:OnSpellStart()
			razor_plasma_field_lua.double_snake = false
		end)
	end
	-- load data
	local radius = self:GetSpecialValueFor( "radius" )
	local speed = self:GetSpecialValueFor( "speed" )

	-- play effects
	local effect = self:PlayEffects( radius, speed )

	-- create ring
	local pulse = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_ring_lua", -- modifier name
		{
			end_radius = radius,
			speed = speed,
			target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
			target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		} -- kv
	)
	pulse:SetCallback( function( enemy )
		self:OnHit( enemy )
	end)

	pulse:SetEndCallback( function()
		-- set effects
		ParticleManager:SetParticleControl( effect, 1, Vector( speed, radius, -1 ) )

		-- create retract ring
		local retract
		local dead = false
		if not caster:IsAlive() then
			dead = true
			-- dead units can't get modifiers
			local thinker = CreateModifierThinker(
				caster, -- player source
				self, -- ability source
				"modifier_generic_ring_lua", -- modifier name
				{
					start_radius = radius,
					end_radius = 0,
					speed = speed,
					target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
					target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				}, -- kv
				caster:GetOrigin(),
				caster:GetTeamNumber(),
				false
			)
			retract = thinker:FindModifierByName( "modifier_generic_ring_lua" )
		else
			retract = caster:AddNewModifier(
				caster, -- player source
				self, -- ability source
				"modifier_generic_ring_lua", -- modifier name
				{
					start_radius = radius,
					end_radius = 0,
					speed = speed,
					target_team = DOTA_UNIT_TARGET_TEAM_ENEMY,
					target_type = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				} -- kv
			)
		end
		retract:SetCallback( function( enemy )
			self:OnHit( enemy )
		end)

		retract:SetEndCallback( function()
			-- destroy particle
			ParticleManager:DestroyParticle( effect, false )
			ParticleManager:ReleaseParticleIndex( effect )
		end)
	end)
end

function razor_plasma_field_lua:OnHit( enemy )
	local caster = self:GetCaster()

	-- load data
	local radius = self:GetSpecialValueFor( "radius" )
	local damage_min = self:GetSpecialValueFor( "damage_min" )
	local damage_max = self:GetSpecialValueFor( "damage_max" )
	local slow_min = self:GetSpecialValueFor( "slow_min" )
	local slow_max = self:GetSpecialValueFor( "slow_max" )
	local duration = self:GetSpecialValueFor( "slow_duration" )

	-- calculate damage & slow
	local distance = (enemy:GetOrigin()-caster:GetOrigin()):Length2D()
	local pct = distance/radius
	pct = math.min(pct,1)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_str9") then
		pct = 1
	end
	local damage = damage_min + (damage_max-damage_min)*pct
	local slow = slow_min + (slow_max-slow_min)*pct

	if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_str6") then
		damage = damage + self:GetCaster():GetStrength()*0.75*pct
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_int8") then
		damage = damage + self:GetCaster():GetIntellect()*0.50*pct
	end

	-- apply damage
	local damageTable = {
		victim = enemy,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	-- slow
	enemy:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_razor_plasma_field_lua", -- modifier name
		{
			duration = duration,
			slow = slow,
		} -- kv
	)

	-- Play effects
	-- self:PlayEffects2( enemy )
	local sound_cast = "Ability.PlasmaFieldImpact"
	EmitSoundOn( sound_cast, enemy )
end

--------------------------------------------------------------------------------
-- Effects
function razor_plasma_field_lua:PlayEffects( radius, speed )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_razor/razor_plasmafield.vpcf"
	local sound_cast = "Ability.PlasmaField"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( speed, radius, 1 ) )

	EmitSoundOn( sound_cast, self:GetCaster() )

	return effect_cast
end

modifier_razor_plasma_field_lua_intrinsic = class({})

function modifier_razor_plasma_field_lua_intrinsic:IsHidden() return true end
function modifier_razor_plasma_field_lua_intrinsic:IsPurgable() return false end
function modifier_razor_plasma_field_lua_intrinsic:RemoveOnDeath() return false end

function modifier_razor_plasma_field_lua_intrinsic:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK,
	}
end

function modifier_razor_plasma_field_lua_intrinsic:OnAttack(params)
    self.caster = self:GetCaster()
    if params.attacker == self:GetParent() and self.caster:FindAbilityByName("npc_dota_hero_razor_int_last") and RollPercentage(10) then
        self:GetAbility():OnSpellStart(self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_razor_int50") == nil)
    end
end
-- 
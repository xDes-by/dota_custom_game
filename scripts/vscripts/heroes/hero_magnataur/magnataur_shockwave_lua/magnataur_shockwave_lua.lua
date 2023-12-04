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
magnataur_shockwave_lua = class({})
LinkLuaModifier( "modifier_magnataur_shockwave_lua", "heroes/hero_magnataur/magnataur_shockwave_lua/modifier_magnataur_shockwave_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magnataur_shockwave_buff_lua", "heroes/hero_magnataur/magnataur_shockwave_lua/modifier_magnataur_shockwave_buff_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------
-- Init Abilities
function magnataur_shockwave_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_shockwave_hit.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf", context )
end
--------------------------------------------------------------------------------
-- Ability Start
function magnataur_shockwave_lua:OnAbilityPhaseStart()
	if not IsServer() then return end

	-- play effects
	self:PlayEffects1()

	return true
end

function magnataur_shockwave_lua:OnAbilityPhaseInterrupted()
	if not IsServer() then return end

	-- stop effects
	-- self:StopEffects1( true )
end

function magnataur_shockwave_lua:GetIntrinsicModifierName()
	return "modifier_magnataur_shockwave_buff_lua"
end

function magnataur_shockwave_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function magnataur_shockwave_lua:GetCooldown( level )
	------- Talent -----
	local int9 = self:GetCaster():FindAbilityByName("npc_dota_hero_magnataur_int9")
	if int9 ~= nil then
		return self.BaseClass.GetCooldown( self, level ) - 7
	end
	---------------------
	return self.BaseClass.GetCooldown( self, level )
end

--------------------------------------------------------------------------------
-- Ability Start
function magnataur_shockwave_lua:OnSpellStart()
    local caster = self:GetCaster()
	local wave_count = self:GetSpecialValueFor("wave_count")
	local int9 = self:GetCaster():FindAbilityByName("npc_dota_hero_magnataur_int9")
	if int9 ~= nil then
		wave_count = wave_count + 1
	end
	caster:FindModifierByName( "modifier_magnataur_shockwave_buff_lua" ):AddStack(wave_count)

	-- play effects
	local sound_cast = "Hero_Magnataur.ShockWave.Particle"
	EmitSoundOn( sound_cast, caster )
end
--------------------------------------------------------------------------------
-- Projectile
function magnataur_shockwave_lua:OnProjectileHit( target, location )
	if not target then return end

	

	local caster = self:GetCaster()
	local damage = self:GetSpecialValueFor( "shock_damage" )
	local duration = self:GetSpecialValueFor( "slow_duration" )

	local pull_duration = self:GetSpecialValueFor( "pull_duration" )
	local pull_distance = self:GetSpecialValueFor( "pull_distance" )

	--------- Talent ---------
	local int11 = caster:FindAbilityByName("npc_dota_hero_magnataur_int11")
	if int11 ~= nil then
		damage = damage * 1.5 + caster:GetIntellect() * 0.1
	end
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_magnataur_int50") then
		damage = damage + self:GetCaster():GetIntellect() * 0.9
	end
	--------------------------
	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	--------- Talent ---------
	local agi8 = caster:FindAbilityByName("npc_dota_hero_magnataur_agi8")
	if agi8 ~= nil then
		physical_damage = caster:GetAverageTrueAttackDamage(caster) * 2
		ApplyDamage({
			victim = target,
			attacker = caster,
			damage = physical_damage,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self, --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		})
	end
	--------------------------


	-- pull
	local mod = target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_generic_arc_lua", -- modifier name
		{
			target_x = location.x,
			target_y = location.y,
			duration = pull_duration,
			distance = pull_distance,
			activity = ACT_DOTA_FLAIL,
		} -- kv
	)

	-- slow
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_magnataur_shockwave_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
    if mod then
	    self:PlayEffects2( target, mod )
    end
	return false
end

--------------------------------------------------------------------------------
-- Effects

function magnataur_shockwave_lua:PlayEffects2( target, mod )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_shockwave_hit.vpcf"
	local sound_cast = "Hero_Magnataur.ShockWave.Target"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- buff particle
	mod:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, target )
end

function magnataur_shockwave_lua:PlayEffects1()
	local caster = self:GetCaster()

	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_magnataur/magnataur_shockwave_cast.vpcf"
	local sound_cast = "Hero_Magnataur.ShockWave.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	self.effect_cast = effect_cast

	-- Create Sound
	EmitSoundOn( sound_cast, caster )
end

function magnataur_shockwave_lua:StopEffects1( interrupted )
	ParticleManager:DestroyParticle( self.effect_cast, interrupted )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	local sound_cast = "Hero_Magnataur.ShockWave.Cast"
	StopSoundOn( sound_cast, self:GetCaster() )
end
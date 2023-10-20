ability_npc_bara_boss_firestorm = class({})
LinkLuaModifier( "modifier_underlord_firestorm_lua", "abilities/bosses/bara/ability_npc_bara_boss_firestorm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_underlord_firestorm_lua_thinker", "abilities/bosses/bara/ability_npc_bara_boss_firestorm", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Custom KV
-- AOE Radius
function ability_npc_bara_boss_firestorm:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

--------------------------------------------------------------------------------
-- Ability Phase Start
function ability_npc_bara_boss_firestorm:OnAbilityPhaseStart()
	local point = self:GetCursorPosition()

	self:PlayEffects( point )

	return true -- if success
end

function ability_npc_bara_boss_firestorm:OnAbilityPhaseInterrupted()
	self:StopEffects()
end

--------------------------------------------------------------------------------
-- Ability Start
function ability_npc_bara_boss_firestorm:OnSpellStart()
	self:StopEffects()

	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	caster:AddNewModifier(caster, self, "modifier_underlord_firestorm_lua_thinker", {})
	-- CreateModifierThinker(
	-- 	caster, -- player source
	-- 	self, -- ability source
	-- 	"modifier_underlord_firestorm_lua_thinker", -- modifier name
	-- 	{}, -- kv
	-- 	point,
	-- 	caster:GetTeamNumber(),
	-- 	false
	-- )
end

--------------------------------------------------------------------------------
function ability_npc_bara_boss_firestorm:PlayEffects( point )
	-- Get Resources
	local particle_cast = "particles/units/heroes/heroes_underlord/underlord_firestorm_pre.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.Firestorm.Start"

	-- get data
	local radius = self:GetSpecialValueFor( "radius" )

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticleForTeam( particle_cast, PATTACH_WORLDORIGIN, self:GetCaster(), self:GetCaster():GetTeamNumber() )
	ParticleManager:SetParticleControl( self.effect_cast, 0, point )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( 2, 2, 2 ) )

	-- Create Sound
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

function ability_npc_bara_boss_firestorm:StopEffects()
	ParticleManager:DestroyParticle( self.effect_cast, true )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )
end

modifier_underlord_firestorm_lua_thinker = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_underlord_firestorm_lua_thinker:IsHidden()
	return true
end

function modifier_underlord_firestorm_lua_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_underlord_firestorm_lua_thinker:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()
	self.ability = self:GetAbility()

	-- references
	local damage = self.ability:GetSpecialValueFor( "wave_damage" )
	local delay = self.ability:GetSpecialValueFor( "first_wave_delay" )
	self.radius = self.ability:GetSpecialValueFor( "radius" )
	self.count = self.ability:GetSpecialValueFor( "wave_count" )
	self.interval = self.ability:GetSpecialValueFor( "wave_interval" )

	self.burn_duration = self.ability:GetSpecialValueFor( "burn_duration" )
	self.burn_interval = self.ability:GetSpecialValueFor( "burn_interval" )
	self.burn_damage = self.ability:GetSpecialValueFor( "burn_damage" )

	if not IsServer() then return end

	-- init
	self.wave = 0
	self.damageTable = {
		-- victim = target,
		attacker = self.caster,
		damage = damage,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability, --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( delay )
end

function modifier_underlord_firestorm_lua_thinker:OnRefresh( kv )
	
end

function modifier_underlord_firestorm_lua_thinker:OnRemoved()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_underlord_firestorm_lua_thinker:OnIntervalThink()
	if not self.delayed then
		self.delayed = true
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()
		return
	end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius + self.wave * 50,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )

		-- add debuff
		enemy:AddNewModifier(
			self.caster, -- player source
			self.ability, -- ability source
			"modifier_underlord_firestorm_lua", -- modifier name
			{
				duration = self.burn_duration,
				interval = self.burn_interval,
				damage = self.burn_damage,
			} -- kv
		)
	end

	-- play effects
	self:PlayEffects()

	-- count wave
	self.wave = self.wave + 1
	if self.wave>=self.count then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_underlord_firestorm_lua_thinker:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave.vpcf"
	local sound_cast = "Hero_AbyssalUnderlord.Firestorm"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self.parent:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 4, Vector( self.radius + self.wave * 50, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end

modifier_underlord_firestorm_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_underlord_firestorm_lua:IsHidden()
	return false
end

function modifier_underlord_firestorm_lua:IsDebuff()
	return true
end

function modifier_underlord_firestorm_lua:IsStunDebuff()
	return false
end

function modifier_underlord_firestorm_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_underlord_firestorm_lua:OnCreated( kv )
	-- references
	if not IsServer() then return end
	local interval = kv.interval
	self.damage_pct = kv.damage/100

	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		-- damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( interval )
end

function modifier_underlord_firestorm_lua:OnRefresh( kv )
	if not IsServer() then return end
	self.damage_pct = kv.damage/100
end

function modifier_underlord_firestorm_lua:OnRemoved()
end

function modifier_underlord_firestorm_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_underlord_firestorm_lua:OnIntervalThink()
	-- check health
	local damage = self:GetParent():GetMaxHealth() * self.damage_pct

	-- apply damage
	self.damageTable.damage = damage
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_underlord_firestorm_lua:GetEffectName()
	return "particles/units/heroes/heroes_underlord/abyssal_underlord_firestorm_wave_burn.vpcf"
end

function modifier_underlord_firestorm_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
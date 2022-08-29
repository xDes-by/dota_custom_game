zuus_boss_circle_lua = class({})
LinkLuaModifier( "modifier_zuus_boss_circle_lua", "abilities/bosses/line/boss_5/zuus_boss_circle_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_ring_lua", "heroes/generic/modifier_generic_ring_lua", LUA_MODIFIER_MOTION_NONE )

-- Init Abilities
function zuus_boss_circle_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_plasmafield.vpcf", context )
end

function zuus_boss_circle_lua:Spawn()
	if not IsServer() then return end
end

--------------------------------------------------------------------------------
-- Ability Start
function zuus_boss_circle_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

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

function zuus_boss_circle_lua:OnHit( enemy )
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
	local damage = damage_min + (damage_max-damage_min)*pct
	local slow = slow_min + (slow_max-slow_min)*pct

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
		"modifier_zuus_boss_circle_lua", -- modifier name
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
function zuus_boss_circle_lua:PlayEffects( radius, speed )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_razor/razor_plasmafield.vpcf"
	local sound_cast = "Ability.PlasmaField"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( speed, radius, 1 ) )

	EmitSoundOn( sound_cast, self:GetCaster() )

	return effect_cast
end
---------------------------------------------------------
---------------------------------------------------------
---------------------------------------------------------

modifier_zuus_boss_circle_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_zuus_boss_circle_lua:IsHidden()
	return false
end

function modifier_zuus_boss_circle_lua:IsDebuff()
	return true
end

function modifier_zuus_boss_circle_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_zuus_boss_circle_lua:OnCreated( kv )
	if not IsServer() then return end
	-- send init data from server to client
	self:SetHasCustomTransmitterData( true )

	-- references
	self.slow = kv.slow
	self:SetStackCount( self.slow )
end

function modifier_zuus_boss_circle_lua:OnRefresh( kv )
	if not IsServer() then return end
	-- references
	self.slow = math.max(kv.slow,self.slow)
	self:SetStackCount( self.slow )
end

function modifier_zuus_boss_circle_lua:OnRemoved()
end

function modifier_zuus_boss_circle_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Transmitter data
function modifier_zuus_boss_circle_lua:AddCustomTransmitterData()
	-- on server
	local data = {
		slow = self.slow
	}

	return data
end

function modifier_zuus_boss_circle_lua:HandleCustomTransmitterData( data )
	-- on client
	self.slow = data.slow
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_zuus_boss_circle_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

function modifier_zuus_boss_circle_lua:GetModifierMoveSpeedBonus_Percentage()
	return -self.slow
end
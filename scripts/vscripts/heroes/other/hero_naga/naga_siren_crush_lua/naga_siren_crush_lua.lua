naga_siren_crush_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_naga_siren_crush_lua_slow", "heroes/hero_naga/naga_siren_crush_lua/modifier_naga_siren_crush_lua_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_naga_siren_crush_lua_haste", "heroes/hero_naga/naga_siren_crush_lua/modifier_naga_siren_crush_lua_haste", LUA_MODIFIER_MOTION_NONE )

function naga_siren_crush_lua:OnSpellStart()
	-- get references
	local radius = self:GetSpecialValueFor("crush_radius")
	local damage = self:GetSpecialValueFor( "damage" )
	local stun_duration = self:GetSpecialValueFor("stun_duration")
	local slow_duration = self:GetSpecialValueFor("crush_extra_slow_duration")
	
	if self:GetCaster():FindAbilityByName("special_bonus_unique_naga_custom"):IsTrained() then 
	damage = damage + 175
	end

	-- find affected units
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),
		self:GetCaster():GetOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)

	-- Prepare damage table
	local damageTable = {
		victim = nil,
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL,
		damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
		ability = self, --Optional.
	}

	-- for each caught enemies
	for _,enemy in pairs(enemies) do
		-- Apply Damage
		damageTable.victim = enemy
		ApplyDamage(damageTable)

		enemy:AddNewModifier( self:GetCaster(), self, "modifier_generic_stunned_lua", { duration = stun_duration } )

		enemy:AddNewModifier( self:GetCaster(), self, "modifier_naga_siren_crush_lua_slow", { duration = stun_duration + slow_duration } )
		
		
	end
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_naga_siren_crush_lua_haste", { duration = slow_duration } )
	self:PlayEffects()
end

function naga_siren_crush_lua:PlayEffects()
	-- get particles
	local particle_cast = "particles/units/heroes/hero_slardar/slardar_crush.vpcf"
	local sound_cast = "Hero_Slardar.Slithereen_Crush"

	-- get data
	local radius = self:GetSpecialValueFor("crush_radius")


	local nFXIndex = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius, radius, radius) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOnLocationWithCaster( self:GetCaster():GetOrigin(), sound_cast, self:GetCaster() )
end
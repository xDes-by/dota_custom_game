jakiro_blast_lua = class({})
LinkLuaModifier( "modifier_jakiro_blast_lua", "heroes/hero_jakiro/jakiro_random_cast/modifier_jakiro_blast_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ogre_magi_ignite_lua", "heroes/hero_jakiro/jakiro_random_cast/modifier_ogre_magi_ignite_lua", LUA_MODIFIER_MOTION_NONE )

function jakiro_blast_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end



function jakiro_blast_lua:OnSpellStart()
	local R5 = RandomInt(1,2)
	if R5 == 1 then
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then
		self:PlayEffects()
		return
	end

	-- load data
	local damage = self:GetSpecialValueFor( "damage" )
	local duration = self:GetSpecialValueFor( "duration" )
	local damage_aoe = self:GetSpecialValueFor("aoe_damage")
	local radius = self:GetSpecialValueFor("radius")

	-- get enemies
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- damage
	local damageTable = {
		victim = target,
		attacker = caster,
		damage = damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self, --Optional.
	}
	ApplyDamage(damageTable)

	damageTable.damage = damage_aoe
	for _,enemy in pairs(enemies) do
		-- damage
		damageTable.victim = enemy
		ApplyDamage( damageTable )
		
		-- debuff
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_jakiro_blast_lua", -- modifier name
			{ duration = duration } -- kv
		)
	end

	self:PlayEffects( target, radius )
	end
	
	if R5 == 2 then
		local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- load data
	local projectile_name = "particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf"--"particles/units/heroes/hero_ogre_magi/ogre_magi_ignite.vpcf"
	local projectile_speed = self:GetSpecialValueFor( "projectile_speed" )

	-- create projectile
	local info = {
		Target = target,
		Source = caster,
		Ability = self,	
		
		EffectName = projectile_name,
		iMoveSpeed = projectile_speed,
		bDodgeable = true,                           -- Optional
	}
	ProjectileManager:CreateTrackingProjectile(info)

	-- find secondary target
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		caster:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self:GetCastRange( target:GetOrigin(), target ),	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local target_2 = nil
	for _,enemy in pairs(enemies) do
		-- only target those who does not have debuff
		if enemy~=target and ( not enemy:HasModifier("modifier_ogre_magi_ignite_lua") ) then
			target_2 = enemy
			break
		end
	end

	-- create secondary projectile
	if target_2 then
		info.Target = target_2
		ProjectileManager:CreateTrackingProjectile(info)
	end

	-- play effects
	local sound_cast = "Hero_Jakiro.Attack"
	EmitSoundOn( sound_cast, caster )
	end
end

function jakiro_blast_lua:PlayEffects( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lich/lich_frost_nova.vpcf"
	local sound_target = "Ability.FrostNova"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, target )
end


function jakiro_blast_lua:OnProjectileHit( target, location )
	if not target then return end

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- add debuff
	target:AddNewModifier(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_ogre_magi_ignite_lua", -- modifier name
		{ duration = duration } -- kv
	)

	-- play effects
	local sound_cast = "Hero_Jakiro.LiquidFire"
	EmitSoundOn( sound_cast, self:GetCaster() )
end
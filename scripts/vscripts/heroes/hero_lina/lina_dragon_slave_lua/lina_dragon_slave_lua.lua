lina_dragon_slave_lua = class({})

function lina_dragon_slave_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_lina_int7")	 ~= nil then 
        return 50 + math.min(65000, self:GetCaster():GetIntellect()/200)
	end
    return 100 + math.min(65000, self:GetCaster():GetIntellect()/100)
end

function lina_dragon_slave_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	if _G.slavetarget ~= nil then
		target = _G.slavetarget
	else
	 	target = self:GetCursorTarget()
	end
	local point = self:GetCursorPosition()
	if target then
		point = target:GetOrigin()
	end
	-- load data
	local projectile_name = "particles/units/heroes/hero_lina/lina_spell_dragon_slave.vpcf"
	local projectile_distance = self:GetSpecialValueFor( "dragon_slave_distance" )
	local projectile_speed = self:GetSpecialValueFor( "dragon_slave_speed" )
	local projectile_start_radius = self:GetSpecialValueFor( "dragon_slave_width_initial" )
	local projectile_end_radius = self:GetSpecialValueFor( "dragon_slave_width_end" )
	
----------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_int10")	
	if abil ~= nil then 

	local left_QAngle = QAngle(0, 30, 0)
	local right_QAngle = QAngle(0, -30, 0)

		-- Left arrow variables
	local left_spawn_point = RotatePosition(caster:GetAbsOrigin(), left_QAngle, point)
	local left_direction = (left_spawn_point - caster:GetAbsOrigin()):Normalized()+0.1

		-- Right arrow variables
	local right_spawn_point = RotatePosition(caster:GetAbsOrigin(), right_QAngle, point)
	local right_direction = (right_spawn_point - caster:GetAbsOrigin()):Normalized()+0.1

	local projectile_direction = right_direction

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Lina.DragonSlave.Cast"
	local sound_projectile = "Hero_Lina.DragonSlave"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_projectile, self:GetCaster() )
	
	
	-------------------------------------------------------------------------
	
	local projectile_direction = left_direction

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Lina.DragonSlave.Cast"
	local sound_projectile = "Hero_Lina.DragonSlave"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_projectile, self:GetCaster() )
	end			
----------------------------------------------------------------------------------------------------------------	
----------------------------------------------------------------------------------------------------------------
	local front = self:GetCaster():GetForwardVector():Normalized()+0.1
	
	local direction = point-caster:GetOrigin()
	direction.z = 0
	local projectile_direction = direction:Normalized()+front

	-- create projectile
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin(),
		
	    bDeleteOnHit = false,
	    
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = projectile_name,
	    fDistance = projectile_distance,
	    fStartRadius = projectile_start_radius,
	    fEndRadius = projectile_end_radius,
		vVelocity = projectile_direction * projectile_speed,

		bProvidesVision = false,
	}
	ProjectileManager:CreateLinearProjectile(info)

	-- Play effects
	local sound_cast = "Hero_Lina.DragonSlave.Cast"
	local sound_projectile = "Hero_Lina.DragonSlave"
	EmitSoundOn( sound_cast, self:GetCaster() )
	EmitSoundOn( sound_projectile, self:GetCaster() )
	_G.slavetarget = nil
end

--------------------------------------------------------------------------------
-- Projectile
function lina_dragon_slave_lua:OnProjectileHitHandle( target, location, projectile )
	if not target then return end
	
	local damage_slave = self:GetSpecialValueFor( "damage" )
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_int8")	
	if abil ~= nil then 
	damage_slave = damage_slave + self:GetCaster():GetIntellect()
	end
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_lina_int50")	
	if abil ~= nil then 
		damage_slave = damage_slave + self:GetCaster():GetIntellect() * 0.5
	end
	-- apply damage
	local damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage = damage_slave,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}
	ApplyDamage( damageTable )

	-- get direction
	local direction = ProjectileManager:GetLinearProjectileVelocity( projectile )
	direction.z = 0
	direction = direction:Normalized()

	-- play effects
	self:PlayEffects( target, direction )
end

--------------------------------------------------------------------------------
function lina_dragon_slave_lua:PlayEffects( target, direction )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_lina/lina_spell_dragon_slave_impact.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControlForward( effect_cast, 1, direction )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
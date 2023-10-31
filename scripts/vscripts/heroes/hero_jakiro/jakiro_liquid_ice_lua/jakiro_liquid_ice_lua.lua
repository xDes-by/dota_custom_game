-- jakiro_liquid_ice_lua = class({})

LinkLuaModifier("modifier_jakiro_liquid_ice_lua", "heroes/hero_jakiro/jakiro_liquid_ice_lua/modifier_jakiro_liquid_ice_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_generic_orb_effect_lua", "heroes/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )

-- function jakiro_liquid_ice_lua:IsHiddenWhenStolen() 		return false end
-- function jakiro_liquid_ice_lua:IsRefreshable() 			return true end
-- function jakiro_liquid_ice_lua:IsStealable() 				return false end
-- function jakiro_liquid_ice_lua:IsNetherWardStealable() 	return false end

-- function jakiro_liquid_ice_lua:GetIntrinsicModifierName() return "modifier_liquid_ice_lua_orb" end

-- function jakiro_liquid_ice_lua:OnSpellStart()
-- 	local caster = self:GetCaster()
-- 	local target = self:GetCursorTarget()
-- 	local info = 
-- 	{
-- 		Target = target,
-- 		Source = caster,
-- 		SourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
-- 		Ability = self,	
-- 		EffectName = "particles/units/heroes/hero_jakiro/jakiro_base_attack.vpcf",
-- 		iMoveSpeed = 900,
-- 		vSourceLoc= caster:GetAbsOrigin(),
-- 		bDrawsOnMinimap = false,
-- 		bDodgeable = true,
-- 		bIsAttack = false,
-- 		bVisibleToEnemies = true,
-- 		bReplaceExisting = false,
-- 		flExpireTime = GameRules:GetGameTime() + 10,
-- 		bProvidesVision = false,	
-- 	}
-- 	projectile = ProjectileManager:CreateTrackingProjectile(info)
-- end

-- function jakiro_liquid_ice_lua:OnProjectileHit(target, location)
-- 	if not target then
-- 		return
-- 	end
-- 	local caster = self:GetCaster()
-- 	local enemies =  FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, self:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	
-- 	--7.30液态冰添加眩晕
-- 	for _, enemy in pairs(enemies) do
-- 		enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = self:GetSpecialValueFor("stun_duration")})
-- 	end

-- 	for _, enemy in pairs(enemies) do
-- 		enemy:AddNewModifier(caster, self, "modifier_liquid_ice_lua", {duration = self:GetSpecialValueFor("duration")})
-- 	end
-- 	local pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_jakiro/jakiro_base_attack_frost_explosion.vpcf", PATTACH_CUSTOMORIGIN, target)
-- 	ParticleManager:SetParticleControl(pfx, 0, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + 64))
-- 	ParticleManager:SetParticleControl(pfx, 1, Vector(self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius"), self:GetSpecialValueFor("radius")))
-- 	EmitSoundOnLocationWithCaster(target:GetAbsOrigin(), "Hero_Jakiro.LiquidFire", target)
-- end

jakiro_liquid_ice_lua = class({})
-- LinkLuaModifier( "modifier_generic_orb_effect_lua", "heroes/generic/modifier_generic_orb_effect_lua", LUA_MODIFIER_MOTION_NONE )
-- LinkLuaModifier( "modifier_jakiro_liquid_fire_lua", "heroes/hero_jakiro/jakiro_liquid_fire_lua/modifier_jakiro_liquid_fire_lua", LUA_MODIFIER_MOTION_NONE )


function jakiro_liquid_ice_lua:GetIntrinsicModifierName()
	return "modifier_generic_orb_effect_lua"
end

function jakiro_liquid_ice_lua:OnSpellStart()
end

function jakiro_liquid_ice_lua:GetCooldown(level)
	return self.BaseClass.GetCooldown( self, level )
end

function jakiro_liquid_ice_lua:GetProjectileName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_projectile.vpcf"
end

function jakiro_liquid_ice_lua:OnOrbFire( params )
	-- play effects
	local sound_cast = "Hero_Jakiro.LiquidFire"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function jakiro_liquid_ice_lua:OnOrbImpact( params )
	local caster = self:GetCaster()

	-- get data
	local duration = self:GetSpecialValueFor( "duration" )
	local radius = self:GetSpecialValueFor( "radius" )

	-- find enemy in radius
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		params.target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- add modifier
		enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_jakiro_liquid_ice_lua", -- modifier name
			{ duration = duration } -- kv
		)
		
	end

	-- play effects
	self:PlayEffects( params.target, radius )
end

function jakiro_liquid_ice_lua:PlayEffects( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_jakiro/jakiro_liquid_ice.vpcf"
	local sound_cast = "Hero_Jakiro.LiquidFire"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
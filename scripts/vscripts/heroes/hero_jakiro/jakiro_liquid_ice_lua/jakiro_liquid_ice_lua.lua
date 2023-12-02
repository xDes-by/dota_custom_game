-- jakiro_liquid_ice_lua = class({})

LinkLuaModifier("modifier_jakiro_liquid_ice_lua", "heroes/hero_jakiro/jakiro_liquid_ice_lua/modifier_jakiro_liquid_ice_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_jakiro_liquid_ice_intrinsic_lua", "heroes/hero_jakiro/jakiro_liquid_ice_lua/modifier_jakiro_liquid_ice_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )

jakiro_liquid_ice_lua = class({})

function jakiro_liquid_ice_lua:GetIntrinsicModifierName()
	return "modifier_jakiro_liquid_ice_intrinsic_lua"
end

function jakiro_liquid_ice_lua:Spawn()
	if IsServer() then
		self:SetLevel(1)
	end
end

function jakiro_liquid_ice_lua:OnSpellStart()
end

function jakiro_liquid_ice_lua:GetCooldown(level)
	return self.BaseClass.GetCooldown( self, level )
end

-- function jakiro_liquid_ice_lua:GetProjectileName()
-- 	return "particles/units/heroes/hero_jakiro/jakiro_liquid_ice_projectile.vpcf"
-- end

function jakiro_liquid_ice_lua:OnOrbFire( params )
	-- play effects
	local sound_cast = "Hero_Jakiro.LiquidFire"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function jakiro_liquid_ice_lua:OnOrbImpact( params )
	if params.target:IsBuilding() then return end
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
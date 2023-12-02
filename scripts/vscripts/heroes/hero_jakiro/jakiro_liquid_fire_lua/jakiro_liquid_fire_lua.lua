jakiro_liquid_fire_lua = class({})
LinkLuaModifier( "modifier_jakiro_liquid_fire_lua", "heroes/hero_jakiro/jakiro_liquid_fire_lua/modifier_jakiro_liquid_fire_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_liquid_fire_intrinsic_lua", "heroes/hero_jakiro/jakiro_liquid_fire_lua/modifier_jakiro_liquid_fire_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )


function jakiro_liquid_fire_lua:GetIntrinsicModifierName()
	return "modifier_jakiro_liquid_fire_intrinsic_lua"
end

function jakiro_liquid_fire_lua:OnSpellStart()
end

function jakiro_liquid_fire_lua:GetCastRange( location , target)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_int9") then
		return 900
	end
end

function jakiro_liquid_fire_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_agi6") then
		return 0
	end
end

function jakiro_liquid_fire_lua:GetProjectileName()
	return "particles/units/heroes/hero_jakiro/jakiro_base_attack_fire.vpcf"
end

function jakiro_liquid_fire_lua:OnOrbFire( params )
	-- play effects
	local sound_cast = "Hero_Jakiro.LiquidFire"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function jakiro_liquid_fire_lua:OnOrbImpact( params )
	if params.target:IsBuilding() then return end
	local caster = self:GetCaster()

	-- get data
	local duration = self:GetDuration()
	local radius = self:GetSpecialValueFor( "radius" )
	local target = params.target
	-- find enemy in radius
	local enemies = FindUnitsInRadius(
		caster:GetTeamNumber(),	-- int, your team number
		target:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	local npc_dota_hero_jakiro_agi12 = caster:FindAbilityByName("npc_dota_hero_jakiro_agi12")
	for _,enemy in pairs(enemies) do
		-- add modifier
		local mod = enemy:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_jakiro_liquid_fire_lua", -- modifier name
			{ duration = duration } -- kv
		)
		if npc_dota_hero_jakiro_agi12 and enemy == target then
			mod:IncrementStackCount()
		end
	end

	-- play effects
	self:PlayEffects( target, radius )

	if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_agi7") then
		local jakiro_dual_breath_lua = self:GetCaster():FindAbilityByName("jakiro_dual_breath_lua")
		local direction = (target:GetOrigin() - caster:GetAbsOrigin()):Normalized()
		if jakiro_dual_breath_lua and jakiro_dual_breath_lua:GetLevel() > 0 then
			jakiro_dual_breath_lua:FireBreath(direction.x, direction.y)
		end
	end
end

function jakiro_liquid_fire_lua:PlayEffects( target, radius )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_explosion.vpcf"
	local sound_cast = "Hero_Jakiro.LiquidFire"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( radius, radius, radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end
jakiro_dual_breath_lua = class({})
LinkLuaModifier( "modifier_jakiro_dual_breath_lua", "heroes/hero_jakiro/jakiro_dual_breath_lua/modifier_jakiro_dual_breath_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_dual_breath_lua_fire", "heroes/hero_jakiro/jakiro_dual_breath_lua/modifier_jakiro_dual_breath_lua_fire", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_dual_breath_lua_ice", "heroes/hero_jakiro/jakiro_dual_breath_lua/modifier_jakiro_dual_breath_lua_ice", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_dual_breath_intrinsic_lua", "heroes/hero_jakiro/jakiro_dual_breath_lua/modifier_jakiro_dual_breath_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )


function jakiro_dual_breath_lua:GetIntrinsicModifierName()
	return "modifier_jakiro_dual_breath_intrinsic_lua"
end
function jakiro_dual_breath_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function jakiro_dual_breath_lua:GetCastRange(location, target)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_agi10") then
   		return self.BaseClass.GetCastRange(self, location, target) * 2
	end
end
function jakiro_dual_breath_lua:GetCooldown( level )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_agi8") then
		return 0.1
	end
	return self.BaseClass.GetCooldown( self, level )
end
function jakiro_dual_breath_lua:OnUpgrade()
    if self:GetLevel() == 1 then
        self:RefreshCharges()
    end
end
--------------------------------------------------------------------------------
function jakiro_dual_breath_lua:FireBreath(direction_x, direction_y)
	local caster = self:GetCaster()
	local distance = self:GetSpecialValueFor( "range" )
	local start_radius = self:GetSpecialValueFor( "start_radius" )
	local end_radius = self:GetSpecialValueFor( "end_radius" )
	local speed = self:GetSpecialValueFor( "speed_fire" )
	local direction = Vector( direction_x, direction_y, 0 )
	direction.z = 0
	direction = direction:Normalized()
	
	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin() + direction * 15,
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf",
	    fDistance = distance,
	    fStartRadius = start_radius,
	    fEndRadius = end_radius,
		vVelocity = direction * speed,
		ExtraData = {
			fire = 1
		}
	}
	ProjectileManager:CreateLinearProjectile( info )
end

function jakiro_dual_breath_lua:IceBreath(direction_x, direction_y)
	local caster = self:GetCaster()
	local distance = self:GetSpecialValueFor( "range" )
	local start_radius = self:GetSpecialValueFor( "start_radius" )
	local end_radius = self:GetSpecialValueFor( "end_radius" )
	local speed = self:GetSpecialValueFor( "speed" )
	local direction = Vector( direction_x, direction_y, 0 )
	direction.z = 0
	direction = direction:Normalized()

	local info = {
		Source = caster,
		Ability = self,
		vSpawnOrigin = caster:GetAbsOrigin() + direction * 15,
		
	    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
	    iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
	    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	    
	    EffectName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_ice.vpcf",
	    fDistance = distance,
	    fStartRadius = start_radius,
	    fEndRadius = end_radius,
		vVelocity = direction * speed,
		ExtraData = {
			fire = 0
		}
	}
	ProjectileManager:CreateLinearProjectile( info )
end

function jakiro_dual_breath_lua:UseAbility(direction)
	local caster = self:GetCaster()
	local delay = self:GetSpecialValueFor( "fire_delay" )
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_jakiro_dual_breath_lua", -- modifier name
		{
			duration = delay,
			x = direction.x,
			y = direction.y,
		} -- kv
	)
	if caster:FindAbilityByName("npc_dota_hero_jakiro_agi11") then
		local jakiro_macropyre_lua = caster:FindAbilityByName("jakiro_macropyre_lua")
		if jakiro_macropyre_lua and jakiro_macropyre_lua:GetLevel() > 0 then
			jakiro_macropyre_lua:UseAbility(direction, 2.5, 200, self:GetSpecialValueFor("range")-100)
		end
	end
end
-- Ability Start
function jakiro_dual_breath_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local point = self:GetCursorPosition()

	-- set position
	if target then
		point = target:GetOrigin()
	end
	local direction = (point - caster:GetAbsOrigin()):Normalized()
	-- create modifier
	self:UseAbility(direction)
	if caster:FindAbilityByName("npc_dota_hero_jakiro_str9") then
		for _, angle_value in pairs({72, 144, 216, 288}) do
			local angle_point = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle_value, 0), point)
			local angle_direction = (angle_point - caster:GetAbsOrigin()):Normalized()
			self:UseAbility(angle_direction)
		end
	end
end
--------------------------------------------------------------------------------
-- Projectile
function jakiro_dual_breath_lua:OnProjectileHit_ExtraData( target, location, data )
	if not target then return end

	-- load data
	local caster = self:GetCaster()
	local delay = self:GetSpecialValueFor( "fire_delay" )
	local duration = self:GetSpecialValueFor("duration")

	-- determine which breath
	local modifier = "modifier_jakiro_dual_breath_lua_ice"
	if data.fire==1 then modifier = "modifier_jakiro_dual_breath_lua_fire" end

	-- add modifier
	target:AddNewModifier(
		caster, -- player source
		self, -- ability source
		modifier, -- modifier name
		{ duration = duration } -- kv
	)
end
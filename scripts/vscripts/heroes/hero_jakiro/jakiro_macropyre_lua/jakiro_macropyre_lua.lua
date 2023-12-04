jakiro_macropyre_lua = class({})
LinkLuaModifier( "modifier_jakiro_macropyre_lua", "heroes/hero_jakiro/jakiro_macropyre_lua/modifier_jakiro_macropyre_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_macropyre_lua_thinker", "heroes/hero_jakiro/jakiro_macropyre_lua/modifier_jakiro_macropyre_lua_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_macropyre_lua_intrinsic_lua", "heroes/hero_jakiro/jakiro_macropyre_lua/modifier_jakiro_macropyre_lua_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )

function jakiro_macropyre_lua:GetIntrinsicModifierName()
	return "modifier_jakiro_macropyre_lua_intrinsic_lua"
end
function jakiro_macropyre_lua:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end
function jakiro_macropyre_lua:UseAbility(dir, duration, path_radius, cast_range)
	local caster = self:GetCaster()
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_jakiro_macropyre_lua_thinker", -- modifier name
		{
			duration = duration,
			x = dir.x,
			y = dir.y,
			path_radius = path_radius,
			cast_range = cast_range,
		}, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
end

function jakiro_macropyre_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local path_radius = self:GetSpecialValueFor("path_radius")
	local cast_range = self:GetSpecialValueFor("cast_range")
	-- calculate direction
	local dir = point - caster:GetOrigin()
	dir.z = 0
	dir = dir:Normalized()

	-- get duration
	local duration = self:GetSpecialValueFor( "duration" )
	-- create thinker
	self:UseAbility(dir, duration, path_radius, cast_range)
	if caster:FindAbilityByName("npc_dota_hero_jakiro_int11") then
		for _, angle_value in pairs({30, -30}) do
			local angle_point = RotatePosition(caster:GetAbsOrigin(), QAngle(0, angle_value, 0), point)
			local angle_direction = (angle_point - caster:GetAbsOrigin()):Normalized()+0.1
			self:UseAbility(angle_direction, duration, path_radius, cast_range)
		end
	end
	-- local right_QAngle = QAngle(0, -30, 0)

	-- 	-- Left arrow variables
	-- local left_spawn_point = RotatePosition(caster:GetAbsOrigin(), left_QAngle, point)
	-- local left_direction = (left_spawn_point - caster:GetAbsOrigin()):Normalized()+0.1
	-- play effects
	local sound_cast = "Hero_Jakiro.Macropyre.Cast"
	EmitSoundOn( sound_cast, caster )
end
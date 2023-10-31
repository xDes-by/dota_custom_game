jakiro_macropyre_lua = class({})
LinkLuaModifier( "modifier_jakiro_macropyre_lua", "heroes/hero_jakiro/jakiro_macropyre_lua/modifier_jakiro_macropyre_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_macropyre_lua_thinker", "heroes/hero_jakiro/jakiro_macropyre_lua/modifier_jakiro_macropyre_lua_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_macropyre_lua_intrinsic_lua", "heroes/hero_jakiro/jakiro_macropyre_lua/modifier_jakiro_macropyre_lua_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )

function jakiro_macropyre_lua:GetIntrinsicModifierName()
	return "modifier_jakiro_macropyre_lua_intrinsic_lua"
end

function jakiro_macropyre_lua:UseAbility(dir, duration, path_radius)
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
	if caster:FindAbilityByName("npc_dota_hero_jakiro_str10") then
		path_radius = path_radius + 150
	end
	-- calculate direction
	local dir = point - caster:GetOrigin()
	dir.z = 0
	dir = dir:Normalized()

	-- get duration
	local duration = self:GetSpecialValueFor( "duration" )
	-- create thinker
	self:UseAbility(dir, duration, path_radius)

	-- play effects
	local sound_cast = "Hero_Jakiro.Macropyre.Cast"
	EmitSoundOn( sound_cast, caster )
end
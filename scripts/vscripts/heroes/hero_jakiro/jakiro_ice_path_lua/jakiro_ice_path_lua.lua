jakiro_ice_path_lua = class({})
LinkLuaModifier( "modifier_jakiro_ice_path_lua", "heroes/hero_jakiro/jakiro_ice_path_lua/modifier_jakiro_ice_path_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_ice_path_lua_thinker", "heroes/hero_jakiro/jakiro_ice_path_lua/modifier_jakiro_ice_path_lua_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_jakiro_ice_path_intrinsic_lua", "heroes/hero_jakiro/jakiro_ice_path_lua/modifier_jakiro_ice_path_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Ability Start

function jakiro_ice_path_lua:GetIntrinsicModifierName()
	return "modifier_jakiro_ice_path_intrinsic_lua"
end
function jakiro_ice_path_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function jakiro_ice_path_lua:UseAbility(dir, startpoint, endpoint)
	local caster = self:GetCaster()
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_jakiro_ice_path_lua_thinker", -- modifier name
		{
			dir_x = dir.x,
			dir_y = dir.y,
			startpoint_x = startpoint.x,
			startpoint_y = startpoint.y,
			startpoint_z = startpoint.z,
			endpoint_x = endpoint.x,
			endpoint_y = endpoint.y,
			endpoint_z = endpoint.z,
		}, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
end

function jakiro_ice_path_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- calculate direction
	local dir = point - caster:GetOrigin()
	dir.z = 0
	dir = dir:Normalized()
	local start_range = 12
	local range = 900
	local startpoint = caster:GetOrigin() + dir + start_range
	local endpoint = startpoint + dir * range

	if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_str11") then
		local count = 0
		Timers:CreateTimer(0, function()
			count = count + 1
			self:UseAbility(dir, startpoint, endpoint)
			if count < 3 then 
				return 4
			end
   		end)
	else
		self:UseAbility(dir, startpoint, endpoint)
	end
end
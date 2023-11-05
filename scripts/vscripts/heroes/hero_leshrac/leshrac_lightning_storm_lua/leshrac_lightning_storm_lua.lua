leshrac_lightning_storm_lua = class({})
LinkLuaModifier( "modifier_leshrac_lightning_storm_lua", "heroes/hero_leshrac/leshrac_lightning_storm_lua/modifier_leshrac_lightning_storm_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_intrinsic_lua", "heroes/hero_leshrac/leshrac_lightning_storm_lua/modifier_leshrac_lightning_storm_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_leshrac_lightning_storm_lua_thinker", "heroes/hero_leshrac/leshrac_lightning_storm_lua/modifier_leshrac_lightning_storm_lua_thinker", LUA_MODIFIER_MOTION_NONE )


function leshrac_lightning_storm_lua:GetIntrinsicModifierName()
	return "modifier_leshrac_lightning_storm_intrinsic_lua"
end
function leshrac_lightning_storm_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
--------------------------------------------------------------------------------
-- Ability Start
function leshrac_lightning_storm_lua:OnSpellStart(count_fixed)
	-- unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- cancel if linken
	if target:TriggerSpellAbsorb( self ) then return end

	-- create thinker
	local thinker = CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_leshrac_lightning_storm_lua_thinker", -- modifier name
		{ count_fixed = count_fixed }, -- kv
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false
	)
	local modifier = thinker:FindModifierByName( "modifier_leshrac_lightning_storm_lua_thinker" )
	modifier:Cast( target )
end
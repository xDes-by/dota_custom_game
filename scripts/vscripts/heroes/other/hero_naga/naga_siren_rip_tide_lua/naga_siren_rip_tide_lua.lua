naga_siren_rip_tide_lua = class({})
LinkLuaModifier( "modifier_naga_siren_rip_tide_lua", "heroes/hero_naga/naga_siren_rip_tide_lua/modifier_naga_siren_rip_tide_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_naga_siren_rip_tide_lua_debuff", "heroes/hero_naga/naga_siren_rip_tide_lua/modifier_naga_siren_rip_tide_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function naga_siren_rip_tide_lua:GetIntrinsicModifierName()
	return "modifier_naga_siren_rip_tide_lua"
end
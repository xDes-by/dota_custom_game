mars_atrophy_aura_lua = class({})
LinkLuaModifier( "modifier_mars_atrophy_aura_lua", "heroes/hero_mars/mars_atrophy_aura_lua/modifier_mars_atrophy_aura_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_atrophy_aura_lua_debuff", "heroes/hero_mars/mars_atrophy_aura_lua/modifier_mars_atrophy_aura_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_atrophy_aura_lua_stack", "heroes/hero_mars/mars_atrophy_aura_lua/modifier_mars_atrophy_aura_lua_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_atrophy_aura_lua_permanent_stack", "heroes/hero_mars/mars_atrophy_aura_lua/modifier_mars_atrophy_aura_lua_permanent_stack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_mars_atrophy_aura_lua_scepter", "heroes/hero_mars/mars_atrophy_aura_lua/modifier_mars_atrophy_aura_lua_scepter", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function mars_atrophy_aura_lua:GetIntrinsicModifierName()
	return "modifier_mars_atrophy_aura_lua"
end
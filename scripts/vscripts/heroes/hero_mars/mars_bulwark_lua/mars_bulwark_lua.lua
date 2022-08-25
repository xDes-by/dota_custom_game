mars_bulwark_lua = class({})
LinkLuaModifier( "modifier_mars_bulwark_lua", "heroes/hero_mars/mars_bulwark_lua/modifier_mars_bulwark_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function mars_bulwark_lua:GetIntrinsicModifierName()
	return "modifier_mars_bulwark_lua"
end
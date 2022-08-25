shadow_fiend_necromastery_lua = class({})
LinkLuaModifier( "modifier_shadow_fiend_necromastery_lua", "heroes/hero_nevermore/shadow_fiend_necromastery_lua/modifier_shadow_fiend_necromastery_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function shadow_fiend_necromastery_lua:GetIntrinsicModifierName()
	return "modifier_shadow_fiend_necromastery_lua"
end

earthshaker_aftershock_lua = class({})
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_earthshaker_aftershock_lua", "bosses/EARTHSHAKER/earthshaker_aftershock_lua/modifier_earthshaker_aftershock_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function earthshaker_aftershock_lua:GetIntrinsicModifierName()
	return "modifier_earthshaker_aftershock_lua"
end
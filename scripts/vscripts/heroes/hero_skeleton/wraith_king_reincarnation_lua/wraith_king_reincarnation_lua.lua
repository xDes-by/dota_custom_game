wraith_king_reincarnation_lua = class({})
LinkLuaModifier( "modifier_wraith_king_reincarnation_lua", "heroes/hero_skeleton/wraith_king_reincarnation_lua/modifier_wraith_king_reincarnation_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wraith_king_reincarnation_lua_debuff", "heroes/hero_skeleton/wraith_king_reincarnation_lua/modifier_wraith_king_reincarnation_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function wraith_king_reincarnation_lua:GetIntrinsicModifierName()
	return "modifier_wraith_king_reincarnation_lua"
end
dragon_blood_lua = class({})
LinkLuaModifier( "modifier_dragon_blood_lua", "heroes/hero_dragon/dragon_blood_lua/modifier_dragon_blood_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function dragon_blood_lua:GetIntrinsicModifierName()
	return "modifier_dragon_blood_lua"
end
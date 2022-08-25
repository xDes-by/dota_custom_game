sand_caustic = class({})
LinkLuaModifier( "modifier_sand_caustic", "heroes/hero_sand/sand_caustic/modifier_sand_caustic", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sand_caustic_debuff", "heroes/hero_sand/sand_caustic/modifier_sand_caustic_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function sand_caustic:GetIntrinsicModifierName()
	return "modifier_sand_caustic"
end
zeus_static_field_lua = class({})
LinkLuaModifier("modifier_zeus_static_field_lua", "heroes/hero_zeus/modifier_zeus_static_field_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_zeus_static_field_shock_lua", "heroes/hero_zeus/modifier_zeus_static_field_shock_lua", LUA_MODIFIER_MOTION_NONE)


function zeus_static_field_lua:GetIntrinsicModifierName()
	return "modifier_zeus_static_field_lua"
end


function zeus_static_field_lua:GetBehavior()
	return DOTA_ABILITY_BEHAVIOR_PASSIVE 
end

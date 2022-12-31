---@class dawnbreaker_luminosity:CDOTA_Ability_Lua
dawnbreaker_luminosity = class({})

LinkLuaModifier("modifier_dawnbreaker_luminosity_lua", "heroes/hero_dawnbreaker/modifier_dawnbreaker_luminosity", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dawnbreaker_luminosity_attack_buff_lua", "heroes/hero_dawnbreaker/modifier_dawnbreaker_luminosity_attack_buff", LUA_MODIFIER_MOTION_NONE)

function dawnbreaker_luminosity:GetIntrinsicModifierName()
	return "modifier_dawnbreaker_luminosity_lua"
end

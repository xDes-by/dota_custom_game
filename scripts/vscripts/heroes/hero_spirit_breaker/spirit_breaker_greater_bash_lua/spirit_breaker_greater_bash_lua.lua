-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
spirit_breaker_greater_bash_lua = class({})
LinkLuaModifier( "modifier_spirit_breaker_greater_bash_lua", "heroes/hero_spirit_breaker/spirit_breaker_greater_bash_lua/modifier_spirit_breaker_greater_bash_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_arc_lua", "heroes/generic/modifier_generic_arc_lua", LUA_MODIFIER_MOTION_BOTH )
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function spirit_breaker_greater_bash_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_greater_bash.vpcf", context )
end

function spirit_breaker_greater_bash_lua:Spawn()
	if not IsServer() then return end
end
--------------------------------------------------------------------------------
-- Passive Modifier
function spirit_breaker_greater_bash_lua:GetIntrinsicModifierName()
	return "modifier_spirit_breaker_greater_bash_lua"
end

function spirit_breaker_greater_bash_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spirit_breaker_agi8") then
		return 0
	end
end

function spirit_breaker_greater_bash_lua:GetCastRange(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spirit_breaker_agi11") then
		return 700
	end
end
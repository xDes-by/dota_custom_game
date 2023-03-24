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
magnataur_skewer_lua = class({})
LinkLuaModifier( "modifier_magnataur_skewer_lua", "heroes/hero_magnataur/magnataur_bus_rush_lua/magnataur_skewer_lua/modifier_magnataur_skewer_lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier( "modifier_magnataur_skewer_lua_debuff", "heroes/hero_magnataur/magnataur_bus_rush_lua/magnataur_skewer_lua/modifier_magnataur_skewer_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_magnataur_skewer_lua_slow", "heroes/hero_magnataur/magnataur_bus_rush_lua/magnataur_skewer_lua/modifier_magnataur_skewer_lua_slow", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function magnataur_skewer_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_skewer.vpcf", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_magnataur/magnataur_skewer_debuff.vpcf", context )
end

--------------------------------------------------------------------------------
-- Ability Start
function magnataur_skewer_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local modifier_bus_rush_unit_lua = self:GetCaster():FindModifierByName("modifier_bus_rush_unit_lua")
	local main_hero = modifier_bus_rush_unit_lua:GetCaster()
	local bus_rush_ability = main_hero:FindAbilityByName("magnataur_bus_rush_lua")
	-- load data
	local maxrange = bus_rush_ability:GetSpecialValueFor( "range" )

	local direction = point-caster:GetOrigin()
	if direction:Length2D() > maxrange then
		direction.z = 0
		direction = direction:Normalized()

		point = caster:GetOrigin() + direction * maxrange
	end

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_magnataur_skewer_lua", -- modifier name
		{
			x = point.x,
			y = point.y,
		} -- kv
	)
end

function magnataur_skewer_lua:GetCastAnimation()
	return ACT_DOTA_MAGNUS_SKEWER_START
end
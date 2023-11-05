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
spirit_breaker_bulldoze_lua = class({})
LinkLuaModifier( "modifier_spirit_breaker_bulldoze_lua", "heroes/hero_spirit_breaker/spirit_breaker_bulldoze_lua/modifier_spirit_breaker_bulldoze_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_spirit_breaker_bulldoze_intrinsic_lua", "heroes/hero_spirit_breaker/spirit_breaker_bulldoze_lua/modifier_spirit_breaker_bulldoze_intrinsic_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function spirit_breaker_bulldoze_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_spirit_breaker/spirit_breaker_haste_owner.vpcf", context )
end
function spirit_breaker_bulldoze_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function spirit_breaker_bulldoze_lua:GetIntrinsicModifierName()
	return "modifier_spirit_breaker_bulldoze_intrinsic_lua"
end

function spirit_breaker_bulldoze_lua:Spawn()
	if not IsServer() then return end
end

function spirit_breaker_bulldoze_lua:GetCastRange()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spirit_breaker_str11") then
		return 800
	end
end

--------------------------------------------------------------------------------
-- Ability Start
function spirit_breaker_bulldoze_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_spirit_breaker_bulldoze_lua", -- modifier name
		{ duration = duration } -- kv
	)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_spirit_breaker_agi7") then
		local modifier_spirit_breaker_greater_bash_lua = self:GetCaster():FindModifierByName("modifier_spirit_breaker_greater_bash_lua")
		local enemies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self:GetCaster():GetOrigin(), nil, 700, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false )
		for _, enemy in pairs(enemies) do
			modifier_spirit_breaker_greater_bash_lua:Bash( enemy, 1 )
		end
	end
end

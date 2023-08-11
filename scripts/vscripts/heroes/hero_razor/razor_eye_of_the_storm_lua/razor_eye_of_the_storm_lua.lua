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
razor_eye_of_the_storm_lua = class({})
LinkLuaModifier( "modifier_razor_eye_of_the_storm_lua", "heroes/hero_razor/razor_eye_of_the_storm_lua/modifier_razor_eye_of_the_storm_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_razor_eye_of_the_storm_lua_debuff", "heroes/hero_razor/razor_eye_of_the_storm_lua/modifier_razor_eye_of_the_storm_lua_debuff", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Init Abilities
function razor_eye_of_the_storm_lua:Precache( context )
	PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context )
	PrecacheResource( "particle", "particles/units/heroes/hero_razor/razor_eye_of_the_storm.vpcf", context )
end

function razor_eye_of_the_storm_lua:GetBehavior()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_str10") then
        return DOTA_ABILITY_BEHAVIOR_TOGGLE + DOTA_ABILITY_BEHAVIOR_IMMEDIATE
    end
end

function razor_eye_of_the_storm_lua:Spawn()
	if not IsServer() then return end
end

function razor_eye_of_the_storm_lua:OnOwnerSpawned()
	if self.toggle_state then
		self:ToggleAbility()
	end
end

function razor_eye_of_the_storm_lua:OnOwnerDied()
	self.toggle_state = self:GetToggleState()
end

function razor_eye_of_the_storm_lua:OnToggle()
	if not IsServer() then return end
	
	if self:GetToggleState() then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_razor_eye_of_the_storm_lua", {})
	else
		self:GetCaster():RemoveModifierByNameAndCaster("modifier_razor_eye_of_the_storm_lua", self:GetCaster())
	end
	
end

function razor_eye_of_the_storm_lua:GetCooldown( level )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_razor_str10") then
		return 0
	end
end

--------------------------------------------------------------------------
-- Ability Start
function razor_eye_of_the_storm_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local duration = self:GetSpecialValueFor( "duration" )

	-- add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_razor_eye_of_the_storm_lua", -- modifier name
		{ duration = duration } -- kv
	)
end

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
huskar_berserkers_blood_lua = class({})
LinkLuaModifier( "modifier_huskar_berserkers_blood_lua", "heroes/hero_huskar/huskar_berserkers_blood_lua/modifier_huskar_berserkers_blood_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_huskar_berserkers_blood_lua_bkb", "heroes/hero_huskar/huskar_berserkers_blood_lua/modifier_huskar_berserkers_blood_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function huskar_berserkers_blood_lua:OnSpellStart()
	EmitSoundOn("DOTA_Item.BlackKingBar.Activate", self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_huskar_berserkers_blood_lua_bkb", {duration = 3})
end
-- Passive Modifier
function huskar_berserkers_blood_lua:GetIntrinsicModifierName()
	return "modifier_huskar_berserkers_blood_lua"
end

function huskar_berserkers_blood_lua:GetBehavior()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_str11") then
		return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	end
	return DOTA_ABILITY_BEHAVIOR_PASSIVE
end

function huskar_berserkers_blood_lua:GetCooldown()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_str11") then
		return 30
	end
	return 0
end

function huskar_berserkers_blood_lua:GetCastRange(vLocation, hTarget)
	return 150
end
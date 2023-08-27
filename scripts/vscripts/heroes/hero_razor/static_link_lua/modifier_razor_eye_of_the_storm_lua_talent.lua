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
modifier_razor_eye_of_the_storm_lua_talent = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_razor_eye_of_the_storm_lua_talent:IsHidden()
	return false
end

function modifier_razor_eye_of_the_storm_lua_talent:IsDebuff()
	return true
end

function modifier_razor_eye_of_the_storm_lua_talent:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_razor_eye_of_the_storm_lua_talent:OnCreated( kv )
	if not IsServer() then return end
    self.ability = self:GetAbility()
	self:StartIntervalThink(2.5 / 15 * self.ability:GetLevel())
end

function modifier_razor_eye_of_the_storm_lua_talent:OnIntervalThink()
    self:GetCaster():PerformAttack(self:GetParent(), false, true, true, false, true, false, false)
end
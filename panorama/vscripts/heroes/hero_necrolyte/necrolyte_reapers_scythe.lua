---@class necrolyte_reapers_scythe:CDOTA_Ability_Lua
necrolyte_reapers_scythe = class({})

LinkLuaModifier("modifier_necrolyte_reapers_scythe_lua", "heroes/hero_necrolyte/modifier_necrolyte_reapers_scythe", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_necrolyte_reapers_scythe_buff_lua", "heroes/hero_necrolyte/modifier_necrolyte_reapers_scythe_buff", LUA_MODIFIER_MOTION_NONE)

function necrolyte_reapers_scythe:OnSpellStart()
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor("stun_duration")

	if target:TriggerSpellAbsorb(self) then
		return
	end

	caster:EmitSound("Hero_Necrolyte.ReapersScythe.Cast")
	target:EmitSound("Hero_Necrolyte.ReapersScythe.Target")

	target:AddNewModifier(caster, self, "modifier_necrolyte_reapers_scythe_lua", {duration = duration})
end

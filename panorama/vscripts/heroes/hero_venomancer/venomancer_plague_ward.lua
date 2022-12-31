---@class venomancer_plague_ward_lua:CDOTA_Ability_Lua
venomancer_plague_ward_lua = class({})

function venomancer_plague_ward_lua:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_venomancer_8")
end

function venomancer_plague_ward_lua:OnSpellStart(multicast_disabled)
	local caster = self:GetCaster()
	local pos = self:GetCursorPosition()
	local unit_name = "npc_dota_venomancer_plague_ward_" .. self:GetLevel()

	local duration = self:GetSpecialValueFor("duration")

	local unit = CreateUnitByName(unit_name, pos, true, caster, caster, caster:GetTeam())
	unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
	unit:AddNewModifier(caster, self, "modifier_kill", {duration = duration})
	unit:AddNewModifier(caster, self, "modifier_magic_immune", {duration = duration})

	if caster:HasTalent("special_bonus_unique_venomancer") then
		local talent_multiplier = caster:FindTalentValue("special_bonus_unique_venomancer")

		unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() * talent_multiplier)
		unit:SetBaseDamageMin(unit:GetBaseDamageMin() * talent_multiplier)
		unit:SetBaseDamageMax(unit:GetBaseDamageMax() * talent_multiplier)
	end

	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	local multicast = 1

	if multicast_modifier and not multicast_disabled then
		multicast = multicast_modifier:GetMulticastFactor(self)
		multicast_modifier:PlayMulticastFX(multicast)
	end

	unit:SetBaseMaxHealth(unit:GetBaseMaxHealth() * multicast)
	unit:SetBaseDamageMin(unit:GetBaseDamageMin() * multicast)
	unit:SetBaseDamageMax(unit:GetBaseDamageMax() * multicast)

	unit:AddAbility("summon_buff")

	if multicast > 1 then
		multicast_modifier:PlaySummonFX(unit, multicast)
	end

	ResolveNPCPositions(unit:GetAbsOrigin(), 64)
end
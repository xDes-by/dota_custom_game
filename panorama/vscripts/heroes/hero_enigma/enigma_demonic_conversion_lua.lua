require("heroes/hero_enigma/eidolons")

---@class enigma_demonic_conversion:CDOTA_Ability_Lua
enigma_demonic_conversion_lua = class({})

function enigma_demonic_conversion_lua:CastFilterResultTarget(target)
	local caster = self:GetCaster()

	if caster == target then return UF_SUCCESS end
	
	return UnitFilter(target, 
		DOTA_UNIT_TARGET_TEAM_BOTH, 
		DOTA_UNIT_TARGET_CREEP,
		DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO,
		self:GetTeamNumber()
	)
end

function enigma_demonic_conversion_lua:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	local origin = target:GetAbsOrigin()

	if caster ~= target then
		target:Kill(self, caster)
	end

	local spawn_count = self:GetSpecialValueFor("spawn_count") + caster:FindTalentValue("special_bonus_unique_enigma")
	local duration = self:GetDuration()

	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	local multicast = 1

	if multicast_modifier then
		multicast = multicast_modifier:GetMulticastFactor(self)
		multicast_modifier:PlayMulticastFX(multicast)
	end

	local unit_origin = (caster == target) and (origin + caster:GetForwardVector()*75) or origin
	SpawnEidolon(self, caster, unit_origin, duration, multicast, spawn_count, true, false)

	ResolveNPCPositions(origin, 128)
end

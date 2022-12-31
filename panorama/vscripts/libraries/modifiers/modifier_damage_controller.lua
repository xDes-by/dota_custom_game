-- Prevents player-based damage except against units in the same arena
-- Unfortunately this doesnt work for Infused Raindrop, because it block damage to early
---@class modifier_damage_controller:CDOTA_Modifier_Lua
modifier_damage_controller = class({})

function modifier_damage_controller:IsHidden() return true end
function modifier_damage_controller:IsDebuff() return false end
function modifier_damage_controller:IsPurgable() return false end
function modifier_damage_controller:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_damage_controller:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
end

function modifier_damage_controller:GetAbsoluteNoDamage(params)
	local attacker = params.attacker ---@type CDOTA_BaseNPC
	local victim = params.target ---@type CDOTA_BaseNPC

	if not attacker or not victim or victim == attacker then return 0 end
	
	if attacker.IsControllableByAnyPlayer and attacker:IsControllableByAnyPlayer() then
		if Enfos:IsEnfosMode() then
			if attacker:GetEnfosArena() ~= victim:GetEnfosArena() then return 1 end
		else
			if attacker:GetRangeToUnit(victim) > 2900 then return 1 end
		end
	end
end

modifier_damage_controller.GetAbsoluteNoDamageMagical = modifier_damage_controller.GetAbsoluteNoDamage
modifier_damage_controller.GetAbsoluteNoDamagePhysical = modifier_damage_controller.GetAbsoluteNoDamage
modifier_damage_controller.GetAbsoluteNoDamagePure = modifier_damage_controller.GetAbsoluteNoDamage


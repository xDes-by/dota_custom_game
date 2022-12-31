enfos_wizard_rune_spawned = class({})

function enfos_wizard_rune_spawned:CastFilterResultLocation(location)
	local caster = self:GetCaster()
	
	if IsServer() and not GridNav:IsTraversable(location) then
		EnfosWizard:AbortSpellCast(caster)
		DisplayError(caster:GetPlayerOwnerID(), "#enfos_hud_error_no_runes_here")
		return UF_FAIL_INVALID_LOCATION
	end
	
	local caster_arena = caster:GetEnfosArena()
	return GetEnfosArena(location) == caster_arena and UF_SUCCESS or UF_FAIL_CUSTOM
end

function enfos_wizard_rune_spawned:GetCustomCastErrorLocation(location)
	return "#enfos_hud_error_no_runes_here"
end

function enfos_wizard_rune_spawned:OnSpellStart()
	local valid_runes = {
		DOTA_RUNE_DOUBLEDAMAGE,
		DOTA_RUNE_HASTE,
		DOTA_RUNE_ILLUSION,
		DOTA_RUNE_ARCANE,
		DOTA_RUNE_BOUNTY
	}

	local caster = self:GetCaster()
	local rune_loc = self:GetCursorPosition()

	EmitSoundOnLocationWithCaster(rune_loc, "Wizard.RuneSpawn", caster)

	CreateRune(rune_loc, valid_runes[RandomInt(1, #valid_runes)])

	EnfosWizard:CastSpellResult(caster, "rune_spawned")
end 

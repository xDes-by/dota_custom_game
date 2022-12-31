enfos_wizard_rain_of_riches = class({})

function enfos_wizard_rain_of_riches:CastFilterResultLocation(location)
	local caster = self:GetCaster()
	
	if IsServer() and not GridNav:IsTraversable(location) then
		EnfosWizard:AbortSpellCast(caster)
		DisplayError(caster:GetPlayerOwnerID(), "#enfos_hud_error_no_runes_here")
		return UF_FAIL_INVALID_LOCATION
	end
	
	local caster_arena = GetEnfosArenaForTeam(caster:GetTeamNumber())
	return GetEnfosArena(location) == caster_arena and UF_SUCCESS or UF_FAIL_CUSTOM
end

function enfos_wizard_rain_of_riches:GetCustomCastErrorLocation(location)
	return "#enfos_hud_error_no_runes_here"
end

function enfos_wizard_rain_of_riches:OnSpellStart()
	local caster = self:GetCaster()
	local target_loc = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")

	EmitSoundOnLocationWithCaster(target_loc, "Wizard.RainOfRiches", caster)

	local item_amounts = {}
	item_amounts["item_book_of_strength"] = 7
	item_amounts["item_book_of_strength_2"] = 1
	item_amounts["item_book_of_agility"] = 7
	item_amounts["item_book_of_agility_2"] = 1
	item_amounts["item_book_of_intelligence"] = 7
	item_amounts["item_book_of_intelligence_2"] = 1
	item_amounts["item_enfos_gold_bag"] = 4
	item_amounts["item_enfos_gold_bag_2"] = 3
	item_amounts["item_enfos_gold_bag_3"] = 2
	item_amounts["item_enfos_gold_bag_4"] = 1
	item_amounts["item_relearn_book_lua"] = 3
	item_amounts["item_upgrade_book"] = 1

	local items = {}
	for item_name, item_amount in pairs(item_amounts) do
		for i = 1, item_amount do
			table.insert(items, item_name)
		end
	end

	items = table.shuffle(items)

	local portal_pfx = ParticleManager:CreateParticle("particles/5v5/enfos_wizard_rain_of_riches_drop_spawner.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(portal_pfx, 0, target_loc)

	Timers:CreateTimer(0.5, function()
		local item = CreateItem(table.remove(items), nil, nil)
		local destination = target_loc + RandomVector(RandomInt(175, 400))
		local launch = CreateItemOnPositionForLaunch(target_loc, item)

		item:LaunchLootInitialHeight(false, 50, 450, 0.7, destination)

		if #items > 0 then
			return 0.15
		else
			ParticleManager:DestroyParticle(portal_pfx, false)
		end
	end)

	EnfosWizard:CastSpellResult(caster, "rain_of_riches")
end

function enfos_wizard_rain_of_riches:GetAOERadius()
	return 400
end

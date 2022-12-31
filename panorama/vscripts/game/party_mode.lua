if PartyMode == nil then PartyMode = class({}) end

PartyMode.party_mode_enabled = false
PartyMode.tournament = false

PartyMode.head_start = false
PartyMode.infinite_paragon = false
PartyMode.damage_casts_spells = false
PartyMode.ebay = false
PartyMode.better_balance = false
PartyMode.fastdeath = false
PartyMode.megadeath = false
PartyMode.hardcore = false

function PartyMode:Fastdeath()
	PartyMode.fastdeath = true
	Notifications:BottomToAll({text = "Fast Death mode enabled: sudden death starts after round 20!", duration = 12, style = { color = "Red" } })
end

function PartyMode:Megadeath()
	PartyMode.megadeath = true
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if hero:IsMainHero() then
			local aegis = hero:FindModifierByName("modifier_aegis")
			if aegis then
				aegis:SetStackCount(3)
				CustomGameEventManager:Send_ServerToAllClients("player_show_aegis_init", {playerId = hero:GetPlayerID(), aegisCount = 3})
			end
		end
	end
	Notifications:BottomToAll({text = "Mega Death mode enabled: +1 aegis, sudden death starts after round 1!", duration = 12, style = { color = "Red" } })
end

function PartyMode:Hardcore()
	PartyMode.hardcore = true
	for _, hero in pairs(HeroList:GetAllHeroes()) do
		if hero:IsMainHero() then
			local aegis = hero:FindModifierByName("modifier_aegis")
			if aegis then
				hero:RemoveModifierByName("modifier_aegis")
				CustomGameEventManager:Send_ServerToAllClients("player_show_aegis_init", {playerId = hero:GetPlayerID(), aegisCount = 0})
			end
		end
	end
	Notifications:BottomToAll({text = "Hardcore mode enabled: ZERO aegis, sudden death starts after round 1!", duration = 12, style = { color = "Red" } })
end

function PartyMode:HeadStart(gold, levels)
	PartyMode.head_start_gold = gold
	PartyMode.head_start_levels = levels

    local heroes = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

    for _,hero in pairs(heroes) do
        PartyMode:HeadStartSpawn(hero)
    end
	
    PartyMode.head_start = true
    Notifications:BottomToAll({ text = "#party_mode_head_start", duration = 10, style = { color = "green" }})
end

function PartyMode:HeadStartSpawn(hero)
    hero:ModifyGold(PartyMode.head_start_gold, true, 0)
	for i=1, (PartyMode.head_start_levels - 1) do
		hero:HeroLevelUp(false)
	end
end

function PartyMode:InfiniteParagon()
	PartyMode.infinite_paragon = true
	Notifications:BottomToAll({ text = "#party_mode_infinite_paragon", duration = 10, style = { color = "green" }})
end

function PartyMode:DamageCastsSpells(arg)	
	if type(arg) ~= "number" then arg = 80 end

	if arg > 95 then
		arg = 95
	elseif arg < 1 then
		arg = 1
	end
	
	local arg = math.floor(arg)
	
	PartyMode.damage_casts_spells = true
	Notifications:BottomToAll({ text = "#party_mode_damage_casts_spells", duration = 10, style = { color = "green" }})
	
	local disable = {
		warlock_upheaval = true,
		windrunner_powershot = true,
		item_travel_boots = true,
		item_travel_boots_2 = true,
		item_helm_of_the_dominator = true,
		item_bfury = true,
		item_quelling_blade = true,
		enchantress_enchant = true,
		furion_wrath_of_nature = true,
		life_stealer_infest = true,
		life_stealer_assimilate = true,
		morphling_morph = true,
		enraged_wildkin_tornado = true,
		zuus_thundergods_wrath = true,
		enigma_demonic_conversion_lua = true,
		item_hand_of_midas = true,
		chen_holy_persuasion = true,
		ember_spirit_sleight_of_fist = true,
		enigma_black_hole = true,
		silencer_global_silence = true,

		abaddon_borrowed_time_lua 	= true,
		arc_warden_tempest_double_lua 	= true,
		dark_willow_shadow_realm	= true,
		dazzle_shallow_grave 		= true,
		doom_bringer_devour			= true,
		faceless_void_chronosphere  = true,
		legion_commander_duel		= true,
		omniknight_guardian_angel	= true,
		oracle_false_promise 		= true,
		phoenix_supernova 	  		= true,
		shadow_shaman_mass_serpent_ward_lua = true,
		slark_shadow_dance 			= true,
		zuus_thundergods_wrath 		= true,
		zuus_thundergods_vengeance	= true,
		arc_warden_scepter			= true,
		chen_hand_of_god_lua 		= true,
		lifestealer_infest_lua 		= true,
		monkey_king_wukongs_command_lua	= true,
		tinker_march_of_the_machines = true,
		
		innate_war_veteran = true,
		innate_magician = true,
		innate_warrior = true,
		innate_healer = true,
		innate_controller = true,
		innate_assassin = true,
		innate_trickster = true,
		innate_berserker = true,
		innate_tenacity = true,
		innate_iron_body = true,
		innate_blank_soul = true,
		innate_golden_boy = true,
		innate_lucky_stars = true,
		innate_gambler = true,
		innate_duelist = true,
		innate_late_bloomer = true,
		innate_second_chance = true,
		innate_harvester = true,
		innate_soul_link = true,
		innate_swift_arcana = true,

		high_five_custom = true,
		empty_0 = true,
		empty_1 = true,
		empty_2 = true,
		empty_3 = true,
		empty_4 = true,
		empty_5 = true,
	}
	
	local problematic = {
		tidehunter_anchor_smash = true,
		arc_warden_tempest_double = true,
		monkey_king_boundless_strike = true,
		mars_gods_rebuke = true,
		void_spirit_astral_step = true,
		jakiro_dual_breath = true,
	}
	
	local less_chance = {
		antimage_blink = true,
		chaos_knight_phantasm = true,
		naga_siren_mirror_image = true,
		phantom_lancer_spirit_lance = true,
		phantom_lancer_doppelwalk = true,
		spectre_haunt = true,
		terrorblade_conjure_image = true,
		arc_warden_tempest_double = true,
		item_manta = true,
		item_illusionsts_cape = true,
		sandking_epicenter = true,
		oracle_fortunes_end = true,
		elder_titan_echo_stomp = true,
		juggernaught_omnislash = true,
	}
	
	local NORMAL_CHANCE = arg
	local PROBLEMATIC_CHANCE = math.floor(NORMAL_CHANCE/2)
	local LESSCHANCE = math.floor(NORMAL_CHANCE/4)
	
	function ability_behavior_includes(ability, behavior)
		return bit.band(ability:GetBehaviorInt(), behavior) == behavior
	end
	
	
	local listener = ListenToGameEvent("entity_hurt", function(keys)
		local damage = keys.damage
		local attackerUnit = keys.entindex_attacker and EntIndexToHScript(keys.entindex_attacker)
		local victimUnit = keys.entindex_killed and EntIndexToHScript(keys.entindex_killed)
		local damagebits = keys.damagebits -- This might always be 0 and therefore useless
	
		if attackerUnit:IsRealHero() and victimUnit:IsAlive() and attackerUnit:IsAlive() then
			local possible = {}
			for i = 0, attackerUnit:GetAbilityCount() - 1 do 
				local hAbility = attackerUnit:GetAbilityByIndex(i)
				if hAbility and not hAbility:IsNull() and not hAbility:IsItem() and hAbility:IsTrained() and hAbility:IsStealable() and not hAbility:IsPassive() then
					if not disable[hAbility:GetAbilityName()] then
						possible[#possible + 1] = hAbility
					end
				end
			end
	
			local random_spell_int = RandomInt(1, #possible)
			local random_spell = possible[random_spell_int]
	
			if not random_spell then
				return
			end
	
			local chance = NORMAL_CHANCE
			if problematic[random_spell:GetAbilityName()] then
				chance = PROBLEMATIC_CHANCE
			end
			if less_chance[random_spell:GetAbilityName()] then
				chance = LESSCHANCE
			end
	
			if RollPercentage(chance) then
				Timers:CreateTimer(
					0.2,
					function()
						if random_spell and attackerUnit:IsAlive() and victimUnit:IsAlive() then  -- test again, object may have been deleted.
							if ability_behavior_includes(random_spell, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) and victimUnit then
								attackerUnit:SetCursorCastTarget(victimUnit)
							elseif ability_behavior_includes(random_spell, DOTA_ABILITY_BEHAVIOR_POINT) then
								attackerUnit:SetCursorPosition(victimUnit:GetAbsOrigin())
							else
								attackerUnit:SetCursorTargetingNothing(true)
							end
		
							attackerUnit:StartGesture(ACT_DOTA_CAST_ABILITY_5)
							random_spell:OnSpellStart()
						end
					end
				)
			end
		end
	end, nil)
end


EventDriver:Listen("HeroBuilder:hero_init_finished", function(event)
	-- Party mode nonsense
	if PartyMode.megadeath then
		event.hero:FindModifierByName("modifier_aegis"):SetStackCount(3)
	end

	if PartyMode.hardcore then event.hero:RemoveModifierByName("modifier_aegis") end

	if PartyMode.head_start then PartyMode:HeadStartSpawn(hero) end
end)

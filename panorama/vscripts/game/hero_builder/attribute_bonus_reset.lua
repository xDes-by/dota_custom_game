AttributeBonusModule = class({})
MAX_ATTRIBUTES_RESPONSE_DELAY = 1.5

function AttributeBonusModule:AttributeBonusReset(event)
	-- Default Null Check
	local player_id = event.PlayerID
	if not player_id then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return end

	local attribute_bonus = hero:FindAbilityByName("special_bonus_attributes")
	if not attribute_bonus then return end

	-- Reset logic
	local attribute_bonus_level = attribute_bonus:GetLevel()
	attribute_bonus:SetLevel(0)
	hero:SetAbilityPoints(hero:GetAbilityPoints() + attribute_bonus_level)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "AttributeBonus:UpdatePointsUI", {
		reset_points = true
	})
end
RegisterCustomEventListener("AttributeBonus:Reset", function(event) AttributeBonusModule:AttributeBonusReset(event) end)

ListenToGameEvent("dota_player_learned_ability", 	function(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local hero = player:GetAssignedHero()
	local ability_name = keys.abilityname
	if not hero or ability_name ~= "special_bonus_attributes" then return end
	
	local ability = hero:FindAbilityByName("special_bonus_attributes")
	if not ability then return end
	
	CustomGameEventManager:Send_ServerToPlayer(player, "AttributeBonus:UpdatePointsUI", {})

	-- Maxed Bonus Attributes logic
	if ability:GetLevel() ~= ability:GetMaxLevel() or hero.attributes_mastery_recieved then return end
	hero.attributes_mastery_recieved = true
	
	BP_Masteries:ChangeMaxCount(keys.PlayerID, 1)

	EmitAnnouncerSound("Item.TomeOfKnowledge")
	
	local particle = ParticleManager:CreateParticle("particles/custom/use_book.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero);
	ParticleManager:SetParticleControlEnt(particle, 0, hero, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", hero:GetAbsOrigin(), true);
	ParticleManager:SetParticleControl(particle, 1, Vector(244, 169, 241))
	ParticleManager:SetParticleControl(particle, 2, Vector(0, 0, -30))
	ParticleManager:SetParticleControl(particle, 3, Vector(163, 135, 250))
	ParticleManager:SetParticleControl(particle, 4, Vector(30, 0, -5))
	ParticleManager:SetParticleControl(particle, 5, Vector(75, 15, 300))
	ParticleManager:ReleaseParticleIndex(particle)
	
	Timers:CreateTimer(MAX_ATTRIBUTES_RESPONSE_DELAY, function()
		EmitAnnouncerSound(AttributeBonusModule.maxed_responses[hero:GetUnitName()])
	end)

end,  nil)

AttributeBonusModule.maxed_responses = {
	npc_dota_hero_abaddon =				"abaddon_abad_levelup_06",
	npc_dota_hero_abyssal_underlord =	"abyssal_underlord_abys_battlebegins_01",
	npc_dota_hero_alchemist =			"alchemist_alch_level_05",
	npc_dota_hero_ancient_apparition =	"ancient_apparition_appa_level_05",
	npc_dota_hero_antimage =			"antimage_anti_level_02",
	npc_dota_hero_arc_warden =			"arc_warden_arcwar_levelup_13",
	npc_dota_hero_axe =					"axe_axe_immort_02",
	npc_dota_hero_bane =				"bane_bane_immort_05",
	npc_dota_hero_batrider =			"batrider_bat_immort_02",
	npc_dota_hero_beastmaster =			"beastmaster_beas_level_04",
	npc_dota_hero_bloodseeker =			"bloodseeker_blod_level_05",
	npc_dota_hero_bounty_hunter =		"bounty_hunter_bount_immort_02",
	npc_dota_hero_brewmaster =			"brewmaster_brew_respawn_01",
	npc_dota_hero_bristleback =			"bristleback_bristle_attack_22",
	npc_dota_hero_broodmother =			"broodmother_broo_kill_01",
	npc_dota_hero_centaur =				"centaur_cent_levelup_03",
	npc_dota_hero_chaos_knight =		"chaos_knight_chaknight_levelup_01",
	npc_dota_hero_chen =				"chen_chen_level_06",
	npc_dota_hero_clinkz =				"clinkz_clinkz_kill_02",
	npc_dota_hero_crystal_maiden =		"crystalmaiden_cm_levelup_03",
	npc_dota_hero_dark_seer =			"dark_seer_dkseer_immort_02",
	npc_dota_hero_dark_willow =			"dark_willow_sylph_immort_02",
	npc_dota_hero_dawnbreaker =			"dawnbreaker_valora_levelup_04",
	npc_dota_hero_dazzle =				"dazzle_dazz_spawn_04",
	npc_dota_hero_death_prophet =		"death_prophet_dpro_levelup_05",
	npc_dota_hero_disruptor =			"disruptor_dis_spawn_03",
	npc_dota_hero_doom_bringer =		"doom_bringer_doom_rare_01",
	npc_dota_hero_dragon_knight =		"dragon_knight_drag_ability_eldrag_03",
	npc_dota_hero_drow_ranger =			"drowranger_drow_battlebegins_01",
	npc_dota_hero_earth_spirit =		"earth_spirit_earthspi_battlebegins_02",
	npc_dota_hero_earthshaker =			"earthshaker_erth_cast_01",
	npc_dota_hero_elder_titan =			"elder_titan_elder_win_04",
	npc_dota_hero_ember_spirit =		"ember_spirit_embr_levelup_15",
	npc_dota_hero_enchantress =			"enchantress_ench_respawn_02",
	npc_dota_hero_enigma =				"enigma_enig_rare_02",
	npc_dota_hero_faceless_void =		"faceless_void_face_respawn_06",
	npc_dota_hero_furion =				"furion_furi_drop_medium",
	npc_dota_hero_grimstroke =			"grimstroke_grimstroke_immort_03",
	npc_dota_hero_gyrocopter =			"gyrocopter_gyro_immort_02",
	npc_dota_hero_hoodwink =			"hoodwink_hoodwink_wheel_all_10",
	npc_dota_hero_huskar =				"huskar_husk_level_09",
	npc_dota_hero_invoker =				"invoker_invo_win_03",
	npc_dota_hero_jakiro =				"jakiro_jak_immort_02",
	npc_dota_hero_juggernaut =			"juggernaut_jug_rare_06",
	npc_dota_hero_keeper_of_the_light =	"keeper_of_the_light_keep_immort_02",
	npc_dota_hero_kunkka =				"kunkka_kunk_spawn_05",
	npc_dota_hero_legion_commander =	"legion_commander_legcom_spawn_05",
	npc_dota_hero_leshrac =				"leshrac_lesh_battlebegins_01",
	npc_dota_hero_lich =				"lich_lich_rare_02",
	npc_dota_hero_life_stealer =		"life_stealer_lifest_lasthit_09",
	npc_dota_hero_lina =				"lina_lina_battlebegins_01",
	npc_dota_hero_lion =				"lion_lion_rare_03",
	npc_dota_hero_lone_druid =			"lone_druid_lone_druid_respawn_03",
	npc_dota_hero_luna =				"luna_luna_rare_03",
	npc_dota_hero_lycan =				"lycan_lycan_battlebegins_01",
	npc_dota_hero_magnataur =			"magnataur_magn_levelup_05",
	npc_dota_hero_marci =				"marci_marci_immortality",
	npc_dota_hero_mars =				"mars_mars_rare_10 ",
	npc_dota_hero_medusa =				"medusa_medus_levelup_07",
	npc_dota_hero_meepo =				"meepo_meepo_immort_03",
	npc_dota_hero_mirana =				"mirana_mir_rare_03",
	npc_dota_hero_monkey_king =			"monkey_king_monkey_spawn_11",
	npc_dota_hero_morphling =			"morphling_mrph_level_01",
	npc_dota_hero_naga_siren =			"naga_siren_naga_respawn_06",
	npc_dota_hero_necrolyte =			"necrolyte_necr_spawn_04",
	npc_dota_hero_nevermore =			"nevermore_nev_ability_presence_02",
	npc_dota_hero_night_stalker =		"night_stalker_nstalk_win_04",
	npc_dota_hero_nyx_assassin =		"nyx_assassin_nyx_spawn_05",
	npc_dota_hero_obsidian_destroyer =	"outworld_destroyer_odest_rival_18",
	npc_dota_hero_ogre_magi =			"ogre_magi_ogmag_ability_multi_04",
	npc_dota_hero_omniknight =			"omniknight_omni_battlebegins_01",
	npc_dota_hero_oracle =				"oracle_orac_randomprophecies_10",
	npc_dota_hero_pangolier =			"pangolin_pangolin_immort_03",
	npc_dota_hero_phantom_assassin =	"phantom_assassin_phass_respawn_06",
	npc_dota_hero_phantom_lancer =		"phantom_lancer_plance_win_02",
	npc_dota_hero_phoenix =				"phoenix_phoenix_bird_victory",
	npc_dota_hero_puck =				"puck_puck_level_06",
	npc_dota_hero_pudge =				"pudge_pud_attack_08",
	npc_dota_hero_pugna =				"pugna_pugna_scepter_02",
	npc_dota_hero_queenofpain =			"queenofpain_pain_spawn_02",
	npc_dota_hero_rattletrap =			"rattletrap_ratt_win_06",
	npc_dota_hero_razor =				"razor_raz_immort_02",
	npc_dota_hero_riki =				"riki_riki_respawn_06",
	npc_dota_hero_rubick =				"rubick_rubick_immort_02",
	npc_dota_hero_sand_king =			"sandking_skg_rare_02",
	npc_dota_hero_shadow_demon =		"shadow_demon_shadow_demon_kill_09",
	npc_dota_hero_shadow_shaman =		"shadowshaman_shad_level_05",
	npc_dota_hero_snapfire =			"snapfire_snapfire_levelup_12",
	npc_dota_hero_shredder =			"shredder_timb_immort_02",
	npc_dota_hero_silencer =			"silencer_silen_level_08",
	npc_dota_hero_skeleton_king =		"skeleton_king_wraith_items_02",
	npc_dota_hero_skywrath_mage =		"skywrath_mage_drag_respawn_06",
	npc_dota_hero_slardar =				"slardar_slar_level_05",
	npc_dota_hero_slark =				"slark_slark_battlebegins_01",
	npc_dota_hero_sniper =				"sniper_snip_tf2_08",
	npc_dota_hero_spectre =				"spectre_spec_level_06",
	npc_dota_hero_spirit_breaker =		"spirit_breaker_spir_immort_02",
	npc_dota_hero_storm_spirit =		"stormspirit_stormspirit_scepter_02",
	npc_dota_hero_sven =				"sven_sven_level_03",
	npc_dota_hero_techies =				"techies_tech_levelup_14",
	npc_dota_hero_templar_assassin =	"templar_assassin_temp_begins_01",
	npc_dota_hero_terrorblade =			"terrorblade_terr_spawn_03",
	npc_dota_hero_tidehunter =			"tidehunter_tide_level_25",
	npc_dota_hero_tinker =				"tinker_tink_immort_02",
	npc_dota_hero_tiny =				"tiny_tiny_rare_03",
	npc_dota_hero_treant =				"treant_treant_battlebegins_01",
	npc_dota_hero_troll_warlord =		"troll_warlord_troll_respawn_01",
	npc_dota_hero_tusk =				"tusk_tusk_immort_02",
	npc_dota_hero_undying =				"undying_undying_immort_02",
	npc_dota_hero_ursa =				"ursa_ursa_cast_03",
	npc_dota_hero_vengefulspirit =		"vengefulspirit_vng_cast_02",
	npc_dota_hero_venomancer =			"venomancer_venm_respawn_06",
	npc_dota_hero_viper =				"viper_vipe_doubdam_02",
	npc_dota_hero_visage =				"visage_visa_levelup_04",
	npc_dota_hero_void_spirit =			"void_spirit_voidspir_wheel_all_05",
	npc_dota_hero_warlock =				"warlock_warl_level_04",
	npc_dota_hero_weaver =				"weaver_weav_win_03",
	npc_dota_hero_windrunner =			"windrunner_wind_haste_02",
	npc_dota_hero_winter_wyvern =		"winter_wyvern_winwyv_rare_02",
	npc_dota_hero_wisp =				"wisp_ally",
	npc_dota_hero_witch_doctor =		"witchdoctor_wdoc_rare_03",
	npc_dota_hero_zuus =				"zuus_zuus_spawn_08",
}

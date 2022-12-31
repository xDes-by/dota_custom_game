LinkLuaModifier("modifier_rerolls_remaining", 	"heroes/modifier_rerolls_remaining", 	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_aegis", 				"heroes/modifier_aegis", 				LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_aegis_buff", 			"heroes/modifier_aegis_buff", 			LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_aegis_buff_invul", 	"heroes/modifier_aegis_buff_invul", 	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bat_handler", 		"heroes/modifier_bat_handler", 			LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_casttime_handler", 	"heroes/modifier_casttime_handler", 	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_channel_listener", 	"heroes/modifier_channel_listener", 	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_fighting_pve", 	"heroes/modifier_hero_fighting_pve", 	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_dueling", 		"heroes/modifier_hero_dueling", 		LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hero_refreshing", 	"heroes/modifier_hero_refreshing", 		LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_summon_refreshing", 	"heroes/modifier_summon_refreshing", 	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_no_collision_custom",	"heroes/modifier_no_collision_custom", 	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_bar_scaling",	"heroes/modifier_ability_bar_scaling", 	LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hide_abandoned_hero",	"heroes/modifier_hide_abandoned_hero", 	LUA_MODIFIER_MOTION_NONE)

-- pseudo-abilities modifiers, here until I find a better place to stick them into
LinkLuaModifier("modifier_clinkz_skeletons", "heroes/hero_clinkz/modifier_clinkz_skeletons", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_lion_finger_of_death_creep_delay", "heroes/hero_lion/lion_finger_of_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_lion_finger_of_death_creep_stack_counter", "heroes/hero_lion/lion_finger_of_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_abyssal_underlord_atrophy_aura_effect_perma", "heroes/hero_abyssal_underlord/abyssal_underlord_atrophy_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_pangolier_shield_crash_creep_check", "heroes/hero_pangolier/pangolier_shield_crash", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_rattletrap_battery_assault_lua", "heroes/hero_rattletrap/rattletrap_battery_assault", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_faceless_void_time_walk_bash_check", "heroes/hero_faceless_void/modifier_faceless_void_time_walk_bash_check", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_legion_commander_duel_creep", "heroes/hero_legion_commander/legion_commander_duel", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_benchmark_power", "heroes/modifier_benchmark_power", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skywrath_mage_shard_lua", "heroes/hero_skywrath_mage/modifier_skywrath_mage_shard_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_skywrath_mage_shard_bonus_counter_lua", "heroes/hero_skywrath_mage/modifier_skywrath_mage_shard_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_shadow_demon_disruption_creep", "heroes/hero_shadow_demon/modifier_shadow_demon_disruption_creep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_melting_strike_lua", "heroes/hero_invoker/invoker_forge_spirit_ad", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_invoker_scepter_fix", "heroes/hero_invoker/modifier_invoker_scepter_fix", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_batrider_sticky_napalm_lua", "heroes/hero_batrider/modifier_batrider_sticky_napalm", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_lina_fiery_soul_shard_lua", "heroes/hero_lina/modifier_lina_fiery_soul_shard", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_axe_culling_blade_permanent_creep_lua", "heroes/hero_axe/modifier_axe_culling_blade_permanent_creep", LUA_MODIFIER_MOTION_NONE)

-- Hero talent corrections
LinkLuaModifier("modifier_dark_willow_talent_enabler", "heroes/hero_dark_willow/modifier_dark_willow_talent_enabler", LUA_MODIFIER_MOTION_NONE)
-- Item corrections
LinkLuaModifier("modifier_item_arcane_blink_buff_lua", "items/modifier_item_arcane_blink_buff_lua", LUA_MODIFIER_MOTION_NONE)


PENDING_HERO_PRECACHE = {}
PENDING_ABILITY_SOUND_PRECACHE = {}
PRECACHED_ABILITY_SOUNDS = {}

PLAYER_PICK_SEEN_HEROES = {}


HeroBuilder.toggled_reorder = {}
HeroBuilder.player_rerolls = {}
HeroBuilder.player_team_definition_listeners = {}
HeroBuilder.initial_aegis_count = 2


ATTACK_TYPE_MODIFIERS = LoadKeyValues("scripts/kv/attack_capability_mods.txt")
ABILITY_EXCLUSIONS_KV = LoadKeyValues("scripts/kv/excluded_ability_combinations.kv")
HERO_EXCLUSIONS_KV = LoadKeyValues("scripts/kv/ability_types/personal.kv")
UNREMOVABLE_ABILITIES_KV = LoadKeyValues("scripts/kv/ability_types/unremovable.kv")
SUMMON_ABILITIES_KV = LoadKeyValues("scripts/kv/ability_types/summon.kv")

HeroBuilder.talent_enablers = {
	npc_dota_hero_dark_willow = "modifier_dark_willow_talent_enabler",
}

HeroBuilder.refundable_subabilities = {
	nevermore_necromastery = true,
}

HeroBuilder.shard_modifier_reapply = {
	jakiro_liquid_ice = "modifier_jakiro_liquidice",
} 

HeroBuilder.modifiers_reapply = {		-- these are the modifiers that are replaced on creation with their _lua counterparts
	modifier_item_arcane_blink_buff = true,		-- for cast time calculations
	modifier_skywrath_mage_shard = true,		-- rewritten to disable toggle spells from triggering counter
	modifier_melting_strike = true,				-- to work on creeps
	modifier_batrider_sticky_napalm = true, 	-- custom Sticky Napalm and Flamebreak shard
}

HeroBuilder.shard_hero_specific = {   -- these are the modifiers that get assigned to a spell instead of being hero specific
	sandking_epicenter = "modifier_sand_king_shard",
	lina_fiery_soul = "modifier_lina_fiery_soul_shard_lua",
}

HeroBuilder.scepter_hero_specific = {	-- these are the modifiers that get assigned to a spell instead of being hero specific
	gyrocopter_flak_cannon = "modifier_gyrocopter_flak_cannon_scepter",
	
	-- Invoker abilities here to fix abilities use level 1 values if you have Aghs Scepter
	invoker_ghost_walk_ad = "modifier_invoker_scepter_fix",
	invoker_deafening_blast_ad = "modifier_invoker_scepter_fix",
	invoker_chaos_meteor_ad = "modifier_invoker_scepter_fix",
	invoker_ice_wall_ad = "modifier_invoker_scepter_fix",
	invoker_tornado_ad = "modifier_invoker_scepter_fix",
	invoker_emp_ad = "modifier_invoker_scepter_fix",
	invoker_sun_strike_ad = "modifier_invoker_scepter_fix",
	invoker_cold_snap_ad = "modifier_invoker_scepter_fix",
} 

HeroBuilder.client_stats = {
	["AttributeBaseStrength"] = true,
	["AttributeStrengthGain"] = true,
	["AttributeBaseAgility"] = true,
	["AttributeAgilityGain"] = true,
	["AttributeBaseIntelligence"] = true,
	["AttributeIntelligenceGain"] = true,
	["AttackDamageMin"] = true,
	["AttackDamageMax"] = true,
	["AttackRate"] = true,
	["AttackRange"] = true,
	["ProjectileSpeed"] = true,
	["ArmorPhysical"] = true,
	["MagicalResistance"] = {base = 25},
	["MovementSpeed"] = true,
	["MovementTurnRate"] = true,
	["StatusHealth"] = {base = 200},
	["StatusHealthRegen"] = {base = 0.2},
	["StatusManaRegen"] = true,
	["StatusMana"] = {base = 75},
}


HeroBuilder.stats_keys = {
	["StatusHealthRegen"] = {stat = "AttributeBaseStrength", value = 0.09},
	["StatusManaRegen"] = {stat = "AttributeBaseIntelligence", value = 0.05},
	["ArmorPhysical"] = {stat = "AttributeBaseAgility", value = 0.16},
	["StatusHealth"] = {stat = "AttributeBaseStrength", value = 20},
	["StatusMana"] = {stat = "AttributeBaseIntelligence", value = 12},
}


HeroBuilder.main_stats = {
	DOTA_ATTRIBUTE_AGILITY = "AttributeBaseAgility",
	DOTA_ATTRIBUTE_STRENGTH = "AttributeBaseStrength",
	DOTA_ATTRIBUTE_INTELLECT = "AttributeBaseIntelligence",
}

HeroBuilder.fountain_disabled_skills = {
	["arc_warden_tempest_double_lua"] 		= true,
	["juggernaut_healing_ward"] 			= true,
	["phoenix_supernova"] 					= true,
	["shredder_timber_chain"] 				= true,
	["ancient_apparition_ice_blast"] 		= true,
	["brewmaster_primal_split"] 			= true,
	["naga_siren_song_of_the_siren"] 		= true,
	["ember_spirit_fire_remnant"] 			= true,
	["ember_spirit_activate_fire_remnant"] 	= true,
	["venomancer_plague_ward_lua"] 			= true,
	["shadow_shaman_mass_serpent_ward_lua"] = true,
	["dark_seer_wall_of_replica"] 			= true,
	["weaver_the_swarm"] 					= true,
	["furion_force_of_nature"] 				= true,
	["broodmother_spin_web"] 				= true,
	["arc_warden_spark_wraith"] 			= true,
	["beastmaster_call_of_the_wild_boar"] 	= true,
	["skeleton_king_vampiric_aura"] 		= true,
	["witch_doctor_death_ward"] 			= true,
	["warlock_rain_of_chaos_lua"] 			= true,
	["lycan_summon_wolves_lua"] 			= true,
	["broodmother_spawn_spiderlings_lua"]	= true,
	["invoker_forge_spirit_ad_lua"] 		= true,
	["enigma_demonic_conversion_lua"] 		= true,
	["chen_test_of_faith"] 					= true,
	["undying_tombstone"] 					= true,
	["templar_assassin_psionic_trap"] 		= true,
	["zeus_cloud_lua"] 						= true,
	["techies_land_mines"] 					= true,
	["techies_stasis_trap"] 				= true,
	["techies_remote_mines"] 				= true,
	["techies_minefield_sign"] 				= true,
	["kunkka_torrent_storm"] 				= true,
	["earth_spirit_stone_caller"] 			= true,
	["rattletrap_power_cogs"] 				= true,
	["disruptor_static_storm"] 				= true,
	["furion_sprout"] 						= true,
	["lich_ice_spire"] 						= true,
	["nevermore_requiem"] 					= true,
	["tusk_frozen_sigil"] 					= true,
	["templar_assassin_trap_teleport"] 		= true,
	["oracle_false_promise"] 				= true,
	["witch_doctor_voodoo_switcheroo"] 		= true,
	["leshrac_split_earth"] 				= true,
	["tinker_march_of_the_machines"] 		= true,
	["clinkz_burning_army"] 				= true,
	["meepo_earthbind"] 					= true,
	["undying_tombstone_lua"] 				= true,
	["pugna_nether_ward"] 					= true,
	["faceless_void_time_walk"]				= true,
	["oracle_fortunes_end"] 				= true,
	["keeper_of_the_light_will_o_wisp"] 	= true,
	["shadow_demon_demonic_purge_lua"]		= true,
	["elder_titan_ancestral_spirit_lua"]	= true,
	["ursa_earthshock"]						= true,
	["ursa_enrage"]							= true,
}

HeroBuilder.fountain_removed_modifiers = {
	"modifier_creature_armor_reduction_boost",
	"modifier_creature_accuracy_boost",
	"modifier_creature_mana_cost_boost",
	"modifier_ice_blast",
	"modifier_doom_bringer_doom",
	"modifier_doom_bringer_doom_aura",
	"modifier_winter_wyvern_winters_curse",
	"modifier_winter_wyvern_winters_curse_aura",
	"modifier_slark_essence_shift_debuff_counter",
	"modifier_slark_essence_shift_debuff_custom",
	"modifier_slark_essence_shift_permanent_debuff",
}

HeroBuilder.solo_disabled_innate = {
		innate_speed_demon = true,
		innate_sunk_cost = true,
		innate_duelist = true,
		innate_gambler = true,
		innate_winner = true,
		innate_momentum = true,
}

-- Each player can have maximum 2 abilities from that pool
HeroBuilder.limited_abilities = {
	skeleton_king_reincarnation = true,
	dark_willow_shadow_realm = true,
	slark_shadow_dance = true,
	abaddon_borrowed_time = true,
	oracle_false_promise = true,
	ursa_enrage = true,
	visage_gravekeepers_cloak_lua = true,
	obsidian_destroyer_astral_imprisonment = true,
	faceless_void_chronosphere = true,
	puck_phase_shift = true,
	meepo_ransack = true,
}
HeroBuilder.limited_abilities_max_count = 2

HeroBuilder.disable_spell_amp = {
	["abyssal_underlord_firestorm"] = true,
	["elder_titan_earth_splitter"] = true,
	["winter_wyvern_arctic_burn"] = true,
	["doom_bringer_infernal_blade"] = true,
	["enigma_midnight_pulse"] = true,
	["enigma_black_hole"] = true,
	["sandking_caustic_finale"] = true,
	["zeus_static_field_lua"] = true,
	["huskar_life_break"] = true,
	["phoenix_sun_ray"] = true,
	["spectre_dispersion"] = true,
	["phantom_assassin_fan_of_knives"] = true,
	["jakiro_liquid_ice"] = true,
	["bloodseeker_rupture"] = true,
	["item_spirit_vessel"] = true,
	["terrorblade_reflection_lua"] = true,
	["venomancer_poison_nova"] = true,
	["bloodseeker_blood_mist"] = true,
	["witch_doctor_voodoo_restoration"] = true,
	["shadow_demon_disseminate"] = true,
}

HeroBuilder.enable_ref_count = {
	spirit_breaker_charge_of_darkness = true
}

-- hero state
HERO_STATE_NONE = 0
HERO_STATE_AWAITING_PRECACHE = 1
HERO_STATE_DEFAULT = 2
HERO_STATE_SELECTING_ABILITY = 3
HERO_STATE_SELECTING_INNATE = 4
HERO_STATE_REMOVING_ABILITY = 5
HERO_STATE_REMOVING_ABILITY_FOR_SUMMON = 6
HERO_STATE_SELECTING_SUMMON_ABILITY = 7

-- ability selection event types
ABILITY_SELECTION_SELECTED = 1
ABILITY_SELECTION_CANCELLED = 2
ABILITY_SELECTION_RELEARN_SELECTED = 3
ABILITY_SELECTION_RELEARN_CANCELLED = 4
ABILITY_SELECTION_SUMMON_SELECTED = 5
ABILITY_SELECTION_SUMMON_CANCELLED = 6


INNATE_SELECTION_ROUND = 2

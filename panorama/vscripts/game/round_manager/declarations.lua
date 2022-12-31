
-- Spawner enemy modifiers
LinkLuaModifier("modifier_creature_true_sight", "creatures/abilities/modifier_creature_true_sight", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_pre_round_frozen", "creatures/abilities/modifier_creature_pre_round_frozen", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_extra_mana", "creatures/abilities/modifier_creature_extra_mana", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_berserk", "creatures/abilities/modifier_creature_berserk", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_invisible_dummy_unit", "creatures/abilities/modifier_invisible_dummy_unit", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_level_indicator", "creatures/abilities/modifier_creature_empower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_empower", "creatures/abilities/modifier_creature_empower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_armor_boost", "creatures/abilities/modifier_creature_empower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_magic_resist_boost", "creatures/abilities/modifier_creature_empower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_status_resist_boost", "creatures/abilities/modifier_creature_empower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_attack_speed_boost", "creatures/abilities/modifier_creature_empower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_move_speed_boost", "creatures/abilities/modifier_creature_empower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_armor_reduction_boost", "creatures/abilities/modifier_creature_empower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_accuracy_boost", "creatures/abilities/modifier_creature_empower", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_creature_mana_cost_boost", "creatures/abilities/modifier_creature_empower", LUA_MODIFIER_MOTION_NONE)

-- Round limits and settings
ROUND_MANAGER_MAX_ROUND = 500
ROUND_MANAGER_MAX_ROUND_TIER = 4
ROUND_MANAGER_ROUNDS_PER_TIER = 10
ROUND_MANAGER_ROUND_DURATION = 50
ROUND_MANAGER_OVERTIME_DURATION = 90
ROUND_MANAGER_DEFEAT_GRACE_PERIOD = 5
ROUND_MANAGER_CREEP_SPAWN_TIME = 12
ROUND_MANAGER_CREEP_SPAWN_STAGGER_INTERVAL = 0.15
ROUND_MANAGER_MAX_CREEP_SPAWN_INTERVAL = 0.5

----------------------------------------

RoundManager.max_time_extensions_per_player = 2
RoundManager.time_extension_duration = 10
RoundManager.minimum_remaining_preparation_time_for_extension = 5

RoundManager.time_extensions_used = {}

----------------------------------------

ROUND_MANAGER_GOLD_SOURCE_OTHER = 0
ROUND_MANAGER_GOLD_SOURCE_CREEPS = 1
ROUND_MANAGER_GOLD_SOURCE_ROUND_PRIZE = 2
ROUND_MANAGER_GOLD_SOURCE_BETS = 3
ROUND_MANAGER_GOLD_SOURCE_DUEL = 4
ROUND_MANAGER_GOLD_SOURCE_GIFTS = 5

RoundManager.player_gold_earned_per_round = {}

----------------------------------------

RoundManager.base_max_abilities_limit = 2

RoundManager.max_ability_increase_rounds = {}
RoundManager.max_ability_increase_rounds[3] = true
RoundManager.max_ability_increase_rounds[6] = true
RoundManager.max_ability_increase_rounds[9] = true

----------------------------------------

RoundManager.round_preparation_time = {}
RoundManager.round_preparation_time["ffa"] = 15
RoundManager.round_preparation_time["demo"] = 15
RoundManager.round_preparation_time["duos"] = 15

RoundManager.extra_pvp_round_preparation_time = {}
RoundManager.extra_pvp_round_preparation_time["ffa"] = 8
RoundManager.extra_pvp_round_preparation_time["demo"] = 8
RoundManager.extra_pvp_round_preparation_time["duos"] = 10

RoundManager.totem_center_offset = {}
RoundManager.totem_center_offset["duos"] = Vector(0, 725, 0)

RoundManager.extra_ability_selection_round_preparation_time = 15

-- Economy
RoundManager.catchup_compensation_frequency = 10
RoundManager.base_round_gold = 270
RoundManager.exponential_gold_scaling = 1.038
RoundManager.linear_gold_scaling = 23
RoundManager.max_round_gold = 13500
RoundManager.boss_round_multiplier = 2.5

----------------------------------------

ROUND_MANAGER_CREEP_STATS_CAP = 100000000	-- 100 million. Prevents health/etc. overflow
ROUND_MANAGER_MAX_CREEP_LEVEL = 150			
ROUND_MANAGER_ROUNDS_PER_TRUESIGHT_CREEP = 15

ROUND_MANAGER_WAVE_COLORS = {
	[0] = Vector(255, 255, 255),	-- Default color
	[1] = Vector(102, 178, 255),	-- Light Blue
	[2] = Vector(0, 0, 255),		-- Blue
	[3] = Vector(102, 255, 102),	-- Light green
	[4] = Vector(0, 153, 0),		-- Green
	[5] = Vector(255, 255, 102),	-- Yellow
	[6] = Vector(255, 128, 0),		-- Orange
	[7] = Vector(255, 0, 0),		-- Red
	[8] = Vector(178, 102, 255),	-- Purple
	[9] = Vector(0, 0, 0)			-- Black
}

----------------------------------------

ROUND_MANAGER_HEALTH_TRACKING_ROUNDS = {
	["Round_Hellbear"] = true,
	["Round_Monkey"] = true,
	["Round_Storegga"] = true,
	["Round_Twins"] = true,
	["Round_Jabberwock"] = true,
	["Round_WolfBoss"] = true,
	["Round_OgreBoss"] = true,
	["Round_FrostbittenBoss"] = true,
	["Round_NianBoss"] = true,
	["Round_AncientBoss"] = true,
	["Round_SiltbreakerBoss"] = true,
	["Round_RoshanBoss"] = true
}

----------------------------------------

LinkLuaModifier("modifier_chc_stalling", "libraries/modifiers/modifier_chc_stalling", LUA_MODIFIER_MOTION_NONE)

ROUND_MANAGER_STALLING_DETER_MAX_ROUND = 20
ROUND_MANAGER_STALLING_DETER_DELAY = 20
ROUND_MANAGER_STALLING_DETER_INTERVAL = 1
ROUND_MANAGER_STALLING_DETER_GOLD_REDUCTION = 2
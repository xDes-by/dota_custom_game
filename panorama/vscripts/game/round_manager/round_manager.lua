-- Round Manager
-- Manages starting, pausing, and ending rounds, as well as related game flow functions.
-- Currently built to work with ffa and duos (enfos uses its own classes).
-- Closely related to the Round and Spawner classes.

if RoundManager == nil then RoundManager = class({}) end

require("game/round_manager/declarations")
require("game/round_manager/round")
require("game/round_manager/spawner")

-- Initializes round manager and rolls the round order for this game.
function RoundManager:Init()
	print("[ROUND MANAGER] initializing")

	-- Enfos map has its own round manager class
	if Enfos:IsEnfosMode() then return end

	-- Set up listeners
	EventDriver:Listen("Spawner:all_creeps_killed", RoundManager.OnAllCreepsKilled, RoundManager)
	EventDriver:Listen("Round:round_preparation_started", RoundManager.OnRoundPreparationStarted, RoundManager)
	EventDriver:Listen("Round:round_started", RoundManager.OnRoundStarted, RoundManager)
	EventDriver:Listen("Round:round_ended", RoundManager.OnRoundEnded, RoundManager)
	EventDriver:Listen("HeroBuilder:hero_init_finished", RoundManager.OnHeroInit, RoundManager)

	RoundManager.sudden_death_listener = EventDriver:Listen("Round:round_preparation_started", RoundManager.UpdateSuddenDeathState, RoundManager)

	RegisterCustomEventListener("checkAutoReadyForClient", function(keys) self:UpdateAutoReadyStatus(keys) end)
	RegisterCustomEventListener("player_check_auto_ready", function(keys) self:SetAutoReadyStatus(keys) end)
	RegisterCustomEventListener("RequestRoundInfoReconnect", function(keys) self:OnPlayerRequestRoundInfo(keys) end)
	RegisterCustomEventListener("update_players_ready", function(keys) self:OnPlayerReady(keys) end)
	RegisterCustomEventListener("ExtendTimerCountCheck", function(keys) self:CheckExtendTimerCount(keys) end)
	RegisterCustomEventListener("ExtendTimer", function(keys) self:ExtendRoundTimer(keys) end)

	-- Player ready state tracking
	RoundManager.ready_players = {}
	RoundManager.auto_ready_players = {}

	-- Team grace periods (time during which they can still win the round, even after dying)
	RoundManager.team_grace_period_timers = {}

	-- Parse round data
	local round_data_path = "scripts/kv/round_data/"..GetMapName().."_"

	if TestMode:IsTestMode() then round_data_path = "scripts/kv/round_data/ffa_" end

	RoundManager.regular_round_data = LoadKeyValues(round_data_path.."normal_rounds.txt")
	RoundManager.boss_round_data = LoadKeyValues(round_data_path.."boss_rounds.txt")
	RoundManager.totem_data = LoadKeyValues("scripts/kv/round_data/totems.txt")

	RoundManager.round_data = {}

	for tier, tier_rounds in pairs(RoundManager.regular_round_data) do
		for round_name, round_data in pairs(tier_rounds) do
			RoundManager.round_data[round_name] = {}
			RoundManager.round_data[round_name].tier = tonumber(tier)
			RoundManager.round_data[round_name].enemy_count = 0

			for key, data in pairs(round_data) do
				RoundManager.round_data[round_name][tonumber(key)] = {}
				RoundManager.round_data[round_name][tonumber(key)].unit = data.unit
				RoundManager.round_data[round_name][tonumber(key)].x = data.x
				RoundManager.round_data[round_name][tonumber(key)].y = data.y
				RoundManager.round_data[round_name].enemy_count = RoundManager.round_data[round_name].enemy_count + 1
			end
		end
	end

	for tier, tier_rounds in pairs(RoundManager.boss_round_data) do
		for round_name, round_data in pairs(tier_rounds) do
			RoundManager.round_data[round_name] = {}
			RoundManager.round_data[round_name].tier = tonumber(tier)
			RoundManager.round_data[round_name].enemy_count = 0
			RoundManager.round_data[round_name].is_boss = true

			for key, data in pairs(round_data) do
				RoundManager.round_data[round_name][tonumber(key)] = {}
				RoundManager.round_data[round_name][tonumber(key)].unit = data.unit
				RoundManager.round_data[round_name][tonumber(key)].x = data.x
				RoundManager.round_data[round_name][tonumber(key)].y = data.y
				RoundManager.round_data[round_name].enemy_count = RoundManager.round_data[round_name].enemy_count + 1
			end
		end
	end

	RoundManager.totem_names = {}
	for _, totem_name in pairs(RoundManager.totem_data) do
		table.insert(RoundManager.totem_names, totem_name)
	end

	-- Build list of rounds for this match
	print("[ROUND MANAGER] building randomized round list")
	RoundManager.round_list = {}

	local fortune_genie_tier = RandomInt(1, 3)
	print("[ROUND MANAGER] rolled fortune genie at tier ", fortune_genie_tier)
	-- Set up rounds up to R40
	local starter_round_list = {}
	for tier = 1, ROUND_MANAGER_MAX_ROUND_TIER do
		starter_round_list[tier] = {}

		-- Randomly add rounds of the appropriate tier
		local this_tier_rounds = RoundManager.regular_round_data[tostring(tier)]
		this_tier_rounds = table.shuffle(this_tier_rounds)

		for round_name, _ in pairs(this_tier_rounds) do
			if #starter_round_list[tier] < (ROUND_MANAGER_ROUNDS_PER_TIER - 1) then
				table.insert(starter_round_list[tier], round_name)
			end
		end

		-- Add any missing rounds (to complete ROUND_MANAGER_ROUNDS_PER_TIER - 1) randomly from lower tier rounds
		if #starter_round_list[tier] < (ROUND_MANAGER_ROUNDS_PER_TIER - 1) then
			local lower_tier_rounds = {}
			for lower_tier = 1, (tier - 1) do
				for round_name, _ in pairs(RoundManager.regular_round_data[tostring(lower_tier)]) do
					table.insert(lower_tier_rounds, round_name)
				end
			end

			lower_tier_rounds = table.shuffle(lower_tier_rounds)
			while #starter_round_list[tier] < (ROUND_MANAGER_ROUNDS_PER_TIER - 1) do
				table.insert(starter_round_list[tier], table.remove(lower_tier_rounds))
			end
		end

		-- Randomize the list's order
		starter_round_list[tier] = table.shuffle(starter_round_list[tier])

		-- Add it to the normal round list
		for round = 1, (ROUND_MANAGER_ROUNDS_PER_TIER - 1) do
			table.insert(RoundManager.round_list, starter_round_list[tier][round])
		end

		-- Add a random boss at each tier's final round
		if tier == fortune_genie_tier then
			local round_name, _ = next(RoundManager.boss_round_data["999"])
			table.insert(RoundManager.round_list, round_name)
		else
			local this_tier_boss_rounds = {}
			for boss_round_name, _ in pairs(RoundManager.boss_round_data[tostring(tier)]) do
				table.insert(this_tier_boss_rounds, boss_round_name)
			end
			table.insert(RoundManager.round_list, this_tier_boss_rounds[RandomInt(1, #this_tier_boss_rounds)])
		end
	end

	-- Set up round 41+
	local all_bosses = {}
	local all_rounds = {}

	for tier = 1, ROUND_MANAGER_MAX_ROUND_TIER do
		for round_name, _ in pairs(RoundManager.boss_round_data[tostring(tier)]) do
			table.insert(all_bosses, round_name)
		end
		for round_name, _ in pairs(RoundManager.regular_round_data[tostring(tier)]) do
			table.insert(all_rounds, round_name)
		end
	end

	local all_bosses_copy = table.shuffle(all_bosses)
	local all_rounds_copy = table.shuffle(all_rounds)

	for round = (1 + ROUND_MANAGER_ROUNDS_PER_TIER * ROUND_MANAGER_MAX_ROUND_TIER), ROUND_MANAGER_MAX_ROUND do
		if (round % ROUND_MANAGER_ROUNDS_PER_TIER == 0) then
			table.insert(RoundManager.round_list, table.remove(all_bosses_copy))
			if #all_bosses_copy < 1 then all_bosses_copy = table.shuffle(all_bosses) end
		else
			table.insert(RoundManager.round_list, table.remove(all_rounds_copy))
			if #all_rounds_copy < 1 then all_rounds_copy = table.shuffle(all_rounds) end
		end
	end

	-- Roll for the special alternate roshan
	for round_number, round_name in pairs(RoundManager.round_list) do
		if round_name == "Round_RoshanBoss" and RandomInt(1, 500) <= 1 then
			RoundManager.round_list[round_number] = "Round_FridgeBoss"
		end
	end

	-- Set up totems
	RoundManager.totem_list = {}

	local all_totems = table.shuffle(RoundManager.totem_names)
	for round = 1, ROUND_MANAGER_MAX_ROUND do
		table.insert(RoundManager.totem_list, table.remove(all_totems))
		if #all_totems < 1 then all_totems = table.shuffle(RoundManager.totem_names) end
	end

	print("[ROUND MANAGER] finished initialization")
end





-- Returns the current round's handle.
function RoundManager:GetCurrentRound()
	return RoundManager.current_round
end

-- Returns the current round's number.
function RoundManager:GetCurrentRoundNumber()
	if self.current_round then
		return self.current_round:GetRoundNumber()
	end

	return 0
end

-- Returns the current round's name.
function RoundManager:GetCurrentRoundName()
	if self.current_round then
		return self.current_round:GetRoundName()
	end

	return nil
end

-- Returns the current round's totem's name.
function RoundManager:GetCurrentRoundTotem()
	if self.current_round then
		return self.current_round:GetTotemName()
	end

	return nil
end

-- Returns the current round's spawner handle for a given team. Returns the spawners table if called without a valid team.
function RoundManager:GetCurrentRoundSpawner(team)
	if self.current_round then
		return self.current_round:GetSpawner(team)
	end

	return nil
end

-- Returns true if totems spawn on the current map
function RoundManager:IsTotemMap()
	return GetMapName() == "duos"
end

-- Returns a round's name based on its number, as randomed for this specific game. Returns nil for rounds above ROUND_MANAGER_MAX_ROUND.
function RoundManager:GetRoundNameFromNumber(round_number)
	return RoundManager.round_list[round_number]
end

-- Returns a round's totem name based on its number, as randomed for this specific game. Returns nil for rounds above ROUND_MANAGER_MAX_ROUND.
function RoundManager:GetRoundTotemFromNumber(round_number)
	return RoundManager.totem_list[round_number]
end

-- Returns a round's tier based on its number
function RoundManager:GetRoundTierFromNumber(round_number)
	return math.min(ROUND_MANAGER_MAX_ROUND_TIER, math.ceil(round_number / ROUND_MANAGER_ROUNDS_PER_TIER))
end

-- Returns the enemy spawn data for a given round, specified by name.
function RoundManager:GetRoundData(round_name)
	return RoundManager.round_data[round_name]
end

-- Returns true if the current round has started (meaning the preparation stage is fully finished).
-- In Enfos mode, this is always true after the first round starts.
function RoundManager:IsRoundStarted()
	return GameMode:GetModeState() == GAME_STATE_ROUND_STARTED
end

-- End the current round and move to the next one's preparation phase.
function RoundManager:MoveToNextRound()
	local next_round = 1

	-- End current round
	if self.current_round then
		next_round = 1 + self.current_round:GetRoundNumber()
	end

	-- If we have gone beyond the maximum round, end the game
	if next_round > ROUND_MANAGER_MAX_ROUND then
		self:ForceEndGameWithError("max_round_reached")

	-- Else, keep going
	else
		if not (self.debug_stop_round_flow or TestMode.__disableAutoStart) then
			self.current_round = Round()
			self.current_round:Prepare(next_round, nil)
		end
	end
end

-- Ends the current round and starts the preparation phase of an arbitrarily specified one.
-- If round number is not specified, uses the current one.
-- If round name is not specified, uses the appropriate one for the round's number.
function RoundManager:DebugMoveToRound(keys)
	local round_number = tonumber(keys.round_number) or self:GetCurrentRoundNumber()
	local round_name = keys.round_name

	self.debug_stop_round_flow = true

	if self.current_round then self.current_round:ForceStopRound() end

	self.debug_stop_round_flow = false

	self.current_round = Round()
	self.current_round:Prepare(round_number, round_name, keys.totem_name)
end

-- Forces the end of the game, usually due to a flow-breaking error.
-- The argument is a string describing the error both to the players and the server
function RoundManager:ForceEndGameWithError(error)
	Notifications:BottomToAll({text = "#"..error, duration = 10, style = {color = "Red"}})

	Timers:CreateTimer(10, function()
		for _, team in pairs(GameMode:GetAllAliveTeams()) do
			GameMode:TeamLose(team)
		end
	end)
end

-- Fires when a team finishes killing the creeps in their arena
function RoundManager:OnAllCreepsKilled(keys)
	if Enfos:IsEnfosMode() then return end

	if RoundManager.team_grace_period_timers[keys.team] then Timers:RemoveTimer(RoundManager.team_grace_period_timers[keys.team]) end

	if GameMode:IsTeamAlive(keys.team) then RoundManager:MoveTeamToFountain(keys.team, true) end

	self.current_round:OnRoundEndedForTeam()
end

-- Fires when the round preparation phase starts
function RoundManager:OnRoundPreparationStarted(keys)
	self:ResetPlayerRoundUI()
	self:StartCheckingReadyState()
end

-- Fires when the round starts
function RoundManager:OnRoundStarted()

	-- Reset teams' grace period timers
	RoundManager.team_grace_period_timers = {}

	-- Stop checking auto-ready states
	Timers:RemoveTimer(self.auto_ready_checker)

	-- Reset all player ready states to false
	for player_id, _ in pairs(RoundManager.ready_players) do
		RoundManager.ready_players[player_id] = false
	end
end

-- Fires when the round ends
function RoundManager:OnRoundEnded(keys)
	self:GrantCatchUpGifts(keys)
	self:HideUnpickedHeroes(keys)
end

-- Moves an entire team to the fountain area
function RoundManager:MoveTeamToFountain(team, iterate_camera_movement, after_duel)
	local team_member_index = 1
	for _, player_id in pairs(GameMode.team_player_id_map[team]) do
		self:MoveHeroToFountain(player_id, iterate_camera_movement, team_member_index, after_duel)
		team_member_index = team_member_index + 1
	end

	GameMode:SetTeamState(team, TEAM_STATE_ON_BASE)
end

-- Moves a hero to the fountain area
function RoundManager:MoveHeroToFountain(player_id, iterate_camera_movement, team_member_index, after_duel)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local team = PlayerResource:GetTeam(player_id)
	local team_fountain_spawn_points = table.shallowcopy(GameMode.team_fountain_spawn_points[team])

	-- Player not assigned to valid team somehow
	if not team_fountain_spawn_points then return end
	if not hero then return end

	local target_location = team_fountain_spawn_points[team_member_index] or team_fountain_spawn_points[1]

	-- If the hero is ressurrecting, come back soon (in order to properly apply modifiers)
	if hero:IsReincarnating() then
		Timers:CreateTimer(0.03, function()
			self:MoveHeroToFountain(player_id, iterate_camera_movement, team_member_index, after_duel)
		end)
		return
	end		

	-- Ressurrect the hero if necessary
	if (not hero:IsAlive()) and (not hero:IsReincarnating()) then hero:RespawnHero(false, false) end

	-- Refresh items and abilities if they're coming from a duel
	if after_duel then
		Util:RefreshAbilityAndItem(hero, {
			item_refresher = true,
		})
		hero:Heal(hero:GetMaxHealth(), nil)
		hero:GiveMana(hero:GetMaxMana())
		hero:RefreshIntrinsicModifiers()

		Util:RefreshAbilityAndItem(hero:GetSummonedBear())
	end

	-- Clean up movement modifiers
	Util:RemoveMovementModifiers(hero)
	ProjectileManager:ProjectileDodge(hero)

	-- Clean up duel and pve modifiers and state
	hero:RemoveModifierByName("modifier_hero_dueling")
	hero:RemoveModifierByName("modifier_big_game_hunter_target")
	hero:RemoveModifierByName("modifier_chc_stalling")
	hero:AddNewModifier(hero, nil, "modifier_hero_fighting_pve", {})
	hero:AddNewModifier(hero, nil, "modifier_hero_refreshing", {})

	--To prevent accidentally activating abilities in the fountain causing them to go on cooldown after the refresh
	if after_duel then
		hero:AddNewModifier(hero, nil, "modifier_silence_mute", { duration = 3 })
	end
	-- Teleport the hero and any summon
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hero)

	GameMode:SetPlayerState(player_id, PLAYER_STATE_ON_BASE)
	FindClearSpaceForUnit(hero, target_location, true)

	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	hero:EmitSound("DOTA_Item.BlinkDagger.Activate")

	Summon:TeleportSummonsToHero(hero, SUMMON_DESTINATION_FOUNTAIN, nil)

	-- Make sure the hero is really where we want them to be
	Timers:CreateTimer(0.1, function()
		if hero and (not hero:IsNull()) then
			local target_distance = (hero:GetAbsOrigin() - target_location):Length()
			if target_distance > 1500 then
				FindClearSpaceForUnit(hero, target_location, true)
				return 0.1
			end
		end
	end)

	-- Auto-pick up items from the stash
	if hero:IsMainHero() and hero:IsControllableByAnyPlayer() and PLAYER_OPTIONS_AUTO_STASH_ENABLED[player_id] then
		for stashSlot = 9, 14 do
			local item = hero:GetItemInSlot(stashSlot)
			if item and DoesHeroHaveFreeSlotInInventory(hero) then
				local taken_item = hero:TakeItem(item)
				hero:AddItem(taken_item)
			end
		end
	end
end

-- Moves an entire team to the appropriate arena
function RoundManager:MoveTeamToArena(team)
	local team_member_index = 1
	local pvp_team_index = table.findkey(PvpManager:GetPvpTeams(), team)
	local current_spawner = RoundManager:GetCurrentRoundSpawner(team)

	for _, player_id in pairs(GameMode.team_player_id_map[team]) do
		if pvp_team_index then
			self:MoveHeroToDuelArena(player_id, pvp_team_index, team_member_index)
		else
			self:MoveHeroToCreepArena(player_id, team_member_index, current_spawner)
		end

		
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero then
			-- Prevent items from being sold for full price if they're in the players main inventory during a round
			hero:OverdueItemsInInventory()
			
			local bear = hero:GetSummonedBear()
			if bear then
				bear:OverdueItemsInInventory()
			end

			-- Flush timelapse modifier to prevent teleporting outside arena
			local modifier_timelapse = hero:FindModifierByName("modifier_weaver_timelapse")
			if modifier_timelapse then
				local timelapse = modifier_timelapse:GetAbility()
				modifier_timelapse:Destroy()
				hero:AddNewModifier(hero, timelapse, "modifier_weaver_timelapse", nil)
			end
		end

		team_member_index = team_member_index + 1
	end

	GameMode:SetTeamState(team, (pvp_team_index and TEAM_STATE_DUELING) or TEAM_STATE_FIGHTING_CREEPS)
end

-- Moves a hero to their creep arena
function RoundManager:MoveHeroToCreepArena(player_id, team_member_index, current_spawner)
	local player = PlayerResource:GetPlayer(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local team = PlayerResource:GetTeam(player_id)

	local hero_spawn_points = table.shallowcopy(GameMode.player_spawn_points[team])
	local target_location = hero_spawn_points[team_member_index] or hero_spawn_points[1]

	local camera_location = target_location
	if GetMapName() == "duos" then
		camera_location = GameMode.arena_centers[team] - Vector(300,200,0)
	end

	if not hero then return end

	-- Clean up movement modifiers
	Util:RemoveMovementModifiers(hero)
	ProjectileManager:ProjectileDodge(hero)

	-- Set proper duel/pve modifiers and state
	hero:RemoveModifierByName("modifier_hero_refreshing")
	hero:RemoveModifierByName("modifier_hero_dueling")
	hero:AddNewModifier(hero, nil, "modifier_hero_fighting_pve", {})
	hero:AddNewModifier(hero, nil, "modifier_chc_stalling", nil)

	if current_spawner then
		if current_spawner.accuracy_boost > 0 then
			local accuracy_modifier = hero:AddNewModifier(nil, nil, "modifier_creature_accuracy_boost", {})
			if accuracy_modifier then 
				accuracy_modifier:SetStackCount(current_spawner.accuracy_boost) 
			end
		end
	end

	Timers:CreateTimer(0.4, function()
		if current_spawner then 
			current_spawner:OnRoundStarted({}) 
		end
		local creeps = FindUnitsInRadius(
			DOTA_TEAM_NEUTRALS, 
			target_location, 
			nil, 2000, 
			DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
			DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
			DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			0, false
		)
	
		for _, creep in pairs(creeps) do
			if creep and not creep:IsNull() then
				creep:RemoveModifierByName("modifier_creature_pre_round_frozen")
			end
		end

		for _, totem in pairs(current_spawner.current_totems) do
			if IsValidEntity(totem) then
				totem:RemoveModifierByName("modifier_creature_pre_round_frozen")
			end
		end
	end)

	-- Teleport the hero and any summon
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hero)

	GameMode:SetPlayerState(player_id, PLAYER_STATE_FIGHTING_CREEPS)
	FindClearSpaceForUnit(hero, target_location, true)

	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	hero:EmitSound("DOTA_Item.BlinkDagger.Activate")

	Summon:TeleportSummonsToHero(hero, SUMMON_DESTINATION_PVE, nil)

	-- Adjust player camera
	if player then
		Camera:SetCameraToPosition(player, camera_location)
	end

	-- Make sure the hero is really where we want them to be
	Timers:CreateTimer(0.1, function()
		if hero and (not hero:IsNull()) then
			local target_distance = (hero:GetAbsOrigin() - target_location):Length()
			if target_distance > 1500 then
				FindClearSpaceForUnit(hero, target_location, true)
				return 0.1
			end
		end
	end)
end

-- Moves a hero to the dueling arena
function RoundManager:MoveHeroToDuelArena(player_id, pvp_team_index, team_member_index)
	local player = PlayerResource:GetPlayer(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)

	local hero_spawn_points = table.shallowcopy(PvpManager.pvp_spawn_points[pvp_team_index])
	local target_location = hero_spawn_points[team_member_index] or hero_spawn_points[1]

	if not hero then return end

	-- Clean up movement modifiers
	Util:RemoveMovementModifiers(hero)
	ProjectileManager:ProjectileDodge(hero)

	-- Set proper duel/pve modifiers and state
	hero:RemoveModifierByName("modifier_hero_refreshing")
	hero:RemoveModifierByName("modifier_hero_fighting_pve")
	hero:RemoveModifierByName("modifier_lifestealer_infest_caster")
	hero:RemoveModifierByName("modifier_creature_accuracy_boost")
	hero:AddNewModifier(hero, nil, "modifier_hero_dueling", {})

	-- Teleport the hero and any summon
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hero)

	GameMode:SetPlayerState(player_id, PLAYER_STATE_DUELING)
	FindClearSpaceForUnit(hero, target_location, true)

	hero:SetForwardVector((GameMode.pvp_center - target_location):Normalized())

	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	hero:EmitSound("DOTA_Item.BlinkDagger.Activate")

	Summon:TeleportSummonsToHero(hero, SUMMON_DESTINATION_PVP, nil)

	-- Adjust player camera
	if player then
		Camera:SetCameraToPosition(player, target_location)
	end

	-- Make sure the hero is really where we want them to be
	Timers:CreateTimer(0.1, function()
		local target_distance = (hero:GetAbsOrigin() - target_location):Length()
		if target_distance > 1500 then
			FindClearSpaceForUnit(hero, target_location, true)
			return 0.1
		end
	end)
end

-- Returns true if sudden death is enabled
function RoundManager:IsSuddenDeathActive()
	return RoundManager.sudden_death_enabled
end

-- Checks if sudden death should be activated
function RoundManager:UpdateSuddenDeathState(keys)
	if GameOptions:OptionsIsActive("game_option_disable_sudden_death") then return end
	if self.sudden_death_enabled then return end

	if (keys.round_number > PvpManager.sudden_death_start_round) then
		self:ActivateSuddenDeath()
	elseif (PartyMode.fastdeath and keys.round_number > 20) or PartyMode.megadeath or PartyMode.hardcore then
		self:ActivateSuddenDeath()
	elseif GameMode:GetAliveTeamCount() <= PvpManager.sudden_death_player_count_limit[GetMapName()] and (IsInToolsMode() or (not GameMode.is_solo_pve_game)) then
		self:ActivateSuddenDeath()
	end
end

-- Enables sudden death from this moment onward
function RoundManager:ActivateSuddenDeath()
	self.sudden_death_enabled = true
	Notifications:BottomToAll({ text = "#sudden_death", duration = 12, style = {color = "Red"}})
	EventDriver:CancelListener("Round:round_preparation_started", RoundManager.sudden_death_listener)

	-- Clear duel weights after sudden death activated
	PvpManager:ClearDuelStats()
end

-- Constantly checks if a player's auto-ready criteria have been met
function RoundManager:StartCheckingReadyState()
	self.auto_ready_checker = Timers:CreateTimer(2, function()
		for _, player_id in pairs(GameMode.all_players) do
			if self.auto_ready_players[player_id] and GameMode:GetModeState() == GAME_STATE_BEFORE_ROUND and (not GameMode:IsTeamDefeated(PlayerResource:GetTeam(player_id))) then
				local hero = PlayerResource:GetSelectedHeroEntity(player_id)
				if hero and (not hero:HasCooldownOnItems()) and (not hero:HasCooldownOnAbilities()) and 
					(hero:GetHealthPercent() >= 99) and (hero:GetManaPercent() >= 99) and self:IsBetReady(player_id) and hero:IsAlive() then
					if (not RoundManager:IsRoundStarted()) and not self.ready_players[player_id] then
						self:SetPlayerReadyForNextRound(player_id) 
					end
				end
			end
		end

		return 0.5
	end)
end

function RoundManager:IsBetReady(player_id)
	if self.current_round:IsPvpRound() then
		if PvpManager:IsPvpTeamThisRound(PlayerResource:GetTeam(player_id)) then
			return true
		else
			return BetManager:GetBet(player_id)
		end
	else
		return true
	end
end

-- Sets a player as being ready for the next round (this one is just a panorama listener for when the player presses the ready button)
function RoundManager:OnPlayerReady(keys)
	if keys.PlayerID then RoundManager:SetPlayerReadyForNextRound(keys.PlayerID) end
end

-- Sets a player as being ready for the next round, and fires the necessary events
function RoundManager:SetPlayerReadyForNextRound(player_id)
	RoundManager.ready_players[player_id] = true
	CustomGameEventManager:Send_ServerToAllClients("player_ready_for_round", {playerId = player_id})

	local player = PlayerResource:GetPlayer(player_id)
	if player then CustomGameEventManager:Send_ServerToPlayer(player, "updateReadyButton", {visible = false, triggerRound = false}) end

	-- If all players are ready, start the next round early
	if self:AreAllPlayersReady() then
		EventDriver:Dispatch("RoundManager:all_players_ready", {})

		-- If this is a solo game, readying up unpauses it
		if GameMode.is_solo_pve_game or GameMode:GetAliveTeamCount() == 1 then
			PauseGame(false)
		end 
	end
end

-- Returns true if all players who are currently in a competing team are ready for the next round
function RoundManager:AreAllPlayersReady()
	for _, team in pairs(GameMode:GetAllAliveTeams()) do
		for _, player_id in pairs(GameMode.team_player_id_map[team]) do
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero and (not hero:IsNull()) and (not hero:IsAlive()) then return false end
			if not (RoundManager.ready_players[player_id] or PlayerResource:IsFakeClient(player_id)) then return false end
		end
	end

	return true
end

-- Updates a player's auto-ready state when a round's preparation phase starts
function RoundManager:UpdateAutoReadyStatus(keys)
	local player_id = keys.PlayerID
	if (not player_id) then return end

	local player = PlayerResource:GetPlayer(player_id)
	if (not player) then return end

	if RoundManager.auto_ready_players[player_id] then
		CustomGameEventManager:Send_ServerToPlayer(player, "setAutoReadyForClient", {isAutoReady = RoundManager.auto_ready_players[player_id]})
	end
end

-- Toggles a player's auto-ready state when the appropriate button is clicked
function RoundManager:SetAutoReadyStatus(keys)
	if not keys.PlayerID then return end
	if keys.auto == 1 then
		RoundManager.auto_ready_players[keys.PlayerID] = true
	else
		RoundManager.auto_ready_players[keys.PlayerID] = false
	end
end

-- Fires when requested by a client. Shows the extend timer button, if appropriate.
function RoundManager:CheckExtendTimerCount(keys)
	local player_id = keys.PlayerID

	if (not player_id) then return end

	local player = PlayerResource:GetPlayer(player_id)

	if RoundManager.time_extensions_used[player_id] == nil then
		RoundManager.time_extensions_used[player_id] = 0
		if (not RoundManager:IsRoundStarted()) and GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			CustomGameEventManager:Send_ServerToPlayer(player, "ShowExtendTimerButton", {})
		end
	elseif RoundManager.time_extensions_used[player_id] < RoundManager.max_time_extensions_per_player then
		if (not RoundManager:IsRoundStarted()) and GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			CustomGameEventManager:Send_ServerToPlayer(player, "ShowExtendTimerButton", {})
		end
	end
end

-- Fires when the 'extend timer' button is pressed.
function RoundManager:ExtendRoundTimer(keys)
	local player_id = keys.PlayerID
	local team = PlayerResource:GetTeam(keys.PlayerID)

	if (not player_id) or (not team) then return end
	if not self.current_round then return end

	if GameMode:IsTeamAlive(team) then
		if GameMode:GetAliveTeamCount() == 1 then
			if not GameMode.is_full_lobby_pvp_game or GameMode.pause_time < PAUSE_TIME_MAX then
				CustomGameEventManager:Send_ServerToAllClients("UpdateExtendTimerText", {paused = not GameRules:IsGamePaused()})
				PauseGame(not GameRules:IsGamePaused())
			end

			if GameRules:IsGamePaused() then
				CustomGameEventManager:Send_ServerToAllClients("ShowExtendTimerButton", {})
			elseif self.current_round.preparation_extend_disabled then
				CustomGameEventManager:Send_ServerToAllClients("HideExtendTimerButton", {})
			end
		else
			if self.current_round.preparation_extend_disabled then return end
			if self.current_round.players_used_time_extension[player_id] then return end

			CustomGameEventManager:Send_ServerToAllClients("HideExtendTimerButton", {})
			if self.time_extensions_used[keys.PlayerID] == nil then
				self.time_extensions_used[keys.PlayerID] = 1
			end

			if self.time_extensions_used[keys.PlayerID] < self.max_time_extensions_per_player then
				self.current_round.players_used_time_extension[player_id] = true
				self.time_extensions_used[keys.PlayerID] = self.time_extensions_used[keys.PlayerID] + 1
				self.current_round:ExtendPreparationTime(self.time_extension_duration)
				Notifications:BottomToAll({ text = "#extend_timer_notification", duration = 4, style = { color = "Red" }})

				if self.current_round then
					local roundInfo = self.current_round.round_preparation_panel_data
					if roundInfo then
						roundInfo.maxround_time = roundInfo.maxround_time + self.time_extension_duration
						roundInfo.round_start_time = roundInfo.round_start_time + self.time_extension_duration
						CustomGameEventManager:Send_ServerToAllClients("PrepareRoundExtendTime", roundInfo)
					end
				end
			end
		end
	end
end

-- Sends round info panel data to a reconnecting player
function RoundManager:OnPlayerRequestRoundInfo(keys)
	local player_id = keys.PlayerID

	if not player_id then return end

	local player = PlayerResource:GetPlayer(player_id)
	local current_round = self.current_round or Enfos:GetCurrentRound()
	
	-- Show round timer and info panel for the reconnected player
	if player and current_round then
		if current_round.round_preparation_panel_data then
			CustomGameEventManager:Send_ServerToPlayer(player, "ShowRoundPanel", current_round.round_preparation_panel_data)
		end

		if current_round.round_started_panel_data then
			CustomGameEventManager:Send_ServerToPlayer(player, "HideExtendTimerButton", {})
			CustomGameEventManager:Send_ServerToPlayer(player, "updateReadyButton", {visible = false, triggerRound = true})
			CustomGameEventManager:Send_ServerToPlayer(player, "HideRoundPanel", {})
			CustomGameEventManager:Send_ServerToPlayer(player, "ShowRoundTimeLimit", current_round.round_started_panel_data)
		end
	end
end

-- Grants players gold, while registering its amount and source, round by round
-- Defaults to current round and ROUND_MANAGER_SOURCE_UNKNOWN if those parameters are not provided
function RoundManager:GiveGoldToPlayer(player_id, gold, round, source)
--	print("Give gold to player:", player_id, gold, round)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return end

	if gold <= 0 then return end

	round = round or self:GetCurrentRoundNumber()
	source = source or ROUND_MANAGER_GOLD_SOURCE_OTHER

	if source == ROUND_MANAGER_GOLD_SOURCE_CREEPS then
		gold = gold * (1 + 0.01 * hero:GetCreepGoldAmplification())
	elseif source == ROUND_MANAGER_GOLD_SOURCE_BETS then
		gold = gold * (1 + 0.01 * hero:GetBetGoldAmplification())
	elseif source == ROUND_MANAGER_GOLD_SOURCE_DUEL then
		gold = gold * (1 + 0.01 * hero:GetDuelGoldAmplification())
	elseif source == ROUND_MANAGER_GOLD_SOURCE_ROUND_PRIZE then
		gold = gold * (1 - 0.01 * hero:GetModifierStackCount("modifier_chc_stalling", hero))
	end

	PlayerResource:ModifyGold(player_id, gold, true, DOTA_ModifyGold_CreepKill)
	GameMode:UpdatePlayerGold(player_id)

	local player = PlayerResource:GetPlayer(player_id)
	if player then SendOverheadEventMessage(player, OVERHEAD_ALERT_GOLD, hero, gold, player) end

	if (not RoundManager.player_gold_earned_per_round[player_id]) then
		RoundManager.player_gold_earned_per_round[player_id] = {}
	end

	if (not RoundManager.player_gold_earned_per_round[player_id][round]) then
		RoundManager.player_gold_earned_per_round[player_id][round] = {}
	end

	RoundManager.player_gold_earned_per_round[player_id][round][source] = (RoundManager.player_gold_earned_per_round[player_id][round][source] or 0) + gold
end

-- Returns the amount of gold a player earned, from a specific source, during a specific round
-- If no round is specified, returns all gold earned until now
-- If no source is specified, returns gold earned from all sources
function RoundManager:GetPlayerGoldHistory(keys)
	local gold = 0

	if (not keys.player_id) then return 0 end

	if keys.round then
		if keys.source then
			-- This is why we can't have nice things
			if self.player_gold_earned_per_round[keys.player_id] and
			self.player_gold_earned_per_round[keys.player_id][keys.round] and
			self.player_gold_earned_per_round[keys.player_id][keys.round][keys.source] then
				return self.player_gold_earned_per_round[keys.player_id][keys.round][keys.source]
			else
				return 0
			end
		else
			for source, source_gold in pairs(self.player_gold_earned_per_round[keys.player_id][keys.round]) do
				gold = gold + source_gold
			end
		end
	else
		if keys.source then
			for round, round_data in pairs(self.player_gold_earned_per_round[keys.player_id]) do
				gold = gold + round_data[keys.source]
			end
		else
			for round, _ in pairs(self.player_gold_earned_per_round[keys.player_id]) do
				for source, source_gold in pairs(self.player_gold_earned_per_round[keys.player_id][round]) do
					gold = gold + source_gold
				end
			end
		end
	end

	return gold
end

-- Resets each player's ready/extend timer UI
function RoundManager:ResetPlayerRoundUI()
	for _, team in pairs(GameMode:GetAllAliveTeams()) do
		for _, player_id in pairs(GameMode.team_player_id_map[team]) do
			local player = PlayerResource:GetPlayer(player_id)
			if player and GameMode:IsPlayerActive(player_id) and (not GameMode:HasPlayerAbandoned(player_id)) then
				CustomGameEventManager:Send_ServerToPlayer(player, "updateReadyButton", {visible = true, triggerRound = true})

				if self.time_extensions_used[player_id] and self.time_extensions_used[player_id] < self.max_time_extensions_per_player then
					CustomGameEventManager:Send_ServerToPlayer(player, "ShowExtendTimerButton", {try = self.max_time_extensions_per_player - self.time_extensions_used[player_id]})
				end

				if GameMode:GetAliveTeamCount() == 1 and GameMode:IsTeamAlive(PlayerResource:GetTeam(player_id)) then
					CustomGameEventManager:Send_ServerToPlayer(player, "UpdateExtendTimerText", {paused = GameRules:IsGamePaused()})
					CustomGameEventManager:Send_ServerToPlayer(player, "ShowExtendTimerButton", {})
				end
			end
		end
	end
end

-- Grants catch-up rewards to poorly performing players
function RoundManager:GrantCatchUpGifts(keys) 

	-- Only happens on rounds which are multiples of catchup_compensation_frequency
	if keys.round_number % self.catchup_compensation_frequency ~= 0 then return end

	local data_list = {}
	for _, team in pairs(GameMode:GetAllAliveTeams()) do
		
		local team_info = {
			networth = 0,
			team = team,
			players = {},
		}

		for _, player_id in pairs(GameMode.team_player_id_map[team]) do
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero and (hero:IsAlive() or hero:IsReincarnating()) then
				local player_networth = math.floor(hero:GetNetworthCHC())
				team_info.networth = team_info.networth + player_networth
				table.insert(team_info.players, { networth = player_networth, player_id = player_id })
			end
		end
		
		-- Catchup compensation gives to lowest networth player in team
		table.sort(team_info.players, function(a, b) return a.networth < b.networth end)
		table.insert(data_list, team_info)
	end

	if #data_list >= 2 then 
		table.sort(data_list, function(a, b) return a.networth < b.networth end)
		
		if data_list[1].players[1] then
			local player_id = data_list[1].players[1].player_id
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero then
				hero:AddItemByName("item_relearn_book_lua")
				local comeback_gift = hero:AddItemByName("item_comeback_gift")
				if comeback_gift and comeback_gift.SetPurchaseTime then
					comeback_gift:SetPurchaseTime(0)
				end

				local barrage_data = {
					type = "compensate_relearn_book",
					round_number = tostring(keys.round_number),
					playerId = player_id,
					book_type = 3
				}

				Barrage:FireBullet(barrage_data)
			end
		end

		if #data_list > 2 and data_list[2].players[1] then
			local player_id = data_list[2].players[1].player_id
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero then
				hero:AddItemByName("item_relearn_book_lua")

				local barrage_data = {
					type = "compensate_relearn_book",
					round_number = tostring(keys.round_number),
					playerId = player_id,
					book_type = 2
				}

				Barrage:FireBullet(barrage_data)
			end
		end

		if #data_list>3 and data_list[3].players[1] then
			local player_id = data_list[3].players[1].player_id
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero then
				local comeback_gift = hero:AddItemByName("item_comeback_gift")
				if comeback_gift and comeback_gift.SetPurchaseTime then
					comeback_gift:SetPurchaseTime(0)
				end
				
				local barrage_data = {
					type = "compensate_relearn_book",
					round_number = tostring(keys.round_number),
					playerId = player_id,
					book_type = 1
				}

				Barrage:FireBullet(barrage_data)
			end
		end
	end
end

-- When the first round ends, remove any hero souls from the game
function RoundManager:HideUnpickedHeroes(keys)
	if keys.round_number ~= 1 then return end

	for _, player_id in pairs(GameMode.all_players) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)

		if hero and hero:IsAlive() and (not GameMode:HasPlayerSelectedHero(player_id)) then
			hero:AddNewModifier(hero, nil, "modifier_hide_abandoned_hero", {})
		end
	end
end

function RoundManager:OnInventoryItemChanged(event)
	DeepPrint(event)
end

function RoundManager:OnHeroInit(event)
	-- In PvE start game 5 secs after players selected hero 
	local lobby_players = LobbyPlayerCount()
	if lobby_players <= 2 then
		
		local heroes_count = 0 
		for i = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
			if not PlayerResource:IsFakeClient(i) and PlayerResource:GetSelectedHeroEntity(i) then
				heroes_count = heroes_count + 1
			end
		end

		if heroes_count >= lobby_players then
			Timers:CreateTimer(5, function()
				if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
					GameRules:ForceGameStart()
				end
			end)
		end
	end
end

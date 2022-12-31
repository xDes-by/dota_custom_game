-- Round class logic

if Round == nil then Round = class({}) end

function Round:Prepare(round_number, round_name, totem_override)

	GameMode:SetModeState(GAME_STATE_BEFORE_ROUND)
	GridNav:RegrowAllTrees()

	-- Initialize round data
	self.spawners = {}

	self.round_number = round_number
	self.round_name = round_name or RoundManager:GetRoundNameFromNumber(round_number)
	self.round_totem = totem_override or RoundManager:GetRoundTotemFromNumber(round_number)
	self.round_tier = RoundManager:GetRoundTierFromNumber(round_number)
	self.round_preparation_time = RoundManager.round_preparation_time[GetMapName()]
	self.round_finish_order = {}

	self.round_spawn_data = RoundManager:GetRoundData(self.round_name)

	if not self.round_spawn_data then
		RoundManager:ForceEndGameWithError("missing_round_data")
		return nil
	end

	self.is_boss_round = self.round_spawn_data.is_boss
	self.enemy_spawn_count = self.round_spawn_data.enemy_count

	-- Ask pvp manager if this will be a pvp round
	self.is_pvp_round = PvpManager:WillThisRoundHavePvp(self.round_number, self.is_boss_round, self.round_name)

	-- Calculate round gold bounty
	local linear_gold_bounty = RoundManager.base_round_gold + RoundManager.linear_gold_scaling * (self.round_number - 1)
	local exponential_gold_bounty = RoundManager.base_round_gold + RoundManager.exponential_gold_scaling ^ (self.round_number - 1)
	self.base_round_bounty = math.max(linear_gold_bounty, exponential_gold_bounty)
	self.base_round_bounty = math.min(self.base_round_bounty, RoundManager.max_round_gold)

	-- Boss round adjustments
	if self.is_boss_round then
		if self.round_name == "Round_FortuneGenie" then
			EmitGlobalSound("fortune.round")
		else
			EmitGlobalSound("boss.round")
		end

		self.base_round_bounty = math.max(self.base_round_bounty * RoundManager.boss_round_multiplier, self.round_number * 100)
	end

	-- Calculate round gold bounty for each team that finishes it
	self.round_bounty_for_position = {}

	local competing_team_count = GameMode:GetAliveTeamCount()
	for position = 1, competing_team_count do
		self.round_bounty_for_position[position] = 0.7 * self.base_round_bounty * (1 - (position - 1) / competing_team_count)
	end

	-- Start listening for ready players
	self.all_players_ready_listener = EventDriver:Listen("RoundManager:all_players_ready", self.OnAllPlayersReady, self)

	-- Fire all relevant round preparation phase events on other modules
	EventDriver:Dispatch("Round:round_preparation_started", {
		round_number = self.round_number,
		round_name = self.round_name,
		is_boss_round = self.is_boss_round,
	})

	-- Spawn creep ability tooltip dummies and build round preparation info panel
	self:BuildRoundPreparationInfoPanel()

	-- Start spawning creeps
	local spawn_team_list = GameMode:GetAllAliveTeams()

	-- If this is the 1st round, spawn creeps for all teams, and kill them later if the team isn't activated yet
	if self.round_number == 1 then spawn_team_list = GameMode.team_list end

	-- Stagger spawners across time to lighten unit creation load on slower pcs
	local spawner_count = 0

	for _, team in pairs(spawn_team_list) do
		if (not PvpManager:IsPvpTeamThisRound(team)) then
			self.spawners[team] = Spawner()
			self.spawners[team]:Init(team, self, 0.5 + spawner_count * ROUND_MANAGER_CREEP_SPAWN_STAGGER_INTERVAL)

			spawner_count = spawner_count + 1
		end
	end
	
	-- Count down until round start
	self.elapsed_preparation_time = 0
	self.hide_extend_button_time = self.round_preparation_time - RoundManager.minimum_remaining_preparation_time_for_extension
	self.players_used_time_extension = {}

	self.round_preparation_timer = Timers:CreateTimer(0.5, function()
		self.elapsed_preparation_time = self.elapsed_preparation_time + 0.5

		-- Extend preparation time button cannot be pressed too close to the round's start
		if self.elapsed_preparation_time >= self.hide_extend_button_time then
			self.preparation_extend_disabled = true
			CustomGameEventManager:Send_ServerToAllClients("HideExtendTimerButton", {})
		end

		-- If all players are ready and spawners have finished their work, we can start the round immediately
		if self.all_players_ready and self:HasFinishedAllSpawns() then
			self:Start()
			return nil
		end

		-- If enough time has elapsed, start the round naturally
		if self.elapsed_preparation_time < self.round_preparation_time then
			return 0.5
		else
			self:Start()
		end
	end)

	if GameMode:GetAliveTeamCount() == 1 and GameMode.is_full_lobby_pvp_game and GameMode.pause_time >= PAUSE_TIME_MAX then
		self.preparation_extend_disabled = true
		CustomGameEventManager:Send_ServerToAllClients("HideExtendTimerButton", {})
	end
end

-- Fires when all players become ready to start the round
function Round:OnAllPlayersReady(keys)
	self.all_players_ready = true

	if self:HasFinishedAllSpawns() then
		self:Start()
	else
		self:SpeedUpSpawners()
	end
end

function Round:Start()
	RoundManager.fortune_boss_claim_scheduled = {}
	-- Clean up timers, listeners and dummies from preparation phase
	if self.round_preparation_timer then Timers:RemoveTimer(self.round_preparation_timer) end

	if self.all_players_ready_listener then
		EventDriver:CancelListener("RoundManager:all_players_ready", self.all_players_ready_listener)
	end

	self:CleanUpRoundPreparationInfoPanel()

	-- Clean up preparation phase UI
	CustomGameEventManager:Send_ServerToAllClients("HideExtendTimerButton", {})
	CustomGameEventManager:Send_ServerToAllClients("updateReadyButton", { visible = false, triggerRound = true })
	CustomGameEventManager:Send_ServerToAllClients("HidePvpBet", {})
	CustomGameEventManager:Send_ServerToAllClients("HideRoundPanel", {})

	self.start_time = GameRules:GetGameTime()

	-- Round panel UI information, saved in case its requested by a reconnecting player
	local pvp_teams = (self.is_pvp_round and PvpManager:GetPvpTeams()) or {}

	self.round_started_panel_data = {
		round_start_time = self.start_time,
		maxround_time = ROUND_MANAGER_ROUND_DURATION,
		text ="#round_time_limit",
		duelTeam1 = pvp_teams[1],
		duelTeam2 = pvp_teams[2],
	}

	CustomGameEventManager:Send_ServerToAllClients("ShowRoundTimeLimit", self.round_started_panel_data)

	-- Round end condition listeners
	self.hero_kill_listener = ListenToGameEvent("dota_player_killed", Dynamic_Wrap(Round, "OnHeroKilled"), self)
	self.creep_kill_listener = ListenToGameEvent("entity_killed", Dynamic_Wrap(Round, "OnEntityKilled"), self)

	if self.is_pvp_round then
		self.pvp_ended_listener = EventDriver:Listen("PvpManager:pvp_ended", self.OnRoundEndedForTeam, self)

		--Kill summons on PVP arena, before next duel started
		Summon:KillSummonedCreature(GameMode.pvp_center)
		CleanSparkWraith(GameMode.pvp_center, 2500)
		CleanTreantEyes(GameMode.pvp_center, 2500)
	end

	-- Teleport teams to their proper arenas
	for _, team in pairs(GameMode.GetAllAliveTeams()) do
		RoundManager:MoveTeamToArena(team)
	end

	-- Fire all relevant round start events on other modules
	GameMode:SetModeState(GAME_STATE_ROUND_STARTED)

	EventDriver:Dispatch("Round:round_started", {
		round_number = self.round_number,
		round_name = self.round_name,
		start_time = self.start_time,
	})

	-- Eliminate any teams that haven't been activated yet. This should only be relevant on the 1st round.
	for _, team in pairs(GameMode.team_list) do
		if (not GameMode:IsTeamAlive(team)) then
			self:DestroyAllCreepsForTeam(team)
		end
	end

	-- Round time tracking
	self.overtime_active = false
	self.current_overtime = 0

	self.regular_time_timer = Timers:CreateTimer(ROUND_MANAGER_ROUND_DURATION, function()
		self:RoundDurationExpired()
	end)

	-- Ready-up accelerate all cooldowns to the point they would be at if the time wasn't skipped
	if self.round_preparation_time and self.elapsed_preparation_time then
		local skipped_preparation_time = (self.round_preparation_time - self.elapsed_preparation_time) * 2 --x2 since on fountain cooldowns ticks faster
		if skipped_preparation_time > 0 then
			for _, team in pairs(GameMode.GetAllAliveTeams()) do
				for _, id in pairs(GameMode.team_player_id_map[team]) do
					local hero = PlayerResource:GetSelectedHeroEntity(id)
					if hero then
						hero:ReduceCooldowns(skipped_preparation_time)
					end
				end
			end
		end
	end
end

-- When a player dies, checks if their entire team is dead, and if that's the case, eliminates them from the game after a grace period.
-- Does not fire if the hero is ressurrecting (due to aegis, reincarnation, etc.)
function Round:OnHeroKilled(keys)
	local player_id = keys.PlayerID

	if (not player_id) then return end

	local team = PlayerResource:GetTeam(player_id)

	-- If all players on this team are truly dead, eliminate it...
	if team and GameMode:IsTeamFightingCreeps(team) then
		for _, id in pairs(GameMode.team_player_id_map[team]) do
			local hero = PlayerResource:GetSelectedHeroEntity(id)
			if IsValidEntity(hero) and (hero:IsAlive() or hero:IsReincarnating()) then
				return
			end
		end

		-- ...but only if a certain grace period elapses and there are still creeps alive
		RoundManager.team_grace_period_timers[team] = Timers:CreateTimer(ROUND_MANAGER_DEFEAT_GRACE_PERIOD, function()
			GameMode:TeamLose(team)
			if not TestMode:IsTestMode() then
				self:OnRoundEndedForTeam()
			end
		end)
	end
end

-- Whenever any unit dies, send that data to the relevant spawner, if any
function Round:OnEntityKilled(keys)
	local killed_unit = EntIndexToHScript(keys.entindex_killed)
	if not killed_unit then return end
	if killed_unit.spawn_team and self.spawners[killed_unit.spawn_team] then
		self.spawners[killed_unit.spawn_team]:OnEntityKilled(killed_unit)
	end
	-- flesh golem doesn't end on unit's death
	-- it does in vanilla, and we haven't touched it in any way, so band-aid fix is enough
	if killed_unit:IsRealHero() then
		killed_unit:RemoveModifierByName("modifier_undying_flesh_golem")
	end

	-- axe culling blade creep buff
	if not killed_unit:IsRealHero() and keys.entindex_inflictor then
		local inflictor = EntIndexToHScript(keys.entindex_inflictor)
		if inflictor and inflictor.GetAbilityName and inflictor:GetAbilityName() == "axe_culling_blade" and keys.entindex_attacker then
			local attacker = EntIndexToHScript(keys.entindex_attacker)
			if attacker and attacker:IsRealHero() and IsValidEntity(attacker) then
				local modifier = attacker:AddNewModifier(attacker, inflictor, "modifier_axe_culling_blade_permanent_creep_lua", {})
				if modifier then
					modifier:IncrementStackCount()
					inflictor:EndCooldown()
				end
			end
		end
	end
end

-- Runs when a round's regular duration expires and at least one team is still fighting
function Round:RoundDurationExpired()

	-- Update round info panel
	self.round_started_panel_data = {
		round_start_time = GameRules:GetGameTime(),
		maxround_time = ROUND_MANAGER_OVERTIME_DURATION, 
		text = "#round_force_end", 
		force = true
	}

	CustomGameEventManager:Send_ServerToAllClients("ShowRoundTimeLimit", self.round_started_panel_data)

	-- Grant all creeps the overtime buff
	for team, spawner in pairs(self.spawners) do
		spawner:StartOvertime()
	end

	-- Count overtime elapsed duration
	self.overtime_active = true
	self.overtime_timer = Timers:CreateTimer(1, function()
		self.current_overtime = self.current_overtime + 1

		if self.current_overtime < ROUND_MANAGER_OVERTIME_DURATION then
			self:ApplyOvertimeDebuffs()
			return 1
		else
			self:OvertimeDurationExpired()
		end
	end)

	EventDriver:Dispatch("Round:round_duration_expired", {
		round_number = self.round_number,
		round_name = self.round_name,
	})
end

-- Applies overtime debuffs to any heroes currently fighting creeps and alive
function Round:ApplyOvertimeDebuffs()
	for _, team in pairs(GameMode:GetAllAliveTeams()) do
		if GameMode:IsTeamFightingCreeps(team) then
			for _, player_id in pairs(GameMode.team_player_id_map[team]) do
				local hero = PlayerResource:GetSelectedHeroEntity(player_id)
				
				if hero and (not hero:IsNull()) and hero:IsAlive() then
					hero:AddNewModifier(hero, nil, "modifier_creature_mana_cost_boost", {stacks = self.current_overtime})
					if hero.tempest_double_clone and not hero.tempest_double_clone:IsNull() then
						hero.tempest_double_clone:AddNewModifier(
							hero, nil, "modifier_creature_mana_cost_boost", {stacks = self.current_overtime}
						)
					end
				end
			end
		end
	end
end

-- Runs when a round's overtime duration has fully elapsed and at least one team is still fighting
function Round:OvertimeDurationExpired()
	EventDriver:Dispatch("Round:overtime_duration_expired", {
		round_number = self.round_number,
		round_name = self.round_name,
	})

	-- Kill any teams still fighting creeps at this time
	for _, team in pairs(GameMode:GetAllAliveTeams()) do
		if GameMode:IsTeamFightingCreeps(team) then
			local team_has_aegis = GameMode:HasAegisOnTeam(team)

			if team_has_aegis then
				GameMode:ConsumeTeamAegis(team)
				self:DestroyAllCreepsForTeam(team)
			else
				for _, player_id in pairs(GameMode.team_player_id_map[team]) do
					GameMode:TrueKill(player_id)
				end

				GameMode:TeamLose(team)

				if not TestMode:IsTestMode() then
					self:OnRoundEndedForTeam()
				end
			end
		end
	end
end

-- Checks if all teams are either dead or done with their fights, and if yes, ends the round.
-- Called safely after any relevant team state transitions
function Round:OnRoundEndedForTeam(keys)
	local teams = GameMode:GetActivePVETeams()

	if #teams == 1 and self.round_number < ROUND_MANAGER_STALLING_DETER_MAX_ROUND then
		Timers:CreateTimer(ROUND_MANAGER_STALLING_DETER_DELAY, function()
			if self.ended then return end

			local team = teams[1]

			for _, player_id in pairs(GameMode.team_player_id_map[team]) do
				local hero = PlayerResource:GetSelectedHeroEntity(player_id)

				if hero then
					local modifier = hero:FindModifierByName("modifier_chc_stalling")

					if modifier then
						modifier:StartIntervalThink(ROUND_MANAGER_STALLING_DETER_INTERVAL)
					end
				end
			end
		end)
	end

	for _, team in pairs(GameMode:GetAllAliveTeams()) do
		if (not GameMode:IsTeamInFountain(team)) then
			return
		end
	end

	self:End()
end

-- Used to forcibly stop a currently ongoing round.
function Round:ForceStopRound()
	if GameMode:GetModeState() == GAME_STATE_BEFORE_ROUND then self:Start() end

	PvpManager:ForceStopDuel()
	self:DestroyAllCreeps()
	self:End(true)

	CustomGameEventManager:Send_ServerToAllClients("HideRoundPanel", {})
end

-- Ends the round. All teams should already be in the fountain by this point.
-- If stop_game_flow is false, immediately starts the next round's preparation.
function Round:End(stop_game_flow)

	self.ended = true

	-- Clean up any leftover timers and listeners
	if self.round_preparation_timer then Timers:RemoveTimer(self.round_preparation_timer) end
	if self.regular_time_timer then Timers:RemoveTimer(self.regular_time_timer) end
	if self.overtime_timer then Timers:RemoveTimer(self.overtime_timer) end

	if self.hero_kill_listener then StopListeningToGameEvent(self.hero_kill_listener) end
	if self.creep_kill_listener then StopListeningToGameEvent(self.creep_kill_listener) end

	if self.all_players_ready_listener then
		EventDriver:CancelListener("RoundManager:all_players_ready", self.all_players_ready_listener)
	end

	if self.pvp_ended_listener then
		EventDriver:CancelListener("PvpManager:pvp_ended", self.pvp_ended_listener)
	end

	-- Set and announce new game state
	GameMode:SetModeState(GAME_STATE_ROUND_ENDED)

	EventDriver:Dispatch("Round:round_ended", {
		round_number = self.round_number,
		round_name = self.round_name,
		is_boss = self.is_boss_round,
	})

	-- Update UI
	CustomGameEventManager:Send_ServerToAllClients("HideProgressWindow", {})

	if self.is_boss_round and self.round_name == "Round_FortuneGenie" then 
		self:_SendFortuneBossClaim()
	end

	-- If not in test mode, move on to the next round
	if stop_game_flow or TestMode.__disableAutoStart then return end

	RoundManager:MoveToNextRound()
end

-- Spawns dummies used for the round preparation panel's ability previews and tooltips
function Round:BuildRoundPreparationInfoPanel()
	local round_unit_names = {}
	local round_tooltip_dummy_entindexes = {}
	local round_tooltip_dummy_totem_entindexes = {}

	self.round_tooltip_dummies = {}

	for unit_number = 1, self.enemy_spawn_count do
		local unit_name = self.round_spawn_data[unit_number].unit
		if not table.contains(round_unit_names, unit_name) then table.insert(round_unit_names, unit_name) end
	end

	for _, unit_name in pairs(round_unit_names) do
		local unit = CreateUnitByName(unit_name, Vector(0,0,0), true, nil, nil, DOTA_TEAM_NEUTRALS)

		table.insert(self.round_tooltip_dummies, unit)
		table.insert(round_tooltip_dummy_entindexes, unit:GetEntityIndex())

		unit:AddNewModifier(unit, nil, "modifier_invulnerable", {})
		unit:AddNewModifier(unit, nil, "modifier_out_from_vision", {})

		for index = 0, (DOTA_MAX_ABILITIES - 1) do
			local ability = unit:GetAbilityByIndex(index)
			if ability then ability:SetLevel(math.min(self.round_tier, ability:GetMaxLevel())) end
		end
	end

	if RoundManager:IsTotemMap() then 
		local totem = CreateUnitByName(self.round_totem, Vector(0,0,0), true, nil, nil, DOTA_TEAM_NEUTRALS)

		table.insert(self.round_tooltip_dummies, totem)
		table.insert(round_tooltip_dummy_totem_entindexes, totem:GetEntityIndex())

		totem:AddNewModifier(totem, nil, "modifier_invulnerable", {})
		totem:AddNewModifier(totem, nil, "modifier_out_from_vision", {})
	end

	-- Save that info to use when a player reconnects
	self.round_preparation_panel_data = {
		round_start_time = GameRules:GetGameTime() + self.round_preparation_time,
		maxround_time = self.round_preparation_time, 
		round = self.round_number, 
		round_name = self.round_name, 
		creeps = round_tooltip_dummy_entindexes,
		totems = round_tooltip_dummy_totem_entindexes
	}

	CustomGameEventManager:Send_ServerToAllClients("ShowRoundPanel", self.round_preparation_panel_data)
end

-- Kills all round preparation panel dummies
function Round:CleanUpRoundPreparationInfoPanel()
	if (not self.round_tooltip_dummies) or type(self.round_tooltip_dummies) ~= "table" then return end

	for _, unit in pairs(self.round_tooltip_dummies) do
		if unit and not unit:IsNull() then 
			unit:RemoveModifierByName("modifier_out_from_vision")
		end
	end
end

function Round:GetRoundNumber()
	return self.round_number
end

function Round:GetRoundName()
	return self.round_name
end

function Round:GetTotemName()
	return self.round_totem
end

function Round:GetTierName()
	return self.round_tier
end

function Round:GetSpawnCount()
	return self.enemy_spawn_count
end

function Round:GetSpawner(team)
	if team then
		return self.spawners[team]
	else
		return self.spawners
	end
end

function Round:IsBossRound()
	return self.is_boss_round
end

function Round:IsPvpRound()
	return self.is_pvp_round
end

function Round:GetTeamFinishPosition(team)
	if team then
		for team_order, finished_team in pairs(self.round_finish_order) do
			if team == finished_team then
				return team_order
			end
		end
	end

	return self.round_finish_order
end

function Round:AddTeamToFinishPositions(team)
	table.insert(self.round_finish_order, team)
end

function Round:GetGoldBounty()
	return self.base_round_bounty or 0
end

function Round:GetGoldBountyForPosition(position)
	return self.round_bounty_for_position[position] or 0
end

function Round:ExtendPreparationTime(amount)
	if Enfos:IsEnfosMode() then return end
	self.round_preparation_time = self.round_preparation_time + amount
end

-- Returns true if all spawners have finished unit creation for this round
function Round:HasFinishedAllSpawns()
	for team, spawner in pairs(self.spawners) do
		if (not spawner:HasFinishedSpawning()) then return false end
	end

	return true
end

-- Speeds up unit creation, since all players are marked as ready for the next round
function Round:SpeedUpSpawners()
	for team, spawner in pairs(self.spawners) do
		spawner:SpeedUpSpawning()
	end
end

-- Immediately stop spawning creeps. Normally only useful for debugging and demo mode.
function Round:ForceStopSpawners()
	for team, spawner in pairs(self.spawners) do
		spawner:ForceStop()
	end
end

-- Force kills all currently alive creeps, while preventing any extra spawns
function Round:DestroyAllCreeps()
	for team, spawner in pairs(self.spawners) do
		spawner:ForceDestroyCreeps()
	end
end

-- Force kills all creeps for a given team, while preventing any extra spawns
function Round:DestroyAllCreepsForTeam(team)
	if self.spawners[team] then self.spawners[team]:ForceDestroyCreeps() end
end

-- Returns true if this round is currently in overtime
function Round:IsOvertimeActive()
	return self.overtime_active
end

-- Returns the amount of time elapsed since the start of overtime
function Round:GetElapsedOvertime()
	return self.current_overtime
end


function Round:_SendFortuneBossClaim()
	if not RoundManager.fortune_boss_claim_scheduled or #RoundManager.fortune_boss_claim_scheduled == 0 then
		print("[Round] fortune claim for Fortune Boss failed - no players registered")
		return
	end
	print("[Round] sending fortune boss claim")
	DeepPrintTable(RoundManager.fortune_boss_claim_scheduled)
	WebApi:Send("match/redeem_fortune_boss", {players = RoundManager.fortune_boss_claim_scheduled}, function(response)
		for steam_id, status in pairs(response.players) do
			local player_id = GetPlayerIdBySteamId(steam_id)
			local player = PlayerResource:GetPlayer(player_id)

			if player then
				CustomGameEventManager:Send_ServerToPlayer(player, "Round:fortune_boss:status", {status = status})
			end

			if status then
				BP_PlayerProgress:SetFortune(player_id, (BP_PlayerProgress:GetFortune(player_id) or 0) + 1)
				BP_Masteries:UpdateFortune(player_id)
				BP_PlayerProgress:UpdatePlayerInfo(player_id)
			end
		end
	end)
end


local function _FireAbilityPointsNotification(team)
	Notifications:BottomToTeam(team, {
		text = "#ability_points_notification", 
		duration = 10, 
		style = {
			color = "#01DF3A",
			textShadow = "0px 0px 6px 6 #000000",
			fontSize = "24",
		}
	})
end


EventDriver:Listen("Spawner:all_creeps_killed", function(event)
	if RoundManager.max_ability_increase_rounds[RoundManager:GetCurrentRoundNumber() + 1] then 
		_FireAbilityPointsNotification(event.team)
	end

	if TestMode:IsTestMode() then return end
	if not IsInToolsMode() and GameRules:IsCheatMode() then return end
	-- fortune boss kill handling
	if not event.is_boss or event.round_name ~= "Round_FortuneGenie" then return end
	
	RoundManager.fortune_boss_claim_scheduled = RoundManager.fortune_boss_claim_scheduled or {}

	local team_number = event.team
	for _, player_id in pairs(GameMode.team_player_id_map[team_number]) do
		if not PlayerResource:IsFakeClient(player_id) then
			local steam_id = tostring(PlayerResource:GetSteamID(player_id))
			table.insert(RoundManager.fortune_boss_claim_scheduled, steam_id)
		end
	end
end)


EventDriver:Listen("PvpManager:pvp_ended", function(event)
	if not RoundManager.max_ability_increase_rounds[RoundManager:GetCurrentRoundNumber() + 1] then return end
	_FireAbilityPointsNotification(event.winner_team)
	_FireAbilityPointsNotification(event.loser_team)
end)

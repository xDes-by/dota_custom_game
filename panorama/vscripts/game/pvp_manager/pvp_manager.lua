-- Pvp Manager
-- Manages matching teams for pvp duels, duel results, and duel history (W-L).
-- Works closely with the RoundManager, Round, and BetManager classes.

if PvpManager == nil then PvpManager = class({}) end

require("game/pvp_manager/declarations")
require("game/pvp_manager/bet_manager")

function PvpManager:Init()

	-- Enfos map has its own pvp manager class
	if Enfos:IsEnfosMode() then return end

	-- Initialize vars
	self.is_pvp_active = false
	self.current_pvp_teams = {}
	self.current_pvp_players = {}
	self.last_pvp_round = 1
	self.previous_first_team = DOTA_TEAM_NEUTRALS
	self.previous_second_team = DOTA_TEAM_NEUTRALS

	-- Set up pvp matching vars and history for all teams
	self.pvp_count = {}
	self.pvp_weights = {}
	self.pvp_history = {}
	self.previous_duel_for_team = {}

	for _, team in pairs(GameMode.team_list) do
		self.pvp_weights[team] = 0
		self.previous_duel_for_team[team] = DOTA_TEAM_NEUTRALS

		self.pvp_count[team] = {}
		for _, enemy_team in pairs(GameMode.team_list) do
			self.pvp_count[team][enemy_team] = 0
		end
	end

	-- Lookup spawn points on the pvp arena
	self.pvp_spawn_points = {}

	local team_a_spawn_points = {}
	local team_b_spawn_points = {}

	for _, spawn_point in pairs(Entities:FindAllByName("player_spawn_pvp_1")) do
		table.insert(team_a_spawn_points, spawn_point:GetOrigin())
	end

	for _, spawn_point in pairs(Entities:FindAllByName("player_spawn_pvp_2")) do
		table.insert(team_b_spawn_points, spawn_point:GetOrigin())
	end

	table.insert(self.pvp_spawn_points, team_a_spawn_points)
	table.insert(self.pvp_spawn_points, team_b_spawn_points)

	-- Spawn dummies which play sound at the center of each arena
	CreateUnitByNameAsync("npc_dummy", GameMode.pvp_center, false, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
		unit:AddNewModifier(unit, nil, "modifier_invisible_dummy_unit", {})
		self.arena_center_sound_dummy = unit
	end)

	-- Set up listeners
	ListenToGameEvent("dota_player_killed", Dynamic_Wrap(PvpManager, "OnHeroKilled"), self)

	RegisterCustomEventListener("RequestDuelInfoReconnect", function(keys) PvpManager:RebuildDuelUI(keys) end)

	EventDriver:Listen("Round:round_preparation_started", PvpManager.OnRoundPreparationStarted, PvpManager)
	EventDriver:Listen("Round:round_started", PvpManager.OnRoundStarted, PvpManager)
	EventDriver:Listen("Round:round_duration_expired", PvpManager.OnRoundDurationExpired, PvpManager)
	EventDriver:Listen("Round:round_ended", PvpManager.OnRoundEnd, PvpManager)
end

function PvpManager:ClearDuelStats()
	self.previous_first_team = DOTA_TEAM_NEUTRALS
	self.previous_second_team = DOTA_TEAM_NEUTRALS

	for _, team in pairs(GameMode:GetAllActiveTeams()) do
		self.pvp_weights[team] = 0
		self.previous_duel_for_team[team] = DOTA_TEAM_NEUTRALS

		self.pvp_count[team] = {}
		for _, enemy_team in pairs(GameMode.team_list) do
			self.pvp_count[team][enemy_team] = 0
		end
	end
end

-- Round fires this when created, right before its preparation phase, in order to determine if its a pvp round
function PvpManager:WillThisRoundHavePvp(round_number, is_boss_round, round_name)
	if GAME_OPTION_BENCHMARK_MODE then return false end

	if TestMode:IsTestMode() then 
		return TestMode.__duels_enabled and not is_boss_round
	end

	local live_teams = GameMode:GetAliveTeamCount()
	local current_pvp_interval = self.pvp_interval[GetMapName()][live_teams]

	-- Check pvp conditions: 2+ teams, enough rounds since the last duel, not a boss round, and not a greevil (bonus) round
	if live_teams >= 2 and (round_number - self.last_pvp_round) >= current_pvp_interval and (not is_boss_round) and (round_name ~= "Round_Greevil") then
		self.last_pvp_round = round_number
		return true
	end

	return false
end

-- Fires when a new round enters its preparation phase
function PvpManager:OnRoundPreparationStarted(keys)
	local current_round = RoundManager:GetCurrentRound()
	if (not current_round:IsPvpRound()) then return end

	current_round:ExtendPreparationTime(RoundManager.extra_pvp_round_preparation_time[GetMapName()])

	Summon:KillSummonedCreatureAsync(GameMode.pvp_center)

	-- Check sudden death and clear duel weights before pick next duel teams
	RoundManager:UpdateSuddenDeathState(keys)

	self:MatchTeamsForPvp()

	EventDriver:Dispatch("PvpManager:new_pvp_match_decided", {
		teams = self.current_pvp_teams,
		round_number = current_round:GetRoundNumber(),
	})

	-- Build pre-duel UI
	local pvp_player_data = {}

	for team, _ in pairs(self.current_pvp_players) do
		for _, player_id in pairs(self.current_pvp_players[team]) do
			table.insert(pvp_player_data, {playerID = player_id, teamID = team})
		end

		--Remove Fire Remnants on PvE arena if player goes into duel
		CleanFireRemnants(GameMode.arena_centers[team], 2500)
	end


	Timers:CreateTimer(0.5, function()

		CustomGameEventManager:Send_ServerToAllClients("ShowPvpInfo", {
			players = pvp_player_data,
			length = #pvp_player_data,
			firstTeamId = self.current_pvp_teams[1],
			secondTeamId = self.current_pvp_teams[2],
		})

		for player_id = 0, DOTA_MAX_PLAYERS - 1 do
			local team = PlayerResource:GetTeam(player_id)
			local player = PlayerResource:GetPlayer(player_id)
			if player and team and GameMode:IsTeamAlive(team) and (not self:IsPvpTeamThisRound(team)) then
				CustomGameEventManager:Send_ServerToPlayer(player, "ShowPvpBet", {})
			end
		end
	end)
end

function PvpManager:OnRoundStarted(keys)
	if (not RoundManager:GetCurrentRound():IsPvpRound()) then return end

	self.is_pvp_active = true

	-- Stop accepting bets after small delay to get all bets from clients
	Timers:CreateTimer(1, function()
		BetManager:EvaluateBets()

		-- Build duel UI
		local pvp_players_data = {}
		for _, player_id in pairs(self:GetAllPvpPlayers()) do
			table.insert(pvp_players_data, {PlayerID = player_id, teamID = PlayerResource:GetTeam(player_id)})
		end

		CustomGameEventManager:Send_ServerToAllClients("ShowPvpBrief", {
			betMap = BetManager.bet_map,
			pair = pvp_players_data,
			length = #pvp_players_data,
			firstTeamId = self.current_pvp_teams[1],
			secondTeamId = self.current_pvp_teams[2]
		})

	end)

	-- Apply duel observers' truesight
	self:ApplyDuelObserverTruesight()

	-- Duel countdown particles and sound
	local countdown = 3

	self.arena_center_sound_dummy:EmitSound("CHC.Duel")

	local countdown_pfx = ParticleManager:CreateParticle("particles/custom/duel_overhead_countdown.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(countdown_pfx, 0, GameMode.pvp_center)
	ParticleManager:SetParticleControl(countdown_pfx, 1, Vector(0, countdown, 0))

	Timers:CreateTimer(1, function()
		countdown = countdown - 1
		ParticleManager:SetParticleControl(countdown_pfx, 1, Vector(0, countdown, 0))

		if countdown > 0 then
			return 1
		else
			ParticleManager:DestroyParticle(countdown_pfx, false)
			ParticleManager:ReleaseParticleIndex(countdown_pfx)

			self.arena_center_sound_dummy:StopSound("CHC.Duel")
			self.arena_center_sound_dummy:EmitSound("CHC.Overwhelming.Location")

			EventDriver:Dispatch("PvpManager:pvp_countdown_ended", {
				teams = self.current_pvp_teams,
			})
		end
	end)
end

-- Fires if the round duration was exceeded.
-- If a duel is still ongoing, forces it to end with a winner, determined by tie breaking criteria.
function PvpManager:OnRoundDurationExpired(keys)
	if (not self.is_pvp_active) then return end

	local tiebreak_winner = self.current_pvp_teams[self:GetTiebreakWinner()]

	if tiebreak_winner == self.current_pvp_teams[1] then
		self:EndPvp(self.current_pvp_teams[1], self.current_pvp_teams[2])
	else
		self:EndPvp(self.current_pvp_teams[2], self.current_pvp_teams[1])
	end
end

-- Fires when a round fully ends
function PvpManager:OnRoundEnd(keys)
	self.current_pvp_teams = {}
	self.current_pvp_players = {}
	self.pvp_weights = {}
end

-- Returns 1 or 2 the team which would win the duel, according to tie breaking criteria, if it ended immediately.
function PvpManager:GetTiebreakWinner()
	local live_count = {
		[1] = self:GetTeamAliveCount(self.current_pvp_teams[1]),
		[2] = self:GetTeamAliveCount(self.current_pvp_teams[2])
	}

	local health_pct = {
		[1] = self:GetTeamHealthPercent(self.current_pvp_teams[1]),
		[2] = self:GetTeamHealthPercent(self.current_pvp_teams[2])
	}

	local total_health = {
		[1] = self:GetTeamTotalHealth(self.current_pvp_teams[1]),
		[2] = self:GetTeamTotalHealth(self.current_pvp_teams[2])
	}

	-- If a team is defeated at this point for some reason (e.g. abandons), make it lose regardless of other conditions
	if GameMode:IsTeamDefeated(self.current_pvp_teams[2]) then
		return self.current_pvp_teams[1]
	elseif GameMode:IsTeamDefeated(self.current_pvp_teams[1]) then
		return self.current_pvp_teams[2]
	end

	-- First tiebreaker criteria is the number of heroes alive in each team
	if live_count[1] > live_count[2] then
		return 1
	elseif live_count[2] > live_count[1] then
		return 2
	end

	-- Second tiebreaker criteria is the remaining health percentage on each team
	if health_pct[1] > health_pct[2] then
		return 1
	elseif health_pct[2] > health_pct[1] then
		return 2
	end

	-- Third tiebreaker criteria is the raw amount of health remaining in each team
	if total_health[1] > total_health[2] then
		return 1
	elseif total_health[2] > total_health[1] then
		return 2
	end

	-- If a tie still persists, we say fuck it
	return self.current_pvp_teams[RandomInt(1, 2)]
end

-- Returns the amount of heroes currently alive in a team.
function PvpManager:GetTeamAliveCount(team)
	local live_heroes = 0

	for _, player_id in pairs(GameMode.team_player_id_map[team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero and hero:IsAlive() then
			live_heroes = live_heroes + 1
		end
	end

	return live_heroes
end

-- Returns the sum of a team's heroes' health percentages. Only useful to compare teams with the same amount of heroes.
function PvpManager:GetTeamHealthPercent(team)
	local health_percent = 0

	for _, player_id in pairs(GameMode.team_player_id_map[team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero then
			health_percent = health_percent + hero:GetHealthPercent()
		end
	end

	return health_percent
end

-- Returns the sum of a team's heroes' current health.
function PvpManager:GetTeamTotalHealth(team)
	local total_health = 0

	for _, player_id in pairs(GameMode.team_player_id_map[team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero then
			total_health = total_health + hero:GetHealth()
		end
	end

	return total_health
end

-- Returns the next pvp match's participating teams
function PvpManager:GetPvpTeams()
	return self.current_pvp_teams
end

-- Returns the next pvp match's players in a single table
function PvpManager:GetAllPvpPlayers()
	local pvp_players = {}

	for team, _ in pairs(self.current_pvp_players) do
		for _, player_id in pairs(self.current_pvp_players[team]) do
			table.insert(pvp_players, player_id)
		end
	end

	return pvp_players
end

-- Returns the next pvp match's players, in two separate tables, one for each team
function PvpManager:GetPvpPlayersByTeam()
	return self.current_pvp_players
end

-- Returns true if this team is participating in the current round's duel
function PvpManager:IsPvpTeamThisRound(team)
	if self.current_pvp_players[team] then
		return true
	end

	return false
end

-- Apply truesight modifiers on duelists so that non-duelists can see them through invisibility
function PvpManager:ApplyDuelObserverTruesight()
	local active_players = GameMode:GetAllActiveTeams()
	local pvp_players = self:GetAllPvpPlayers()

	self.duel_truesight_timer = Timers:CreateTimer(0, function()
		for _, obs_team in pairs(active_players) do
			if (not GameMode:IsTeamDueling(obs_team)) then
				for _, obs_player_id in pairs(GameMode.team_player_id_map[obs_team]) do
					for _, pvp_player_id in pairs(pvp_players) do
						local obs_hero = PlayerResource:GetSelectedHeroEntity(obs_player_id)
						local pvp_hero = PlayerResource:GetSelectedHeroEntity(pvp_player_id)
						if obs_hero and pvp_hero then pvp_hero:AddNewModifier(obs_hero, nil, "modifier_truesight", {duration = 2}) end
					end
				end
			end
		end

		return 1.5
	end)
end

-- Remove the observer truesight granted by the function above
function PvpManager:RemoveDuelObserverTruesight()
	if self.duel_truesight_timer then Timers:RemoveTimer(self.duel_truesight_timer) end
end

function PvpManager:IncrementTeamDuelCount(team, enemy_team)
	if self.pvp_count[team] then
		if self.pvp_count[team][enemy_team] then
			self.pvp_count[team][enemy_team] = self.pvp_count[team][enemy_team] + 1
		else
			self.pvp_count[team][enemy_team] = 1
		end
	else
		self.pvp_count[team] = {}
		self.pvp_count[team][enemy_team] = 1
	end

	self.previous_duel_for_team[team] = enemy_team
end

function PvpManager:GetTeamDuelCount(team)
	local duel_count = 0
	for enemy_team, duels in pairs(self.pvp_count[team]) do
		duel_count = duel_count + duels
	end

	return duel_count
end

function PvpManager:GetWeightedRandomParticipant(teams)
	local weight_sum = 0
	for _, team in pairs(teams) do
		weight_sum = weight_sum + self.pvp_weights[team]
	end
	local selection = RandomInt(1, weight_sum)
	for _, team in pairs(teams) do
		selection = selection - self.pvp_weights[team]
		if selection <= 0 then
			self.pvp_weights[team] = 0
			return team
		end
	end
end

function PvpManager:MatchTeamsForPvp()

	-- Clean up vars from last round
	self.current_pvp_teams = {}
	self.current_pvp_players = {}
	self.pvp_weights = {}

	-- Fetch valid teams
	local valid_teams = GameMode:GetAllAliveTeams()
	local valid_team_count = GameMode:GetAliveTeamCount()

	for _, team in pairs(valid_teams) do
		print("Added team "..team.." to this round's pvp pairing process")
	end

	-- Fetch duel counts for each team
	local duel_counts = {}
	local highest_duel_count = 0
	for _, team in pairs(valid_teams) do
		duel_counts[team] = self:GetTeamDuelCount(team)
		if duel_counts[team] > highest_duel_count then
			highest_duel_count = duel_counts[team]
		end
	end

	-- Calculate weights based on amount of past duels
	for _, team in pairs(valid_teams) do
		self.pvp_weights[team] = 1 + math.floor(100 * (highest_duel_count - duel_counts[team]) ^ 1.7 + 9 * math.random())
	end

	-- Remove teams from the last duel round, if possible
	if valid_team_count > 4 then
		if self.pvp_weights[self.previous_first_team] then self.pvp_weights[self.previous_first_team] = 0 end
		if self.pvp_weights[self.previous_second_team] then self.pvp_weights[self.previous_second_team] = 0 end
	end

	-- Weighted-random select the first team
	local first_team = self:GetWeightedRandomParticipant(valid_teams)

	-- Fetch duel counts against the first team for each team
	local this_team_duel_counts = {}
	local this_team_highest_duel_count = 0
	for _, team in pairs(valid_teams) do
		this_team_duel_counts[team] = self.pvp_count[first_team][team]
		if this_team_duel_counts[team] > this_team_highest_duel_count then
			this_team_highest_duel_count = this_team_duel_counts[team]
		end
	end

	-- Modify weights based on duel count with the first team
	for _, team in pairs(valid_teams) do
		if team ~= first_team then
			self.pvp_weights[team] = self.pvp_weights[team] * (1 + 4 * (this_team_highest_duel_count - this_team_duel_counts[team]) ^ 1.7)
		end
	end

	-- If there are still enough valid matchups, prevent the first team from facing its most recent duel opponent again
	local possible_matchups = 0
	for team, weight in pairs(self.pvp_weights) do
		if weight > 0 then
			possible_matchups = possible_matchups + 1
		end
	end

	if possible_matchups > 2 then
		if self.pvp_weights[self.previous_duel_for_team[first_team]] then self.pvp_weights[self.previous_duel_for_team[first_team]] = 0 end
	end

	-- Weighted-random select the second team
	local second_team = self:GetWeightedRandomParticipant(valid_teams)

	-- Update pvp history for both teams
	self:IncrementTeamDuelCount(first_team, second_team)
	self:IncrementTeamDuelCount(second_team, first_team)

	local match_teams = {}
	table.insert(match_teams, first_team)
	table.insert(match_teams, second_team)
	table.insert(self.pvp_history, match_teams)

	self.previous_first_team = first_team
	self.previous_second_team = second_team

	-- Properly build a table of current pvp participants
	table.insert(self.current_pvp_teams, first_team)
	table.insert(self.current_pvp_teams, second_team)

	self.current_pvp_players[first_team] = {}
	self.current_pvp_players[second_team] = {}

	for team, _ in pairs(self.current_pvp_players) do
		for _, player_id in pairs(GameMode.team_player_id_map[team]) do
			table.insert(self.current_pvp_players[team], player_id)
		end
	end
end

-- Returns true if at least one player in this team is alive *or* reincarnating.
function PvpManager:TeamHasAliveDuelist(team)
	for _, player_id in ipairs(GameMode.team_player_id_map[team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero and (hero:IsAlive() or hero:IsReincarnating()) then
			return true
		end
	end

	return false
end

function PvpManager:OnHeroKilled(keys)
	local player_id = keys.PlayerID

	if (not player_id) then return end

	local loser_team = PlayerResource:GetTeam(player_id)

	-- If this team's players are all dead, end the duel
	if loser_team and self:IsPvpTeamThisRound(loser_team) then
		if (not self:TeamHasAliveDuelist(loser_team)) then
			local loser_team_index = table.findkey(self.current_pvp_teams, loser_team)
			local winner_team = self.current_pvp_teams[loser_team_index == 1 and 2 or 1]

			for _, win_player_id in pairs(GameMode.team_player_id_map[winner_team]) do
				local hero = PlayerResource:GetSelectedHeroEntity(win_player_id)

				if IsValidEntity(hero) and hero:IsAlive() then
					hero:AddNewModifier(hero, nil, "modifier_invuln", {duration = 1})
					hero:Heal(hero:GetMaxHealth(), nil)
					hero:GiveMana(hero:GetMaxMana())
					hero:Purge(false, true, false, true, true)
					hero:InterruptMotionControllers(true)
					ProjectileManager:ProjectileDodge(hero)
				end
			end

			Timers:CreateTimer(0.1, function()
				PvpManager:EndPvp(winner_team, loser_team)
			end)
		end
	end
end

function PvpManager:EndPvp(winner_team, loser_team)
	if (not self.is_pvp_active) then return end

	-- Clean up
	self.is_pvp_active = false
	self:RemoveDuelObserverTruesight()

	RoundManager:MoveTeamToFountain(winner_team, true, true)
	RoundManager:MoveTeamToFountain(loser_team, true, true)

	Summon:KillSummonedCreatureAsync(GameMode.pvp_center)
	CleanSparkWraith(GameMode.pvp_center, 2500)
	CleanTreantEyes(GameMode.pvp_center, 2500)
	CleanFireRemnants(GameMode.pvp_center, 2500)

	-- Announce the winning team on the UI
	CustomGameEventManager:Send_ServerToAllClients("PlayerWin", {
		winnersPlayers = GameMode.team_player_id_map[winner_team],
		winnersLength = #GameMode.team_player_id_map[winner_team],
		losersPlayers = GameMode.team_player_id_map[loser_team],
		losersLength = #GameMode.team_player_id_map[loser_team],
		nWinnerId = winner_team,
		nLoserId = loser_team
	})

	-- Winning team effects
	local max_new_level = RoundManager:GetCurrentRoundNumber()

	self:PlayGroupVictoryEffects(winner_team)

	for _, player_id in pairs(GameMode.team_player_id_map[winner_team]) do
		local winner_record = CustomNetTables:GetTableValue("pvp_record", tostring(player_id)) or {}
		winner_record.win = (winner_record.win and winner_record.win + 1) or 1
		CustomNetTables:SetTableValue("pvp_record", tostring(player_id), winner_record)

		local hero = PlayerResource:GetSelectedHeroEntity(player_id)

		if IsValidEntity(hero) then
			hero:HeroLevelUpWithMinValue(max_new_level, true)

			-- If player win 3 duels in a row remove 1 loser curse stack
			hero.duel_win_streak = (hero.duel_win_streak or 0) + 1
			if hero.duel_win_streak >= 3 then
				local curse_modifier = hero:FindModifierByName("modifier_loser_curse")
				if curse_modifier then
					hero.duel_win_streak = 0
					hero:DecrementCurseCount()
				end
			end
		end
	end

	-- Losing team effects
	for _, player_id in ipairs(GameMode.team_player_id_map[loser_team]) do
		local loser_record = CustomNetTables:GetTableValue("pvp_record", tostring(player_id)) or {}
		loser_record.lose = (loser_record.lose and loser_record.lose + 1) or 1
		CustomNetTables:SetTableValue("pvp_record", tostring(player_id), loser_record)

		PlayerResource:ClearStreak(player_id)

		local hero = PlayerResource:GetSelectedHeroEntity(player_id)

		if IsValidEntity(hero) then
			hero:HeroLevelUpWithMinValue(max_new_level, true)
			hero.duel_win_streak = 0
		end
	end

	Timers:CreateTimer(1, function()
		if RoundManager:IsSuddenDeathActive() then
			PvpManager:PunishSuddenDeathLoser(winner_team, loser_team)
		end
	end)

	-- Tell the other modules that the match has ended
	EventDriver:Dispatch("PvpManager:pvp_ended", {
		winner_team = winner_team,
		loser_team = loser_team,
	})

	ProgressTracker:EventTriggered("CUSTOM_EVENT_DUEL_WON", {team = winner_team})
end

function PvpManager:PunishSuddenDeathLoser(winner_team, loser_team)
	local winner_heroes = {}

	for _, player_id in pairs(GameMode.team_player_id_map[winner_team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero and (not hero:IsNull()) then table.insert(winner_heroes, hero) end
	end

	for _, player_id in pairs(GameMode.team_player_id_map[loser_team]) do
		local loser = PlayerResource:GetSelectedHeroEntity(player_id)
		if loser and (not loser:IsNull()) then

			-- Curse particle
			local current_winner = table.remove(winner_heroes)
			local scythe_origin = current_winner and current_winner:GetAbsOrigin() or loser:GetAbsOrigin()

			local curse_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_necrolyte/necrolyte_scythe_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, loser)
			ParticleManager:SetParticleControl(curse_pfx, 0, scythe_origin)
			ParticleManager:SetParticleControl(curse_pfx, 1, loser:GetAbsOrigin())
			ParticleManager:ReleaseParticleIndex(curse_pfx)

			-- Aegis removal/pvp curse
			local aegis_modifier = loser:FindModifierByName("modifier_aegis")

			if loser:HasModifier("modifier_innate_second_chance") then
				loser:FindAbilityByName("innate_revenge"):SetActivated(false)
				loser:RemoveModifierByName("modifier_innate_second_chance")
			elseif aegis_modifier then
				local data = {}
				data.type = "pvp_lose_aegis"
				data.playerId = player_id

				Barrage:FireBullet(data)

				local aegis_count = aegis_modifier:GetStackCount()
				if aegis_count >= 2 then
					aegis_modifier:SetStackCount(aegis_count - 1)
				else
					aegis_modifier:SetStackCount(aegis_count - 1)
					aegis_modifier:Destroy()
				end

				CustomGameEventManager:Send_ServerToAllClients("player_lose_aegis", {playerId = player_id, aegisCount = aegis_count - 1})
			else
				local data = {}
				data.type = "pvp_stack_curse"
				data.playerId = player_id

				Barrage:FireBullet(data)

				loser:IncrementCurseCount()			
			end
		end
	end
end

function PvpManager:PlayVictoryEffects(hero)
	if (not hero) or hero:IsNull() then return end
	
	local winner_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_duel_victory.vpcf", PATTACH_OVERHEAD_FOLLOW, hero)
	ParticleManager:ReleaseParticleIndex(winner_pfx)
	EmitSoundOn("CHC.Duel.Victory", hero)
end

function PvpManager:PlayGroupVictoryEffects(team)
	local taunt_delay = 2

	for _, player_id in pairs(GameMode.team_player_id_map[team]) do

		local hero = PlayerResource:GetSelectedHeroEntity(player_id)

		PvpManager:PlayVictoryEffects(hero)

		Timers:CreateTimer(taunt_delay, function()
			if hero and (not hero:IsNull()) then
				local hero_sound_taunt = PvpManager.winner_sound_map[hero:GetUnitName()]
				if hero_sound_taunt then EmitGlobalSound(hero_sound_taunt) end
			end
		end)

		taunt_delay = taunt_delay + 3
	end
end

-- Rebuilds the duel UI for a reonnecting player
function PvpManager:RebuildDuelUI(keys)
	local player_id = keys.PlayerID
	if not player_id then return end

	local player = PlayerResource:GetPlayer(player_id)

	if player and RoundManager:GetCurrentRound() and RoundManager:GetCurrentRound():IsPvpRound() then

		local pvp_player_data = {}

		for team, _ in pairs(self.current_pvp_players) do
			for _, player_id in pairs(self.current_pvp_players[team]) do
				table.insert(pvp_player_data, {playerID = player_id, teamID = team})
			end
		end

		local team = PlayerResource:GetTeam(player_id)
		local can_player_bet = GameMode:IsTeamAlive(team) and (not self:IsPvpTeamThisRound(team))

		local duel_info = {
			length = #pvp_player_data,
			firstTeamId = self.current_pvp_teams[1],
			secondTeamId = self.current_pvp_teams[2],
			players = pvp_player_data,
		}

		CustomGameEventManager:Send_ServerToPlayer(player, "ShowPvpInfo", duel_info)

		if self.is_pvp_active then
			duel_info.pair = pvp_player_data
			duel_info.betMap = BetManager.bet_map
			CustomGameEventManager:Send_ServerToPlayer(player, "ShowPvpBrief", duel_info)
		elseif can_player_bet then
			CustomGameEventManager:Send_ServerToPlayer(player, "ShowPvpBet", {})
		end
	end
end

-- Forces an ongoing duel to end. Makes team 1 the winner.
function PvpManager:ForceStopDuel()
	if self.current_pvp_teams[1] and self.current_pvp_teams[2] then
		self:EndPvp(self.current_pvp_teams[1], self.current_pvp_teams[2])
	end
end

-- Returns true if a duel is currently happening
function PvpManager:IsPvpActive()
	return self.is_pvp_active
end

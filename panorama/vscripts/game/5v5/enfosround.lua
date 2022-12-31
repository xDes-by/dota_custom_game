if EnfosRound == nil then EnfosRound = class(Round) end

ENFOS_TIME_BETWEEN_ROUNDS = 15

Enfos.base_max_abilities_limit = 2

max_abilities_limit = {}
max_abilities_limit[3] = true
max_abilities_limit[6] = true
max_abilities_limit[9] = true

function EnfosRound:InitializeRounds()
	print("[ENFOS] RANDOMIZING ROUND ORDER...")

	Enfos.round_data = {}
	Enfos.round_list = {}

	local current_round_creep_data = table.shuffle(Enfos.round_creeps)
	for round = 1, ENFOS_MAX_ROUND do
		if #current_round_creep_data <= 0 then current_round_creep_data = table.shuffle(Enfos.round_creeps) end
		Enfos.round_data[round] = table.remove(current_round_creep_data)
		Enfos.round_list[round] = Enfos.round_data[round].name
	end

	GameMode:SetModeState(GAME_STATE_ENFOS_PVE)

	print("[ENFOS] ...DONE")
end

function EnfosRound:Prepare(round_number)

	if round_number > ENFOS_MAX_ROUND then
		RoundManager:ForceEndGameWithError("max_round_reached")
		return nil
	end

	-- Initialize round
	self.round_number = round_number
	self.round_data = Enfos.round_data[round_number]
	self.round_name = self.round_data.name
	self.spawn_count = Enfos.round_stats.spawn_count[round_number]
	self.is_boss_round = (round_number % 10 == 0)
	self.time_to_round_start = ENFOS_TIME_BETWEEN_ROUNDS
	self.has_started = false

	GridNav:RegrowAllTrees()

	-- Grant players +1 ability on the appropriate rounds
	if max_abilities_limit[round_number] then
		Enfos.base_max_abilities_limit = Enfos.base_max_abilities_limit + 1

		for _, player_id in pairs(GameMode.all_players) do
			if GameMode:HasPlayerSelectedHero(player_id) and (not PlayerResource:IsFakeClient(player_id)) then
				HeroBuilder:ShowRandomAbilitySelection(player_id)
			end
		end
	end
	
	-- Show round information panel
	self:ShowRoundInfoPanel()

	-- Adjust round panel UI
	CustomGameEventManager:Send_ServerToAllClients("updateReadyButton", {visible = false, triggerRound = true})

	-- Boss audio stinger
	if self.is_boss_round then
		if self.round_name == "Round_FortuneGenie" then
			EmitGlobalSound("fortune.round")
		else
			EmitGlobalSound("boss.round")
		end
	end

	EventDriver:Dispatch("Round:round_preparation_started", {
		round_number = self.round_number,
		round_name = self.round_name,
		is_boss_round = self.is_boss_round,
	})

	-- Waiting for the round to start
	Timers:CreateTimer(1, function()
		if (not Enfos:IsGroupPvpActive()) then
			self.time_to_round_start = self.time_to_round_start - 1
		end

		-- Time to start the round!
		if self.time_to_round_start <= 0 then
			self:Start()
			return nil
		end

		-- Not yet, wait one second and try again
		return 1
	end)
end

function EnfosRound:ShowRoundInfoPanel()

	-- Build information for the round panel UI
	local round_units = {}
	table.insert(round_units, self.round_data.basic_creep)
	table.insert(round_units, self.round_data.elite_creep)
	
	self.dummy_units = {}
	local dummy_entindexes = {}
	for _, unit_name in pairs(round_units) do
		local dummy_unit = CreateUnitByName(unit_name, Vector(0,0,0), true, nil, nil, DOTA_TEAM_NEUTRALS)
		table.insert(self.dummy_units, dummy_unit)
		table.insert(dummy_entindexes, dummy_unit:GetEntityIndex())

		dummy_unit:AddNewModifier(dummy_unit, nil, "modifier_invulnerable", {})
		dummy_unit:AddNewModifier(dummy_unit, nil, "modifier_out_from_vision", {})

		dummy_unit:RemoveAbility("creature_ancient")

		for index = 0, 9 do
			local ability = dummy_unit:GetAbilityByIndex(index)
			if ability then ability:SetLevel(1) end
		end
	end

	CustomGameEventManager:Send_ServerToAllClients("ShowRoundPanel", {
		round_start_time = GameRules:GetGameTime() + self.time_to_round_start,
		maxround_time = self.time_to_round_start,
		round = self.round_number,
		round_name = self.round_name,
		creeps = dummy_entindexes,
		totems = {}
	})
end

function EnfosRound:Start()

	-- Adjust round panel UI
	self.round_started_panel_data = {
		round_start_time = GameRules:GetGameTime(),
		maxround_time = ENFOS_ROUND_DURATION,
		text ="#time_to_next_round",
	}

	CustomGameEventManager:Send_ServerToAllClients("ShowRoundTimeLimit", self.round_started_panel_data)

	-- Destroy round panel dummy units
	for _, unit in pairs(self.dummy_units) do unit:RemoveModifierByName("modifier_out_from_vision") end

	-- Update illusion passive abilities
	HeroBuilder:IndexAllHeroesPassives()

	-- Start spawning creeps
	self.spawners = {}
	self.spawner_finished = {}

	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		local team_state = GameMode:GetTeamState(team)
		self.spawner_finished[team] = team_state == TEAM_STATE_DEFEATED

		if team_state ~= TEAM_STATE_DEFEATED then
			self.spawners[team] = EnfosSpawner()
			self.spawners[team]:Init(self, team)
		end
	end

	self.has_started = true

	EventDriver:Dispatch("Round:round_started", {
		round_number = self.round_number,
		round_name = self.round_name,
	})
end

function EnfosRound:SpawnerFinished(team)
	self.spawner_finished[team] = true

	if self.spawner_finished[DOTA_TEAM_GOODGUYS] and self.spawner_finished[DOTA_TEAM_BADGUYS] then
		self:End()
	end
end

function EnfosRound:End()
	ProgressTracker:SendServerUpdate()

	EventDriver:Dispatch("Round:round_ended", {
		round_number = self.round_number,
		round_name = self.round_name,
		is_boss = self.is_boss_round,
	})

	if self.round_number >= ENFOS_MAX_ROUND then
		Enfos:EndGameWithWinner(DOTA_TEAM_GOODGUYS)
	else
		Enfos.current_round = EnfosRound()
		Enfos.current_round:Prepare(self.round_number + 1)
	end
end

function EnfosRound:IsTeamFightingCreeps(team)
	return (not Enfos:IsGroupPvpActive())
end

function EnfosRound:IsPvpRound()
	return false
end

Benchmark = Benchmark or class({})

function Benchmark:Init()
	info = {}

	EventDriver:Listen("GameMode:state_changed", Benchmark.InitializeBenchmarkMode, Benchmark)
end

function Benchmark:InitializeBenchmarkMode(keys)

	if keys.state ~= DOTA_GAMERULES_STATE_GAME_IN_PROGRESS or Enfos:IsEnfosMode() or (not GAME_OPTION_BENCHMARK_MODE) then return end 

	RoundManager.round_preparation_time[GetMapName()] = 3
	ROUND_MANAGER_CREEP_SPAWN_TIME = 0

	Benchmark.benchmark_info = {}

	Benchmark.benchmark_info.match_actual_start_time = GetSystemTimeMS()
	Benchmark.benchmark_info.match_game_start_time = GameRules:GetGameTime()

	EventDriver:Listen("Round:round_ended", Benchmark.EndBenchmarkTrackingForRound, Benchmark)
	EventDriver:Listen("Round:round_started", Benchmark.StartBenchmarkTrackingForRound, Benchmark)

	local bot_abilities = {
		"dragon_knight_elder_dragon_form_lua",
		"drow_ranger_marksmanship_lua",
		"medusa_split_shot",
		"faceless_void_time_lock_lua",
		"life_stealer_feast",
		"luna_moon_glaive",
		"ursa_fury_swipes",
		"winter_wyvern_arctic_burn",
		"abaddon_frostmourne",
		"slardar_bash",
	}

	local bot_items = {
		"item_ranged_cleave_2",
		"item_mjollnir",
		"item_monkey_king_bar",
		"item_greater_crit",
		"item_diffusal_blade",
		"item_ultimate_scepter",
		"item_desolator_2"
	}

	local all_heroes = HeroList:GetAllHeroes()
	for _, hero in pairs(all_heroes) do

		for i = 0, (DOTA_MAX_ABILITIES - 1) do
		local old_ability = hero:GetAbilityByIndex(i)
			if old_ability then
				hero:RemoveAbility(old_ability:GetAbilityName())
			end
		end

		for i = 0, DOTA_ITEM_NEUTRAL_SLOT do
		local old_item = hero:GetItemInSlot(i)
			if old_item then
				hero:RemoveItem(old_item)
			end
		end

		for _, item_name in pairs(bot_items) do
			hero:AddItemByName(item_name)
		end

		for _, ability_name in pairs(bot_abilities) do
			local ability = hero:AddAbility(ability_name)
			ability:SetLevel(ability:GetMaxLevel())

			if ability_name == "dragon_knight_elder_dragon_form_lua" then
				ExecuteOrderFromTable({
					UnitIndex = hero:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = ability:entindex(),
				})
			end

			if ability_name == "winter_wyvern_arctic_burn" or ability_name == "medusa_split_shot" then
				ability:ToggleAbility()
			end
		end

		hero:AddNewModifier(hero, nil, "modifier_benchmark_power", {})
		hero:SetAbilityPoints(0)
	end

	for i = 1, 150 do
		if GAME_OPTION_LATE_BENCHMARK_MODE then
			GameRules.health_table[i] = 100000
			GameRules.damage_table[i] = 100000
			GameRules.bat_table[i] = 0.5
		elseif GAME_OPTION_EARLY_BENCHMARK_MODE then
			GameRules.health_table[i] = 250
			GameRules.damage_table[i] = 130
			GameRules.bat_table[i] = 0.5
		end
	end

	self.round_count = 0
	for _, tier_rounds in pairs(RoundManager.regular_round_data) do
		for round_name, _ in pairs(tier_rounds) do
			self.round_count = self.round_count + 1
			RoundManager.round_list[self.round_count] = round_name
		end
	end

	for _, tier_rounds in pairs(RoundManager.boss_round_data) do
		for round_name, _ in pairs(tier_rounds) do
			self.round_count = self.round_count + 1
			RoundManager.round_list[self.round_count] = round_name
		end
	end
end

function Benchmark:StartBenchmarkTrackingForRound(keys)
	Benchmark.benchmark_info[keys.round_number] = {}

	Benchmark.benchmark_info[keys.round_number].round_name = RoundManager.round_list[keys.round_number]

	Benchmark.benchmark_info[keys.round_number].actual_start_time = GetSystemTimeMS()
	Benchmark.benchmark_info[keys.round_number].game_start_time = GameRules:GetGameTime()
end

function Benchmark:EndBenchmarkTrackingForRound(keys)
	local round_number = keys.round_number
	local round_name = keys.round_name

	local round_info = Benchmark.benchmark_info[round_number]
	round_info.actual_end_time = GetSystemTimeMS()
	round_info.game_end_time = GameRules:GetGameTime()

	round_info.actual_round_duration = round_info.actual_end_time - round_info.actual_start_time
	round_info.game_round_duration = 1000 * (round_info.game_end_time - round_info.game_start_time)

	round_info.average_dilation = 100 * (round_info.actual_round_duration - round_info.game_round_duration) / round_info.game_round_duration


	print("----- ROUND SUMMARY -----")
	print("Round name: "..round_name)
	print("In-game duration: "..round_info.game_round_duration)
	print("Actual duration: "..round_info.actual_round_duration)
	print("Average time dilation: "..round_info.average_dilation.."%")

	if round_number >= self.round_count then
		Benchmark:EndBenchmarkMode()
	end
end

function Benchmark:EndBenchmarkMode()
	local info = Benchmark.benchmark_info
	info.match_actual_end_time = GetSystemTimeMS()
	info.match_game_end_time = GameRules:GetGameTime()

	info.actual_full_round_duration = 0
	info.game_full_round_duration = 0

	for i = 1, self.round_count do
		info.actual_full_round_duration = info.actual_full_round_duration + info[i].actual_round_duration
		info.game_full_round_duration = info.game_full_round_duration + info[i].game_round_duration
	end

	info.actual_fountain_duration = info.match_actual_end_time - info.match_actual_start_time - info.actual_full_round_duration
	info.game_fountain_duration = 1000 * (info.match_game_end_time - info.match_game_start_time) - info.game_full_round_duration

	info.average_round_dilation = 100 * (info.actual_full_round_duration - info.game_full_round_duration) / info.game_full_round_duration
	info.average_fountain_dilation = 100 * (info.actual_fountain_duration - info.game_fountain_duration) / info.game_fountain_duration

	print("----- MATCH SUMMARY -----")

	if GAME_OPTION_LATE_BENCHMARK_MODE then
		print("Late game benchmark")
	elseif GAME_OPTION_EARLY_BENCHMARK_MODE then
		print("Early game benchmark")
	end

	print("In-game match duration: "..(info.game_full_round_duration + info.game_fountain_duration))
	print("Actual match duration: "..(info.actual_full_round_duration + info.actual_fountain_duration))
	print("Average time dilation on fountain: "..info.average_fountain_dilation.."%")
	print("Average time dilation during rounds: "..info.average_round_dilation.."%")

	print("Individual round time dilations:")
	for i = 1, self.round_count do
		print("["..i.."] : "..Benchmark.benchmark_info[i].round_name.." - "..Benchmark.benchmark_info[i].average_dilation.."%")
	end

	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
end

Benchmark:Init()

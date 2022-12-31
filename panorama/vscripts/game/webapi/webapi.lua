WebApi = WebApi or {}
WebApi.player_settings = WebApi.player_settings or {}
WebApi.data_for_end_game = WebApi.data_for_end_game or {}
WebApi.player_records = WebApi.player_records or {}
WebApi.leaderboards = WebApi.leaderboards or nil
WebApi.custom_game = "CustomHeroClash"

for player_id = 0, 23 do
	WebApi.player_settings[player_id] = WebApi.player_settings[player_id] or {}
	WebApi.data_for_end_game[player_id] = {}
	WebApi.player_records[player_id] = {}
end

WebApi.match_id = IsInToolsMode() and RandomInt(-10000000, -1) or tonumber(tostring(GameRules:Script_GetMatchID()))

local server_host = IsInToolsMode() and "https://api.chc-test.dota2unofficial.com" or "https://api.chc.dota2unofficial.com"
local dedicated_server_key = GetDedicatedServerKeyV2("1")

function WebApi:Send(path, data, on_success, on_error, retry_while)
	local request = CreateHTTPRequestScriptVM("POST", server_host .. "/api/lua/" .. path)

	request:SetHTTPRequestHeaderValue("Dedicated-Server-Key", dedicated_server_key)
	if data then
		data.mapName = GetMapName_Engine()
		request:SetHTTPRequestRawPostBody("application/json", json.encode(data))
	end

	request:Send(function(response)
		local status_code = response.StatusCode
		if status_code >= 200 and status_code < 300 then
			local data = json.decode(response.Body)

			if IsInToolsMode() then
				print("[WebApi] request " .. path .. " - <" .. status_code ..">:")
				if data then DeepPrintTable(data) end
			end

			if on_success then
				on_success(data)
			end
		else
			local err = json.decode(response.Body)
			if type(err) ~= "table" then err = {} end

			if IsInToolsMode() then
				print("[WebApi] error from " .. path .. " - <" .. status_code ..">:")
				if status_code == 0 then
					print("[WebApi] couldn't reach backend server or connection refused.")
				elseif response.Body then
					local status, result = pcall(json.decode, response.Body)
					if status then
						DeepPrintTable(result)
					else
						print(response.Body)
					end
				end
			end

			err.status_code = status_code

			if retry_while and retry_while(err) then
				WebApi:Send(path, data, on_success, on_error, retry_while)
			elseif on_error then
				ErrorTracking.Try(on_error, err)
			end
		end
	end)
end

local function RetryTimes(times)
	return function()
		times = times - 1
		return times >= 0
	end
end

function WebApi:BeforeMatch()
	local players = {}

	for player_id = 0, 23 do
		if PlayerResource:IsValidPlayerID(player_id) then
			table.insert(players, tostring(PlayerResource:GetSteamID(player_id)))
		end
	end
	
	local records_params = {
		"BestPvE_FFA_Round",
		"BestPvE_FFA_Time",
		"BestPvE_Duos_Round",
		"BestPvE_Duos_Time",
		"BestPvE_Squads_Round",
		"BestPvE_Squads_Time",
		"BestPvP_FFA_Round",
		"BestPvP_FFA_Time",
		"BestPvP_Duos_Round",
		"BestPvP_Duos_Time",
		"BestPvP_Squads_Round",
		"BestPvP_Squads_Time",
	}
	
	WebApi:Send("match/before", { 
		mapName = GetMapName_Engine(), 
		players = players,
		match_id = WebApi.match_id
	}, function(data)
		print("BEFORE MATCH")
		--DeepPrintTable(data)
		CustomNetTables:SetTableValue("leaderboards", "season_info", {
			reset = data.reset_date
		})

		WebApi.player_ratings = {}
		WebApi.season_reset_info = {}
		WebApi.patch_notes = data.patchnotes
		local matches_count = {}
		for _, player in ipairs(data.players) do
			local player_id = GetPlayerIdBySteamId(player.steamId)
			if player.settings then
				WebApi.player_settings[player_id] = player.settings
				ErrorTracking.Try(PlayerOptions.PlayerSettingsLoaded, PlayerOptions, player_id, player.settings)
			end
			if player.rating then
				WebApi.player_ratings[player_id] = player.rating
			end
			matches_count[player_id] = player.matchCount
			if player.supporterState then
				Supporters:SetPlayerState(player_id, player.supporterState)
			end
			if player.masteries then
				BP_Masteries:SetMasteriesForPlayer(player_id, player.masteries)
			end
			if player.gift_codes then
				GiftCodes:SetCodesForPlayer(player_id, player.gift_codes)
			end
			if player.reset then
				WebApi.season_reset_info[player_id] = {
					glory = player.reset.glory or 0,
					fortune = player.reset.fortune or 0,
					items = player.reset.items or "",
				}
			end
			if player.mails then
				Mail:SetMails(player_id, player.mails)
			end
			if player.MutedUntil then
				SyncedChat:MutePlayer(player_id, player.MutedUntil, false)
			end
			for _, r_param in pairs(records_params) do
				if player[r_param] then
					WebApi.player_records[player_id][r_param] = player[r_param]
				end
			end
		end

		CustomNetTables:SetTableValue("game", "game_counts", matches_count)
		
		for __player_id, __mmr_data in pairs(WebApi.player_ratings) do
			if __mmr_data.squads then WebApi.player_ratings[__player_id].enfos = __mmr_data.squads end
		end
		CustomNetTables:SetTableValue("leaderboards", "match_rating_info", WebApi.player_ratings)
		
		local mapName = GetMapName()
		WebApi.player_deltas = {}
		for this_player_id, this_player_rating_map in pairs(WebApi.player_ratings) do
			local rating_average = WebApi:GetOtherPlayersAverageRating(this_player_id)

			if this_player_rating_map[mapName] then
				WebApi.player_deltas[this_player_id] = math.min(20, math.max(-20, math.floor(0.02 * (rating_average - this_player_rating_map[mapName]))))
			end
		end

		if data.banned_abilities then
			for _, ability_name in pairs(data.banned_abilities) do
				local hero_name = HeroBuilder.ability_hero_map[ability_name]
				if hero_name then
					local hero_full_name = "npc_dota_hero_" .. HeroBuilder.ability_hero_map[ability_name]

					table.insert(HeroBuilder.hero_disabled_abilities[hero_full_name], ability_name)
					table.remove_item(HeroBuilder.all_abilities, ability_name)
					table.remove_item(HeroBuilder.hero_abilities[hero_full_name], ability_name)
					HeroBuilder.ability_hero_map[ability_name] = nil
				end
			end
			CustomNetTables:SetTableValue("game", "disabled_abilities", HeroBuilder.hero_disabled_abilities)
		end

		Battlepass:OnDataArrival(data)

		GameMode.is_tournament_mode_allowed = data.tournament_mode_allowed or IsInToolsMode()
	end, 
	function(err)
		CustomNetTables:SetTableValue("game", "server_info", { 
			is_dedicated = IsInToolsMode() or IsDedicatedServer(),
			is_cheats_enabled = not IsInToolsMode() and GameRules:IsCheatMode(),
			error = {}
		})
		DeepPrintTable(err)
	end, 
	RetryTimes(2))
end


function WebApi:AfterMatchTeam(team_number)
	if not IsInToolsMode() then
		if GameRules:IsCheatMode() or PartyMode.party_mode_enabled or PartyMode.tournament then return end
		if not (GameMode.is_solo_pve_game or GameMode.is_full_lobby_pvp_game) then return end
	end

	if TestMode:IsTestMode() then return end

	print("TEAM", team_number, " FINISHED AT RANK", GameMode.team_final_rank[team_number])

	local lose_info = GameMode.team_defeat_data[team_number]
	
	local requestBody = {
		mapName = GetMapName(),
		matchId = WebApi.match_id,
		isPvp = (not GameMode.is_solo_pve_game),
		isRealGame = (not IsInToolsMode()),
		team = {
			teamId = team_number,
			round = lose_info.round,
			time = lose_info.time,
			matchPlace = GameMode.team_final_rank[team_number] - 1,  -- backend is 0-indexed
			otherTeamsAvgMMR = WebApi:GetOtherTeamsAverageRating(team_number),
		},
	}

	local players = {}
	for _, player_id in pairs(GameMode.team_player_id_map[team_number]) do
		if not PlayerResource:IsFakeClient(player_id) then
			local abilities = HeroBuilder:GetPlayerAbilities(player_id)
			local round_death_data = HeroBuilder:GetPlayerRoundDeaths(player_id)
			local items = HeroBuilder:GetPlayerItems(player_id)
			local settings = PlayerOptions.scheduled_settings_update[player_id] and WebApi.player_settings[player_id] or nil
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)

			table.insert(players, {
				playerId = player_id,
				steamId = tostring(PlayerResource:GetSteamID(player_id)),
				hero_name = IsValidEntity(hero) and hero:GetUnitName() or "",
				innate = abilities.innate,
				abilities = abilities.default,
				roundDeaths = round_death_data,
				items = items,
				otherPlayersAvgMMR = WebApi:GetOtherPlayersAverageRating(player_id),
				earlyLeaver = (GameMode.team_final_rank[team_number] > teams_layout[GetMapName()].max_fortune_rank),
				mastery = HeroBuilder:GetPlayerMasteries(player_id),
				-- add player settings / quests / achievements to update, to ensure settings state 
				-- in case any edits were made after last save when match ended
				settings = settings,
				quests = BP_Quests:GetPlayerQuests(player_id, true),
				achievements = BP_Achievements:GetPlayerAchievements(player_id, true),
				favourite_masteries = BP_Masteries:GetFavouriteMasteries(player_id, true)
			})

			local innate_stacks = 0 
			if hero then
				local innate = hero:FindAbilityByName(abilities.innate)
				if innate then
					innate_stacks = hero:GetModifierStackCount(innate:GetIntrinsicModifierName(), hero)
				end
			end

			WebApi.data_for_end_game[player_id].team = team_number;
			WebApi.data_for_end_game[player_id].place = GameMode.team_final_rank[PlayerResource:GetTeam(player_id)];
			WebApi.data_for_end_game[player_id].masteries = WearFunc[CHC_ITEM_TYPE_MASTERIES] and WearFunc[CHC_ITEM_TYPE_MASTERIES][player_id] or nil;
			WebApi.data_for_end_game[player_id].innate_stacks = innate_stacks
		end
	end

	CustomNetTables:SetTableValue("end_game_data", "end_game_data", WebApi.data_for_end_game)

	if GameMode:IsTournamentMode() then -- in tournament mode we dont send AfterMatch to backend
		for _, player_id in pairs(GameMode.team_player_id_map[team_number]) do
			local client_data = {
				top = {
					value = GameMode.team_final_rank[PlayerResource:GetTeam(player_id)],
					exp = 0,
				},
				is_solo_pve = GameMode.is_solo_pve_game
			}
			
			if GameMode.is_solo_pve_game then
				client_data["rounds"] = {
					value = lose_info.round,
					exp = BP_PlayerProgress:GetBPExpByRounds(lose_info.round),
				};
			end

			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "end_game:init_end_game_results", client_data)
		end
		return
	end
	
	requestBody.team.players = players

	WebApi:Send(
		(not GameMode.game_winner_team) and "match/after_match_team" or "match/set_match_player_round_data", 
		requestBody, 
		function(resp)
			if not resp then return end
			WebApi:AfterMatchResultCallback(resp, lose_info)
			
		end,
		function(err)
			print("Remote sending error: ", err)
			DeepPrintTable(err)
		end
	)
end


function WebApi:AfterMatchResultCallback(resp, lose_info)
	for steam_id, data in pairs(resp.players) do
		if steam_id == "0" then return end
		local player_id = Battlepass.playerid_map[steam_id]

		local place = GameMode.team_final_rank[PlayerResource:GetTeam(player_id)]
		if GameMode.is_solo_pve_game then place = 1 end

		local client_data = {
			mmr_changes = data.ratingChange,
			bp_level_changes = data.battlepassChange.level,
			bp_exp_changes = {
				old = {
					min = BP_PlayerProgress:GetCurrentExp(player_id),
					max = BP_PlayerProgress:GetRequiredExp(player_id),
				},
				new = {
					min = data.battlepassChange.exp.new,
					max = data.battlepassChange.exp.levelup_requirement,
				},
			},
			top = {
				value = place,
				exp = BP_PlayerProgress:GetBPExpByTop(place, player_id),
			},
			old_daily_limit = data.battlepassChange.exp.daily_exp_current - data.battlepassChange.exp.change,
			new_daily_limit = data.battlepassChange.exp.daily_exp_current,
			daily_limit = data.battlepassChange.exp.daily_exp_limit,

			is_solo_pve = GameMode.is_solo_pve_game
		}
		if GameMode.is_solo_pve_game then
			client_data["rounds"] = {
				value = lose_info.round,
				exp = BP_PlayerProgress:GetBPExpByRounds(lose_info.round),
			};
		end
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "end_game:init_end_game_results", client_data)
		
		if WebApi.data_for_end_game[player_id] then
			WebApi.data_for_end_game[player_id].mmr = data.ratingChange.new
			WebApi.data_for_end_game[player_id].mmrDiff = data.ratingChange.new - data.ratingChange.old
		end
		CustomNetTables:SetTableValue("end_game_data", "end_game_data", WebApi.data_for_end_game)
		
		if not BP_PlayerProgress.players then BP_PlayerProgress.players = {} end
		if not BP_PlayerProgress.players[steam_id] then BP_PlayerProgress.players[steam_id] = {} end
		BP_PlayerProgress.players[steam_id].level = data.battlepassChange.level.new
		BP_PlayerProgress.players[steam_id].current_exp = data.battlepassChange.exp.new
		BP_PlayerProgress.players[steam_id].required_exp = data.battlepassChange.exp.levelup_requirement
		BP_PlayerProgress:AddGlory(player_id, data.battlepassChange.glory.change)
		BP_PlayerProgress:UpdatePlayerInfo(player_id)
	end
	print("Remote sending successful")
	DeepPrintTable(resp)
end


function WebApi:GetOtherTeamsAverageRating(target_team_number)
	local rating_average = 1500
	local rating_total = 0
	local rating_count = 0

	if IsInToolsMode() then return rating_average end
	if not WebApi.player_ratings then return rating_average end

	local mapName = GetMapName()
	for id, rating_map in pairs(WebApi.player_ratings) do
		if PlayerResource:GetTeam(id) ~= target_team_number then
			rating_total = rating_total + (rating_map[mapName] or 1500)
			rating_count = rating_count + 1
		end
	end

	if rating_count > 0 then
		rating_average = rating_total / rating_count
	end

	return rating_average
end


function WebApi:GetOtherPlayersAverageRating(player_id)
	local rating_average = 1500
	local rating_total = 0
	local rating_count = 0

	if IsInToolsMode() then return rating_average end

	local mapName = GetMapName()
	for id, rating_map in pairs(WebApi.player_ratings or {}) do
		if id ~= player_id then
			rating_total = rating_total + (rating_map[mapName] or 1500)
			rating_count = rating_count + 1
		end
	end

	if rating_count > 0 then
		rating_average = rating_total / rating_count
	end

	return rating_average
end


function WebApi:ProcessMetadata(player_id, steam_id, metadata)
	if not player_id or not PlayerResource:IsValidPlayerID(player_id) then print("metadata - bad player id") return end

	if metadata.supporterState then
		Supporters:SetPlayerState(player_id, metadata.supporterState)
		BP_Inventory:UpdateLocalItems(Battlepass.steamid_map[player_id])
		BP_Inventory:UpdateAvailableItems(player_id)
	end

	if metadata.level then
		BP_PlayerProgress.players[steam_id].level = metadata.level
	end

	if metadata.exp then
		BP_PlayerProgress.players[steam_id].current_exp = metadata.exp
		BP_PlayerProgress.players[steam_id].required_exp = metadata.expRequired
	end

	if metadata.purchasedItem then
		BP_Inventory:AddItemLocal(metadata.purchasedItem.itemName, steam_id, metadata.purchasedItem.count)
	end

	if metadata.items then
		for _, item in pairs(metadata.items) do
			BP_Inventory:AddItemLocal(item.itemName, steam_id, item.count or 1, "set")
		end
	end

	if metadata.purchasedCodeDetails then
		GiftCodes:AddCodeForPlayer(player_id, metadata.purchasedCodeDetails)
		GiftCodes:UpdateCodeDataClient(player_id)
	end

	if metadata.gift_codes then
		for _, code in pairs(metadata.gift_codes) do
			GiftCodes:AddCodeForPlayer(player_id, code)
		end
		GiftCodes:UpdateCodeDataClient(player_id)
	end

	if metadata.glory then
		BP_PlayerProgress:AddGlory(player_id, metadata.glory - BP_PlayerProgress:GetGlory(player_id))
	end
	
	if metadata.fortune then
		BP_PlayerProgress:SetFortune(player_id, metadata.fortune)
		BP_Masteries:UpdateFortune(player_id)
	end

	BP_PlayerProgress:UpdatePlayerInfo(player_id)
end



RegisterGameEventListener("player_connect_full", function()
	print("LOADED WEBAPI")
	if WebApi.before_match_requested then return end
	WebApi.before_match_requested = true
	WebApi:BeforeMatch()
	MatchEvents:ScheduleNextRequest()
end)

function SendLeaderboardsToPlayer(player)
	local b_data_type = type(WebApi.leaderboards)
	if b_data_type == "table" then
		CustomGameEventManager:Send_ServerToPlayer(player, "leaderboard:update_table", WebApi.leaderboards)
	elseif b_data_type == "boolean" and b_data_type then
		Timers:CreateTimer(1, function()
			SendLeaderboardsToPlayer(player)
		end)
	end
end

RegisterCustomEventListener("leaderboard:get_dedicated_leadeboards", function(event)
	local player_id = event.PlayerID
	if not player_id then return end

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end
	
	if not WebApi.leaderboards then
		WebApi.leaderboards = true;
		WebApi:Send(
			"match/get_all_leaderboards", 
			{},
			function(data)
				WebApi.leaderboards = data
				SendLeaderboardsToPlayer(player)
				print("Successfully got leaderboards")
			end,
			function(e)
				WebApi.leaderboards = false;
				print("error got leaderboards: ", e)
			end
		)
	else
		SendLeaderboardsToPlayer(player)
	end
end)

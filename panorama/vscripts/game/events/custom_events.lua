RegisterCustomEventListener("toggle_activate_bots", function(data)
	GAME_OPTION_ACTIVATE_BOTS = not GAME_OPTION_ACTIVATE_BOTS
end)


RegisterCustomEventListener("toggle_immortal_bots", function(data)
	GAME_OPTION_IMMORTAL_BOTS = not GAME_OPTION_IMMORTAL_BOTS
end)


RegisterCustomEventListener("toggle_early_lag_benchmark", function(data)
	GAME_OPTION_EARLY_BENCHMARK_MODE = not GAME_OPTION_EARLY_BENCHMARK_MODE
	GAME_OPTION_BENCHMARK_MODE = (GAME_OPTION_EARLY_BENCHMARK_MODE or GAME_OPTION_LATE_BENCHMARK_MODE)
end)


RegisterCustomEventListener("toggle_late_lag_benchmark", function(data)
	GAME_OPTION_LATE_BENCHMARK_MODE = not GAME_OPTION_LATE_BENCHMARK_MODE
	GAME_OPTION_BENCHMARK_MODE = (GAME_OPTION_EARLY_BENCHMARK_MODE or GAME_OPTION_LATE_BENCHMARK_MODE)
end)


RegisterCustomEventListener("update_chat_wheel_favorites", function(data)
	local playerId = data.PlayerID
	if not playerId then return end

	if WebApi.player_settings and WebApi.player_settings[data.PlayerID] then
		local favourites = data.favourites
		if not favourites then return end

		WebApi.player_settings[data.PlayerID].chatWheelFavourites = favourites
		PlayerOptions:ScheduleUpdateSettings(data.PlayerID)
	end
end)

RegisterCustomEventListener("toggle_tournament_mode", function(data)
	if not data.PlayerID or not GameMode.is_tournament_mode_allowed or GameRules:State_Get() ~= DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then return end

	local player = PlayerResource:GetPlayer(data.PlayerID)

	if GameRules:PlayerHasCustomGameHostPrivileges(player) then
		GameMode.is_tournament_mode_enabled = not GameMode.is_tournament_mode_enabled
		CustomNetTables:SetTableValue("game", "tournament_mode", { enabled = GameMode.is_tournament_mode_enabled } )
	end
end)

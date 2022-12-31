function GameMode:OnGameRulesStateChange()

	local nNewState = GameRules:State_Get()

	EventDriver:Dispatch("GameMode:state_changed", {
		state = nNewState
	})

	if nNewState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		if IsInToolsMode() then
			CustomGameEventManager:Send_ServerToAllClients("show_activate_bots_label", {} )
		end

		-- Activate all players in game
		for player_id = 0, 23 do
			if PlayerResource:IsValidPlayerID(player_id) and not PlayerResource:IsFakeClient(player_id) then
				GameMode:ActivatePlayer(player_id)
			end
		end

		if GameMode.is_solo_pve_game then
			for i = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
				local player = PlayerResource:GetPlayer(i)
				if player and GameRules:PlayerHasCustomGameHostPrivileges(player) then
					CustomGameEventManager:Send_ServerToPlayer(player, "Gamemode:show_bots_checkbox", {})
				end
			end
		end

		if GameMode.is_tournament_mode_allowed then
			for i = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
				local player = PlayerResource:GetPlayer(i)
				if player and GameRules:PlayerHasCustomGameHostPrivileges(player) then
					CustomGameEventManager:Send_ServerToPlayer(player, "show_activate_tournament_mode", {})
				end
			end
		end

		local playersInTeams = {}
		Timers:CreateTimer(0.4, function()
			for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
				if PlayerResource:IsValidPlayer( nPlayerID ) and nPlayerID>=0 then
					local player = PlayerResource:GetPlayer(nPlayerID)
					if player then
						local playerTeam = player:GetTeam()
						playersInTeams[playerTeam] = playersInTeams[playerTeam] or {}
						table.insert(playersInTeams[playerTeam], nPlayerID)
					end
				end
			end
			local fTeamNoFull
			local sTeamNoFull
			for key,value in pairs(playersInTeams) do
				if #value<GameRules:GetCustomGameTeamMaxPlayers(key) then
					if fTeamNoFull == nil then
						fTeamNoFull = key
					else
						sTeamNoFull = key
					end
				end
				if fTeamNoFull and sTeamNoFull then
					while (#playersInTeams[fTeamNoFull] < GameRules:GetCustomGameTeamMaxPlayers(fTeamNoFull)) and (#playersInTeams[sTeamNoFull] > 0) do
						local pID = table.random(playersInTeams[sTeamNoFull])
						local player = PlayerResource:GetPlayer(pID)
						player:SetTeam(fTeamNoFull)
						for i,x in pairs(playersInTeams[sTeamNoFull]) do
							if x == pID then
								playersInTeams[sTeamNoFull][i] = nil
							end
						end
					end
					fTeamNoFull = nil
					sTeamNoFull = nil
				end
			end
		end)

		CustomNetTables:SetTableValue("game", "player_count", { player_count = LobbyPlayerCount() })
	end

	if nNewState == DOTA_GAMERULES_STATE_HERO_SELECTION then
		CustomUI:DynamicHud_Create(-1, "background_ingame", "file://{resources}/layout/custom_game/pick_menu/background_ingame.xml", nil)
	end

	if nNewState == DOTA_GAMERULES_STATE_PRE_GAME then

		-- Color player names according to their party status
		PartyColors:Activate()

		-- Enable/disable pauses according to player vote
		GameRules:GetGameModeEntity():SetPauseEnabled(IsInToolsMode() or GameOptions:OptionsIsActive("game_option_enable_pause"))

		-- Enable bot teams and bots, if appropriate
		Timers:CreateTimer(3, function()
			if not GAME_OPTION_ACTIVATE_BOTS and not Enfos:IsEnfosMode() then return end

			AI_Core:AddBots(nil, function(bot)
				if IsInToolsMode() then
					bot:SetControllableByPlayer(0, true)
				end
			end)
		end)
	end

	if nNewState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then

		-- Force pick remaining heroes
		for _, player_id in pairs(GameMode.all_players) do
			HeroBuilder:ForceFinishHeroBuild(player_id)
		end

		HeroBuilder:RunAbilitySoundPrecache()
		GameRules:SendCustomMessage("#chat_wheel_motification_before_game", -1, 0)

		if GameMode.is_solo_pve_game then
			Notifications:BottomToAll({text = "#suicide_note", duration = 15, style = {color = "Red"}})
		elseif (not GameMode.is_full_lobby_pvp_game) then
			Notifications:BottomToAll({text = "#match_not_scored", duration = 15, style = {color = "Red"}})
		end

		if GameMode:IsTournamentMode() then
			Notifications:BottomToAll({text = "#tournament_mode_note", duration = 15, style = {color = "Red"}})
		end

		-- Start of the first round
		if Enfos:IsEnfosMode() then
			RoundManager.current_round = EnfosRound()
			RoundManager.current_round:Prepare(1, nil)
			Enfos:StartGame()
		elseif (not TestMode.__disableAutoStart) then
			RoundManager:MoveToNextRound()
		end

		Timers:CreateTimer(1, function()
			AttackCapabilityChanger:ProcessAttackCapabilityChangers()
			ScepterAbilities:ProcessScepterOwners()
			return 1
		end)

		CustomGameEventManager:Send_ServerToAllClients("StartTipsHint", {} )
	end
end

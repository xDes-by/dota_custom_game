_G.GameMode = GameMode or {}

if not GetMapName_Engine then
	_G.GetMapName_Engine = GetMapName
	_G.GetMapName = function() 
		local map_name = GetMapName_Engine()

		if map_name == "demo_duos" then
			map_name = "duos"
		end

		return map_name
	end
end

do
	local allowed_maps = {}
	for map_name in LoadKeyValues("addoninfo.txt").maps:gmatch("[%w_]+") do
		allowed_maps[map_name] = true
	end

	--DeepPrintTable(allowed_maps)

	if not allowed_maps[GetMapName()] then
		_G.CHC_WRONG_MAP = true
	end

	ListenToGameEvent("game_rules_state_change", function()
		if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
			if _G.CHC_WRONG_MAP then
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
			end
		end
	end, nil)
end

Precache = require( "Precache" )
xpTable  = require( "utils/xp_table" )
teams_layout = require( "utils/teams_layout" )

require("core_declarations")
require("extensions/init")
require("utils/init")
require("libraries/init")
require("game/init")


function Activate()
	GameMode:InitGameMode()
end

_G.DISCONNECTED_PLAYER_GIVE_UP_TIME = 60
_G.PLAYER_ABANDON_TIME = 300

function GameMode:InitGameMode()
	local game_mode_entity = GameRules:GetGameModeEntity()
	game_mode_entity.GameMode = self

	if _G.CHC_WRONG_MAP then
		game_mode_entity:SetCustomGameForceHero("npc_dota_hero_starter")
		GameRules:SetPreGameTime(0)
		GameRules:SetCustomGameSetupAutoLaunchDelay(0)
	end

	GameRules:SetSafeToLeave(true)

	-- Team list based on map
	GameMode:SetupMapData()

	GameMode.all_players = {}
	GameMode.human_player_count = 0
	GameMode.active_team_count = 0

	-- False by default, changes to true once enough players connect
	GameMode.is_full_lobby_pvp_game = false

	-- True by default, changes to false once enough players connect
	GameMode.is_solo_pve_game = true

	GameMode.is_tournament_mode_allowed = IsInToolsMode() -- Changes in WebApi:BeforeMatch response handler
	GameMode.is_tournament_mode_enabled = false
	CustomNetTables:SetTableValue("game", "tournament_mode", { enabled = false } )

	CustomNetTables:SetTableValue("game", "server_info", { 
		is_dedicated = IsInToolsMode() or IsDedicatedServer(),
		is_cheats_enabled = not IsInToolsMode() and GameRules:IsCheatMode()
	})

	CustomNetTables:SetTableValue("game", "match_id", { match_id = tostring(GameRules:Script_GetMatchID()) })
	
	-- Some predefined map references
	if (not Enfos:IsEnfosMode()) then
		GameMode.pvp_center = Entities:FindByName(nil, "center_pvp"):GetOrigin()
		GameMode.fountain_center = Entities:FindByName(nil, "center_base"):GetOrigin()
	end

	GameMode.game_winner_team = false

	CustomChat:Init()
	HeroBuilder:Init()
	PvpManager:Init()
	BetManager:Init()
	ItemLoot:Init()
	Cosmetics:Init()
	Filters:Init()
	Battlepass:Init()
	RoundManager:Init()
	Camera:Init()
	History:Init()
	GiftCodes:Init()
	TestMode:Init()
	UniquePortraits:Init()
	DPS_Counter:Init()

	GameRules:SetSameHeroSelectionEnabled( true )
	GameRules:SetUseUniversalShopMode( true )
	GameRules:SetHeroRespawnEnabled( false )
	GameRules:SetUseCustomHeroXPValues( true ) -- for overriding death exp
	--GameRules:GetGameModeEntity():SetDaynightCycleDisabled(false)
	GameRules:LockCustomGameSetupTeamAssignment(true)
	GameRules:SetTreeRegrowTime(10)
	GameRules:SetFirstBloodActive(false)
	GameRules:SetHideKillMessageHeaders(true)

	if TestMode:IsTestMode() then
		GameRules:SetPreGameTime(5)
		GameRules:SetStartingGold(99999)
		GameRules:SetCustomGameSetupAutoLaunchDelay(0)
	elseif IsInToolsMode() then
    	GameRules:SetPreGameTime(15)
		GameRules:SetStartingGold(30000)
		GameRules:SetCustomGameSetupAutoLaunchDelay(5)
	else
		GameRules:SetPreGameTime(70)
		GameRules:SetStartingGold(600)
		GameRules:SetCustomGameSetupAutoLaunchDelay(10)
	end

	GameRules.xpTable = xpTable

	game_mode_entity:SetCustomGameForceHero("npc_dota_hero_starter")
	game_mode_entity:SetUseCustomHeroLevels(true)
	game_mode_entity:SetBuybackEnabled(false)
	game_mode_entity:SetCustomXPRequiredToReachNextLevel(xpTable)
	game_mode_entity:SetFogOfWarDisabled(not Enfos:IsEnfosMode())
	game_mode_entity:SetLoseGoldOnDeath(false)
	game_mode_entity:SetKillingSpreeAnnouncerDisabled(true)
	game_mode_entity:SetMaximumAttackSpeed(1400)
	game_mode_entity:SetPauseEnabled(IsInToolsMode() or false) -- disable pauses on startup to enable later from game state change
	game_mode_entity:SetGiveFreeTPOnDeath(false)
	game_mode_entity:SetNeutralStashEnabled(Enfos:IsEnfosMode())

	GameMode:AssembleHeroesData()

	GameMode:SetupTeamData()

	if Enfos:IsEnfosMode() then
		Enfos:Init()
	end

	SendToServerConsole("dota_max_physical_items_purchase_limit 9999")
	--Convars:SetInt("tv_delay", 3)

	ListenToGameEvent("game_rules_state_change",		Dynamic_Wrap(GameMode, 'OnGameRulesStateChange' ),  self)
	-- ListenToGameEvent("dota_item_purchased",			Dynamic_Wrap(GameMode, "OnItemPurchased"), 			self)
	ListenToGameEvent("dota_player_gained_level",		Dynamic_Wrap(GameMode, "OnHeroLevelUp"), 			self)
	ListenToGameEvent("dota_player_learned_ability", 	Dynamic_Wrap(GameMode, "OnPlayerLearnedAbility" ),  self)
	ListenToGameEvent("npc_spawned",					Dynamic_Wrap(GameMode, "OnNPCSpawned"), 			self)
	ListenToGameEvent("dota_player_pick_hero",			Dynamic_Wrap(GameMode, "OnHeroPicked"), 		 	self)
	ListenToGameEvent("dota_player_killed",				Dynamic_Wrap(GameMode, "OnHeroKilled"), 		 	self)
	ListenToGameEvent("dota_player_used_ability", 		Dynamic_Wrap(GameMode, 'OnPlayerUsedAbility'), 		self)
	ListenToGameEvent("dota_item_spawned",				Dynamic_Wrap(GameMode, 'OnItemSpawned'), 			self)

	ListenToGameEvent('player_connect_full',			Dynamic_Wrap(HeroBuilder, 'OnConnectFull'), HeroBuilder)
	ListenToGameEvent('player_disconnect',				Dynamic_Wrap(HeroBuilder, 'OnDisconnect'), HeroBuilder)

	CustomGameEventManager:RegisterListener("HeroIconClicked", Dynamic_Wrap(GameMode, 'HeroIconClicked'))
	CustomGameEventManager:RegisterListener("EndGameByChoice", Dynamic_Wrap(GameMode, 'EndGameByChoice'))
	CustomGameEventManager:RegisterListener("patch_notes:get_patch_notes", Dynamic_Wrap(GameMode, 'GetPatchNotesInfo'))
	CustomGameEventManager:RegisterListener("leaderboard:get_local_records", Dynamic_Wrap(GameMode, 'GetLocalRecords'))

	RegisterCustomEventListener("CheckAegisLoserState", function(keys) GameMode:UpdateAegisCount() end)

	--Team color
	GameMode.team_colors = {}
	GameMode.team_colors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --    Teal
	GameMode.team_colors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --    Yellow
	GameMode.team_colors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  --    Pink
	GameMode.team_colors[DOTA_TEAM_CUSTOM_2] = { 255, 108, 0 }   --    Orange
	GameMode.team_colors[DOTA_TEAM_CUSTOM_3] = { 52, 85, 255 }   --    Blue
	GameMode.team_colors[DOTA_TEAM_CUSTOM_4] = { 101, 212, 19 }  --    Green
	GameMode.team_colors[DOTA_TEAM_CUSTOM_5] = { 129, 83, 54 }   --    Brown
	GameMode.team_colors[DOTA_TEAM_CUSTOM_6] = { 27, 192, 216 }  --    Cyan
	GameMode.team_colors[DOTA_TEAM_CUSTOM_7] = { 199, 228, 13 }  --    Olive
	GameMode.team_colors[DOTA_TEAM_CUSTOM_8] = { 140, 42, 244 }  --    Purple

	-- Set up team colors
	for team, color in pairs(GameMode.team_colors) do
		SetTeamCustomHealthbarColor(team, color[1], color[2], color[3])
	end

	GameMode.teams_states = {}
	GameMode.players_states = {}
	GameMode.player_disconnected_time = {}
	GameMode.players_abandoned = {}

	if Enfos:IsEnfosMode() then
		BoundEnforcer:StartEnfosBoundsEnforcer()
	else
		BoundEnforcer:StartBoundsEnforcer()
	end

	local neutral_items_kv = LoadKeyValues("scripts/npc/neutral_items.txt")
	GameMode.neutral_items = {}
	for level, description in pairs(neutral_items_kv) do
		if description and type(description) == "table" then
			for description_type, data in pairs(description) do
				if description_type == "items" then
					for k, v in pairs(data) do
						GameMode.neutral_items[k] = v
					end
				end
			end
		end
	end

	-- Limit max pause time in a scored games
	GameMode.pause_time = 0
	if not IsInToolsMode() and not GameRules:IsCheatMode() then	
		Timers:CreateTimer({
	    	useGameTime = false,
	    	endTime = 1,
	    	callback = function()
				if GameRules:IsGamePaused() then
					GameMode.pause_time = GameMode.pause_time + 1

					if GameMode.is_full_lobby_pvp_game and GameMode.pause_time >= PAUSE_TIME_MAX then
						CustomGameEventManager:Send_ServerToAllClients("HideExtendTimerButton", {})
						PauseGame(false)
					end
				end

				return 1
			end
		})
	end
end


--Read hero KV, assemble data
function GameMode:AssembleHeroesData()

	local heroKV = LoadKeyValues("scripts/npc/npc_heroes.txt")
	local abilityKV = LoadKeyValues("scripts/npc/npc_abilities.txt")

	for szHeroName, data in pairs(heroKV) do
		if data and type(data) == "table" then
			local heroInfo={}
			heroInfo.szHeroName = szHeroName
			heroInfo.szAttributePrimary = data.AttributePrimary
			heroInfo.talentNames = {}
			heroInfo.talentValues = {}
			for i=1,20 do
				if data["Ability"..i] and string.find(data["Ability"..i], "special_bonus_") then
					local sTalentName = data["Ability"..i]
					table.insert(heroInfo.talentNames, sTalentName) 
					table.insert(heroInfo.talentValues, FindTalentValue(abilityKV,sTalentName)  ) 
				end
			end
			CustomNetTables:SetTableValue("game", "hero_info_" .. szHeroName, heroInfo)
		end
	end
end

function GameMode:ActivateTeam(team)
	if GameMode:IsTeamActive(team) then return end

	GameMode:SetTeamState(team, TEAM_STATE_ON_BASE)
	GameMode.active_team_count = GameMode.active_team_count + 1

	if GameMode.active_team_count > 1 then GameMode.is_solo_pve_game = false end

	EventDriver:Dispatch("GameMode:team_activated", {
		team_number = team,
	})

	print("team "..team.." activated, current total: "..GameMode.active_team_count)
end

-- Activates a player, supposed to be performed only once, when they first connect to the game
function GameMode:ActivatePlayer(player_id)
	if GameMode:IsPlayerActive(player_id) then return end

	table.insert(GameMode.all_players, player_id)

	GameMode:SetPlayerState(player_id, PLAYER_STATE_NO_HERO)
	GameMode.player_disconnected_time[player_id] = 0

	CustomNetTables:SetTableValue("pvp_record", tostring(player_id), {win = 0, lose = 0})

	GameMode.human_player_count = GameMode.human_player_count + 1
	if GameMode.human_player_count >= (#GameMode.team_list * GameMode.team_player_count) then
		GameMode.is_full_lobby_pvp_game = true
		GameOptions:SetOptionState("game_option_disable_sudden_death", false)
	end

	local game_state = GameRules:State_Get()

	if game_state < DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		HeroBuilder.player_team_definition_listeners[player_id] = EventDriver:Listen("GameMode:state_changed", function(event)
			if event.state >= DOTA_GAMERULES_STATE_HERO_SELECTION and GameMode.team_player_id_map[PlayerResource:GetTeam(player_id)] then
				table.insert(GameMode.team_player_id_map[PlayerResource:GetTeam(player_id)], player_id)
				EventDriver:CancelListener("GameMode:state_changed", HeroBuilder.player_team_definition_listeners[player_id])
			end
		end)
	elseif game_state == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS and RoundManager:GetCurrentRoundNumber() <= 1 and GameMode:IsInPreparationPhase() and GameMode.team_player_id_map[PlayerResource:GetTeam(player_id)] then
		table.insert(GameMode.team_player_id_map[PlayerResource:GetTeam(player_id)], player_id)
	end

	if (not Enfos:IsEnfosMode()) then
		BetManager.total_bet_gold[player_id] = 0
	end
end

-- Activates a bot
function GameMode:ActivateBot(player_id)
	if GameMode:IsPlayerActive(player_id) then return end

	local team = PlayerResource:GetTeam(player_id)
	table.insert(GameMode.all_players, player_id)
	table.insert(GameMode.team_player_id_map[team], player_id)

	GameMode:SetPlayerState(player_id, PLAYER_STATE_NO_HERO)
	GameMode.player_disconnected_time[player_id] = 0

	CustomNetTables:SetTableValue("pvp_record", tostring(player_id), {win = 0, lose = 0})

	if (not Enfos:IsEnfosMode()) then
		BetManager.total_bet_gold[player_id] = 0
	end
end

function GameMode:GetAliveTeamCount()
	local alive_team_count = 0

	for _, team in pairs(GameMode.team_list) do
		if GameMode:IsTeamAlive(team) then alive_team_count = alive_team_count + 1 end
	end

	return alive_team_count
end

function GameMode:GetActiveTeamCount()
	return self.active_team_count
end

function GameMode:GetAllAliveTeams()
	local alive_teams = {}

	for _, team in pairs(GameMode.team_list) do
		if GameMode:IsTeamAlive(team) then table.insert(alive_teams, team) end
	end

	return alive_teams
end

function GameMode:GetAllActiveTeams()
	local active_teams = {}

	for _, team in pairs(GameMode.team_list) do
		if GameMode:IsTeamActive(team) then table.insert(active_teams, team) end
	end

	return active_teams
end

function GameMode:GetActivePVETeams()
	local teams = {}

	for _, team in pairs(GameMode.team_list) do
		if GameMode:IsTeamFightingCreeps(team) then
			table.insert(teams, team)
		end
	end

	return teams
end

function GameMode:SetupTeamData()

	-- key is team, value is player ID queue 
	GameMode.team_player_id_map = {}

	-- Ranking
	GameMode.team_final_rank = {}
	GameMode.team_defeat_data = {}

	--Record Team Spawn Points
	GameMode.team_fountain_spawn_points = {}

	for _, player_spawn_point in pairs(Entities:FindAllByClassname("info_player_start_dota")) do
		local team = player_spawn_point:GetTeam()
		if not GameMode.team_fountain_spawn_points[team] then
			GameMode.team_fountain_spawn_points[team] = {}
		end
		table.insert(GameMode.team_fountain_spawn_points[team], player_spawn_point:GetOrigin())
	end

	-- Arena to team conversion
	self.arena_per_team = {}
	self.arena_per_team[DOTA_TEAM_GOODGUYS] = 1
	self.arena_per_team[DOTA_TEAM_BADGUYS] = 2
	self.arena_per_team[DOTA_TEAM_CUSTOM_1] = 3
	self.arena_per_team[DOTA_TEAM_CUSTOM_2] = 4
	self.arena_per_team[DOTA_TEAM_CUSTOM_3] = 5
	self.arena_per_team[DOTA_TEAM_CUSTOM_4] = 6
	self.arena_per_team[DOTA_TEAM_CUSTOM_5] = 7
	self.arena_per_team[DOTA_TEAM_CUSTOM_6] = 8
	self.arena_per_team[DOTA_TEAM_CUSTOM_7] = 9
	self.arena_per_team[DOTA_TEAM_CUSTOM_8] = 10

	-- Round spawn points
	self.player_spawn_points = {}
	self.enemy_spawn_points = {}
	self.arena_centers = {}

	for _, team in pairs(self.team_list) do
		GameRules:SetCustomGameTeamMaxPlayers(team, self.team_player_count)
		GameMode.team_player_id_map[team] = {}

		if (not Enfos:IsEnfosMode()) then
			self.player_spawn_points[team] = {}
			for _, team_spawn_point in pairs(Entities:FindAllByName("player_spawn_"..self.arena_per_team[team])) do
				table.insert(self.player_spawn_points[team], team_spawn_point:GetOrigin())
			end

			self.enemy_spawn_points[team] = Entities:FindByName(nil, "enemy_spawn_"..self.arena_per_team[team]):GetOrigin()
			self.arena_centers[team] = Entities:FindByName(nil, "center_"..self.arena_per_team[team]):GetOrigin()
		end
	end
end

-- Update player's net worth information on the UI
function GameMode:UpdatePlayerGold(player_id)
	local player = PlayerResource:GetPlayer(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)

	if hero and player then
		CustomNetTables:SetTableValue("player_gold", tostring(player_id), {
			gold = hero:GetNetworthCHC()
		})
	end
end

-- Fires when player [player_id] clicks on [target_player_id]'s hero icon somewhere on the UI
function GameMode:HeroIconClicked(keys) 
	local player_id = keys.PlayerID
	if not player_id then return end

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	local target_player_id = keys.targetPlayerId

	local target_hero =  PlayerResource:GetSelectedHeroEntity(target_player_id) 
	if not target_hero then return end 

	local is_double_click = toboolean(keys.doubleClick)
	local is_control_down = toboolean(keys.controldown)

	if is_double_click or is_control_down then
		Camera:SetCameraToPosition(player, target_hero:GetOrigin())                 
	end
end

-- Fires when a team is defeated and should be eliminated from the game
function GameMode:TeamLose(team)

	-- In test mode you never really lose
	if TestMode:IsTestMode() then TestMode:KillAllCreeps() return end

	-- Mark the team's final placement and eliminate it
	GameMode.team_final_rank[team] = GameMode:GetAliveTeamCount()
	GameMode:SetTeamState(team, TEAM_STATE_DEFEATED)

	-- Fire barrage and update UI
	Barrage:FireBullet({type = "team_lose", nTeamNumber = team})
	CustomGameEventManager:Send_ServerToAllClients("TeamLose", {teamId = team})
	CustomNetTables:SetTableValue("team_rank", tostring(team), {rank = GameMode.team_final_rank[team]})

	-- Zero players' gold
	for _, player_id in ipairs(GameMode.team_player_id_map[team]) do
		PlayerResource:SetGold(player_id, 0, false)
	end

	-- Stop spawning, or kill team's creeps, as appropriate
	local spawner = RoundManager:GetCurrentRoundSpawner(team)

	if spawner and (not Enfos:IsEnfosMode()) then spawner:ForceDestroyCreeps() end

	-- Start building, or update, results table (uploads to server whenever a team is defeated)
	local lose_round
	if Enfos:IsEnfosMode() then
		lose_round = Enfos.current_round.round_number
		CustomNetTables:SetTableValue("game", "enfos_defeat", { enemy_defeated = true })
	else
		lose_round = RoundManager:GetCurrentRoundNumber()
	end

	GameMode.team_defeat_data[team] = {
		round = lose_round,
		time = GameRules:GetDOTATime(false, true)
	}

	WebApi:AfterMatchTeam(team)

	-- If the game was already decided previously, and this is just the solo winner going for extra rounds, end the game now
	if GameMode.game_winner_team then GameRules:SetGameWinner(GameMode.game_winner_team) end

	-- Otherwise, check if the game has ended (PVE game)
	if GameMode.is_solo_pve_game and GameMode:GetAliveTeamCount() == 0 then

		-- If cheats were enabled, no data is saved, and the game ends
		if GameRules:IsCheatMode() and (not IsInToolsMode()) then
			Notifications:BottomToAll({text = "#cheat_no_record", duration = 10, style = {color = "Red"}})
			Timers:CreateTimer(10, function() GameRules:SetGameWinner(team) end)

		-- Else, game data is sent to the server
		else

			-- In tools mode, data is saved to the server but flagged as "not from a real game"
			if IsInToolsMode() then
				Notifications:BottomToAll({text = "Game recorded as being finished in tools mode", duration = 6, style = {color = "Red"}})
				Timers:CreateTimer(10, function() GameRules:SetGameWinner(team) end)

			-- In real games, it is saved to the server and eligible for leaderboards and such
			else
				Notifications:BottomToAll({text = "#game_recorded", duration = 10, style = {color = "Red"}})
				GameRules:SetGameWinner(team)
			end

			CustomNetTables:SetTableValue("end_game_data", "end_game_data", WebApi.data_for_end_game)
		end

	-- Check if the game has ended (PVP game)
	elseif (not GameMode.is_solo_pve_game) and GameMode:GetAliveTeamCount() == 1 then
		local winner_team = GameMode:GetAllAliveTeams()[1]

		GameMode.team_defeat_data[winner_team] = {
			round = lose_round,
			time = GameRules:GetDOTATime(false, true)
		}

		GameMode.team_final_rank[winner_team] = 1
		CustomNetTables:SetTableValue("team_rank", tostring(winner_team), {rank = 1})

		ProgressTracker:EventTriggered("CUSTOM_EVENT_GAME_WON", {team = winner_team})
		ProgressTracker:SendServerUpdate()

		WebApi:AfterMatchTeam(winner_team)

		GameMode.game_winner_team = winner_team

		for _, player_id in pairs(self.team_player_id_map[winner_team]) do
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero then hero:RemoveCurse() end
		end
	end

	EventDriver:Dispatch("GameMode:team_defeated", {team = team, rank = GameMode.team_final_rank[team]})
end

-- Fires when a team wins a pvp match and decided to stop playing
function GameMode:EndGameByChoice(keys)
	if PlayerResource:GetTeam(keys.PlayerID) == GameMode.game_winner_team then
		GameMode:TeamLose(GameMode.game_winner_team)
	end
end


function GameMode:SetupMapData()
	local mapname = GetMapName()
	if mapname == "ffa" or TestMode:IsTestMode() then
		Convars:SetInt("sv_allchat", 1)
		Convars:SetInt("sv_alltalk", 1)
	end

	local map_layout = teams_layout[mapname]
	if not map_layout then 
		map_layout = teams_layout['ffa']
	end

	self.team_list = map_layout.teamlist
	self.rating_delta = map_layout.rating_delta
	self.team_player_count = map_layout.player_count
end

function GameMode:IsSoloMap()
	return (GetMapName() == "ffa" or GetMapName() == "demo")
end

-- Returns true if *at least* one player in the team has *at least* one stack of the aegis buff.
function GameMode:HasAegisOnTeam(team)
	for _, player_id in pairs(self.team_player_id_map[team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero and (not hero:IsNull()) and hero:IsAlive() and hero:HasModifier("modifier_aegis") then
			return true
		end
	end
end

-- Removes one aegis stack from all players in this team.
-- Does nothing to players with no aegis.
function GameMode:ConsumeTeamAegis(team)
	for _, player_id in pairs(self.team_player_id_map[team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero and (not hero:IsNull()) then

			local aegis_modifier = hero:FindModifierByName("modifier_aegis")

			if hero:HasModifier("modifier_innate_second_chance") then
				hero:FindAbilityByName("innate_revenge"):SetActivated(false)
				hero:RemoveModifierByName("modifier_innate_second_chance")
			elseif aegis_modifier then

				local aegis_count = aegis_modifier:GetStackCount()
				if aegis_count > 1 then
					aegis_modifier:DecrementStackCount()
				else
					aegis_modifier:Destroy()
				end

				CustomGameEventManager:Send_ServerToAllClients("player_lose_aegis", {playerId = player_id, aegisCount = aegis_count - 1})
			end
		end
	end
end

function GameMode:UpdateAegisCount()
	for _, player_id in pairs(self.all_players) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero and (not hero:IsNull()) then

			local aegis_modifier = hero:FindModifierByName("modifier_aegis")
			if aegis_modifier then
				CustomGameEventManager:Send_ServerToAllClients("player_show_aegis_init", {
					playerId = player_id,
					aegisCount = aegis_modifier:GetStackCount()
				})
			end

			local curse_modifier = hero:FindModifierByName("modifier_loser_curse")
			if curse_modifier then
				CustomGameEventManager:Send_ServerToAllClients("player_debuff_loser", {
					playerId = player_id,
					loserCount = curse_modifier:GetStackCount()
				})
			end
		end
	end
end

-- Kills a player's hero, bypassing all death prevention measures, except aegis charges.
function GameMode:TrueKill(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)

	if (not hero) or hero:IsNull() then return end

	local death_prevention_abilities = {
		"abaddon_borrowed_time",
		"skeleton_king_reincarnation",
	}

	local death_prevention_modifiers = {
		"modifier_abaddon_borrowed_time_absorbtion",
		"modifier_oracle_false_promise",
		"modifier_oracle_false_promise_timer",
	}

	for _, ability_name in pairs(death_prevention_abilities) do
		if hero:FindAbilityByName(ability_name) then
			hero:FindAbilityByName(ability_name):StartCooldown(1)
		end
	end

	for _, modifier_name in pairs(death_prevention_modifiers) do
		hero:RemoveModifierByName(modifier_name)
	end

	-- Then kill the hero 10 times in a row, for good measure.
	for i = 1, 10 do
		hero:ForceKill(true)
	end
end

function GameMode:GetLocalRecords(keys)
	local player_id = keys.PlayerID
	if not player_id or not WebApi.player_records[player_id] then return end
	
	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	CustomGameEventManager:Send_ServerToPlayer(player, "leaderboard:update_local_records", WebApi.player_records[player_id])
end

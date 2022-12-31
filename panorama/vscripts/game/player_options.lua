PlayerOptions = PlayerOptions or class({})

PLAYER_OPTIONS_DEFAULT_CREEP_CAMERA_ENABLED = false
PLAYER_OPTIONS_DEFAULT_DUEL_CAMERA_ENABLED = true
PLAYER_OPTIONS_DEFAULT_CAMERA_SMOOTHNESS_ENABLED = true

PLAYER_OPTIONS_DEFAULT_BARRAGE_OPACITY = 1
PLAYER_OPTIONS_DEFAULT_BARRAGE_CHAT_ENABLED = true

PLAYER_OPTIONS_DEFAULT_AUTO_STASH_ENABLED = true
PLAYER_OPTIONS_DEFAULT_SHOP_CLOSE_ON_SHIFT_BUY_ENABLED = true

PLAYER_OPTIONS_DEFAULT_AGHS_CHECK_ENABLED = true

PLAYER_OPTIONS_DEFAULT_HIDE_MY_RATING_ENABLED = false
PLAYER_OPTIONS_DEFAULT_AUTO_CONFIRM_BET_ENABLED = false

PLAYER_OPTIONS_CREEP_CAMERA_ENABLED = {}
PLAYER_OPTIONS_DUEL_CAMERA_ENABLED = {}
PLAYER_OPTIONS_CAMERA_SMOOTHNESS_ENABLED = {}

PLAYER_OPTIONS_BARRAGE_OPACITY = {}
PLAYER_OPTIONS_BARRAGE_CHAT_ENABLED = {}

PLAYER_OPTIONS_AGHS_CHECK_ENABLED = {}

PLAYER_OPTIONS_AUTO_STASH_ENABLED = {}
PLAYER_OPTIONS_SHOP_CLOSE_ON_SHIFT_BUY_ENABLED = {}
PLAYER_OPTIONS_HIDE_MY_RATING_ENABLED = {}
PLAYER_OPTIONS_AUTO_CONFIRM_BET_ENABLED = {}

PLAYER_OPTIONS_CAMERA_DISTANCE = {}
PLAYER_OPTIONS_DEFAULT_CAMERA_DISTANCE = 0

PLAYER_OPTIONS_DPS_COUNTER = {}
PLAYER_OPTIONS_DEFAULT_DPS_COUNTER_ENABLED = true

PLAYER_OPTIONS_MASTERIES_SORT = {}
PLAYER_OPTIONS_DEFAULT_MASTERIES_SORT = 0

PLAYER_OPTION_MUTE_BOTS = {}
PLAYER_OPTION_DEFAULT_MUTE_BOTS = false

function PlayerOptions:Init()
	PlayerOptions.scheduled_settings_update = PlayerOptions.scheduled_settings_update or {}

	RegisterCustomEventListener("options:force_load", function(data) PlayerOptions:PlayerSettingsLoaded(data.PlayerID, {}) end)

	RegisterCustomEventListener("options:automatic_stash", function(data)
		if not data.PlayerID then return end
		PLAYER_OPTIONS_AUTO_STASH_ENABLED[data.PlayerID] = toboolean(data.state)

		PlayerOptions:SavePlayerOptionsState(data.PlayerID)
	end)

	RegisterCustomEventListener("options:close_shop_shift_buy", function(data)
		if not data.PlayerID then return end
		PLAYER_OPTIONS_SHOP_CLOSE_ON_SHIFT_BUY_ENABLED[data.PlayerID] = toboolean(data.state)

		PlayerOptions:SavePlayerOptionsState(data.PlayerID)
	end)

	RegisterCustomEventListener("options:aghs_check", function(data)
		if not data.PlayerID then return end
		PLAYER_OPTIONS_AGHS_CHECK_ENABLED[data.PlayerID] = toboolean(data.state)

		PlayerOptions:SavePlayerOptionsState(data.PlayerID)
	end)

	RegisterCustomEventListener("options:hide_rating", function(data)
		if not data.PlayerID then return end
		PLAYER_OPTIONS_HIDE_MY_RATING_ENABLED[data.PlayerID] = toboolean(data.state)

		PlayerOptions:SavePlayerOptionsState(data.PlayerID)
	end)

	RegisterCustomEventListener("options:auto_confirm_bet", function(data)
		if not data.PlayerID then return end
		PLAYER_OPTIONS_AUTO_CONFIRM_BET_ENABLED[data.PlayerID] = toboolean(data.state)

		PlayerOptions:SavePlayerOptionsState(data.PlayerID)
	end)

	RegisterCustomEventListener("options:camera_distance", function(data)
		if not data.PlayerID then return end
		local current_value = PLAYER_OPTIONS_CAMERA_DISTANCE[data.PlayerID]
		if current_value and current_value == data.state then return end

		PLAYER_OPTIONS_CAMERA_DISTANCE[data.PlayerID] = data.state

		PlayerOptions:SavePlayerOptionsState(data.PlayerID)
	end)

	RegisterCustomEventListener("options:dps_counter", function(data)
		if not data.PlayerID then return end
		PLAYER_OPTIONS_DPS_COUNTER[data.PlayerID] = toboolean(data.state)
		print("dps counter option changed")
		PlayerOptions:SavePlayerOptionsState(data.PlayerID)
	end)

	RegisterCustomEventListener("options:masteries_sort", function(data)
		if not data.PlayerID then return end
		PLAYER_OPTIONS_MASTERIES_SORT[data.PlayerID] = data.state

		PlayerOptions:SavePlayerOptionsState(data.PlayerID)
	end)

	RegisterCustomEventListener("options:mute_bots", function(data)
		if not data.PlayerID then return end
		PLAYER_OPTION_MUTE_BOTS[data.PlayerID] = data.state

		PlayerOptions:SavePlayerOptionsState(data.PlayerID)
	end)

	RegisterCustomEventListener("options:barrage_opacity", function(data) 
		Barrage:SetBarrageOpacity(data) 
	end)

    RegisterCustomEventListener("options:barrage_chat_lines", function(data) 
		Barrage:SetBarrageChatEnabled(data) 
		PlayerOptions:SavePlayerOptionsState(data.PlayerID)
	end)

	EventDriver:Listen("Round:round_ended", function(event)
		if event.round_number % 10 == 0 then
			PlayerOptions:SaveSettings()
		end
	end)
end

function PlayerOptions:PlayerSettingsLoaded(player_id, player_settings)
	print("[PlayerOptions] PlayerSettingsLoaded", player_id)
	DeepPrintTable(player_settings)
	if not player_id then return end
	local options = WebApi.player_settings[player_id].options or {}

	-- global player settings name --- backend-saved short name --- default value
	PlayerOptions.settings_map = {
		["PLAYER_OPTIONS_CREEP_CAMERA_ENABLED"] 			= {"creep_camera", PLAYER_OPTIONS_DEFAULT_CREEP_CAMERA_ENABLED},
		["PLAYER_OPTIONS_DUEL_CAMERA_ENABLED"] 				= {"duel_camera", PLAYER_OPTIONS_DEFAULT_DUEL_CAMERA_ENABLED},
		["PLAYER_OPTIONS_CAMERA_SMOOTHNESS_ENABLED"] 		= {"smooth_camera", PLAYER_OPTIONS_DEFAULT_CAMERA_SMOOTHNESS_ENABLED},
		["PLAYER_OPTIONS_BARRAGE_OPACITY"] 					= {"barrage_opacity", PLAYER_OPTIONS_DEFAULT_BARRAGE_OPACITY},
		["PLAYER_OPTIONS_BARRAGE_CHAT_ENABLED"] 			= {"barrage_chat", PLAYER_OPTIONS_DEFAULT_BARRAGE_CHAT_ENABLED},
		["PLAYER_OPTIONS_AUTO_STASH_ENABLED"]				= {"auto_stash", PLAYER_OPTIONS_DEFAULT_AUTO_STASH_ENABLED},
		["PLAYER_OPTIONS_AGHS_CHECK_ENABLED"]				= {"aghs_check", PLAYER_OPTIONS_DEFAULT_AGHS_CHECK_ENABLED},
		["PLAYER_OPTIONS_SHOP_CLOSE_ON_SHIFT_BUY_ENABLED"]	= {"close_shop_shift_buy", PLAYER_OPTIONS_DEFAULT_SHOP_CLOSE_ON_SHIFT_BUY_ENABLED},
		["PLAYER_OPTIONS_HIDE_MY_RATING_ENABLED"]			= {"hide_rating", PLAYER_OPTIONS_DEFAULT_HIDE_MY_RATING_ENABLED},
		["PLAYER_OPTIONS_AUTO_CONFIRM_BET_ENABLED"]			= {"auto_confirm_bet", PLAYER_OPTIONS_DEFAULT_AUTO_CONFIRM_BET_ENABLED},
		["PLAYER_OPTIONS_CAMERA_DISTANCE"]					= {"camera_distance", PLAYER_OPTIONS_DEFAULT_CAMERA_DISTANCE},
		["PLAYER_OPTIONS_DPS_COUNTER"]						= {"dps_counter", PLAYER_OPTIONS_DEFAULT_DPS_COUNTER_ENABLED},
		["PLAYER_OPTIONS_MASTERIES_SORT"]					= {"masteries_sort", PLAYER_OPTIONS_DEFAULT_MASTERIES_SORT},
		["PLAYER_OPTION_MUTE_BOTS"]							= {"mute_bots", PLAYER_OPTION_DEFAULT_MUTE_BOTS}
	}

	for global_name, settings in pairs(PlayerOptions.settings_map) do
		if _G[global_name][player_id] == nil then
			local saved_value = options[settings[1]]
			if saved_value == nil then -- nothing saved for this setting, fall back to default value
				_G[global_name][player_id] = settings[2]
			else -- saved value
				_G[global_name][player_id] = saved_value
			end
		end
	end

	Camera:SetCreepsCameraState({state = PLAYER_OPTIONS_CREEP_CAMERA_ENABLED[player_id], PlayerID = player_id, update_hud = true})
	Camera:SetDuelCameraState({state = PLAYER_OPTIONS_DUEL_CAMERA_ENABLED[player_id], PlayerID = player_id, update_hud = true})
	Camera:SetCameraSmoothness({state = PLAYER_OPTIONS_CAMERA_SMOOTHNESS_ENABLED[player_id], PlayerID = player_id, update_hud = true})

	Barrage:SetBarrageChatEnabled({state = PLAYER_OPTIONS_BARRAGE_CHAT_ENABLED[player_id], PlayerID = player_id, update_hud = true})
	Barrage:SetBarrageOpacity({state = PLAYER_OPTIONS_BARRAGE_OPACITY[player_id], PlayerID = player_id, update_hud = true})

	CustomNetTables:SetTableValue("player_settings", tostring(player_id), player_settings)

	EventDriver:Dispatch("PlayerOptions:option_changed", {
		player_id = player_id, 
		options = options
	})

	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "PlayerOptions:option_changed", {options = options})
end

function PlayerOptions:SavePlayerOptionsState(player_id)
	if not player_id then return end

	if not PlayerOptions.settings_map then
		PlayerOptions:PlayerSettingsLoaded(player_id, {})
	end

	local options = {}
	for global_name, settings in pairs(PlayerOptions.settings_map or {}) do
		options[settings[1]] = PlayerOptions:_SaveCompare(_G[global_name][player_id], settings[2])
	end
	if not options or next(options) == nil then return end

	WebApi.player_settings[player_id].options = options
	PlayerOptions:ScheduleUpdateSettings(player_id)

	local settings = CustomNetTables:GetTableValue("player_settings", tostring(player_id))
	if not settings then settings = {} end
	
	settings.options = options
	CustomNetTables:SetTableValue("player_settings", tostring(player_id), settings)

	EventDriver:Dispatch("PlayerOptions:option_changed", {
		player_id = player_id, 
		options = options
	})
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "PlayerOptions:option_changed", {options = options})
end

function PlayerOptions:_SaveCompare(arg1, arg2)
	if arg1 == arg2 then return nil end
	return arg1
end


function PlayerOptions:ScheduleUpdateSettings(player_id)
	PlayerOptions.scheduled_settings_update[player_id] = true
end


function PlayerOptions:SaveSettings()
	if next(PlayerOptions.scheduled_settings_update) == nil then return end
	local players = {}
	for player_id = 0, 23 do
		if PlayerResource:IsValidPlayerID(player_id) and PlayerOptions.scheduled_settings_update[player_id] then
			local settings = WebApi.player_settings[player_id]
			DeepPrintTable(settings)
			if next(settings) ~= nil then
				table.insert(players, { 
					steamId = tostring(PlayerResource:GetSteamID(player_id)), 
					settings = settings 
				})
			end
		end
	end
	if next(players) == nil then return end
	WebApi:Send("match/update-settings", { players = players })
	PlayerOptions.scheduled_settings_update = {}
end


PlayerOptions:Init()

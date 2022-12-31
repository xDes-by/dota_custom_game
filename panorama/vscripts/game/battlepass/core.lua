require("game/battlepass/inventory/collection_enum")
require("game/battlepass/inventory/gift_codes")
require("game/battlepass/cosmetic_abilities")
require("game/battlepass/player_progress")
require("game/battlepass/quests")
require("game/battlepass/chests")
require("game/battlepass/achievements")
require("game/battlepass/masteries")
require("game/battlepass/inventory/wear_functions")
require("game/battlepass/inventory/inventory")
require("game/battlepass/tracker/progress_tracker")
require("game/battlepass/mail")

Battlepass = Battlepass or {}

function Battlepass:Init()
	print("[Battlepass] Init Core")
	Battlepass.steamid_map = {}
	Battlepass.playerid_map = {}

	ProgressTracker:Init()
	BP_PlayerProgress:Init()
	BP_Achievements:Init()
	BP_Quests:Init()
	BP_Inventory:Init()
	BP_Masteries:Init()
	WearFunc:Init()
	Feedback:Init()
	Mail:Init()
	Battlepass:InitConversionTables()
	SyncedChat:Init()
end

function Battlepass:InitConversionTables()
	for player_id=0, 23 do
		if PlayerResource:IsValidPlayerID(player_id) then
			local steam_id = tostring(PlayerResource:GetSteamID(player_id))
			self.steamid_map[player_id] = steam_id
			self.playerid_map[steam_id] = player_id
		end
	end
end

-- when data from webapi arrives, it will be passed here
function Battlepass:OnDataArrival(data)
	Battlepass:InitConversionTables()
	if not data.players then print("[Battlepass] no players data in incoming data") return end

	local quests_definitions = data.quests
	local achievements_definition = data.achievements

	local achievements = {}
	local quests = {}
	local player_stats = {}
	local inventories = {}
	local equipped_items = {}

	for index, player_data in pairs(data.players) do
		local steam_id = player_data.steamId
		if player_data.achievements then
			achievements[steam_id] = player_data.achievements
		end
		if player_data.quests then
			quests[steam_id] = player_data.quests
		end
		if player_data.progress then
			player_stats[steam_id] = player_data.progress
		end
		if player_data.inventory then
			inventories[steam_id] = player_data.inventory
		end
		if player_data.equipped_items then
			equipped_items[steam_id] = player_data.equipped_items

			if player_data.equipped_items.favourite_masteries then
				BP_Masteries:SetFavoriteMasteries({
					PlayerID = Battlepass:GetPlayerId(steam_id),
					favorite_masteries = player_data.equipped_items.favourite_masteries,
					b_skip_save = true
				})
			end
		end
	end
	
	BP_Achievements:OnDataArrival(achievements, achievements_definition)
	BP_Quests:OnDataArrival(quests, quests_definitions)
	BP_PlayerProgress:OnDataArrival(player_stats)
	BP_Inventory:OnDataArrival(inventories, equipped_items)
end


function Battlepass:GetSteamId(player_id)
	if not player_id then return end
	player_id = tonumber(player_id)
	if Battlepass.steamid_map[player_id] then return Battlepass.steamid_map[player_id] end
	local steam_id = tostring(PlayerResource:GetSteamID(player_id))
	Battlepass.steamid_map[player_id] = steam_id
	return steam_id
end


function Battlepass:GetPlayerId(steam_id)
	if not Battlepass.playerid_map[steam_id] then
		print("[Battlepass:GetPlayerId] " .. steam_id .. " not found", type(steam_id))
	end
	return Battlepass.playerid_map[steam_id]
end

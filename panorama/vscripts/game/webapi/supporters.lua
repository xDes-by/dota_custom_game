Supporters = Supporters or {}
Supporters.player_state = Supporters.player_state or {}

function Supporters:GetLevel(player_id)
	return Supporters.player_state[player_id] and Supporters.player_state[player_id].level or 0
end

function Supporters:GetEndDate(player_id)
	return Supporters.player_state[player_id] and Supporters.player_state[player_id].endDate or ""
end

function Supporters:SetPlayerState(player_id, state)
	Supporters.player_state[player_id] = state
	CustomNetTables:SetTableValue("game", "player_supporter_" .. player_id, state)
end

local developer_steam_ids = {
	["76561198132422587"] = true, -- Sanctus Animus
	["76561198054179075"] = true, -- darklord
	["76561198052211234"] = true, -- bukka
	["76561199069138789"] = true, -- ninepigeons (Chinese tester)
	["76561198007141460"] = true, -- Firetoad
	["76561198064622537"] = true, -- Sheodar
	["76561198070058334"] = true, -- ark120202
	["76561198271575954"] = true, -- HappyFeedFriends
	["76561198188258659"] = true, -- Australia is my City
	["76561199069138789"] = true, -- Dota 2 unofficial
	["76561198249367546"] = true, -- Flam3s
	["76561198091437567"] = true, -- Shesmu
	["76561198054211176"] = true, -- Snoresville
}

function Supporters:IsDeveloper(player_id)
	local steam_id = tostring(PlayerResource:GetSteamID(player_id))
	return developer_steam_ids[steam_id] == true
end

local party_steam_ids = {
	["76561198032344982"] = true, -- Neetoro
	["76561198071627284"] = true, -- Komapuk
	["76561199056725376"] = true, -- Husayn
	["76561198003571172"] = true, -- Baumi
	["76561198133364162"] = true, -- Blasphemy Incarnate
	["76561198040469212"] = true, -- Draze22
	["76561198094162496"] = true, -- iamKusin
	["76561198057328007"] = true, -- takadoto
}

function Supporters:IsPartier(player_id)
	local steam_id = tostring(PlayerResource:GetSteamID(player_id))
	return party_steam_ids[steam_id] == true
end

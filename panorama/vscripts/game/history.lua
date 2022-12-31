History = History or {
	Bet = {},
	Round = {},
	Duel = {}
}

function History:Init()
	EventDriver:Listen("Spawner:all_creeps_killed", History.OnAllCreepsKilled, History)
end

function History:AddBetLine(playerID, line)
	History.Bet[playerID] = History.Bet[playerID] or {}
	table.insert(History.Bet[playerID], line)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "GoldHistoryAddBetLine", line)
	end
end

function History:AddRoundLine(playerID, line)
	History.Round[playerID] = History.Round[playerID] or {}
	table.insert(History.Round[playerID], line)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "GoldHistoryAddRoundLine", line)
	end
end

function History:AddDuelLine(playerID, line)
	History.Duel[playerID] = History.Duel[playerID] or {}
	table.insert(History.Duel[playerID], line)
	local player = PlayerResource:GetPlayer(playerID)
	if player then
		CustomGameEventManager:Send_ServerToPlayer(player, "GoldHistoryAddDuelLine", line)
	end
end

function History:OnAllCreepsKilled(keys)
	if Enfos:IsEnfosMode() then return end

	for _, player_id in ipairs(GameMode.team_player_id_map[keys.team]) do

		local creep_gold = RoundManager:GetPlayerGoldHistory({
			player_id = player_id,
			round = keys.round,
			source = ROUND_MANAGER_GOLD_SOURCE_CREEPS
		})
		
		History:AddRoundLine(player_id, { 
			round = keys.round, 
			roundName = keys.round_name, 
			goldForCreeps = math.floor(creep_gold),
			goldForRound = keys.prize_gold,
			playerFinishedNumber = keys.position,
			duration = keys.duration
		})
	end
end

RegisterCustomEventListener("RequestGoldHistoryReconnect", function(event) 
	local playerID = event.PlayerID
	if not playerID then return end

	local result = {
		Bet = History.Bet[playerID],
		Round = History.Round[playerID],
		Duel = History.Duel[playerID]
	}

	local player = PlayerResource:GetPlayer(playerID)

	--send event only if result not empty
	if next(result) and player then
		CustomGameEventManager:Send_ServerToPlayer(player, "GoldHistoryReconnectResult", result)
	end
end)

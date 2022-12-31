if GameOptions == nil then GameOptions = class({}) end

-- Game options also can be activated if all players in game voted yes, regardless of votes count
local votesForInitOption = {
	['demo'] = 1,
	['ffa'] = 6,
	['duos'] = 8,
	['squads'] = 9,
	['enfos'] = 6,
}

local gameOptions = {
	[0] = {name = "game_option_enable_pause"},
	[1] = {name = "game_option_disable_sudden_death"},
}

-- Is option enabled for voting
local optionState = {
	[0] = true,
	[1] = true,
}

function GameOptions:Init()
	self.pauseTime = 0
	self.mapName = GetMapName()
	
	for _, option in pairs(gameOptions) do
		option.votes = 0
		option.players = {}
	end

	CustomGameEventManager:RegisterListener("PlayerVoteForGameOption",function(_, data)
		self:PlayerVoteForGameOption(data)
	end)

	CustomNetTables:SetTableValue("game", "game_options_state", optionState)
end

function GameOptions:UpdatePause()
	Timers:RemoveTimer("game_options_unpause")
	Convars:SetFloat("host_timescale", 0.1)

	Timers:CreateTimer(0, function()
		self.pauseTime = self.pauseTime - 0.1
		if self.pauseTime > 0 then
			return 0.1
		else
			return nil
		end
	end)
	Timers:CreateTimer("game_options_unpause",{
		useGameTime = false,
		endTime = self.pauseTime/10,
		callback = function()
			Convars:SetFloat("host_timescale", 1)
			return nil
		end
	})
end

function GameOptions:PlayerVoteForGameOption(data)
	if not gameOptions[data.id] then return end

	if gameOptions[data.id].players[data.PlayerID] == nil then
		gameOptions[data.id].players[data.PlayerID] = true
		local newValue = gameOptions[data.id].votes + 1
		gameOptions[data.id].votes = newValue
		if newValue <= votesForInitOption[self.mapName] then
			self.pauseTime = self.pauseTime + 1
			self:UpdatePause()
		end
	else
		gameOptions[data.id].players[data.PlayerID] = not gameOptions[data.id].players[data.PlayerID]
		local newValue = -1
		if gameOptions[data.id].players[data.PlayerID] then
			newValue = 1
		end
		gameOptions[data.id].votes = gameOptions[data.id].votes + newValue
	end

	local gameOptionsVotesForClient = {}
	for id, option in pairs(gameOptions) do
		gameOptionsVotesForClient[id] = option.votes
	end
	CustomNetTables:SetTableValue("game", "game_options", gameOptionsVotesForClient)
end

-- Is option enabled for voting
function GameOptions:IsOptionEnabled(name)
	for id, option in pairs(gameOptions) do
		if option.name == name then
			return optionState[id]
		end
	end
end

function GameOptions:SetOptionState(name, state)
	for id, option in pairs(gameOptions) do
		if option.name == name then
			optionState[id] = state
		end
	end

	CustomNetTables:SetTableValue("game", "game_options_state", optionState)
end

function GameOptions:OptionsIsActive(name)
	for _, option in pairs(gameOptions) do
		if option.name == name then 
			return GameOptions:IsOptionEnabled(name) 
			and (option.votes >= votesForInitOption[self.mapName] or option.votes >= GameMode.human_player_count)
		end
	end
	return nil
end


GameOptions:Init()

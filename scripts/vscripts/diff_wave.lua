if diff_wave == nil then
	_G.diff_wave = class({})
end

function diff_wave:init()
	self.rating_scale = 1
	self.info = {
		Easy = { respawn = 60, talent_scale = 0.5, rating_scale = 0},
		Normal = { respawn = 120, talent_scale = 1.0, rating_scale = 1},
		Hard = { respawn = 120, talent_scale = 1.25, rating_scale = 2},
		Ultra = { respawn = 90, talent_scale = 1.5, rating_scale = 3},
		Insane = { respawn = 75, talent_scale = 1.75, rating_scale = 4},
		Impossible = { respawn = 60, talent_scale = 2.0, rating_scale = 5},
	}
	self.difficultyVote = {}
	CustomGameEventManager:RegisterListener("GameSettings",function(_, keys)
        self:GameSettings(keys)
    end)
	CustomGameEventManager:RegisterListener("GameSettingsToggle",function(_, keys)
        self:GameSettingsToggle(keys)
    end)
	ListenToGameEvent("game_rules_state_change",function(_, keys)
        self:OnGameStateChanged(keys)
    end, self)
	CustomGameEventManager:RegisterListener("GameSettingsInit",function(_, keys)
        self:GameSettingsInit(keys)
    end)
	self.maximum_passed_difficulty = {}
	self.diff_toggle = {}
end

function diff_wave:GameSettings(t)
	self.difficultyVote[t.PlayerID] = t.mode
	CustomNetTables:SetTableValue( "difficultyVote", tostring(t.PlayerID), self.difficultyVote )
end

function diff_wave:GameSettingsToggle(t)
	if BattlePass ~= nil and BattlePass.current_season ~= nil then
		local pid = t.PlayerID
		local send = {}
		if t.toggle == 1 then
			send.diff_toggle = t.id
		else
			send.diff_toggle = ""
		end
		DataBase:Send(DataBase.link.GameSettingsToggle, "GET", send, pid, true, nil)
	end
end

function diff_wave:GameSettingsInit(t)
	Timers:CreateTimer(0 ,function()
		if self.maximum_passed_difficulty[t.PlayerID] == nil then return 0.1 end
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "GameSettingsMaxDifficulty", {
			maximum_passed_difficulty = self.maximum_passed_difficulty[t.PlayerID],
			diff_toggle = self.diff_toggle[t.PlayerID],
		} )
	end)
end

function diff_wave:SetPlayerData(pid, settings)
	self.maximum_passed_difficulty[pid] = settings.maximum_passed_difficulty
	self.diff_toggle[pid] = settings.diff_toggle
end

function diff_wave:OnGameStateChanged(t)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
		local diff = {0,0,0,0,0,0}
		local count = 0
		for i = 0, PlayerResource:GetPlayerCount()-1 do
			if self.difficultyVote[i] ~= nil then
				local idx = self.difficultyVote[i]+1
				diff[idx] = diff[idx] + 1
				count = count + 1
			end
		end
		if count == 0 then
			diff[2] = 1
		end
		local diff_index = 1
		local vote_count = 0
		for i = 1, 6 do
			if diff[i] >= vote_count and diff[i] > 0 then
				diff_index = i
				vote_count = diff[i]
			end
		end
		for i, mode in pairs({"Easy", "Normal", "Hard", "Ultra", "Insane", "Impossible"}) do
			if i == diff_index then
				self.wavedef = mode
				self.rating_scale = self.info[mode].rating_scale
				self.respawn = self.info[mode].respawn
				self.talent_scale = self.info[mode].talent_scale
			end
		end
		CustomNetTables:SetTableValue("GameInfo", tostring("mode"), {
			name = self.wavedef,
			scale = self.rating_scale,
		})
	end
end

function diff_wave:InitGameMode()
	-- if GetMapName() == "turbo" then
	-- self.wavedef = "Easy"
	-- self.rating_scale = 0
	-- self.respawn = 60
	-- end
	
	-- if GetMapName() == "normal" then
	-- self.wavedef = "Normal"
	-- self.rating_scale = 1
	-- self.respawn = 120
	-- end
	
	-- if GetMapName() == "hard" then
	-- self.wavedef = "Hard"
	-- self.rating_scale = 2
	-- self.respawn = 120
	-- end
	
	-- if GetMapName() == "ultra" then
	-- self.wavedef = "Ultra"
	-- self.rating_scale = 3
	-- self.respawn = 120
	-- end
	
	-- if GetMapName() == "insane" then
	-- self.wavedef = "Insane"
	-- self.rating_scale = 4
	-- self.respawn = 120
	-- end
end 

diff_wave:init()
if Quests == nil then
    _G.Quests = class({})
end

function Quests:init()
    self.daily_tasks_list = dailyTasks
    self.bp_tasks_list = battlePassTasks
    self.daily_tasks_number = 3
    self.daily = {}
    self.bp = {}
    self.settings = {}
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( self, 'OnGameStateChanged' ), self )
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( self, "OnEntityKilled" ), self)
    ListenToGameEvent( "nommed_tree", Dynamic_Wrap( self, "OnNommedTree" ), self)
    ListenToGameEvent( "player_death", Dynamic_Wrap( self, "OnPlayerDeath" ), self)
    ListenToGameEvent( "dota_item_physical_destroyed", Dynamic_Wrap( self, "OnItemDestroyed" ), self)
    ListenToGameEvent("game_end", Dynamic_Wrap( self, "OnGameEnd" ), self)
    ListenToGameEvent("player_disconnect", Dynamic_Wrap( self, "OnPlayerDisconnect" ), self)
    CustomGameEventManager:RegisterListener("GetDailyAwardButton",function(_, keys)
        self:GetDailyAwardButton(keys)
    end)
    CustomGameEventManager:RegisterListener("GetBpAwardButton",function(_, keys)
        self:GetBpAwardButton(keys)
    end)
    
end

function Quests:SetPlayerData(pid, daily, bp, settings)
    self.settings[pid] = {}
    self.settings[pid].quest_auto_submit = settings.quest_auto_submit or 0
    self.daily[pid] = {}
    for k,v in pairs(daily) do
        self.daily[pid][tonumber(k)] = {}
        for key,value in pairs(v) do
            self.daily[pid][tonumber(k)][key] = value
        end
    end
    for i = 1, self.daily_tasks_number do
        local index = self.daily[pid][i]['index']
        for key, value in pairs(self.daily_tasks_list[index]) do
            self.daily[pid][i][key] = value
        end
    end
    self.bp[pid] = {}
    for k,v in pairs(bp) do
        self.bp[pid][tonumber(k)] = {}
        for key,value in pairs(v) do
            self.bp[pid][tonumber(k)][key] = value
        end
    end
    for i = 1, 2 do
        local index = self.bp[pid][i].index
        for key, value in pairs(self.bp_tasks_list[index]) do
            self.bp[pid][i][key] = value
        end
    end
    self:UpdateTable(pid)
end
function Quests:UpdateDailyQuets(pid, index)
    if DataBase:IsCheatMode() then return end
    for _, data in pairs(self.daily[pid]) do
        if data.index == index then
            if data.now >= data.count then return end
            if not data.count_after_victory and self:IsGameVictory() then return end
            if data.now + 1 == data.count then self:PlaySound(pid) end
            data.now = data.now + 1
            self:UpdateTable(pid)
            break
        end
    end
end
function Quests:UpdateBpQuets(pid, index)
    if DataBase:IsCheatMode() then return end
    for _, data in pairs(self.bp[pid]) do
        if data.index == index then
            if data.now >= data.count then return end
            if not data.count_after_victory and self:IsGameVictory() then return end
            if data.now + 1 == data.count then self:PlaySound(pid) end
            data.now = data.now + 1
            self:UpdateTable(pid)
            break
        end
    end
end
function Quests:UpdateCounter(quest_type, pid, index, index2)
    if quest_type == "daily" then
        self:UpdateDailyQuets(pid, index)
    end
    if quest_type == "bp" then
        self:UpdateBpQuets(pid, index)
    end
    if quest_type == "main" or quest_type == "bonus" then
        QuestSystem:UpdateCounter(quest_type, index, index2, pid)
    end
end

function Quests:GetDailyAwardButton(t)
    if DataBase:IsCheatMode() then return end
    for _, data in pairs(self.daily[t.PlayerID]) do
        if data.index == t.index and data.now >= data.count then
            local received = 0
            for _, data2 in pairs(self.daily[t.PlayerID]) do
                if data2.received == 1 then 
                    received = received + 1
                end
            end
            local prize = 0
            if received == 0 then
                prize = 5
            elseif received >= 1 then
                prize = 10
            end
            data.received = 1
            prize = CustomShop:AddRP(t.PlayerID, prize, true, false)
            BattlePass:AddExperience(t.PlayerID, 100)
            DataBase:Send(DataBase.link.DailyReward, "GET", {
                id = data.id,
                prize = prize,
                now = data.now,
                pass_id = BattlePass.player[t.PlayerID].pass_id,
                experience = 100,
            }, t.PlayerID, not DataBase:IsCheatMode(), nil)
            self:UpdateTable(t.PlayerID)
            break
        end
    end
end

function Quests:GetBpAwardButton(t)
    if DataBase:IsCheatMode() then return end
    for _, data in pairs(self.bp[t.PlayerID]) do
        if data.index == t.index and data.now >= data.count and data.received == 0 then
            data.received = 1
            
            BattlePass:AddExperience(t.PlayerID, 1000)
            DataBase:Send(DataBase.link.BpReward, "GET", {
                id = data.id,
                now = data.now,
                pass_id = BattlePass.player[t.PlayerID].pass_id,
                experience = 1000,
            }, t.PlayerID, not DataBase:IsCheatMode(), nil)
            self:UpdateTable(t.PlayerID)
            break
        end
    end
end

function Quests:GetServerDataArray(pid)
    local data = {}
    for i = 1, #self.daily[pid] do
        local now = self.daily[pid][i].now
        if self.daily[pid][i].dont_save_unfinished_progress then
            now = 0
        end
		table.insert(data, {
			id = self.daily[pid][i].id,
			now = now,
		})
	end
    for i = 1, #self.bp[pid] do
		table.insert(data, {
			id = self.bp[pid][i].id,
			now = self.bp[pid][i].now,
		})
	end
    return data
end
function Quests:OnGameStateChanged(t)
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
        
    end
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        Timers:CreateTimer(60*60, function()
            for nPlayerID = 0, PlayerResource:GetPlayerCount()-1 do
                self:UpdateCounter("daily", nPlayerID, 29)
            end
		end)
    end
end

function Quests:OnEntityKilled(keys)
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    local killerEntity = EntIndexToHScript( keys.entindex_attacker ):GetOwnerEntity() or EntIndexToHScript( keys.entindex_attacker )
    if killerEntity:GetTeamNumber() ~= DOTA_TEAM_GOODGUYS or killedUnit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return
    end

	local unitName = killedUnit:GetUnitName()
    if not killerEntity.GetPlayerOwnerID and not killerEntity.GetPlayerID then return end
    if killerEntity.GetPlayerOwnerID then
        PlayerID = killerEntity:GetPlayerOwnerID()
    end
    if killerEntity.GetPlayerID then
        PlayerID = killerEntity:GetPlayerID()
    end
    -- Обновление счетчика для убийцы
    for _, data in pairs(self.daily[PlayerID]) do
        if data.event and table.has_value({"kill", "assistance"}, data.event) and (table.has_value(data.target, unitName) or table.has_value(data.target, "any")) then
            self:UpdateCounter("daily", PlayerID, data.index)
        end
    end
    -- Обновление счетчика для героев вокург
    local heroes = FindUnitsInRadius(killerEntity:GetTeamNumber(), killedUnit:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false )
    for _, unit in pairs(heroes) do
        if unit:GetPlayerID() ~= PlayerID then
            for _, data in pairs(self.daily[unit:GetPlayerID()]) do
                if data.event and data.event == "assistance" and (table.has_value(data.target, unitName) or table.has_value(data.target, "any")) then
                    self:UpdateCounter("daily", unit:GetPlayerID(), data.index)
                end
            end
        end
    end
    -- Обновление счетчика для убийцы
    for _, data in pairs(self.bp[PlayerID]) do
        if data.event and table.has_value({"kill", "assistance"}, data.event) and (table.has_value(data.target, unitName) or table.has_value(data.target, "any")) then
            self:UpdateCounter("bp", PlayerID, data.index)
        end
    end
    -- Обновление счетчика для героев вокург
    local heroes = FindUnitsInRadius(killerEntity:GetTeamNumber(), killedUnit:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false )
    for _, unit in pairs(heroes) do
        if unit:GetPlayerID() ~= PlayerID then
            for _, data in pairs(self.bp[unit:GetPlayerID()]) do
                if data.event and data.event == "assistance" and (table.has_value(data.target, unitName) or table.has_value(data.target, "any")) then
                    self:UpdateCounter("bp", unit:GetPlayerID(), data.index)
                end
            end
        end
    end
end
function Quests:OnNommedTree(t)
    self:UpdateCounter("daily", t.PlayerID, 41)
end
function Quests:OnItemDestroyed(t)
    self:UpdateCounter("daily", t.PlayerID, 46)
end
function Quests:OnPlayerDeath(t)
    local hero = EntIndexToHScript( t.userid ) 
    self:UpdateCounter("daily", hero:GetPlayerID(), 49)
end
function Quests:UpdateTable(pid)
    CustomNetTables:SetTableValue("quests", tostring(pid), {
        daily = self.daily[pid],
        bp = self.bp[pid],
    })
end
function Quests:IsGameVictory()
    return _G.kill_invoker
end
function Quests:OnGameEnd()
    for i = 0, 4 do
        if PlayerResource:IsValidPlayer(i) and PlayerResource:GetConnectionState(i) == DOTA_CONNECTION_STATE_CONNECTED then
            self:SaveData(i)
        end
    end
end
function Quests:OnPlayerDisconnect(t)
    self:SaveData(t.PlayerID)
end
function Quests:PlaySound(pid)
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "PlayCompletionSound", {})
end
function Quests:SaveData(pid)
    DataBase:Send(DataBase.link.SaveQuestsData, "GET", {
        data = self:GetServerDataArray(pid),
    }, pid, not DataBase:IsCheatMode(), nil)
end
Quests:init()
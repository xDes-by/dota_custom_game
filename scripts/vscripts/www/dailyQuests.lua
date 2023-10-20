if DailyQuests == nil then
    _G.DailyQuests = class({})
end

function DailyQuests:init()
    self.tasksNumber = 3
    self.player = {}
    self.tasksForToday = {}
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( self, 'OnGameStateChanged' ), self )
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( self, "OnEntityKilled" ), self)
    CustomGameEventManager:RegisterListener("GetDailyAwardButton",function(_, keys)
        self:GetAwardButton(keys)
    end)
end

function DailyQuests:SetTodayTasks(data)
    for i = 1, self.tasksNumber do
        table.insert(self.tasksForToday, data.tasks[i])
    end
    self.startDate = data.date
end
function DailyQuests:SetPlayerData(pid, data)
    self.player[pid] = {data.tasks[1],data.tasks[2],data.tasks[3]}
end


function DailyQuests:UpdateCounter(pid, index)
    if DataBase:IsCheatMode() then return end
    for _, data in pairs(self.player[pid]) do
        if data.index == index then
            if data.now >= data.count then return end
            data.now = data.now + 1
            CustomNetTables:SetTableValue("Daily", tostring(pid), self.player[pid])
            break
        end
    end
end

function DailyQuests:OnGameStateChanged(t)
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
        Timers:CreateTimer(1, function()
            for nPlayerID = 0, PlayerResource:GetPlayerCount()-1 do
                for i = 1, self.tasksNumber do
                    for key, value in pairs(dailyTasks[self.tasksForToday[i]]) do
                        self.player[nPlayerID][i][key] = value
                    end
                end
                CustomNetTables:SetTableValue("Daily", tostring(nPlayerID), self.player[nPlayerID])
            end
		end)
    end
end

function DailyQuests:OnEntityKilled(keys)
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    local killerEntity = EntIndexToHScript( keys.entindex_attacker ):GetOwnerEntity() or EntIndexToHScript( keys.entindex_attacker )
    if killerEntity:GetTeamNumber() ~= DOTA_TEAM_GOODGUYS or killedUnit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return
    end
	local unitName = killedUnit:GetUnitName()
    print(unitName)
    local PlayerID = killerEntity:GetPlayerID()
    for _, data in pairs(self.player[PlayerID]) do
        if data.event and data.event == "kill" and (table.has_value(data.target, unitName) or table.has_value(data.target, "any")) then
            self:UpdateCounter(PlayerID, data.index)
        end
    end
    local heroes = FindUnitsInRadius(killerEntity:GetTeamNumber(), killedUnit:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false )
    for _, unit in pairs(heroes) do
        if unit:GetPlayerID() ~= PlayerID then
            for _, data in pairs(self.player[unit:GetPlayerID()]) do
                if data.event and data.event == "kill" and (table.has_value(data.target, unitName) or table.has_value(data.target, "any")) then
                    self:UpdateCounter(unit:GetPlayerID(), data.index)
                end
            end
        end
    end
end

function DailyQuests:GetAwardButton(t)
    for _, data in pairs(self.player[t.PlayerID]) do
        if data.index == t.index and data.now >= data.count then
            local received = 0
            for _, data2 in pairs(self.player[t.PlayerID]) do
                if data2.received == true then 
                    received = received + 1
                end
            end
            local prize = 0
            if received == 0 then
                prize = 5
            elseif received >= 1 and received <= 2 then
                prize = 10
            end
            DataBase:DailyAward(t.PlayerID, t.index, prize, data.now)
            Shop:AddRP(t.PlayerID, prize)
            data.received = true
            CustomNetTables:SetTableValue("Daily", tostring(t.PlayerID), self.player[t.PlayerID])
            break
        end
    end
end


DailyQuests:init()
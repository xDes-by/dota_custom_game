if BattlePass == nil then
    _G.BattlePass = class({})
end
function BattlePass:init()
    CustomGameEventManager:RegisterListener("GetAllReward",function(_, keys)
        self:GetAllReward(keys)
    end)
    CustomGameEventManager:RegisterListener("GetReward",function(_, keys)
        self:GetReward(keys)
    end)
    CustomGameEventManager:RegisterListener("bp_start_lua",function(_, keys)
        Shop:bp_start_lua(keys)
    end)
    self.player = {}
    self.reward = {
        base = battlePassBaseRewards,
        gold = battlePassGoldRewards,
        days = battlePassDailyRewards
    }
    self.ExpToLevelUp = battlePassLevelExperience
    ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( self, 'OnGameRulesStateChange'), self)
end

function BattlePass:OnGameRulesStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        CustomNetTables:SetTableValue('BattlePass', "reward", self.reward)
        CustomNetTables:SetTableValue('BattlePass', "ExpToLevelUp", self.ExpToLevelUp)
    end
end

function BattlePass:SetPlayerData(pid, obj)
    self.player[pid] = {}
    self.player[pid].level = PlayerBPData.level
    self.player[pid].exp = PlayerBPData.exp
    self.player[pid].available = PlayerBPData.available
    self.player[pid].day = PlayerBPData.day
    self.player[pid].premium = PlayerBPData.premium
    self.player[pid].AddLevel = 0
    -- self.player[sid].level = obj.level
    -- self.player[sid].exp = obj.exp
    -- self.player[sid].available = obj.bp_rewards
    -- self.player[sid].day = obj.day
    -- self.player[sid].premium = obj.premium
    -- self.player[sid].AddLevel = 0
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end

-- function BattlePass:bp_start_lua(t)
--     CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "bp_start_js", BattlePass.reward )
--     CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "bp_available_js", {
--         level = BattlePass.Level[t.PlayerID],
--         exp = BattlePass.exp[t.PlayerID],
--         available = BattlePass.available[t.PlayerID],
--         premium = BattlePass.premium[t.PlayerID],
--         day = BattlePass.day[t.PlayerID],
--     })
-- end

function BattlePass:BuyExp(pid, add)
    self:AddExp(pid, add)
    -- Server:BPSave(pid, self.player[pid].exp, self.player[pid].AddLevel)
    self.player[pid].AddLevel = 0
end

function BattlePass:AddExp(id, add)
    -- Начисление опыта
    LevelAdd = 0    -- кол-во уровней полученный за опыт
    
    level = {}
    exp = {}
    -- уровень и опыт до изменений
    level[1] = self.player[id]['level']
    exp[1] = self.player[id]['exp']
    exp[2] = self.player[id]['exp']
    -- Я ваще хз что тут происходит
    while true do
        level[2] = level[1] + LevelAdd
        if  self.ExpToLevelUp[level[2]+1] 
        and self.ExpToLevelUp[level[2]+1] <= exp[2] + add then
            LevelAdd = LevelAdd + 1
            add = add - self.ExpToLevelUp[level[2]+1] + exp[2]
            exp[2] = 0
        else
            exp[2] = exp[2] + add
            break
        end
    end
    -- ваще хз
    self.player[id]['exp'] = exp[2]
    for i=1, LevelAdd do
        local nextLevel = self.player[id]['level'] + 1
        self.player[id]['level'] = nextLevel
        self.player[id].available['base'][tostring(nextLevel)] = true
        self.player[id].available['gold'][tostring(nextLevel)] = {true, true}
    end
    
    -- до сих пор не ебу
    self.player[id].AddLevel = self.player[id].AddLevel + LevelAdd
    CustomNetTables:SetTableValue('BattlePass', tostring(id), self.player[id])
end

function BattlePass:GetReward(t)
    if not self.player[t.PlayerID].available[t.type][tostring(t.number)] then print("return") return end
    self.player[t.PlayerID].available[t.type][tostring(t.number)] = false
    local reward
    if t.type == "gold" then
        reward = self.reward[t.type][t.number][t.layer]
    end
    if t.type == "base" then
        reward = self.reward[t.type][t.number]
    end
    if t.type == "day" then
        reward = self.reward[t.type][t.number]
    end
    CustomNetTables:SetTableValue('BattlePass', tostring(t.PlayerID), self.player[t.PlayerID])
    Server:GetReward(t.PlayerID, t.type, t.number, t.layer)
end

function BattlePass:GetAllReward(t)
    for i = 1, self.player[t.PlayerID].level do
        self.player[t.PlayerID].available['base'][tostring(i)] = false
        if self.player[t.PlayerID].premium then
            self.player[t.PlayerID].available['gold'][tostring(i)][1] = false
            self.player[t.PlayerID].available['gold'][tostring(i)][2] = false
        end
    end
    CustomNetTables:SetTableValue('BattlePass', tostring(t.PlayerID), self.player[t.PlayerID])
    Server:GetAllReward(t.PlayerID)
end

function BattlePass:TakeReward(t)
    



    if reward.info.type == 'chest' then
        t.add = reward.info.add or 1
        t.type = reward.info.type
        t.number = reward.info.number
        Shop:Give(t)
    end
end
function BattlePass:bp_take_lua(t)
    BattlePass:TakeReward(t)
end
function BattlePass:bp_take_all_lua(t)
    for i = 1, self.Level[t.PlayerID] do
        self:TakeReward({PlayerID = t.PlayerID, number = i, type = 'base'})
        self:TakeReward({PlayerID = t.PlayerID, number = i, type = 'gold'})
    end
end

function BattlePass:GiveLevel(t)
    self.Level[t.PlayerID] = self.Level[t.PlayerID] + t.add

    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "bp_available_js", {
        level = self.Level[t.PlayerID],
        exp = self.exp[t.PlayerID],
        available = self.available[t.PlayerID],
        premium = self.premium[t.PlayerID],
    })
end

function BattlePass:GivePremium(t)
    self.premium[t.PlayerID] = true
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "bp_available_js", {
        level = self.Level[t.PlayerID],
        exp = self.exp[t.PlayerID],
        available = self.available[t.PlayerID],
        premium = self.premium[t.PlayerID],
    })
end
BattlePass:init()
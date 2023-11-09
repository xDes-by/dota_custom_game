if BattlePass == nil then
    _G.BattlePass = class({})
end
function BattlePass:init()
    CustomGameEventManager:RegisterListener("GetAllReward",function(_, keys)
        self:GetAllReward(keys)
    end)
    CustomGameEventManager:RegisterListener("BattlePassClaimReward",function(_, keys)
        self:ClaimReward(keys)
    end)
    CustomGameEventManager:RegisterListener("bp_start_lua",function(_, keys)
        Shop:bp_start_lua(keys)
    end)
    self.player = {}
    self.levelMax = 30
    self.reward = battlePassRewards
    self.ExpToLevelUp = {}
    self.ExpToLevelUp[0] = 0
    for i=1,self.levelMax do
        self.ExpToLevelUp[i] = self.ExpToLevelUp[i-1] + battlePassLevelExperience[i]
    end
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
    self.player[pid].level = self:CalculateLevelFromExperience(obj.experience)
    self.player[pid].experience = obj.experience
    self.player[pid].premium = obj.premium
    self.player[pid].list = {}
    for i = 1, 90 do
        self.player[pid].list[i] = obj[i]
    end
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
----------------- HELPERS ------------------------------------
function BattlePass:CalculateLevelFromExperience(experience)
    for i = 1, self.levelMax do
        if experience < self.ExpToLevelUp[i] then
            return i-1
        end
    end
    return self.levelMax
end
function BattlePass:DetermineRewardType(number_type)
    if number_type > 0 then return "premium" end
    return "free"
end
function BattlePass:DetermineRewardIndex(number_type, number_level)
    if number_type == 0 then return number_level end
    if number_type == 1 then return number_level * 2 - 1 + self.levelMax end
    if number_type == 2 then return number_level * 2 + self.levelMax end
end
function BattlePass:DetermineRewardLevel(reward_type, reward_index)
    if reward_type == "free" then return reward_index end
    return math.ceil((reward_index-self.levelMax)/2)
end
function BattlePass:DetermineRewardDataByIndex(reward_index)
    if reward_index <= self.levelMax then return self.reward['free'][reward_index] end
    local a = math.floor(reward_index - self.levelMax)
    local b = 1
    if reward_index % 2 == 0 then b = 2 end
    return self.reward['premium'][a][b]
end
function BattlePass:IsRewardAvailable(pid, reward_type, reward_index)
    local level = self:DetermineRewardLevel(reward_type, reward_index)
    if reward_type == "premium" and self.player[pid].premium == 0 then return false end
    if level > self.player[pid].level then return false end
    if self.player[pid].list[reward_index] ~= nil then return false end
    return true
end
function BattlePass:CalculateAvailableRewardsCount(pid)
    local count = 0
    for index = 1, self.player[pid].level do
        if self.player[pid].list[index] == nil then
            count = count + 1
        end
    end
    if self.player[pid].premium == 1 then
        for index = self.levelMax + 1, self.player[pid].level * 2 + self.levelMax do
            if self.player[pid].list[index] == nil and self:DetermineRewardDataByIndex(index) then
                count = count + 1
            end
        end
    end
    return count
end
----------------- /HELPERS ------------------------------------
function BattlePass:ActivatePremium(pid)
    self.player[pid].premium = 1
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
function BattlePass:ResetProgress(pid)
    self.player[pid].experience = 0
    self.player[pid].level = self:CalculateLevelFromExperience(self.player[pid].experience)
    for i = 1, self.levelMax do
        self.player[pid].list[i] = nil
    end
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
function BattlePass:AddExperience(pid, value)
    self.player[pid].experience = self.player[pid].experience + value
    self.player[pid].level = self:CalculateLevelFromExperience(self.player[pid].experience)
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
function BattlePass:ClaimReward(t)
    local pid = t.PlayerID
    local reward_type = self:DetermineRewardType(t.number_type)
    local reward_index = self:DetermineRewardIndex(t.number_type, t.reward_level)
    if not self:IsRewardAvailable(pid, reward_type, reward_index) then return end
    local reward_data = self:DetermineRewardDataByIndex(reward_index)
    self.player[pid].list[reward_index] = reward_data.data.value
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
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
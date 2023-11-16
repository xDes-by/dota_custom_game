if BattlePass == nil then
    _G.BattlePass = class({})
end
function BattlePass:init()
    CustomGameEventManager:RegisterListener("BattlePassClaimAllRewards",function(_, keys)
        self:ClaimAllRewards(keys)
    end)
    CustomGameEventManager:RegisterListener("BattlePassClaimReward",function(_, keys)
        self:ClaimReward(keys)
    end)
    CustomGameEventManager:RegisterListener("BattlePassSelectReward",function(_, keys)
        self:SelectReward(keys)
    end)
    CustomGameEventManager:RegisterListener("BattlePassHeroVote",function(_, keys)
        self:OnVote(keys)
    end)
    CustomGameEventManager:RegisterListener("BattlePassBuy",function(_, keys)
        self:OnBuy(keys)
    end)
    self.shop = battle_pass_shop
    self.player = {}
    self.levelMax = 30
    self.dataReward = battlePassRewards
    self.ExpToLevelUp = {}
    self.ExpToLevelUp[0] = 0
    for i=1,self.levelMax do
        self.ExpToLevelUp[i] = self.ExpToLevelUp[i-1] + battlePassLevelExperience[i]
    end
    self.voting_heroes_list = {}
    for key, value in pairs(voting_heroes_list) do
        self.voting_heroes_list[key] = value
        self.voting_heroes_list[key].index = key
    end
    ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( self, 'OnGameRulesStateChange'), self)
end

function BattlePass:OnGameRulesStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        CustomNetTables:SetTableValue('BattlePass', "dataReward", self.dataReward)
        CustomNetTables:SetTableValue('BattlePass', "ExpToLevelUp", self.ExpToLevelUp)
        CustomNetTables:SetTableValue('BattlePass', "VotingHeroesList", self.voting_heroes_list)
    end
end

function BattlePass:SetPlayerData(pid, obj)
    self.player[pid] = {}
    self.player[pid].level = self:CalculateLevelFromExperience(obj.experience)
    self.player[pid].experience = obj.experience
    self.player[pid].premium = obj.premium
    self.player[pid].pass_id = obj.battle_pass_id
    self.player[pid].rewards = {}
    self.player[pid].vote = obj.vote or ""
    self.player[pid].exp_current_game = 0
    for i = 1, self.levelMax * 2 do
        local reward_index = obj.rewards[i].reward_index
        self.player[pid].rewards[reward_index] = obj.rewards[i]
    end
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
----------------- ACTION FUNCTIONS ----------------------------
function BattlePass:ActivatePremium(pid)
    self.player[pid].premium = 1
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
function BattlePass:ResetProgress(pid)
    self.player[pid].experience = 0
    self.player[pid].level = self:CalculateLevelFromExperience(self.player[pid].experience)
    for i = 1, self.levelMax * 3 do
        self.player[pid].rewards[i].claimed = 0
        self.player[pid].rewards[i].choice_count = 0
    end
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
    DataBase:Send(DataBase.link.ResetProgress, "GET", {
        pass_id = self.player[pid].pass_id
    }, pid, true, nil)
end
function BattlePass:AddExperience(pid, value, write)
    if write == true then
        self.player[pid].exp_current_game = self.player[pid].exp_current_game + value
    end
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
    self.player[pid].rewards[reward_index].claimed = 1
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
    self:GiveOutReward(pid, reward_index)
end
function BattlePass:ClaimAllRewards(t)
    local choice_index = {}
    local claime = {}
    local pid = t.PlayerID
    for index = 1, self.player[pid].level do
        local data = self:DetermineRewardDataByIndex(index)
        if data and data.data.choice_count and self.player[pid].rewards[index].claimed == 0 then
            table.insert(choice_index, index)
        elseif data and self.player[pid].rewards[index].claimed == 0 then
            table.insert(claime, index)
            self.player[pid].rewards[index].claimed = 1
        end
    end
    if self.player[pid].premium == 1 then
        for index = self.levelMax + 1, self.player[pid].level * 2 + self.levelMax do
            local data = self:DetermineRewardDataByIndex(index)
            if data and data.data.choice_count and self.player[pid].rewards[index].claimed == 0 then
                table.insert(choice_index, index)
            elseif data and self.player[pid].rewards[index].claimed == 0 then
                table.insert(claime, index)
                self.player[pid].rewards[index].claimed = 1
            end
        end
    end
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( pid ), "BattlePass_ClaimAllRewards_ChoiceIndex", choice_index )
end
function BattlePass:SelectReward(t)
    local pid = t.PlayerID
    local choice_index = t.choice_index
    local reward_index = self:DetermineRewardIndex(t.number_type, t.reward_level)
    local data = self:DetermineRewardDataByIndex(reward_index)
    self.player[pid].rewards[reward_index].choice_count = self.player[pid].rewards[reward_index].choice_count + 1
    if self.player[pid].rewards[reward_index].choice_count >= data.data.choice_count then
        self.player[pid].rewards[reward_index].claimed = 1
    end
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
    self:GiveOutReward(pid, reward_index, choice_index)
end
function BattlePass:OnVote(t)
    local pid = t.PlayerID
    if self.player[pid].premium == 0 then return end
    self:DecrementVoteCount(self.player[pid].vote)
    if self.player[pid].vote == t.hero_name then
        self.player[pid].vote = ""
    else
        self.player[pid].vote = t.hero_name
        self:IncrementVoteCount(t.hero_name)
    end
    CustomNetTables:SetTableValue('BattlePass', "VotingHeroesList", self.voting_heroes_list)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
    DataBase:Send(DataBase.link.HeroVote, "GET", {
        pass_id = self.player[pid].pass_id,
        hero_name = self.player[pid].vote,
    }, pid, true, nil)
end
function BattlePass:GiveOutReward(pid, reward_index, choice_index)
    local reward_data = self:DetermineRewardDataByIndex(reward_index)
    local send_data = {
        reward_info = {
            id = self.player[pid].rewards[reward_index].id,
            reward_index = self.player[pid].rewards[reward_index].reward_index,
            claimed = self.player[pid].rewards[reward_index].claimed,
            choice_count = self.player[pid].rewards[reward_index].choice_count,
        }
    }
    send_data = self:GemsReward(reward_data, send_data, pid)
    send_data = self:TalentNormalExperience(pid, reward_data, send_data)
    send_data = self:TalentGoldenExperience(pid, reward_data, send_data)
    send_data = self:AddRpReward(reward_data, send_data, pid)
    send_data = self:AddCoinsReward(reward_data, send_data, pid)
    send_data = self:AddBoosterExperience(reward_data, send_data, pid)
    send_data = self:AddBoosterRp(reward_data, send_data, pid)
    send_data = self:AddItem(reward_data, send_data)
    send_data = self:PetAccess(reward_data, send_data, pid, choice_index)
    send_data = self:ExtraSouls(reward_data, send_data, pid, choice_index)
    DataBase:Send(DataBase.ClaimReward, "GET", send_data, pid, not DataBase:IsCheatMode(), function(body)
        print(body)
    end)
end
function BattlePass:OnBuy(t)
    local pid = t.PlayerID
    local name = t.name
    local currency = t.currency
    local amount = tonumber(t.amount)
    if currency == 'don' and not (self.shop[name].price.don ~= nil and Shop.pShop[pid]["coins"] >= self.shop[name].price.don * amount) then
        return
    end
    if currency == 'rp' and not (self.shop[name].price.rp ~= nil and Shop.pShop[pid]["mmrpoints"] >= self.shop[name].price.rp * amount) then
        return
    end
    local send = {}
    if currency == 'don' then
        Shop.pShop[pid]["coins"] = Shop.pShop[pid]["coins"] - self.shop[name].price.don * amount
        send.don = self.shop[name].price.don * amount
    end
    if currency == 'rp' then
        Shop.pShop[pid]["mmrpoints"] = Shop.pShop[pid]["mmrpoints"] - self.shop[name].price.rp * amount
        send.rp = self.shop[name].price.rp * amount
    end
    send.pass_id = self.player[pid].pass_id
    if name == "bp_premium" then
        self:ActivatePremium(pid)
        send.bp_premium = 1
    end
    if name == "bp_experience" then
        self:AddExperience(pid, self.shop[name].give * amount, false)
        send.bp_experience = self.shop[name].give * amount
    end
    CustomShop:UpdateShopInfoTable(pid)
    DataBase:Send(DataBase.link.BattlePassBuy, "GET", send, pid, not DataBase:IsCheatMode(), nil)
end
----------------- /ACTION FUNCTIONS ----------------------------
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
    if number_type == 1 then return number_level + self.levelMax end
end
function BattlePass:DetermineRewardLevel(reward_type, reward_index)
    if reward_type == "free" then return reward_index end
    return reward_index - self.levelMax
end
function BattlePass:DetermineRewardDataByIndex(reward_index)
    if reward_index <= self.levelMax then return self.dataReward['free'][reward_index] end
    return self.dataReward['premium'][reward_index - self.levelMax]
end
function BattlePass:IsRewardAvailable(pid, reward_type, reward_index)
    local level = self:DetermineRewardLevel(reward_type, reward_index)
    if reward_type == "premium" and self.player[pid].premium == 0 then return false end
    if level > self.player[pid].level then return false end
    if self.player[pid].rewards[reward_index].claimed == 1 then return false end
    return true
end
function BattlePass:CalculateAvailableRewardsCount(pid)
    local count = 0
    for index = 1, self.player[pid].level do
        if self.player[pid].rewards[index].claimed == 0 then
            count = count + 1
        end
    end
    if self.player[pid].premium == 1 then
        for index = self.levelMax + 1, self.player[pid].level + self.levelMax do
            if self.player[pid].rewards[index].claimed == 0 and self:DetermineRewardDataByIndex(index) then
                count = count + 1
            end
        end
    end
    return count
end
function BattlePass:DecrementVoteCount(hero_name)
    for _, value in pairs(self.voting_heroes_list) do
        if value.name == hero_name then
            value.vote = value.vote -1
        end
    end
end
function BattlePass:IncrementVoteCount(hero_name)
    for _, value in pairs(self.voting_heroes_list) do
        if value.name == hero_name then
            value.vote = value.vote +1
        end
    end
end
----------------- /HELPERS ------------------------------------
----------------- REWARDS ------------------------------------
function BattlePass:GemsReward(reward_data, send_data, pid)
    if reward_data.reward_type == "gems" then
        local add_value = reward_data.data.value
        if not send_data.gems then
            send_data.gems = {0,0,0,0,0}
        end
        send_data.gems[1] = send_data.gems[1] + add_value
        send_data.gems[2] = send_data.gems[2] + add_value
        send_data.gems[3] = send_data.gems[3] + add_value
        send_data.gems[4] = send_data.gems[4] + add_value
        send_data.gems[5] = send_data.gems[5] + add_value
        CustomShop:AddGems(pid, send_data.gems, false)
    end
    return send_data
end
function BattlePass:TalentNormalExperience(pid, reward_data, send_data)
    if reward_data.reward_type == "experience_common" then
        talants:AddExperience(pid, reward_data.data.value)
    end
    return send_data
end
function BattlePass:TalentGoldenExperience(pid, reward_data, send_data)
    if reward_data.reward_type == "experience_golden" then
        talants:AddExperienceDonate(pid, reward_data.data.value)
    end
    return send_data
end
function BattlePass:AddRpReward(reward_data, send_data, pid)
    if reward_data.reward_type == "rp" then
        local add_value = reward_data.data.value
        if not send_data.rp then
            send_data.rp = 0
        end
        send_data.rp = CustomShop:AddRP(pid, send_data.rp, true, false)
    end
    return send_data
end
function BattlePass:AddCoinsReward(reward_data, send_data, pid)
    if reward_data.reward_type == "coins" then
        local add_value = reward_data.data.value
        if not send_data.coins then
            send_data.coins = 0
        end
        send_data.coins = send_data.coins + add_value
        CustomShop:AddCoins(pid, send_data.coins, true, false)
    end
    return send_data
end
function BattlePass:AddBoosterExperience(reward_data, send_data, pid)
    if reward_data.reward_type == "boost_experience" then
        if not send_data.booster_experience then
            send_data.booster_experience = {}
        end
        local data = {
            multiplier = reward_data.data.value,
            remaining_games_count = reward_data.data.game_count,
        }
        table.insert(send_data.booster_experience, data)
        MultiplierManager:InsertTalentExperienceList(pid, data)
    end
    return send_data
end
function BattlePass:AddBoosterRp(reward_data, send_data, pid)
    if reward_data.reward_type == "boost_rp" then
        if not send_data.booster_rp then
            send_data.booster_rp = {}
        end
        local data = {
            multiplier = reward_data.data.value,
            remaining_games_count = reward_data.data.game_count,
        }
        table.insert(send_data.booster_rp, data)
        MultiplierManager:InsertCurrencyRpList(pid, data)
    end
    return send_data
end
function BattlePass:FindDBItemNameByDotaItemName(item_name)
    for categoryKey, category in ipairs(_G.basicshop) do
        for itemKey, item in ipairs(category) do
            if item.itemname and item.itemname == item_name then
                return item.name
            end
        end
    end
    return false
end
function BattlePass:AddItem(reward_data, send_data)
    if table.has_value({"item_scroll","item_forever_ward","item_boss_summon","item_ticket"},reward_data.reward_type) then
        if not send_data.items then
            send_data.items = {}
        end
        table.insert(send_data.items, {
            name = self:FindDBItemNameByDotaItemName(reward_data.data.item_name),
            value = reward_data.data.value,
        })
    end
    return send_data
end
function BattlePass:PetAccess(reward_data, send_data, pid, choice_index)
    if table.has_value({"pet_access150","pet_access250"},reward_data.reward_type) then
        if not send_data.pets then
            send_data.pets = {}
        end
        local data = {
            name = Pets:FindPetDataByAbilityName(reward_data.data.choice[choice_index]).name,
            value = reward_data.data.value,
            remaining_games_count = reward_data.data.game_count,
        }
        table.insert(send_data.pets, data)
        if Pets.player[pid][data.name] == nil or Pets.player[pid][data.name].value <= data.value then
            Pets.player[pid][data.name] = data
            CustomNetTables:SetTableValue('Pets', tostring(pid), Pets.player[pid])
        end
    end
    return send_data
end
function BattlePass:ExtraSouls(reward_data, send_data, pid, choice_index)
    if reward_data.reward_type == "soul" then
        if not send_data.souls then
            send_data.souls = {}
        end
        local data = {
            name = reward_data.data.choice[choice_index],
            days_count = reward_data.data.days_count,
        }
        table.insert(send_data.souls, data)
        sInv:AddSoul(data.name, pid)
    end
    return send_data
end
----------------- /REWARDS ------------------------------------

BattlePass:init()
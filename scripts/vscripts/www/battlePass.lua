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
    CustomGameEventManager:RegisterListener("BattlePassInventoryItemSelect",function(_, keys)
        self:OnInventorySelection(keys)
    end)
    CustomGameEventManager:RegisterListener("BattlePassRefreshVoteCount",function(_, keys)
        self:RefreshVoteCount(keys)
    end)
    ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( self, 'OnGameRulesStateChange'), self)
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
    self.pet_exclusive = 29
    self.effect = {{'free', 9},{'free', 19},{'free', 29},{'premium', 9},{'premium', 19},{'premium', 27}}
    self.hero_model = { 10,20,30 }
end

function BattlePass:OnGameRulesStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        CustomNetTables:SetTableValue('BattlePass', "dataReward", self.dataReward)
        CustomNetTables:SetTableValue('BattlePass', "ExpToLevelUp", self.ExpToLevelUp)
    end
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        for pid = 0, 4 do
            if PlayerResource:IsValidPlayer(pid) and PlayerResource:HasSelectedHero(pid) then
                Timers:CreateTimer(function()
                    if PlayerResource:GetSelectedHeroEntity( pid ) and self.player[pid] ~= nil then
                        local hero = PlayerResource:GetSelectedHeroEntity(pid)
                        for hero_name, value in pairs(self.player[pid].auto_models) do
                            if hero:GetUnitName() == hero_name and value == true then
                                Wearable:SetAlternative(pid)
                            end
                        end
                        if self.player[pid].auto_projectile_particle ~= "" then
                            self:AddPariticle(pid, self.player[pid].auto_projectile_particle, self.player[pid].projectile_particles, true)
                        end
                        if self.player[pid].auto_following_particle ~= "" then
                            self:AddPariticle(pid, self.player[pid].auto_following_particle, self.player[pid].following_particles, true)
                        end
                        return nil
                    end
                    return 0.1
                end)
            end
        end
    end
end

function BattlePass:SetPlayerData(pid, obj, settings)
    self.player[pid] = {}
    self.player[pid].level = self:CalculateLevelFromExperience(obj.experience)
    self.player[pid].experience = obj.experience
    self.player[pid].premium = obj.premium
    self.player[pid].pass_id = obj.battle_pass_id
    self.player[pid].rewards = {}
    self.player[pid].vote = obj.vote or ""
    self.player[pid].exp_current_game = 0
    self.player[pid].auto_projectile_particle = settings.projectile_particle
    self.player[pid].auto_following_particle = settings.following_particle
    self.player[pid].auto_models = json.decode(settings.models)
    for i = 1, self.levelMax * 2 do
        local reward_index = obj.rewards[i].reward_index
        self.player[pid].rewards[reward_index] = obj.rewards[i]
    end
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
function BattlePass:SetVoteList(db_vote)
    self.voting_heroes_list = {}
    for _, name in pairs(battle_pass_vote[BattlePass.current_season]) do
        self.voting_heroes_list[name] = 0
    end
    for _, value in pairs(db_vote) do
        if self.voting_heroes_list[value.vote] then
            self.voting_heroes_list[value.vote] = tonumber(value.vote_count)
        end
    end
    CustomNetTables:SetTableValue('BattlePass', "VotingHeroesList", self.voting_heroes_list)
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
    for i = 1, self.levelMax * 2 do
        self.player[pid].rewards[i].claimed = 0
        self.player[pid].rewards[i].choice_count = 0
    end
    self.player[pid].rewardCount = self:CalculateAvailableRewardsCount(pid)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
    DataBase:Send(DataBase.link.ResetProgress, "GET", {
        pass_id = self.player[pid].pass_id
    }, pid, true, nil)
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
    if self.player[pid].rewards[reward_index].claimed == 1 then return end
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
    if self.player[pid].rewards[reward_index].claimed == 1 then return end
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
    print(self.player[pid].vote)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
    CustomNetTables:SetTableValue('BattlePass', "VotingHeroesList", self.voting_heroes_list)
    DataBase:Send(DataBase.link.HeroVote, "GET", {
        pass_id = self.player[pid].pass_id,
        hero_vote = self.player[pid].vote,
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
    send_data = self:TalentGoldenExperience(reward_data, send_data, pid, choice_index)
    send_data = self:AddRpReward(reward_data, send_data, pid)
    send_data = self:AddCoinsReward(reward_data, send_data, pid)
    send_data = self:AddBoosterExperience(reward_data, send_data, pid)
    send_data = self:AddBoosterRp(reward_data, send_data, pid)
    send_data = self:ForeverWard(reward_data, send_data, pid)
    send_data = self:PetAccess(reward_data, send_data, pid, choice_index)
    send_data = self:ExtraSouls(reward_data, send_data, pid, choice_index)
    send_data = self:ExclusivePet(reward_data, send_data)
    send_data = self:Particle(reward_data, send_data, pid)
    send_data = self:Model(reward_data, send_data)
    send_data = self:HeroAccess(reward_data, send_data, choice_index)
    send_data = self:Treasury(reward_data, send_data, pid, choice_index)
    send_data = self:Scroll(reward_data, send_data, pid, choice_index)
    send_data = self:BossSummonTicket(reward_data, send_data, pid, choice_index)
    send_data = self:GoldenBranch(reward_data, send_data, pid)

    DataBase:Send(DataBase.ClaimReward, "GET", send_data, pid, not DataBase:IsCheatMode(), function(body)
        if send_data.pet_exclusive ~= nil then
            local pet_exclusive = json.decode(body)[1]
            Pets.player[pid][pet_exclusive.name] = pet_exclusive
            CustomNetTables:SetTableValue('Pets', tostring(pid), Pets.player[pid])
        end
        if send_data.effects ~= nil then
            local effects = json.decode(body)[1]
            local data = self:FindParticleDataByName(effects.name)
            if data.type == "projectile" then
                table.insert(self.player[pid].projectile_particles, data)
            end
            if data.type == "following" then
                table.insert(self.player[pid].following_particles, data)
            end
            CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
            if data.type == "projectile" then
                self:AddPariticle(pid, data.name, self.player[pid].projectile_particles, true)
                self:SetSelectedParticle(pid, "projectile_particle", data.name, true)
            elseif data.type == "following" then
                self:AddPariticle(pid, data.name, self.player[pid].following_particles, true)
                self:SetSelectedParticle(pid, "following_particle", data.name, true)
            end
        end
        if send_data.models ~= nil then
            local models = json.decode(body)[1]
            local data = self:FindModelDataByName(models.name)
            table.insert(self.player[pid].models, data)
            CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
            self:SetSelectedModel(pid, models.name, true)
        end
        if send_data.pets ~= nil then
            local pet = json.decode(body)[1]
            Pets.player[pid].pets[pet.name] = json.decode(body)
            CustomNetTables:SetTableValue('Pets', tostring(pid), Pets.player[pid])
        end
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
function BattlePass:AddPariticle(pid, name, tab, checked)
    local hero = PlayerResource:GetSelectedHeroEntity( pid )
    for _, value in pairs(tab) do
        hero:RemoveModifierByName( value.modifier )
        if value.name == name and checked == true then
            LinkLuaModifier( value.modifier, "effects/" .. value.modifier, LUA_MODIFIER_MOTION_NONE )
            hero:AddNewModifier( hero, nil, value.modifier, {} )
        end
    end
end
function BattlePass:SetSelectedParticle(pid, variable, name, checked)
    if checked then
        self.player[pid]['auto_'..variable] = name
    else
        self.player[pid]['auto_'..variable] = ""
    end
    DataBase:Send(DataBase.link.SettingsSetParticle, "GET", {
        variable = variable,
        name = name,
    }, pid, true, nil)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
function BattlePass:SetSelectedModel(pid, name, hero_name, checked)
    self.player[pid].auto_models[name] = checked
    DataBase:Send(DataBase.link.SettingsSetAutoModels, "GET", {
        checked = checked,
        name = hero_name,
    }, pid, true, nil)
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
function BattlePass:OnInventorySelection(t)
    local pid = t.PlayerID
    local name = t.name
    local checked = t.checked == 1
    local IsNameInTable = function(name, tab)
        for _, value in pairs(tab) do
            if value.name == name then
                return true
            end
        end
        return false
    end
    if IsNameInTable(name, self.player[pid].projectile_particles) then
        self:AddPariticle(pid, name, self.player[pid].projectile_particles, checked)
        self:SetSelectedParticle(pid, "projectile_particle", name, checked)
    end
    if IsNameInTable(name, self.player[pid].following_particles) then
        self:AddPariticle(pid, name, self.player[pid].following_particles, checked)
        self:SetSelectedParticle(pid, "following_particle", name, checked)
    end
    if IsNameInTable(name, self.player[pid].models) then
        local data = self:FindModelDataByName(name)
        self:SetSelectedModel(pid, name, data.hero_name, checked)
        if data.hero_name == PlayerResource:GetSelectedHeroName(pid) and checked == true then
            Wearable:SetAlternative( pid )
        elseif data.hero_name == PlayerResource:GetSelectedHeroName(pid) and checked == false then
            Wearable:ClearWear(pid)
            Wearable:SetDefault( pid )
        end
    end
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
    for name, value in pairs(self.voting_heroes_list) do
        if name == hero_name then
            self.voting_heroes_list[name] = self.voting_heroes_list[name] -1
        end
    end
end
function BattlePass:IncrementVoteCount(hero_name)
    for name, value in pairs(self.voting_heroes_list) do
        if name == hero_name then
            self.voting_heroes_list[name] = self.voting_heroes_list[name] +1
        end
    end
end
function BattlePass:UpdateRewardsForCurrentSeason()
    self.dataReward['premium'][self.pet_exclusive].data.abilityname = battle_pass_pets[self.current_season].itemname
    self.dataReward['premium'][self.pet_exclusive].data.name = battle_pass_pets[self.current_season].name
    for key, value in pairs(battle_pass_effects[self.current_season]) do
        self.dataReward[self.effect[key][1]][self.effect[key][2]].data.name = value.name
        self.dataReward[self.effect[key][1]][self.effect[key][2]].data.modifier = value.modifier
        self.dataReward[self.effect[key][1]][self.effect[key][2]].data.video = value.video
    end
    for key, value in pairs(battle_pass_models[self.current_season]) do
        self.dataReward['premium'][self.hero_model[key]].data.name = value.name
        self.dataReward['premium'][self.hero_model[key]].data.hero_name = value.hero_name
        self.dataReward['premium'][self.hero_model[key]].data.image = value.image
        self.dataReward['premium'][self.hero_model[key]].data.video = value.video
    end
    CustomNetTables:SetTableValue('BattlePass', "dataReward", self.dataReward)
end
function BattlePass:UpdatePlayerCosmeticEffects(pid, items)
    local particles = {}
    for _, season_value in pairs(battle_pass_effects) do
        for _, particle in pairs(season_value) do
            if particle.name then
                particles[particle.name] = particle
            end
        end
    end
    local projectile_particles = {}
    local following_particles = {}
    for key, value in pairs(items) do
        if particles[value.name] ~= nil and value.value > 0 then
            if particles[value.name].type == "projectile" then
                projectile_particles[value.name] = particles[value.name]
            end
            if particles[value.name].type == "following" then
                following_particles[value.name] = particles[value.name]
            end
        end
    end
    self.player[pid].projectile_particles = {}
    self.player[pid].following_particles = {}
    for _, season_value in pairs(battle_pass_effects) do
        for _, particle in ipairs(season_value) do
            if particle.name and particle.type then
                if particle.type == "projectile" and projectile_particles[particle.name] then
                    table.insert(self.player[pid].projectile_particles, projectile_particles[particle.name])
                end
                if particle.type == "following" and following_particles[particle.name] then
                    table.insert(self.player[pid].following_particles, following_particles[particle.name])
                end
            end
        end
    end
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
function BattlePass:UpdatePlayerHeroModels(pid, items)
    local models = {}
    for _, season_value in pairs(battle_pass_models) do
        for _, model in pairs(season_value) do
            if model.name then
                models[model.name] = model
            end
        end
    end
    local models2 = {}
    for key, value in pairs(items) do
        if models[value.name] ~= nil and value.value > 0 then
            models2[value.name] = models[value.name]
        end
    end
    self.player[pid].models = {}
    for _, season_value in pairs(battle_pass_models) do
        for _, model in ipairs(season_value) do
            if model.name then
                table.insert(self.player[pid].models, models2[model.name])
            end
        end
    end
    CustomNetTables:SetTableValue('BattlePass', tostring(pid), self.player[pid])
end
function BattlePass:FindParticleDataByName(name)
    for _, season_value in pairs(battle_pass_effects) do
        for _, particle in pairs(season_value) do
            if particle.name and particle.name == name then
                return particle
            end
        end
    end
end
function BattlePass:FindModelDataByName(name)
    for _, season_value in pairs(battle_pass_models) do
        for _, model in pairs(season_value) do
            if model.name and model.name == name then
                return model
            end
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
        CustomShop:AddGems(pid, send_data.gems, not DataBase:IsCheatMode())
    end
    return send_data
end
function BattlePass:TalentNormalExperience(pid, reward_data, send_data)
    if reward_data.reward_type == "experience_common" then
        Talents:AddExperience(pid, reward_data.data.value, false)
    end
    return send_data
end
function BattlePass:TalentGoldenExperience(reward_data, send_data, pid, choice_index)
    if reward_data.reward_type == "experience_choice" then
        if reward_data.data.choice[choice_index] == 'experience_common' then
            Talents:AddExperience(pid, reward_data.data.value)
        end
        if reward_data.data.choice[choice_index] == 'experience_golden' then
            Talents:AddExperienceDonate(pid, reward_data.data.value, false)
        end
    end
    return send_data
end
function BattlePass:AddRpReward(reward_data, send_data, pid)
    if reward_data.reward_type == "rp" then
        if not send_data.rp then
            send_data.rp = 0
        end
        send_data.rp = send_data.rp + CustomShop:AddRP(pid, reward_data.data.value, true, false)
    end
    return send_data
end
function BattlePass:AddCoinsReward(reward_data, send_data, pid)
    if reward_data.reward_type == "coins" then
        if not send_data.coins then
            send_data.coins = 0
        end
        send_data.coins = send_data.coins + CustomShop:AddCoins(pid, reward_data.data.value, true, false)
    end
    return send_data
end
function BattlePass:AddBoosterExperience(reward_data, send_data, pid)
    if reward_data.reward_type == "boost_experience" then
        if not send_data.booster_experience then
            send_data.booster_experience = {}
        end
        local data = {
            name = 'booster_experience',
            value = reward_data.data.value,
            remaining_games_count = reward_data.data.game_count,
        }
        data.multiplier = data.value
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
            name = 'booster_rp',
            value = reward_data.data.value,
            remaining_games_count = reward_data.data.game_count,
        }
        data.multiplier = data.value
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
function BattlePass:ForeverWard(reward_data, send_data, pid)
    if reward_data.reward_type == 'item_forever_ward' then -- table.has_value({"item_scroll","item_forever_ward","item_boss_summon","item_ticket"},reward_data.reward_type) then
        if not send_data.items then
            send_data.items = {}
        end
        local data = {
            name = reward_data.data.name,
            value = 1
        }
        table.insert(send_data.items, data)
        Shop:AddItemByName(pid, data.name, data.value)
    end
    return send_data
end
function BattlePass:PetAccess(reward_data, send_data, pid, choice_index)
    if table.has_value({"pet_access150","pet_access250"},reward_data.reward_type) then
        if not send_data.pets then
            send_data.pets = {}
        end
        local data = {
            name = reward_data.data.choice[choice_index],
            value = reward_data.data.value,
            remaining_games_count = reward_data.data.game_count,
        }
        table.insert(send_data.pets, data)
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
            value = 1,
            days_count = reward_data.data.days_count,
        }
        table.insert(send_data.souls, data)
        sInv:AddSoul(data.name, pid)
    end
    return send_data
end
function BattlePass:ExclusivePet(reward_data, send_data)
    if reward_data.reward_type == "pet_exclusive" then
        if not send_data.pet_exclusive then
            send_data.pet_exclusive = {}
        end
        local data = {
            name = reward_data.data.name,
            value = 1;
        }
        table.insert(send_data.pet_exclusive, data)
    end
    return send_data
end
function BattlePass:Particle(reward_data, send_data, pid)
    if reward_data.reward_type == "effect" then
        if not send_data.effects then
            send_data.effects = {}
        end
        local data = {
            name = reward_data.data.name,
            value = 1;
        }
        table.insert(send_data.effects, data)
    end
    return send_data
end
function BattlePass:Model(reward_data, send_data, pid)
    if reward_data.reward_type == "hero_model" then
        if not send_data.models then
            send_data.models = {}
        end
        local data = {
            name = reward_data.data.name,
            value = 1;
        }
        table.insert(send_data.models, data)
    end
    return send_data
end
function BattlePass:HeroAccess(reward_data, send_data, choice_index)
    if reward_data.reward_type == "hero_access" then
        if not send_data.hero_access then
            send_data.hero_access = {}
        end
        local data = {
            name = reward_data.data.choice[choice_index],
            value = reward_data.data.game_count,
        }
        table.insert(send_data.hero_access, data)
    end
    return send_data
end
function BattlePass:Treasury(reward_data, send_data, pid, choice_index)
    if reward_data.reward_type == "treasury" then
        if not send_data.treasury then
            send_data.treasury = {}
        end
        local data = {
            name = reward_data.data.choice[choice_index],
            value = reward_data.data.value,
        }
        table.insert(send_data.treasury, data)
        Shop:AddItemByName(pid, data.name, data.value)
    end
    return send_data
end
function BattlePass:Scroll(reward_data, send_data, pid, choice_index)
    if table.has_value({'item_scroll1','item_scroll2'}, reward_data.reward_type) then
        if not send_data.scroll then
            send_data.scroll = {}
        end
        local data = {
            name = reward_data.data.choice[choice_index],
            value = reward_data.data.value,
        }
        table.insert(send_data.scroll, data)
        Shop:AddItemByName(pid, data.name, data.value)
    end
    return send_data
end
function BattlePass:BossSummonTicket(reward_data, send_data, pid, choice_index)
    if reward_data.reward_type == 'boss_summon_ticket' then
        if not send_data.items then
            send_data.items = {}
        end
        local data = {
            name = reward_data.data.choice[choice_index],
        }
        if data.name == 'scroll_12' then
            data.value = 3
        end
        if data.name == 'scroll_11' then
            data.value = 10
        end
        table.insert(send_data.items, data)
        Shop:AddItemByName(pid, data.name, data.value)
    end
    return send_data
end
function BattlePass:GoldenBranch(reward_data, send_data, pid)
    if reward_data.reward_type == 'golden_branch' then
        if not send_data.golden_branch then
            send_data.golden_branch = {}
        end
        local data = {
            name = 'golden_branch',
            days_count = reward_data.data.days_count,
            value = 1,
        }
        table.insert(send_data.golden_branch, data)
        Shop.pShop[pid].golden_branch = true
        if RATING["rating"][pid]["patron"] ~= 1 then
            Talents:ActivateGoldenBranch(pid)
        end
    end
    return send_data
end
function BattlePass:RefreshVoteCount(t)
    DataBase:Send(DataBase.link.RefreshVoteCount, "GET", {}, nil, true, function(body)
        self:SetVoteList(json.decode(body))
    end)
end
----------------- /REWARDS ------------------------------------

BattlePass:init()
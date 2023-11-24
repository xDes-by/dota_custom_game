if Talents == nil then
	_G.Talents = class({})
end

function Talents:init()
    CustomGameEventManager:RegisterListener("TalentsExplore",function(_, keys)
        self:OnExplore(keys)
    end)
    CustomGameEventManager:RegisterListener("TalentExploreAmount",function(_, keys)
        self:ExploreAmount(keys)
    end)
    CustomGameEventManager:RegisterListener("TalentsExploreDblClick",function(_, keys)
        self:ExploreDblClick(keys)
    end)
    CustomGameEventManager:RegisterListener("TalentsExploreRightClick",function(_, keys)
        self:RemoveRightClick(keys)
    end)
    CustomGameEventManager:RegisterListener("TalentsBuy",function(_, keys)
        self:OnBuy(keys)
    end)
    CustomGameEventManager:RegisterListener("TalentsRemoveAllCheat",function(_, keys)
        self:RemoveAllTalentsCheat(keys)
    end)
    CustomGameEventManager:RegisterListener("RestartMiniGame",function(_, keys)
        self:RestartAFKGame(keys)
    end)
    
    ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( self, 'OnGameRulesStateChange'), self)
    ListenToGameEvent("player_reconnected", Dynamic_Wrap( self, 'OnPlayerReconnected' ), self)
    self.shop = talents_shop
    self.barracks_destroyed = false
    self.hell_game = {}
    self.levelMax = 50
    self.calculated_levels = {}
    self.calculated_levels[0] = 0
    for i=1,self.levelMax do
        self.calculated_levels[i] = self.calculated_levels[i-1] + talents_experience[i]
    end
    self.player = {}
    self.data_base = {}
    self.afk_game = {}
end

function Talents:OnGameRulesStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        CustomNetTables:SetTableValue("talants", "talents_experience", self.calculated_levels)
    end
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
        for pid = 0, 4 do
            if PlayerResource:IsValidPlayer(pid) and PlayerResource:HasSelectedHero(pid) then
                Timers:CreateTimer(function()
                    if self.player[pid] ~= nil and PlayerResource:GetSelectedHeroEntity( pid ) then
                        self.player[pid].index = PlayerResource:GetSelectedHeroEntity( pid ):entindex()
                        self:UpdateTable(pid)
                        return nil
                    end
                    return 0.1
                end)
            end
        end
    end
end
function Talents:OnPlayerReconnected(t)

end
function Talents:HeroSelectedListen(pid)
    Timers:CreateTimer(function()
		if PlayerResource:GetPlayer(pid) == nil then
			return nil
		end
		if PlayerResource:HasSelectedHero(pid) then
			self:RequestData(pid, PlayerResource:GetSelectedHeroName(pid))
			return nil
		end
		return 0.1
	end)
end
function Talents:RequestData(pid, hero_name)
    local send = {
        hero_name = hero_name,
        name = PlayerResource:GetPlayerName(pid),
    }
    DataBase:Send(DataBase.link.RequestTalents, "GET", send, pid, true, function(body)
        local data = json.decode(body)
        self:FillTablesFromDatabase(pid, data, DataBase:IsCheatMode())
    end)
end
function Talents:FillTablesFromDatabase(pid, data, is_cheat_mode)
    self.data_base[pid] = data
    self.player[pid] = {}
    self.player[pid].totalexp = data['totalexp']
    self.player[pid].reincarnation = data['reincarnation']
    self.player[pid].gametime = data['gametime']
    self.player[pid].gamecout = data['gamecout']
    self.player[pid].totaldonexp = data['totaldonexp']
    if is_cheat_mode then
        for k,v in pairs({'agi','int','don','str'}) do
            for i = 1, 13 do
                self.player[pid][v..i] = 0
            end
        end
        self.player[pid].totalexp = 1500000
        self.player[pid].totaldonexp = 1500000
        self.player[pid].testing = true
    end
    self.player[pid].patron = self:IsPatron(pid)
    self.player[pid].cout = 1
    if is_cheat_mode or self:IsSecondBranchActive(pid) then
        self.player[pid].cout = 2
    end
    self.player[pid].level = self:CalculateLevelFromExperience(self.player[pid].totalexp)
    self.player[pid].freepoints = self.player[pid].level
    self.player[pid].donlevel = self:CalculateLevelFromExperience(self.player[pid].totaldonexp)
    self.player[pid].freedonpoints = self.player[pid].donlevel
    self.player[pid].earnedexp = 0
    self.player[pid].earneddonexp = 0
    if self.player[pid].donlevel > 7 and self.player[pid].donlevel < 30 then
        self.player[pid].freedonpoints = 7
    elseif self.player[pid].donlevel >= 30 and self.player[pid].donlevel < 50 then
        self.player[pid].freedonpoints = 8
    elseif self.player[pid].donlevel >= 50 then
        self.player[pid].freedonpoints = 9
    end
    for k,v in pairs({"int","str","agi","don"}) do
        for i = 1, 13 do
            local arg = v..i
            self.player[pid][arg] = {}
            if data[arg] == nil then
                data[arg] = 0
            end
            if v ~= "don" then
                self.player[pid].freepoints = self.player[pid].freepoints - data[arg]
            elseif v == "don" then
                self.player[pid].freedonpoints = self.player[pid].freedonpoints - data[arg]
            end
            if DataBase:IsCheatMode() == false and diff_wave.wavedef == "Easy" and i == 12 then
                self.player[pid][arg].value = 0
            elseif v == "don" and DataBase:IsCheatMode() == false and not self:IsPatron(pid) then
                self.player[pid][arg].value = 0
            else
                self.player[pid][arg].value = data[arg]
            end
        end
    end
    local hero_name = PlayerResource:GetSelectedHeroName(pid)
    local talents_data = GetHeroTalentsData(hero_name)
    for ability_name, data in pairs(talents_data) do
        local arg = string.gsub(data.place[1], "%s", "")
        self.player[pid][arg].ability = ability_name
        self.player[pid][arg].url = data.url
        self.player[pid][arg].name = data.name
    end
    self.player[pid].hero_name = hero_name
    self:UpdateTable(pid)
end
function Talents:CalculateLevelFromExperience(experience)
    for i = 1, self.levelMax do
        if experience < self.calculated_levels[i] then
            return i-1
        end
    end
    return self.levelMax
end
function Talents:IsSecondBranchActive(pid)
    local hero_name = PlayerResource:GetSelectedHeroName(pid)
    for k, v in ipairs(Shop.pShop[pid]) do
		for key, item in ipairs(v) do
            if item.hero and item.hero == hero_name and item.now > 0 then
                return true
            end
        end
    end
    return false
end
function Talents:IsPatron(pid)
    if RATING["rating"][pid]["patron"] == 1 or Shop.pShop[pid].golden_branch then
        return true
    end
    return false
end
function Talents:UpdateTable(pid)
    CustomNetTables:SetTableValue("talants", tostring(pid), self.player[pid])
end
function Talents:OnExplore(t)
    print('OnExplore')
    local pid = t.PlayerID
    local arg = t.i .. t.j
    local j = tonumber(t.j)
    if t.i == "don" and self:IsPatron(pid) == false and DataBase:IsCheatMode() == false then return end
    if t.i ~= 'don' and j == 1 then
        local boo = 0
        if self.player[pid]["int1"].value > 0 and t.i ~= "int" then boo = boo + 1 end
        if self.player[pid]["str1"].value > 0 and t.i ~= "str" then boo = boo + 1 end
        if self.player[pid]["agi1"].value > 0 and t.i ~= "agi" then boo = boo + 1 end
        if boo >= self.player[pid]["cout"] then
            return
        end 
    end
    local talents_to_explore = {}
    -- изучение с поиском пути
    if self.player[pid][arg].value == 0 and j < 12 then
        for _, n in pairs(self:GetExplorePath(j)) do
            if self.player[pid][t.i..n].value == 0 then
                table.insert(talents_to_explore, n)
            end
        end
    -- улучшение талатна до 6 уровня
    elseif self.player[pid][arg].value < 6 and j <= 5 then
        table.insert(talents_to_explore, j)
    -- изучение 12, 13 таланта
    elseif self.player[pid][arg].value == 0 and j == 12
    and (self.player[pid][t.i .. 11].value + self.player[pid][t.i .. 10].value + self.player[pid][t.i .. 11].value) == 1 
    and (t.i == 'don' or (self.player[pid]['agi12'].value + self.player[pid]['str12'].value + self.player[pid]['int12'].value) == 0)
    then
        table.insert(talents_to_explore, j)
    elseif self.player[pid][arg].value == 0 and j == 13 and self.player[pid][t.i .. 12].value == 1 then
        table.insert(talents_to_explore, j)
    end
    if t.i == 'don' and self.player[pid].freedonpoints < #talents_to_explore then return end
    if t.i ~= 'don' and self.player[pid].freepoints < #talents_to_explore then return end
    -------------------------------------------------------
    for _, f in pairs(talents_to_explore) do
        self:Explore(pid, t.i, f)
    end
end
function Talents:Explore(pid, i, f)
    print('Explore')
    if i ~= 'don' and f <= 5 and self.player[pid][i..f].value >= 6 then return end
    if i == 'don' and self.player[pid][i..f].value >= 1 then return end
    if i ~= 'don' and (f > 5 and self.player[pid][i..f].value >= 1) then return end
    if i == 'don' and self.player[pid].freedonpoints <= 0 then return end
    if i ~= 'don' and self.player[pid].freepoints <= 0 then return end
    print('4567')
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    self.player[pid][i..f].value = self.player[pid][i..f].value + 1
    if i == "don" or f <= 5 then
        self:AddModifierFiltered(hero, self.player[pid][i..f].ability, f, self.player[pid][i..f].value)
    elseif i ~= "don" then
        self:AddAbilityFiltered(hero, self.player[pid][i..f].ability, f)
    end
    if i == "don" then
        self.player[pid].freedonpoints = self.player[pid].freedonpoints - 1
    elseif i ~= "don" then
        self.player[pid].freepoints = self.player[pid].freepoints - 1
    end
    self:UpdateTable(pid)
end
function Talents:GetExplorePath(j)
    local path = {}
    for i = 1, 5 do
        if j >= i then
            table.insert(path, i)
        end
    end
    for i = 6, 8 do
        if j == i then
            table.insert(path, i)
        end
    end
    if j == 9 then
        table.insert(path, 6)
        table.insert(path, 9)
    end
    if j == 10 then
        table.insert(path, 7)
        table.insert(path, 10)
    end
    if j == 11 then
        table.insert(path, 8)
        table.insert(path, 11)
    end
    return path
end
function Talents:AddAbilityFiltered(hero, skillname, place)
    if diff_wave.rating_scale == 0 and place == 12 then return end

    ability = hero:AddAbility(skillname)
    ability:SetLevel(1)
end
function Talents:AddModifierFiltered(hero, skillname, place, level)
    if diff_wave.rating_scale == 0 and place == 12 then return end
    modifier = hero:AddNewModifier( hero, nil, skillname, {} )
    modifier:SetStackCount(level)
end
function Talents:ExploreAmount(t)
    local pid = t.PlayerID
    local arg = t.i .. t.j
    local send = {
        arr = {
            sid = PlayerResource:GetSteamAccountID(pid),
            hero_name = t.hero_name,
            pos = arg
        }
    }
    DataBase:Send(DataBase.GetHeroInfo, "GET", send, pid, true, function(body)
        self.player[pid][arg].explored = body
        self:UpdateTable(pid)
    end)
end
function Talents:ExploreDblClick(t)
    if self.player[t.PlayerID].testing == true then
        self:Explore(t.PlayerID, t.i, tonumber(t.j))
    end
end
function Talents:OnBuy(t)
    local pid = t.PlayerID
    local name = t.name
    local amount = tonumber(t.amount)
    local currency = t.currency
    local item = self.shop[name]
    if currency == 'don' and not (item.price.don ~= nil and Shop.pShop[pid]["coins"] >= item.price.don * amount) then
        return
    end
    if currency == 'rp' and not (item.price.rp ~= nil and Shop.pShop[pid]["mmrpoints"] >= item.price.rp * amount) then
        return
    end
    if item.type == 'normal' then
        local experience = item.value * amount
        self:AddExperience(pid, experience, false)
        self.player[pid].earnedexp = self.player[pid].earnedexp - experience
        self:UpdateTable(pid)
    end
    if item.type == 'golden' then
        local experience = item.value * amount
        self:AddExperienceDonate(pid, experience, false)
        self.player[pid].earneddonexp = self.player[pid].earneddonexp - experience
        self:UpdateTable(pid)
    end
    print('OnBuy')
    DeepPrintTable(t)
end
function Talents:AddExperience(pid, value, multiply)
    if multiply then
        value = value * MultiplierManager:GetTalentExperienceMultiplier(pid)
        if self.player[pid]['don2'].value > 0 then
            value = value * 1.15
        end
        if GameRules:GetGameTime() / 60 >= 120 then
            return false
        end
    end
    if self.player[pid].totalexp + value < 0 then 
        self.player[pid].totalexp = 0
        value = 0
    end
    local level = self:CalculateLevelFromExperience(self.player[pid].totalexp + value)
    self.player[pid].level = level
    self.player[pid].freepoints = self:CalculateFreePointsNormal(pid)
    self.player[pid].totalexp = self.player[pid].totalexp + value
    self.player[pid].earnedexp = self.player[pid].earnedexp + value
    self:UpdateTable(pid)
end
function Talents:AddExperienceDonate(pid, value, multiply)
    if multiply then
        value = value * MultiplierManager:GetTalentExperienceMultiplier(pid)
        if self.player[pid]['don2'].value > 0 then
            value = value * 1.15
        end
        if GameRules:GetGameTime() / 60 >= 120 then
            return false
        end
    end
    if self.player[pid].totaldonexp + value < 0 then 
        self.player[pid].totaldonexp = 0
        value = 0
    end
    if RATING["rating"][pid]["patron"] == 0 and not Shop.pShop[PlayerID].golden_branch then
        return false
    end
    local level = self:CalculateLevelFromExperience(self.player[pid].totaldonexp + value)
    self.player[pid].donlevel = level
    self.player[pid].freedonpoints = self:CalculateFreePointsGolden(pid)
    self.player[pid].totaldonexp = self.player[pid].totaldonexp + value
    self.player[pid].earneddonexp = self.player[pid].earneddonexp + value
    self:UpdateTable(pid)
end
function Talents:UpdateGainValue(pid, value, multiply)
    if multiply then
        value = value * MultiplierManager:GetTalentExperienceMultiplier(pid)
        if self.player[pid]['don2'].value > 0 then
            value = value * 1.15
        end
    end
    self.player[pid].gain = value
    self:UpdateTable(pid)
end
function Talents:CalculateFreePointsNormal(pid)
    local count = 0
    for _, t in pairs({"agi","int","str"}) do
        for i = 1, 13 do
            count = count + self.player[pid][t..i].value
        end
    end
    return self.player[pid].level - count
end
function Talents:CalculateFreePointsGolden(pid)
    if self.player[pid].donlevel > 7 and self.player[pid].donlevel < 30 then
        points_max = 7
    elseif self.player[pid].donlevel >= 30 and self.player[pid].donlevel < 50 then
        points_max = 8
    elseif self.player[pid].donlevel >= 50 then
        points_max = 9
    end
    local count = 0
    for i = 1, 13 do
        count = count + self.player[pid]["don"..i].value
    end

    return points_max - count
end
function Talents:RemoveAllTalentsCheat(t)
    local pid = t.PlayerID
    if self.player[pid].testing ~= true then return end
    for _, i in pairs({'str','agi','int','don'}) do
        for j = 1, 13 do
            self:RemoveTalent(pid, i..j)
        end
    end
    self.player[pid].freedonpoints = self:CalculateFreePointsGolden(pid)
    self.player[pid].freepoints = self:CalculateFreePointsNormal(pid)
    self:UpdateTable(pid)
end
function Talents:RemoveTalent(pid, arg)
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    hero:RemoveModifierByName( self.player[pid][arg].ability )
    hero:RemoveAbility( self.player[pid][arg].ability )
    self.player[pid][arg].value = 0
end
function Talents:RemoveRightClick(t)
    local pid = t.PlayerID
    local i = t.i
    local j = tonumber(t.j)
    if self.player[pid].testing ~= true then return end
    self:RemoveTalent(pid, i..j)
    self.player[pid].freedonpoints = self:CalculateFreePointsGolden(pid)
    self.player[pid].freepoints = self:CalculateFreePointsNormal(pid)
    self:UpdateTable(pid)
end
function Talents:EnableAFKGame(pid)
    if self.afk_game[pid] == nil then
        self.afk_game[pid] = {}
        self.afk_game[pid].value = -20
    end
    self.afk_game[pid].enable = true
    local tick = 0
    Timers:CreateTimer(1, function()
        self:AddExperience(pid, self.afk_game[pid].value, false)
        self:AddExperienceDonate(pid, self.afk_game[pid].value, false)
        self:UpdateGainValue(pid, self.afk_game[pid].value, false)
        tick = tick + 1
        if tick % 15 == 0 then 
            self.afk_game[pid].value = self.afk_game[pid].value - 1
        end
        if self.afk_game[pid].enable then
            return 1
        end
    end)
end
function Talents:RestartAFKGame(t)
    local pid = t.PlayerID
    self.afk_game[pid].value = self.afk_game[pid].value - 10
    self:UpdateGainValue(pid, self.afk_game[pid].value, false)
end
function Talents:DisableAFKGame(pid)
    self.afk_game[pid].enable = false
    self:UpdateGainValue(pid, 0, false)
end
Talents:init()
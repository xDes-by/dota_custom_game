if Pets == nil then
    _G.Pets = class({})
end
function Pets:init()
    CustomGameEventManager:RegisterListener("PetsEquip",function(_, keys)
        self:EquipPanoramaEvent(keys)
    end)
    CustomGameEventManager:RegisterListener("UsePet",function(_, keys)
        self:OnUse(keys)
    end)
    CustomGameEventManager:RegisterListener("PetsOnFeed",function(_, keys)
        self:OnFeed(keys)
    end)
    CustomGameEventManager:RegisterListener("PetsShop",function(_, keys)
        self:OnBuyShop(keys)
    end)
    CustomGameEventManager:RegisterListener("BuyPet",function(_, keys)
        self:OnBuyPet(keys)
    end)
    CustomGameEventManager:RegisterListener("ChangeAutoPet",function(_, keys)
        self:ChangeAutoPet(keys)
    end)
    
    ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( self, 'OnGameRulesStateChange'), self)
    self.list = pets_list
    self.experience_levels = pets_exp
    self.shop = pets_shop
    self.player = {}
    self.equip = {}
    self.change_limit = {}
    self.current_pet_name = {}
    self.current_pet_spell = {}
    for i = 0, 4 do
        self.change_limit[i] = 1
        self.current_pet_name[i] = ""
        self.current_pet_spell[i] = "spell_item_pet"
    end
end
function Pets:OnGameRulesStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
        CustomNetTables:SetTableValue('Pets', "list", self.list)
        CustomNetTables:SetTableValue('Pets', "experience_levels", self.experience_levels)
    end
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        for pid = 0, 4 do
            if PlayerResource:IsValidPlayer(pid) then
                print("auto_pet", Shop.pShop[pid].auto_pet)
                if Shop.pShop[pid].auto_pet ~= "" then
                    self:Equip(pid, Shop.pShop[pid].auto_pet)
                else
                    self:EquipFree(pid)
                end
            end
        end
    end
    
end
function Pets:SetPlayerData(pid, obj)
    self.player[pid] = {}
    for _, pet in pairs(obj) do
        if self.player[pid][pet.name] ~= nil and self.player[pid][pet.name].value < pet.value then
            self.player[pid][pet.name] = pet
        elseif self.player[pid][pet.name] == nil then
            self.player[pid][pet.name] = pet
        end
    end
    CustomNetTables:SetTableValue('Pets', tostring(pid), self.player[pid])
end
function Pets:FindSpellNameByName(name)
    for _, tier in ipairs(self.list) do
        for _, pet in ipairs(tier) do
            if pet.name == name then
                return pet.itemname
            end
        end
    end
end
function Pets:CalculateLevelFromExperience(exp)
	local level = 10
	local passed_exp = 0
	for i = 1, 10 do 
		passed_exp = passed_exp + self.experience_levels[i-1]
		if exp >= passed_exp and exp < passed_exp + self.experience_levels[i] then
			level = i-1
			break
		end
	end
	return level
end
function Pets:EquipPanoramaEvent(t)
    local pid = t.PlayerID
    local name = t.name
    if self.player[pid][name] == nil or self.player[pid][name].value <= 0 then return end
    if not (self.change_limit[pid] > 0 or Shop.pShop[pid].pet_change == 1) then return end
    local equip = self:Equip(pid, name)
    if equip and Shop.pShop[pid].pet_change == 0 then
        self.change_limit[pid] = self.change_limit[pid] -1
    end
end
function Pets:Equip(pid, name)
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    if not hero then return end
    local equip = false
    local spell = "spell_item_pet"
    local level = 1
    hero:RemoveAbility(self.current_pet_spell[pid])
    if self.current_pet_name[pid] ~= name then
        spell = self:FindSpellNameByName(name)
        level = self:CalculateLevelFromExperience(self.player[pid][name].value)
        equip = true
    else
        name =  "spell_item_pet"
    end
    hero:AddAbility(spell):SetLevel(level)
    self.current_pet_name[pid] = name
    self.current_pet_spell[pid] = spell
    CustomNetTables:SetTableValue( "cosmetic_buttons", "pet", self.current_pet_spell )
    return equip
end
function Pets:EquipFree(pid)
    local hero = PlayerResource:GetSelectedHeroEntity(pid)
    if not hero then return end
    hero:AddAbility("spell_item_pet"):SetLevel(1)
    self.current_pet_name[pid] = "spell_item_pet"
    self.current_pet_spell[pid] = "spell_item_pet"
    CustomNetTables:SetTableValue( "cosmetic_buttons", "pet", self.current_pet_spell )
end
function Pets:OnUse(t)
	local player = PlayerResource:GetPlayer(t.PlayerID)
	local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
	if hero:IsAlive() and not hero:IsSilenced() then
        local ability = hero:FindAbilityByName(self.current_pet_spell[t.PlayerID])
        ability:OnSpellStart()
        Quests:UpdateCounter("daily", t.PlayerID, 35)
	end
end
function Pets:OnFeed(t)
	local pid = t.PlayerID
    local name = t.name
	local count = tonumber(t.count)

	if Shop.pShop[pid]["feed"] < count then return end
	if self.player[pid][name].remaining_games_count ~= nil or self.player[pid][name].end_date ~= nil then return end

	Shop.pShop[pid]["feed"] = Shop.pShop[pid]["feed"] - count
    self.player[pid][name].value = self.player[pid][name].value + count
    if self.current_pet_name[pid] == name then
        local level = self:CalculateLevelFromExperience(self.player[pid][name].value)
        local hero = PlayerResource:GetSelectedHeroEntity(pid)
        local ability = hero:FindAbilityByName(self.current_pet_spell[pid])
        ability:SetLevel(level)
    end
    CustomShop:UpdateShopInfoTable(pid)
    CustomNetTables:SetTableValue('Pets', tostring(pid), self.player[pid])
    DataBase:Send(DataBase.link.FeedPet, "GET", {
        id = self.player[pid][name].id,
        feed = count,
    }, pid, not DataBase:IsCheatMode(), function(body)
        print(body)
    end)
end
function Pets:OnBuyShop(t)
	local pid = t.PlayerID
    local name = t.name
    local currency = t.currency
	local amount = tonumber(t.amount)
    local price = self.shop[name].price[currency]
    if currency == "rp" and Shop.pShop[pid]["mmrpoints"] < price * amount then return end
    if currency == "don" and Shop.pShop[pid]["coins"] < price * amount then return end
    local send = {}
    if currency == "rp" then
        Shop.pShop[pid]["mmrpoints"] = Shop.pShop[pid]["mmrpoints"] - price * amount
        send.rp = price * amount
    end
    if currency == "don" then
        Shop.pShop[pid]["coins"] = Shop.pShop[pid]["coins"] - price * amount
        send.don = price * amount
    end
    if self.shop[name].type == "feed" then
        Shop.pShop[pid]["feed"] = Shop.pShop[pid]["feed"] + self.shop[name].give * amount
        send.feed = self.shop[name].give * amount
    end
    if self.shop[name].type == "pet_change" then
        Shop.pShop[pid].pet_change = 1
        send.pet_change = 1
    end
    CustomShop:UpdateShopInfoTable(pid)
    DataBase:Send(DataBase.link.BuyPetShop, "GET", send, pid, not DataBase:IsCheatMode(), function(body)
        print(body)
    end)
end
function Pets:FindPetDataByName(name)
    for _, tier in ipairs(self.list) do
        for _, pet in ipairs(tier) do
            if pet.name == name then 
                return pet
            end
        end
    end
end
function Pets:FindPetDataByAbilityName(abilityname)
    for _, tier in ipairs(self.list) do
        for _, pet in ipairs(tier) do
            if pet.itemname == abilityname then 
                return pet
            end
        end
    end
end
function Pets:OnBuyPet(t)
	local pid = t.PlayerID
    local name = t.name
    local pet = self:FindPetDataByName(name)
    local send = {}

    if pet.price.rp ~= nil and pet.price.rp > 0 then
        Shop.pShop[pid]["mmrpoints"] = Shop.pShop[pid]["mmrpoints"] - pet.price.rp
        send.rp = pet.price.rp
    elseif pet.price.don ~= nil and pet.price.don > 0 then
        Shop.pShop[pid]["coins"] = Shop.pShop[pid]["coins"] - pet.price.don
        send.don = pet.price.don
    else
        return
    end
    send.name = name
    CustomShop:UpdateShopInfoTable(pid)
    self.player[pid][name] = { status = "loading" }
    CustomNetTables:SetTableValue('Pets', tostring(pid), self.player[pid])
    DataBase:Send(DataBase.link.BuyPet, "GET", send, pid, not DataBase:IsCheatMode(), function(body)
        self.player[pid][name] = json.decode(body)
        CustomNetTables:SetTableValue('Pets', tostring(pid), self.player[pid])
    end)
end
function Pets:ChangeAutoPet(t)
    DeepPrintTable(t)
    local pid = t.PlayerID
    if t.checked == 1 then
        Shop.pShop[pid].auto_pet = t.name 
    else
        Shop.pShop[pid].auto_pet = ""
    end
    CustomShop:UpdateShopInfoTable(pid)
    DataBase:Send(DataBase.link.ChangeAutoPet, "GET", {
        auto_pet = Shop.pShop[pid].auto_pet
    }, pid, true, nil)
end
Pets:init()
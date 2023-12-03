if Forge == nil then
    _G.Forge = class({})
end

function Forge:init()
    self.upgradeableItems = {
        'item_ring_of_flux_lua','item_satanic_lua','item_sheepstick_lua','item_bloodstone_lua','item_radiance_lua',"item_greater_crit_lua",
        'item_desolator_lua','item_butterfly_lua','item_monkey_king_bar_lua','item_bfury_lua','item_veil_of_discord_lua',"item_crimson_guard_lua",
        'item_shivas_guard_lua','item_heart_lua','item_kaya_custom_lua','item_kaya_lua','item_vladmir_lua',
        'item_ethereal_blade_lua','item_pipe_lua','item_octarine_core_lua','item_skadi_lua','item_mjollnir_lua',
        'item_pudge_heart_lua','item_mage_heart_lua','item_agility_heart_lua','item_moon_shard_lua','item_hood_sword_lua','item_assault_lua',
        'item_meteor_hammer_lua', "item_boots_of_bearing_lua", "item_sabre_blade", "item_spirit_vessel_lua", "item_hurricane_pike_lua", "item_midas_lua",
        "item_tank_cuirass", "item_tank_crimson", "item_tank_hell",
    }
    self.upgradeCost = {
        [1] = { gold = 5000, soul = "item_forest_soul", max_gems = 150},
        [2] = { gold = 10000, soul = "item_village_soul", max_gems = 300},
        [3] = { gold = 20000, soul = "item_mines_soul", max_gems = 450},
        [4] = { gold = 30000, soul = "item_dust_soul", max_gems = 600},
        [5] = { gold = 40000, soul = "item_cemetery_soul", max_gems = 750},
        [6] = { gold = 50000, soul = "item_swamp_soul", max_gems = 900},
        [7] = { gold = 75000, soul = "item_snow_soul", max_gems = 1050},
        [8] = { gold = 100000, soul = "item_divine_soul", max_gems = 1200},
        [9] = { gold = 180000, soul = "item_magma_soul", max_gems = 1350},
        [10] = { gold = 500000, soul = "item_antimage_soul", max_gems = 1500},
        [11] = {                                         max_gems = 2000},
    }
    self.midItems = {
        ["item_tank_cuirass"] = "item_dragon_soul",
        ["item_tank_crimson"] = "item_dragon_soul_2",
        ["item_tank_hell"] = "item_dragon_soul_3",
    }
    ListenToGameEvent("dota_hero_inventory_item_change", Dynamic_Wrap(self, 'ItemUpdate'), self)
    ListenToGameEvent("game_rules_state_change", Dynamic_Wrap( self, 'OnGameStateChanged' ), self )
    self.PlayerItems = {}
    self.PlayerItems[0] = {}
    self.PlayerItems[1] = {}
    self.PlayerItems[2] = {}
    self.PlayerItems[3] = {}
    self.PlayerItems[4] = {}
    CustomGameEventManager:RegisterListener("UpdgradeButton",function(_, keys)
        self:UpdgradeButton(keys)
    end)
    CustomGameEventManager:RegisterListener("UpdgradeGemsButton",function(_, keys)
        self:UpdgradeGemsButton(keys)
    end)
    self.levelMax = 11
end

function Forge:OnGameStateChanged(t)
    local state = GameRules:State_Get()
end
function Forge:GetItemUpgradeCost(level)
    if DataBase:IsCheatMode() then return 0 end
    return self.upgradeCost[level].gold
end
function Forge:GetSoulNameForItemUpgrade(name, level)
    if self.midItems[name] then
        if level == 8 then
            return "item_divine_soul"
        elseif level == 9 then
            return "item_magma_soul"
        elseif level == 10 then
            return "item_antimage_soul"
        end
        return self.midItems[name]
    end
    return self.upgradeCost[level].soul
end
function Forge:GetItemUpgradeSoulsCost()
    if DataBase:IsCheatMode() then return 0 end
    return 1
end
function Forge:GatherItemDataArray(item)
    local level = item:GetLevel()
    local name = item:GetName()
    local data = {
        itemname = name,
        itemLevel = level,
        entindex = item:entindex(),
        gold_cost = self:GetItemUpgradeCost(level),
        soul_name = self:GetSoulNameForItemUpgrade(name, level),
        soul_cost = self:GetItemUpgradeSoulsCost(item),
        max_gems = self.upgradeCost[level].max_gems,
        gemType = item.gemType or 0,
        gemsNumber = item.gemsNumber or 0,
        image = item:GetAbilityTextureName(),
    }
    return data
end
function Forge:ExploreAllInventory(PlayerID)
    local NewItemsList = {}
    local hero = PlayerResource:GetSelectedHeroEntity( PlayerID )
    for ITEM_SLOT = DOTA_ITEM_SLOT_1, DOTA_STASH_SLOT_6 do
        local item = hero:GetItemInSlot(ITEM_SLOT)
        if item then
            if table.has_value(self.upgradeableItems, item:GetName()) then
                table.insert(NewItemsList, self:GatherItemDataArray(item))
            end
            if item:GetLevel() >= 8 and item:GetName() == "item_spirit_vessel_lua" then
                Quests:UpdateCounter("bonus", 8, 2, pid)
            end
        end
    end
    self.PlayerItems[PlayerID] = NewItemsList
    self:CreateOrUpdateUpgardeItemPanel(PlayerID)
end

function Forge:UpdateItemData(PlayerID, entindex)
    local item = EntIndexToHScript( entindex )
    for key, data in pairs(self.PlayerItems[PlayerID]) do
        if data.entindex == entindex then
            self.PlayerItems[PlayerID][key] = self:GatherItemDataArray(item)
        end
    end
end

function Forge:ItemUpdate(t)
    DeepPrintTable(t)
    self:ExploreAllInventory(t.player_id)
end

function Forge:CreateOrUpdateUpgardeItemPanel(PlayerID)
    CustomNetTables:SetTableValue("forge", tostring(PlayerID), self.PlayerItems[PlayerID])
end

function Forge:RecordTaskCompletionOnItemLevelUp(pid, item)
    if item:GetLevel() == 8 then
        Quests:UpdateCounter("daily", pid, 30)
    end
    if item:GetLevel() == 8 and item:GetName() == "item_midas_lua" then
        Quests:UpdateCounter("daily", pid, 44)
    end
    if item:GetLevel() == 9 then
        Quests:UpdateCounter("daily", pid, 31)
    end
    if item:GetLevel() == 10 then
        Quests:UpdateCounter("daily", pid, 32)
    end
    if item:GetLevel() == 11 then
        Quests:UpdateCounter("daily", pid, 33)
    end
    if item:GetLevel() >= 8 and item:GetName() == "item_spirit_vessel_lua" then
        Quests:UpdateCounter("bonus", pid, 8, 2)
    end
    Quests:UpdateCounter("daily",  pid, 34)
end
function Forge:DeductResourcesForItemUpgrade(pid, item)
    local hero = PlayerResource:GetSelectedHeroEntity( pid )
    local soul_name = self:GetSoulNameForItemUpgrade(item:GetName(), item:GetLevel())
    for i = 1, self:GetItemUpgradeSoulsCost() do
        local soul_item = hero:FindItemInInventory(soul_name)
        if soul_item then
            hero:RemoveItem(soul_item)
        else
            sInv:RemoveSoul(soul_name, pid)
        end
    end
    local gold_cost = self:GetItemUpgradeCost(item:GetLevel())
    hero:ModifyGoldFiltered(-gold_cost, true, 0)
end
function Forge:UpdgradeButton(t)
    local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
    local item = EntIndexToHScript( t.entindex )
    local level = item:GetLevel()
    local soul_name = self:GetSoulNameForItemUpgrade(item:GetName(), level)
    if self:GetItemUpgradeSoulsCost() <= 0 or (hero:FindItemInInventory(soul_name) or sInv:HasSoul(soul_name, t.PlayerID)) then
        if hero:GetTotalGold() >= self:GetItemUpgradeCost(level) then
            self:DeductResourcesForItemUpgrade(t.PlayerID, item)
            item:SetLevel( level + 1 )
            self:RecordTaskCompletionOnItemLevelUp(t.PlayerID, item)
            self:ExploreAllInventory(t.PlayerID)
        end
    end
end
function Forge:ApplyGemModifierToPlayer(pid, item, cost)
    local hero = PlayerResource:GetSelectedHeroEntity( pid )
    hero:AddNewModifier(hero, nil, "modifier_gem" .. item.gemType, {ability = item:entindex(), gem_bonus = cost})
    item:SetSecondaryCharges(item.gemType)
end
function Forge:UpdgradeGemsButton(t)
    local item = EntIndexToHScript( t.entindex )
    local cost = t.gemsNumber - (item.gemsNumber or 0 )
    if Shop.pShop[t.PlayerID].gems[t.gemType] and cost > Shop.pShop[t.PlayerID].gems[t.gemType] then
        return
    end
    if item.gemType ~= nil and item.gemType ~= t.gemType then
        return
    end
    if t.gemType <= 0 or t.gemsNumber <= 0 then 
        return
    end
    item.gemType = t.gemType
    item.gemsNumber = (item.gemsNumber or 0) + cost
    CustomShop:AddGems(t.PlayerID, {[item.gemType] = -cost}, false)
    self:ApplyGemModifierToPlayer(t.PlayerID, item, cost)
    self:UpdateItemData(t.PlayerID, t.entindex)
    self:CreateOrUpdateUpgardeItemPanel(t.PlayerID)
end

Forge:init()
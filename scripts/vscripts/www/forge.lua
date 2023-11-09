if Forge == nil then
    _G.Forge = class({})
end

local upgradeableItems = {
    'item_ring_of_flux_lua','item_satanic_lua','item_sheepstick_lua','item_bloodstone_lua','item_radiance_lua',"item_greater_crit_lua",
    'item_desolator_lua','item_butterfly_lua','item_monkey_king_bar_lua','item_bfury_lua','item_veil_of_discord_lua',"item_crimson_guard_lua",
    'item_shivas_guard_lua','item_heart_lua','item_kaya_custom_lua','item_kaya_lua','item_vladmir_lua',
    'item_ethereal_blade_lua','item_pipe_lua','item_octarine_core_lua','item_skadi_lua','item_mjollnir_lua',
    'item_pudge_heart_lua','item_mage_heart_lua','item_agility_heart_lua','item_moon_shard_lua','item_hood_sword_lua','item_assault_lua',
    'item_meteor_hammer_lua', "item_boots_of_bearing_lua", "item_sabre_blade", "item_spirit_vessel_lua", "item_hurricane_pike_lua", "item_midas_lua",
    "item_tank_cuirass", "item_tank_crimson", "item_tank_hell",
}

local upgradeCost = {
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
    [11] = {                                         max_gems = 100000},
}
local midItems = {
    item_tank_cuirass = "item_dragon_soul",
    item_tank_crimson = "item_dragon_soul_2",
    item_tank_hell = "item_dragon_soul_3",
}
local gems = {

}

function Forge:init()
    --лучше использовать этот ивент, он так же вызывается при выкладывании или продаже предмета, 
    --так же он исключит дальнейшие ошибки попыток обращения к null объектам или отсутсвия предмета в инвентаре
    ListenToGameEvent("dota_hero_inventory_item_change", Dynamic_Wrap(self, 'ItemUpdate'), self)
    -- ListenToGameEvent("dota_item_combined", Dynamic_Wrap(self, 'ItemUpdate'), self)
    -- ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(self, 'ItemUpdate'), self)
    -- ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(self, 'ItemUpdate'), self)
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
    if state >= DOTA_GAMERULES_STATE_PRE_GAME then
        Timers:CreateTimer(3, function()
            for nPlayerID = 0, PlayerResource:GetPlayerCount()-1 do
                gems[nPlayerID] = {}
                for i = 1, 5 do
                    gems[nPlayerID][i] = _G.SHOP[nPlayerID]['gem_'..i] or 0
                end
                if PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED then
                    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "update_gems_js",  gems[nPlayerID])
                end
            end
		end)
    end
end
function Forge:GetItemUpgradeCost(level)
    if DataBase:IsCheatMode() then return 0 end
    return upgradeCost[level].gold
end
function Forge:GetSoulNameForItemUpgrade(name, level)
    if midItems[name] then return midItems[name] end
    return upgradeCost[level].soul
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
        max_gems = upgradeCost[level].max_gems,
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
            if table.has_value(upgradeableItems, item:GetName()) then
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
    self:ExploreAllInventory(t.player_id)
end

function Forge:CreateOrUpdateUpgardeItemPanel(PlayerID)
    CustomNetTables:SetTableValue("forge", tostring(PlayerID), self.PlayerItems[PlayerID])
end

function Forge:RecordTaskCompletionOnItemLevelUp(pid, item)
    if item:GetLevel() == 8 then
        DailyQuests:UpdateCounter( pid, 30)
    end
    if item:GetLevel() == 8 and item:GetName() == "item_midas_lua" then
        DailyQuests:UpdateCounter( pid, 44)
    end
    if item:GetLevel() == 9 then
        DailyQuests:UpdateCounter( pid, 31)
    end
    if item:GetLevel() == 10 then
        DailyQuests:UpdateCounter( pid, 32)
    end
    if item:GetLevel() == 11 then
        DailyQuests:UpdateCounter( pid, 33)
    end
    if item:GetLevel() >= 8 and item:GetName() == "item_spirit_vessel_lua" then
        Quests:UpdateCounter("bonus", 8, 2, pid)
    end
    DailyQuests:UpdateCounter( pid, 34)
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
    if gems[t.PlayerID][t.gemType] and cost > gems[t.PlayerID][t.gemType] then
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
    self:add_gems({
        PlayerID = t.PlayerID, type = t.gemType-1, value = -cost
    })
    self:ApplyGemModifierToPlayer(t.PlayerID, item, cost)
    self:UpdateItemData(t.PlayerID, t.entindex)
    self:CreateOrUpdateUpgardeItemPanel(t.PlayerID)
end

function Forge:UpdateGemsTable(pid)
    local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(pid))
    shopinfo['purple_gem'] = gems[pid][1]
    shopinfo['blue_gem'] = gems[pid][2]
    shopinfo['orange_gem'] = gems[pid][3]
    shopinfo['red_gem'] = gems[pid][4]
    shopinfo['green_gem'] = gems[pid][5]
    CustomNetTables:SetTableValue("shopinfo", tostring(pid), shopinfo)
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( pid ), "update_gems_js", gems[pid] )
end

function Forge:add_gems(t)
    if DataBase:IsCheatMode() then return end
    gems[t.PlayerID][t.type] = gems[t.PlayerID][t.type] + t.value
    if t.shop ~= true then
        DataBase:EdditGems({PlayerID = t.PlayerID, type = t.type, value = t.value, action = 'add'})
    end
    self:UpdateGemsTable(t.PlayerID)
end


Forge:init()


if not CDOTA_BaseNPC_Hero.oldModifyGoldFiltered then
	CDOTA_BaseNPC_Hero.oldModifyGoldFiltered = CDOTA_BaseNPC_Hero.ModifyGoldFiltered
end

function CDOTA_BaseNPC_Hero:ModifyGoldFiltered(goldChange, reliable, reason)
    while goldChange < 0 do
        if (goldChange + 99999) < 0 then
            goldChange = goldChange + 99999
            self:oldModifyGoldFiltered(-99999, reliable, reason)
        else
            self:oldModifyGoldFiltered(goldChange, reliable, reason)
            return
        end
    end
	self:oldModifyGoldFiltered(goldChange, reliable, reason)
end

function CDOTA_BaseNPC_Hero:GetTotalGold()
	local mod = self:FindModifierByName("modifier_gold_bank")
	if mod and mod:GetStackCount() > 0 then
		totalgold = mod:GetStackCount() + self:GetGold()
	else
		totalgold = self:GetGold()
	end
	return totalgold
end
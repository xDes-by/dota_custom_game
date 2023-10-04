if Forge == nil then
    _G.Forge = class({})
end

local upgradeableItems = {
    'item_ring_of_flux_lua','item_satanic_lua','item_sheepstick_lua','item_bloodstone_lua','item_radiance_lua',"item_greater_crit_lua",
    'item_desolator_lua','item_butterfly_lua','item_monkey_king_bar_lua','item_bfury_lua','item_veil_of_discord_lua',"item_crimson_guard_lua",
    'item_shivas_guard_lua','item_heart_lua','item_kaya_custom_lua','item_kaya_lua','item_vladmir_lua',
    'item_ethereal_blade_lua','item_pipe_lua','item_octarine_core_lua','item_skadi_lua','item_mjollnir_lua',
    'item_pudge_heart_lua','item_mage_heart_lua','item_agility_heart_lua','item_moon_shard_lua','item_hood_sword_lua','item_assault_lua','item_meteor_hammer_lua', "item_boots_of_bearing_lua", "item_sabre_blade", "item_hurricane_pike",
}

local upgradeCost = {
    [1] = { gold = 5000, soul = "item_forest_soul", max_gems = 1000},
    [2] = { gold = 10000, soul = "item_village_soul", max_gems = 2000},
    [3] = { gold = 20000, soul = "item_mines_soul", max_gems = 3000},
    [4] = { gold = 30000, soul = "item_dust_soul", max_gems = 4000},
    [5] = { gold = 40000, soul = "item_swamp_soul", max_gems = 5000},
    [6] = { gold = 50000, soul = "item_snow_soul", max_gems = 6000},
    [7] = { gold = 99999, soul = "item_divine_soul", max_gems = 7000},
    [8] = {                                         max_gems = 8000},
}
local gems = {

}

function Forge:init()
    ListenToGameEvent("dota_item_combined", Dynamic_Wrap(self, 'ItemUpdate'), self)
    ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(self, 'ItemUpdate'), self)
    ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(self, 'ItemUpdate'), self)
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

function Forge:ItemUpdate(t)
    for _, itemname in pairs(upgradeableItems) do
        if t.itemname == itemname then
            self:CreateOrUpdateUpgardeItemPanel(t)
            break
        end
    end
end

function Forge:CreateOrUpdateUpgardeItemPanel(t)
    if table.has_value(self.PlayerItems[t.PlayerID], t.itemname) then
        return
    end
    local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
    local item = hero:FindItemInInventory(t.itemname)
    local itemLevel = item:GetLevel()
    local data = {
        itemname = t.itemname,
        itemLevel = itemLevel,
        gold = upgradeCost[itemLevel].gold,
        soul = upgradeCost[itemLevel].soul,
        max_gems = upgradeCost[itemLevel].max_gems,
        gemType = item.gemType or 0,
        gemsNumber = item.gemsNumber or 0,
    }
    local insert = true
    for itemKey, itemData in pairs(self.PlayerItems[t.PlayerID]) do
        if itemData.itemname == t.itemname then 
            insert = false
            self.PlayerItems[t.PlayerID][itemKey] = data
            break
        end
    end
    if insert then
        table.insert(self.PlayerItems[t.PlayerID], data)
    end
    self:UpdateGemsTable(t.PlayerID)
    CustomNetTables:SetTableValue("forge", tostring(t.PlayerID), self.PlayerItems[t.PlayerID])
end

function Forge:UpdgradeButton(t)
    local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
    local item = hero:FindItemInInventory(t.itemname)
    local itemLevel = item:GetLevel()
    local soul = upgradeCost[itemLevel].soul
    if itemLevel < 8 and (sInv:HasSoul(soul, t.PlayerID) or hero:FindItemInInventory(soul)) then 
        if hero:GetGold() >= upgradeCost[itemLevel].gold then
            hero:ModifyGoldFiltered(-upgradeCost[itemLevel].gold, true, 0)
            if hero:FindItemInInventory(soul) then
                hero:RemoveItem(soul)
            else
                sInv:RemoveSoul(soul, t.PlayerID)
            end
            item:SetLevel( itemLevel + 1 )
            self:ItemUpdate(t)
        end
    end
end

function Forge:UpdgradeGemsButton(t)
    local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
    local item = hero:FindItemInInventory(t.itemname)
    local itemLevel = item:GetLevel()
    local cost = t.gemsNumber - (item.gemsNumber or 0 )
    if cost > gems[t.PlayerID][t.gemType] then
        return
    end
    if item.gemType == nil then
        item.gemType = t.gemType
        item.gemsNumber = 0
    elseif item.gemType ~= t.gemType then
        return
    end
    DataBase:EdditGems({PlayerID = t.PlayerID, type = t.gemType, value = cost, action = 'remove'})
    gems[t.PlayerID][t.gemType] = gems[t.PlayerID][t.gemType] - cost
    self:UpdateGemsTable(t.PlayerID)
    item.gemsNumber = t.gemsNumber
    self:CreateOrUpdateUpgardeItemPanel(t)
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
    gems[t.PlayerID][t.type] = gems[t.PlayerID][t.type] + t.value
    if t.shop ~= true then
        DataBase:EdditGems({PlayerID = t.PlayerID, type = t.type, value = t.value, action = 'add'})
    end
    self:UpdateGemsTable(t.PlayerID)
end


Forge:init()
if Forge == nil then
    _G.Forge = class({})
end

local upgradeableItems = {
    "item_satanic_custom"
}

local upgradeCost = {
    [1] = { gold = 5000, soul = "item_forest_soul"},
    [2] = { gold = 10000, soul = "item_village_soul"},
    [3] = { gold = 20000, soul = "item_mines_soul"},
    [4] = { gold = 30000, soul = "item_dust_soul"},
    [5] = { gold = 40000, soul = "item_swamp_soul"},
    [6] = { gold = 50000, soul = "item_snow_soul"},
    [7] = { gold = 99999, soul = "item_divine_soul"},
}

function Forge:init()
    ListenToGameEvent("dota_item_combined", Dynamic_Wrap(self, 'ItemUpdate'), self)
    ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(self, 'ItemUpdate'), self)
    ListenToGameEvent("dota_item_purchased", Dynamic_Wrap(self, 'ItemUpdate'), self)
    self.PlayerItems = {}
    self.PlayerItems[0] = {}
    self.PlayerItems[1] = {}
    self.PlayerItems[2] = {}
    self.PlayerItems[3] = {}
    self.PlayerItems[4] = {}
end


function Forge:ItemUpdate(t)
    for _, itemname in pairs(upgradeableItems) do
        if string.find(t.itemname, itemname) then
            self:CreateOrUpdateUpgardeItemPanel(t)
            break
        end
    end
end

function Forge:CreateOrUpdateUpgardeItemPanel(t)
    if table.has_value(self.PlayerItems[t.PlayerID], t.itemname) then
        return
    end
    table.insert(self.PlayerItems[t.PlayerID], t.itemname)

    CustomNetTables:SetTableValue("forge", tostring(t.PlayerID), self.PlayerItems[t.PlayerID])
end










Forge:init()
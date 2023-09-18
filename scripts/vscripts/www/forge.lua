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
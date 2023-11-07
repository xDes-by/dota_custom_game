if sInv == nil then
    _G.sInv = class({})
end


function sInv:init()
    CustomGameEventManager:RegisterListener("GetSoul",function(_, keys)
        self:GetSoul(keys)
    end)
    ListenToGameEvent("player_reconnected", Dynamic_Wrap(self, 'OnPlayerReconnected'), self)
    ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( self, "OnItemPickUp"), self)
    self.item_forest_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_village_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_mines_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_dust_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_swamp_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_snow_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_divine_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_cemetery_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_magma_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_antimage_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_dragon_soul = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_dragon_soul_2 = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
    self.item_dragon_soul_3 = {[0]=0,[1]=0,[2]=0,[3]=0,[4]=0}
end

function sInv:AddSoul(soul_name, pid)
    if not self[soul_name] then return end
    if pid ~= nil then
        self[soul_name][pid] = self[soul_name][pid] + 1
        sInv:UpdateInventory(pid)
    else
        for i = 0, 4 do
            self[soul_name][i] = self[soul_name][i] + 1
            sInv:UpdateInventory(i)
        end
    end
    
end

function sInv:HasSoul(soul_name, pid)
    if not self[soul_name] then return false end
    if self[soul_name][pid] <= 0 then return false end
    return true
end

function sInv:RemoveSoul(soul_name, pid)
    if not self[soul_name] then return end
    if self[soul_name][pid] <= 0 then return end
    self[soul_name][pid] = self[soul_name][pid] - 1
    sInv:UpdateInventory(pid)
end

function sInv:OnItemPickUp(keys)
    if not self[keys.itemname] then return end
    local hero = PlayerResource:GetSelectedHeroEntity( keys.PlayerID )
    local item = nil
    for i = 0, 8 do
        if hero:GetItemInSlot(i) then
            if hero:GetItemInSlot(i):GetName() == keys.itemname and hero:GetName() == hero:GetItemInSlot(i):GetPurchaser():GetName() then
                item = hero:GetItemInSlot(i)
            end
        end
    end
    if not item then return end

    self[keys.itemname][keys.PlayerID] = self[keys.itemname][keys.PlayerID] + 1
    hero:RemoveItem(item)
    sInv:UpdateInventory(keys.PlayerID)
end

function sInv:OnPlayerReconnected(t)
    -- sInv:UpdateInventory(t.PlayerID)
end

function sInv:UpdateInventory(pid)
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( pid ), "updateSoulsInventory", {
        [0] = self.item_forest_soul[pid],
        [1] = self.item_village_soul[pid],
        [2] = self.item_mines_soul[pid],
        [3] = self.item_dust_soul[pid],
        [4] = self.item_cemetery_soul[pid],
        [5] = self.item_swamp_soul[pid],
        [6] = self.item_snow_soul[pid],
        [7] = self.item_divine_soul[pid],
        [8] = self.item_magma_soul[pid],
        [9] = self.item_antimage_soul[pid],
        [10] = self.item_dragon_soul[pid],
        [11] = self.item_dragon_soul_2[pid],
        [12] = self.item_dragon_soul_3[pid],
    } )
end


function sInv:GetSoul(t)
    if not self[t.name][t.PlayerID] then return end
    if self[t.name][t.PlayerID] == 0 then return end
    self[t.name][t.PlayerID] = self[t.name][t.PlayerID] -1
    local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
    hero:AddItemByName(t.name)
    sInv:UpdateInventory(t.PlayerID)
end


sInv:init()
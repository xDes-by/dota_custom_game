if CustomShop == nil then
    _G.CustomShop = class({})
end

function CustomShop:init()

end

function CustomShop:UpdateShopInfoTable(pid)
    local data = {
        mmrpoints = Shop.pShop[pid].mmrpoints,
        coins = Shop.pShop[pid].coins,
        feed = Shop.pShop[pid].feed,
        pet_change = Shop.pShop[pid].pet_change,
        auto_pet = Shop.pShop[pid].auto_pet,
        likes = _G.RATING['rating'][pid]['likes'], 
		reports = _G.RATING['rating'][pid]['reports'],
		purple_gem = Shop.pShop[pid].gems[1],
		blue_gem = Shop.pShop[pid].gems[2],
		orange_gem = Shop.pShop[pid].gems[3],
		red_gem = Shop.pShop[pid].gems[4],
		green_gem = Shop.pShop[pid].gems[5],
    }
    CustomNetTables:SetTableValue("shopinfo", tostring(pid), data)
end

function CustomShop:AddRP(pid, value, notification, sendToServer)
    value = value * MultiplierManager:GetCurrencyRpMultiplier(pid)
    value = math.ceil(value)
    Shop.pShop[pid].mmrpoints = Shop.pShop[pid].mmrpoints + value
	self:UpdateShopInfoTable(pid)
    if notification then
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "ReceivingRPAlert", { value = value })
    end
    DataBase:Send(DataBase.link.AddRP, "GET", {
        data = {
            value = value
        }
    }, pid, sendToServer, nil)
    return value
end

function CustomShop:AddCoins(pid, value, notification, sendToServer)
    Shop.pShop[pid].coins = Shop.pShop[pid].coins + value
	self:UpdateShopInfoTable(pid)
    if notification then
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "ReceivingCoinsAlert", { value = value })
    end
    DataBase:Send(DataBase.link.AddCoins, "GET", {
        data = {
            value = value
        }
    }, pid, sendToServer, nil)
end

function CustomShop:AddGems(pid, info, sendToServer)
    for i = 1, 5 do
        Shop.pShop[pid].gems[i] = Shop.pShop[pid].gems[i] + (info[i] or 0)
    end
    self:UpdateShopInfoTable(pid)
    DataBase:Send(DataBase.link.AddGems, "GET", {
        data = {
            [1] = info[1] or 0,
            [2] = info[2] or 0,
            [3] = info[3] or 0,
            [4] = info[4] or 0,
            [5] = info[5] or 0,
        }
    }, pid, sendToServer, nil)
end


CustomShop:init()
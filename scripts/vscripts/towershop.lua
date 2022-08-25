LinkLuaModifier( "modifier_shopkeeper2", "modifiers/modifier_shopkeeper2", LUA_MODIFIER_MOTION_NONE )

if IsServer() then
	towershop = class({})
end

_G.nPlayers = 0
_G.resources = {}                                         

items = LoadKeyValues("scripts/kv/items.txt")                               
costs = LoadKeyValues("scripts/kv/itemscosts.txt")

function towershop:FillingNetTables()                                     
    for shop, item in pairs(items) do
        CustomNetTables:SetTableValue("items",shop,item)
    end
    for item, cost in pairs(costs) do
        CustomNetTables:SetTableValue("itemscost",item,cost)
    end
end

function towershop:StartGame()                  
	CustomGameEventManager:RegisterListener("BuyItem2", Dynamic_Wrap(towershop, 'BuyItem_dark'))     
	local blacksmith = CreateUnitByName("blacksmith", Vector(-384,-10432,384), false, nil, nil, DOTA_TEAM_GOODGUYS)
	--local blacksmith = CreateUnitByName("blacksmith", Vector(-3136,-1164,224), false, nil, nil, DOTA_TEAM_GOODGUYS)
	blacksmith:AddNewModifier(blacksmith, nil, "modifier_shopkeeper2", {})
	blacksmith:SetModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith:SetOriginalModel("models/props_gameplay/shopkeeper_fountain/shopkeeper_fountain.vmdl")
	blacksmith:StartGesture(ACT_DOTA_IDLE)
	blacksmith:SetAngles(0,-180,0)
	blacksmith:AddNewModifier(blacksmith,nil,"modifier_shop2",{})                    
end


function towershop:BuyItem_dark(t)   
  local pid = t.PlayerID                                                 
  local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)                 
  local currentgold = PlayerResource:GetGold(pid)    
	if currentgold <= 10 then return end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid),"DeactivateShop2",{})
	
	Timers:CreateTimer(0.01, function()
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(pid),"OpenShop2",{name = "blacksmith"})
	end)

	
 
  local item = items[t.shop][t.itemid]                                  
  local cost = costs[tostring(item .. "_" .. t.itemid)] or nil               
  if cost == nil and costs[item] ~= nil then                               
    cost = costs[item]  
  elseif cost == nil and costs[item] == nil then
    cost = {}
    cost["gold"] = 0
  end

  local currentwood = 0     

  if cost["gold"] or 0 <= currentgold then
		
		hero:SpendGold(cost["gold"] or 0, DOTA_ModifyGold_Unspecified)
		local purchaseditem = CreateItem(item, hero, hero)
		hero:AddItem(purchaseditem)  
  end
end
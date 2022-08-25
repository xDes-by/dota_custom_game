if herogold == nil then
	_G.herogold = class({})
end

_G.playergold = {}
_G.networth = {}
local creepArray = LoadKeyValues("scripts/npc/npc_units_custom.txt")

function herogold:init()
    ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( herogold, 'OnGameRulesStateChange'), self)
    ListenToGameEvent( 'dota_item_purchased', Dynamic_Wrap( herogold, 'OnItemPurchased'), self)
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( herogold, 'OnEntityKilled' ), self )
    
end

function herogold:OnEntityKilled( keys )
    local bResult = xpcall(function()
	--функция в которой может быть ошибка
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
    if creepArray[name] == nil or creepArray[name]["BountyGoldMin"] == nil then
        return
    end
    if killerEntity:IsRealHero() then
        local gold = creepArray[name]["BountyGoldMin"]
        gold = tonumber(gold)
        herogold:addGold(killerEntity:GetPlayerID(),gold)
    end
	--функция в которой может быть ошибка
	---------------------------------------------------------------------
	---------------------------------------------------------------------
	---------------------------------------------------------------------
	--дебаг
	end,
	function(e)
		print("-------------Error-------------")
		print(e)
		print("-------------Error-------------")
	end)  
	--дебаг
	
	--вызов вункции в которой может быть ошибка
	if bResult then
	--print("дроп выпал")
	else
	print("ошибка начисления голды")
	end    
end

function herogold:OnGameRulesStateChange()
    if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        local hero = PlayerResource:GetSelectedHeroEntity( 0 )
        playergold[0] = hero:GetGold()
        networth[0] = hero:GetGold()
    end
end

function herogold:OnItemPurchased(t)
    herogold:addGold(t.PlayerID,t.itemcost*-1)
end

function herogold:SellItem(t)
    --DeepPrintTable(t)
end


function herogold:addGold(p,g)
    g = math.floor( g + 0.5 )
    if playergold[p] == nil or playergold[p] + g < 0 then
        return false
    end
    if g > 0 then
        networth[p] = networth[p] + g
    end
    
    playergold[p] = playergold[p] + g

    local hero = PlayerResource:GetSelectedHeroEntity( p )
    hero:SetGold(0 , false) 
    if playergold[p] > 99999 then
        hero:SetGold(99999, true)
    else
        hero:SetGold(playergold[p], true)
    end
    --goldjs
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( p ), "golded", { money = playergold[p] } )
end

herogold:init()
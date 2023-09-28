if Smithy == nil then
    _G.Smithy = class({})
end
------------------------------------------------------------------------------------------ CONSTANT
local SmithyArr = {
    [0] = {main = {},gold = {},soul={},result={},gems={},stone=false},
    [1] = {main = {},gold = {},soul={},result={},gems={},stone=false},
    [2] = {main = {},gold = {},soul={},result={},gems={},stone=false},
    [3] = {main = {},gold = {},soul={},result={},gems={},stone=false},
    [4] = {main = {},gold = {},soul={},result={},gems={},stone=false},
}
local AvailableItems = {
    'item_ring_of_flux_lua','item_satanic_lua','item_sheepstick_lua','item_bloodstone_lua','item_radiance_lua',"item_greater_crit_lua",
    'item_desolator_lua','item_butterfly_lua','item_monkey_king_bar_lua','item_bfury_lua','item_veil_of_discord_lua',"item_crimson_guard_lua",
    'item_shivas_guard_lua','item_heart_lua','item_kaya_custom_lua','item_kaya_lua','item_vladmir_lua',
    'item_ethereal_blade_lua','item_pipe_lua','item_octarine_core_lua','item_skadi_lua','item_mjollnir_lua',
    'item_pudge_heart_lua','item_mage_heart_lua','item_agility_heart_lua','item_moon_shard_lua','item_hood_sword_lua','item_assault_lua','item_meteor_hammer_lua', "item_boots_of_bearing_lua", "item_sabre_blade", "item_hurricane_pike",
}
local item_gold = 'item_gold_brus'
local UpgradeCost = {
    [1] = {gems = 50, gold = 1},
    [2] = {gems = 100, gold = 1, soul = {name = 'item_forest_soul', price = 1}},
    [3] = {gems = 150, gold = 1, soul = {name = 'item_village_soul', price = 2}},
    [4] = {gems = 250, gold = 1, soul = {name = 'item_mines_soul', price = 4}},
    [5] = {gems = 400, gold = 1, soul = {name = 'item_dust_soul', price = 6}},
    [6] = {gems = 650, gold = 1, soul = {name = 'item_swamp_soul', price = 8}},
    [7] = {gems = 1050, gold = 1, soul = {name = 'item_snow_soul', price = 10}},
    [8] = {gems = 1500, gold = 1, soul = {name = 'item_divine_soul', price = 12}},
}
local npc = {}
------------------------------------------------------------------------------------------ INIT
function Smithy:init()
    CustomGameEventManager:RegisterListener("put_item_lua", Dynamic_Wrap( Smithy, 'put_item_lua' ))
    CustomGameEventManager:RegisterListener("return_item_lua", Dynamic_Wrap( Smithy, 'return_item_lua' ))
    CustomGameEventManager:RegisterListener("pick_up_item_lua", Dynamic_Wrap( Smithy, 'pick_up_item_lua' ))
    CustomGameEventManager:RegisterListener("select_stone_lua", Dynamic_Wrap( Smithy, 'select_stone_lua' ))
    CustomGameEventManager:RegisterListener("automatic_installation_lua", Dynamic_Wrap( Smithy, 'automatic_installation_lua' ))
    ListenToGameEvent( "game_rules_state_change", Dynamic_Wrap( Smithy, 'OnGameStateChanged' ), self )
    ListenToGameEvent("player_reconnected", Dynamic_Wrap( Smithy, 'OnPlayerReconnected' ), self)
end
------------------------------------------------------------------------------------------ OnGameStateChanged
function Smithy:OnGameStateChanged(t)
    local state = GameRules:State_Get()
    if state >= DOTA_GAMERULES_STATE_PRE_GAME then
        Smithy:LoadNpc() -- npc
        Timers:CreateTimer(3, function()
            for nPlayerID = 0, PlayerResource:GetPlayerCount()-1 do
                for i = 1, 5 do
                    SmithyArr[nPlayerID]['gems'][i] = _G.SHOP[nPlayerID+1]['gem_'..i] or 0
                end
                if PlayerResource:GetConnectionState(nPlayerID) == DOTA_CONNECTION_STATE_CONNECTED then
                    local send = {
                        npc = npc,
                        patron = RATING["rating"][nPlayerID+1]["patron"]
                    }
                    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "init",  send)
                    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( nPlayerID ), "update_gems_js",  SmithyArr[nPlayerID]['gems'])

                end
            end
		end)
    end
end

function Smithy:LoadNpc()  ----------------- load npc
    i = 0
    while true do
        i = i + 1
        unit = Entities:FindByName(nil, "Smithy_" .. i)
        if not unit then return i - 1
        end
        unit:AddNewModifier(unit,nil,"modifier_quest",{})
        saf = {
            unit = unit,
            name = unit:GetUnitName(),
            index = unit:entindex()
        }
        table.insert(npc, saf)
    end
end

function Smithy:OnPlayerReconnected(t)
    local state = GameRules:State_Get()
    if state >= DOTA_GAMERULES_STATE_PRE_GAME then
        Timers:CreateTimer(1, function()
            local send = {
                npc = npc,
                patron = RATING["rating"][t.PlayerID+1]["patron"]
            }
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "init",  send)
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "update_gems_js",  SmithyArr[t.PlayerID]['gems'])
		end)
    end
end

function Smithy:automatic_installation_lua(t)
    -- DeepPrintTable(t)
    local souls = {}
    for i = 2, 8 do 
        table.insert(souls, UpgradeCost[i]['soul']['name'])
    end
    if t.item_name == item_gold then
        t.type = 'gold'
    elseif t.item_name and indexOfStringInVar(AvailableItems, t.item_name) then
        t.type = 'main'
    elseif indexOf(souls, t.item_name) then
        t.type = 'soul'
    end
    if t.type then 
        Smithy:put_item_lua(t)
        if t.type == 'main' then

        end
    end
    
end

function Smithy:put_item_lua(t)
    -- print('put_item_lua')
    -- Кладем предмет
    DeepPrintTable({
        slot = t.slot,
    })
    local slot = t.slot
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    if hero then
        local current_item = hero:GetItemInSlot(slot)
        if current_item then
            local item_name = current_item:GetName()
            local quantity = current_item:GetCurrentCharges()
            if hero:GetName() ~= current_item:GetPurchaser():GetName() or slot > 8 and item_name ~= item_gold then
                return
            end
            for _,block in pairs({"item_quest_blue_stone","item_cheese_lua","item_greed_agi","item_greed_int","item_greed_str","item_weird_potion"}) do
                if item_name == block then return end
            end
            if t.type == nil then
                t.item_name = item_name
                Smithy:automatic_installation_lua(t)
                return
            end
            current_item:SetCombineLocked(true)
            if SmithyArr[t.PlayerID][t.type].item_name and SmithyArr[t.PlayerID][t.type].item_name == item_name then
                if current_item:IsStackable() then
                    quantity = quantity + SmithyArr[t.PlayerID][t.type].stuck
                else
                    Smithy:return_item_lua(t)
                end
            end
            hero:RemoveItem(current_item)
            local event = {
                item_name = item_name,
                stuck = quantity,
                slot = t.type,
            }
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "put_item_js", event )
            if SmithyArr[t.PlayerID][t.type].item_name and SmithyArr[t.PlayerID][t.type].item_name ~= item_name then
                local additem = hero:AddItemByName(SmithyArr[t.PlayerID][t.type].item_name)
                additem:SetPurchaseTime(0)
                -- additem:IsDisassemblable(false)
            end
            SmithyArr[t.PlayerID][t.type].item_name = item_name
            SmithyArr[t.PlayerID][t.type].stuck = quantity
            DeepPrintTable(SmithyArr[t.PlayerID][t.type])
            if t.notbuild == nil then
                Smithy:building_control({PlayerID = t.PlayerID,selected_gem = SmithyArr[t.PlayerID].stone, toggle = t.toggle})
            end
        end
    end
end

function Smithy:item_search_lua(t)
    t.notbuild = true
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    if hero then
        for i = 0, 14 do
            t.slot = i
            local item = hero:GetItemInSlot(i)
            if item and item:GetName() == t.item_name then
                if t.put == nil then
                    Smithy:put_item_lua(t)
                end
                return i
            end
        end
    end
    return false
end

function Smithy:return_item_lua(t)
    -- print('return_item_lua')
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    -- print(hero)
    -- print(SmithyArr[t.PlayerID][t.type].item_name)
    if hero and SmithyArr[t.PlayerID][t.type].item_name then
        local slot = Smithy:item_search_lua({PlayerID = t.PlayerID, item_name = SmithyArr[t.PlayerID][t.type].item_name, put = false})
        invItem = false
        if slot then
            invItem = hero:GetItemInSlot(slot)
        end
        if invItem and invItem:GetPurchaser():GetName() == hero:GetName() and invItem:GetCurrentCharges() > 0 and SmithyArr[t.PlayerID][t.type].stuck > 0 then
            invItem:SetCurrentCharges(invItem:GetCurrentCharges() + SmithyArr[t.PlayerID][t.type].stuck)
            t.isok = true
        else
            local return_item = hero:AddItemByName(SmithyArr[t.PlayerID][t.type].item_name)
            t.isok = false
            if return_item then
                return_item:SetCurrentCharges(SmithyArr[t.PlayerID][t.type].stuck)
                return_item:SetPurchaseTime(0)
                t.isok = true
            end
        end
        SmithyArr[t.PlayerID][t.type] = {}
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "return_item_js",  t)
    end

    if SmithyArr[t.PlayerID]['result'].done then
        Smithy:building_control({PlayerID = t.PlayerID,selected_gem = SmithyArr[t.PlayerID]['result'].gem_type, toggle = t.toggle})
        
    end
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "return_item_js",  t)
end

function Smithy:building_control(t)
    local selected_gem_1 = t.selected_gem
    local main = SmithyArr[t.PlayerID]['main']
    local soul = SmithyArr[t.PlayerID]['soul']
    local gold = SmithyArr[t.PlayerID]['gold']
    local gems = SmithyArr[t.PlayerID]['gems']
    local check = true
    local autoReturn = false
    -- print(main.item_name)
    if main.item_name and indexOfStringInVar(AvailableItems, main.item_name) then
        local vanilla_name = AvailableItems[indexOfStringInVar(AvailableItems, main.item_name)]
        SmithyArr[t.PlayerID]['result'].need = false
        local item_level = 0
        local gem_type = false
        local lock = false
        for i = 1, 8 do
            if string.find(main.item_name, vanilla_name .. i) then
                item_level = i
                break
            end
        end
        if string.find(main.item_name,vanilla_name..item_level..'_gem') then
            for i = 1, 5 do
                if main.item_name == vanilla_name..item_level..'_gem'..i then
                    gem_type = i
                    t.selected_gem = i
                    lock = true
                    break
                end
            end
        end
        local improved_item = ''
        local amount_gold = 0
        local amount_gems = 0
        local del_soul = false
        
        local nxtlvl = item_level+1
        -- print("t.selected_gem=",t.selected_gem)
        if gem_type then
            improved_item = vanilla_name..nxtlvl..'_gem'..gem_type
            amount_gold = UpgradeCost[nxtlvl].gold
            amount_gems = UpgradeCost[nxtlvl].gems
            if item_level < 8 and UpgradeCost[nxtlvl]['soul'].name == soul.item_name then
                -- print("1+1=2")
                del_soul = true
                amount_gold = amount_gold + UpgradeCost[nxtlvl]['soul'].price
            elseif item_level < 8 and UpgradeCost[nxtlvl]['soul'].name ~= soul.item_name then
                check = false
                SmithyArr[t.PlayerID]['result'].need = UpgradeCost[nxtlvl]['soul'].name
                amount_gold = amount_gold + UpgradeCost[nxtlvl]['soul'].price
                -- print('need:')
                -- print(UpgradeCost[nxtlvl]['soul'].name)
                -- print(item_gold)
                if tonumber(t.toggle) == 1 and Smithy:item_search_lua({PlayerID = t.PlayerID, item_name = UpgradeCost[nxtlvl]['soul'].name, type = 'soul', toggle = t.toggle}) then
                    Smithy:building_control({PlayerID = t.PlayerID, selected_gem = selected_gem_1, toggle = t.toggle})
                    return
                end
            end
        elseif t.selected_gem then
            improved_item = vanilla_name..item_level..'_gem'..t.selected_gem
            amount_gold = amount_gold + UpgradeCost[item_level].gold
            for i = 1, item_level do
                amount_gems = amount_gems + UpgradeCost[i].gems
            end
            if item_level < 8 then
                if soul.item_name == UpgradeCost[nxtlvl]['soul'].name then
                    del_soul = true
                    amount_gold = amount_gold + UpgradeCost[nxtlvl].gold + UpgradeCost[nxtlvl]['soul'].price
                    amount_gems = amount_gems + UpgradeCost[nxtlvl].gems
                    improved_item = vanilla_name..nxtlvl..'_gem'..t.selected_gem
                end
            end
        end

        if not gold.item_name or gold.item_name ~= item_gold then
            -- print("t.toggle=",t.toggle)
            if tonumber(t.toggle) == 1 and Smithy:item_search_lua({PlayerID = t.PlayerID, item_name = item_gold, type = 'gold', toggle = t.toggle}) then
                Smithy:building_control({PlayerID = t.PlayerID, selected_gem = selected_gem_1, toggle = t.toggle})
                return
            end
        end
        if t.selected_gem == nil then
            check = false
        elseif t.selected_gem and gems[t.selected_gem] < amount_gems then
            check = false
        end
        SmithyArr[t.PlayerID]['result'].done = improved_item
        SmithyArr[t.PlayerID]['result'].use_soul = del_soul
        SmithyArr[t.PlayerID]['result'].gold = amount_gold
        SmithyArr[t.PlayerID]['result'].gems = amount_gems
        SmithyArr[t.PlayerID]['result'].gem_type = t.selected_gem
        local enough = false
        local panel = 'visible'
        if improved_item == '' then
            panel = 'hidden'
        end
        if (amount_gold == 0 or (gold.item_name and gold.item_name == item_gold and gold.stuck >= amount_gold)) and check then
            enough = true
        end
        if t.selected_gem then
            SmithyArr[t.PlayerID].stone = t.selected_gem
        end
        local event = {
            item_name = improved_item,
            gold = amount_gold,
            gems = amount_gems,
            panel = panel,
            enough = enough,
            lock = lock,
            select = t.selected_gem,
            valid = true,
        }
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "prepare_build_js", event )
        return check
    end
    local event = {
        gold = 0,
        gems = 0,
        panel = 'hidden',
        valid = false,
    }
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "prepare_build_js", event )
    SmithyArr[t.PlayerID]['result'].done = false
    -- print('none')
    
    if main.item_name and indexOfStringInVar(AvailableItems, main.item_name) and jsItem == main.item_name then
        autoReturn = 'main'
    end
    if jsItem == item_gold then
        autoReturn = 'gold'
    end
    return autoReturn
end

function Smithy:pick_up_item_lua(t)
    -- print('pick_up_item_lua')
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    local result = SmithyArr[t.PlayerID]['result']
    local gold = SmithyArr[t.PlayerID]['gold']
    local main = SmithyArr[t.PlayerID]['main']
    local soul = SmithyArr[t.PlayerID]['soul']
    local gems = SmithyArr[t.PlayerID]['gems']
    -- DeepPrintTable(SmithyArr[t.PlayerID])
    if hero and result.done and result.gold and (result.gold == 0 or (gold.stuck and result.gold <= gold.stuck)) 
        and SmithyArr[t.PlayerID].stone and 
        result.gems and gems[SmithyArr[t.PlayerID].stone] >= result.gems then
        -- DeepPrintTable(result)
        
        if result.need and ( result.need ~= soul.item_name) then
            return false
        end
        local gem_type = result.gem_type
        -- print("result.done=",result.done)
        local additem = hero:AddItemByName(result.done)
            additem:SetPurchaseTime(0)
            -- additem:IsDisassemblable(false)
        
        
        main.item_name = false
        if result.use_soul then 
            soul.item_name = false
        end
        if result.gold > 0 then
            gold.stuck = gold.stuck - result.gold
            if gold.stuck == 0 then
                gold.item_name = false
            end
        end
        DataBase:EdditGems({PlayerID = t.PlayerID, type = gem_type, value = result.gems, action = 'remove'})
        -- print('test')
        -- print(result.gems)
        -- print(gems[gem_type])
        gems[gem_type] = gems[gem_type] - result.gems
        result = {}
        SmithyArr[t.PlayerID] = {main = main, gold = gold, soul = soul, result = result, gems = gems, stone = false}
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "pick_up_item_js", SmithyArr[t.PlayerID] )
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "update_gems_js", SmithyArr[t.PlayerID]['gems'] )
        Smithy:building_control({PlayerID = t.PlayerID, selected_gem = false, toggle = t.toggle})
    end
end

function Smithy:select_stone_lua(t)
    if t.stone then
        if t.stone == -1 then
            SmithyArr[t.PlayerID].stone = false
            local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
            -- if SmithyArr[t.PlayerID]['gold'].item_name and SmithyArr[t.PlayerID]['gold'].stuck then
            --     Smithy:return_item_lua({PlayerID = t.PlayerID, type = 'gold'})
            -- end
            if SmithyArr[t.PlayerID]['main'].item_name and SmithyArr[t.PlayerID]['main'].stuck then
                Smithy:return_item_lua({PlayerID = t.PlayerID, type = 'main', toggle = t.toggle})
            end
            if SmithyArr[t.PlayerID]['soul'].item_name and SmithyArr[t.PlayerID]['soul'].stuck then
                Smithy:return_item_lua({PlayerID = t.PlayerID, type = 'soul', toggle = t.toggle})
            end
        else
            SmithyArr[t.PlayerID].stone = t.stone
        end
        Smithy:building_control({PlayerID = t.PlayerID, selected_gem = t.stone, toggle = t.toggle})
    end
end

function Smithy:add_gems(t)
    SmithyArr[t.PlayerID]['gems'][t.type] = SmithyArr[t.PlayerID]['gems'][t.type] + t.value
    if t.shop ~= true then
        DataBase:EdditGems({PlayerID = t.PlayerID, type = t.type, value = t.value, action = 'add'})
    end
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "update_gems_js", SmithyArr[t.PlayerID]['gems'] )
end

Smithy:init()
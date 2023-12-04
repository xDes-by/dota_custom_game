local sendata = {}
if statist == nil then
	_G.statist = class({})
end


function statist:init()
    ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( statist, 'OnGameRulesStateChange'), self)
    ListenToGameEvent( 'dota_item_picked_up', Dynamic_Wrap( statist, 'itemPickedUp'), self)
    ListenToGameEvent( 'dota_match_done', Dynamic_Wrap( statist, 'GameEnd'), self)
    ListenToGameEvent( 'dota_item_purchased', Dynamic_Wrap( statist, 'OnItemPurchased'), self)
    ListenToGameEvent( "entity_killed", Dynamic_Wrap( statist, "OnEntityKilled"), self)
    -- ListenToGameEvent( "player_chat", Dynamic_Wrap( statist, "OnChat" ), self )
end

function statist:OnChat(t)
    print("statist:OnChat")
    statist:GameEnd(t)
end

function statist:itemPickedUp(t)
    if string.find(t.itemname, "soul") then

        

    end
end

function statist:GameEnd(t)
    if statist.gameend then return end
    if DataBase:IsCheatMode() then return end
    print(_G.kill_invoker)
    if _G.kill_invoker then
        sendata["game_result"] = "win"
    else
        sendata["game_result"] = "lose"
    end
    print(sendata["game_result"])
    -- sendata["rait"] = ((_G.rating_wave * diff_wave.rating_scale) + (_G.mega_boss_bonus * diff_wave.rating_scale))
    -- sendata["difficult"] = diff_wave.rating_scale
    sendata["difficult"] = diff_wave.rating_scale
    sendata["in_game_time"] = GameRules:GetGameTime()
    sendata["match_id"] = tostring(GameRules:Script_GetMatchID())
    statist:loadendstatist()
    statist.gameend = true
end

function statist:ShowState(gane, WinOrLose)
    arr = {}
    for i = 0, PlayerResource:GetPlayerCount() do
        if PlayerResource:IsValidPlayer(i) then
            local hero = PlayerResource:GetSelectedHeroEntity(i)
            arr[i] = {
                lh = hero:GetLastHits(),
                dmg = _G.physdamage[i] + _G.magdamage[i] + _G.puredamage[i],
                gold = sendata[i]['gold'],
                boss = sendata[i]['boss'],
                rating = _G.RATING['rating'][i]['points'] + gane,
                hero_name = PlayerResource:GetSelectedHeroName( i ),
            }
        end
    end

    CustomGameEventManager:Send_ServerToAllClients( "ShowState", {arr = arr, result = WinOrLose} )
    PauseGame(true)
end


function statist:loadendstatist()
    local arr = json.encode(sendata)
    local req = CreateHTTPRequestScriptVM( "POST", _G.host .. "/backend/api/stats?key=" .. _G.key ..'&match=' .. tostring(GameRules:Script_GetMatchID()) )
    req:SetHTTPRequestGetOrPostParameter('arr',arr)
    req:SetHTTPRequestAbsoluteTimeoutMS(100000)
    req:Send(function(res)
        if res.StatusCode == 200 then
            -- print(res.Body)
        end
    end)
end

function statist:OnGameRulesStateChange(t)
    
    local gamestate = GameRules:State_Get()
    

    if gamestate == DOTA_GAMERULES_STATE_PRE_GAME then
        sendata["player_count"] = PlayerResource:GetPlayerCount()
        for PlayerID = 0, PlayerResource:GetPlayerCount() - 1 do
            local hero_name = PlayerResource:GetSelectedHeroName(PlayerID)
            local sid = PlayerResource:GetSteamAccountID(PlayerID)
            sendata[PlayerID] = {
                hero_name = hero_name,
                sid = sid, 
                name = PlayerResource:GetPlayerName(PlayerID), 
                souls = {furion = {},pudge = {},erth = {},nix = {},veno = {},tiny = {},}, 
                timer = {}, 
                status = "in", 
                gold = 0,
                boss = 0,
            }
            statist:inventory_updated(PlayerID, 60)
        end
    end
end


function statist:inventory_updated(PlayerID, time)
    Timers:CreateTimer(time, function()
        -- print("timer")
        local lng = #sendata[PlayerID]["timer"] + 1
        local hero = PlayerResource:GetSelectedHeroEntity(PlayerID)
        if hero then
            local connection = PlayerResource:GetConnectionState(PlayerID)
            sendata[PlayerID]["in_game_time"] = GameRules:GetGameTime()
            sendata[PlayerID]["timer"][lng] = {
                in_game_time = GameRules:GetGameTime(),
                level = hero:GetLevel(),
                last_hits = hero:GetLastHits(),
                dmg = {
                    -- damagecount = _G.damagecount[PlayerID],
                    -- physdamage = _G.physdamage[PlayerID],
                    -- magdamage = _G.magdamage[PlayerID],
                    -- puredamage = _G.puredamage[PlayerID],
                },
                items = {

                },
            }
            sendata[PlayerID]["timer"][lng]["items"] = statist:GetAllItems(hero)
            if connection == DOTA_CONNECTION_STATE_ABANDONED then
                sendata[PlayerID]["status"] = "out"
                return nil
            end
        end
        statist:inventory_updated(PlayerID, time)
    end)
end

function statist:GetAllItems(ent)
    local items = {}
    for i=DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
        local current_item = ent:GetItemInSlot(i)
        if current_item then
            items[tostring(i)] = current_item:GetName()
        else
            items[tostring(i)] = "empty"
        end
    end
    return items
end

function statist:OnItemPurchased(t)
    sendata[t.PlayerID]['gold'] = sendata[t.PlayerID]['gold'] + t.itemcost
end

function statist:OnEntityKilled(keys)
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
    if killedUnit:GetUnitName() == "npc_invoker_boss" and (not killedUnit:HasModifier("modifier_health_voker")) then
        _G.kill_invoker = true
        statist:GameEnd()
    end
    if killerEntity:IsRealHero() then
        local pid = killerEntity:GetPlayerID()
        for _,boss in pairs({"boss_1","boss_2","boss_3","boss_4","boss_5","boss_6","boss_7","boss_8","boss_9","boss_10","boss_11","boss_12","boss_13","boss_14","boss_15","boss_16","boss_17","boss_18","boss_19","boss_20", "npc_forest_boss", "npc_village_boss", "npc_mines_boss","npc_dust_boss","npc_swamp_boss","npc_snow_boss","npc_mega_boss"}) do
            
            if name == boss then
                sendata[pid]['boss'] = sendata[pid]['boss'] + 1
    
                if name == "npc_forest_boss" then
                    local pos = #sendata[pid]["souls"]["furion"] + 1
                    sendata[pid]["souls"]["furion"][pos] = math.floor(GameRules:GetGameTime())
                elseif name == "npc_village_boss" then
                    local pos = #sendata[pid]["souls"]["pudge"] + 1
                    sendata[pid]["souls"]["pudge"][pos] = math.floor(GameRules:GetGameTime())
                elseif name == "npc_mines_boss" then
                    local pos = #sendata[pid]["souls"]["erth"] + 1
                    sendata[pid]["souls"]["erth"][pos] = math.floor(GameRules:GetGameTime())
                elseif name == "npc_dust_boss" then
                    local pos = #sendata[pid]["souls"]["nix"] + 1
                    sendata[pid]["souls"]["nix"][pos] = math.floor(GameRules:GetGameTime())
                elseif name == "npc_swamp_boss" then
                    local pos = #sendata[pid]["souls"]["veno"] + 1
                    sendata[pid]["souls"]["veno"][pos] = math.floor(GameRules:GetGameTime())
                elseif name == "npc_snow_boss" then
                    local pos = #sendata[pid]["souls"]["tiny"] + 1
                    sendata[pid]["souls"]["tiny"][pos] = math.floor(GameRules:GetGameTime())
                end
                
                return
            end
        end 
    end
end

statist:init()
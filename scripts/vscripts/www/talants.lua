local heroname = {}
local herotalant = {}
_G.progress = {}
local pInfo = {}
local lvls = {
    [1] = 1500,-- 1500
    [2] = 4500,-- 6к
    [3] = 7500,-- 13500
    [4] = 10500,-- 24 000
    [5] = 12000,-- 36000
    [6] = 13500,--49500
    [7] = 15000,--64500
    [8] = 16500,--81000
    [9] = 18000,--99000
    [10] = 18000,--117000
    [11] = 18000,--135 000
    [12] = 18000,--153 000
    [13] = 18000,--171 000
    [14] = 18000,--189 000
    [15] = 18000,--207 000
    [16] = 18000,--225 000
    [17] = 18000,--243 000
    [18] = 18000,--261 000
    [19] = 18000,--279 000
    [20] = 18000,--297 000
    [21] = 18000,--315 000
    [22] = 18000,--333 000
    [23] = 18000,--351 000
    [24] = 18000,--369 000
    [25] = 18000,--387 000
    [26] = 18000,--405 000
    [27] = 18000,--423 000
    [28] = 18000,--441 000
    [29] = 18000,--459 000
    [30] = 18000,--477 000
}
local talant_shop = {
    [1] = {
        name = "talant-shop-refresh", description = "talant-shop-refresh-description", url = "images/custom_game/talants/scroll7.png", gems = 50, rait = 250,
    },
    [2] = {
        name = "talant-shop-exp-pack-1", description = "talant-shop-exp-pack-1-description", url = "images/custom_game/talants/scroll1.png", gems = 5, rait = 50, type = "normal", gane = 1000,
    },
    [3] = {
        name = "talant-shop-exp-pack-2", description = "talant-shop-exp-pack-2-description", url = "images/custom_game/talants/scroll2.png", gems = 25, rait = 250, type = "normal", gane = 5000,
    },
    [4] = {
        name = "talant-shop-exp-pack-3", description = "talant-shop-exp-pack-3-description", url = "images/custom_game/talants/scroll3.png", gems = 50, rait = 500, type = "normal", gane = 15000,
    },
    [5] = {
        name = "talant-shop-don-exp-pack-1", description = "talant-shop-don-exp-pack-1-description", url = "images/custom_game/talants/scroll4.png", gems = 10, rait = 0, type = "donate", gane = 1000,
    },
    [6] = {
        name = "talant-shop-don-exp-pack-2", description = "talant-shop-don-exp-pack-2-description", url = "images/custom_game/talants/scroll5.png", gems = 50, rait = 0, type = "donate", gane = 5000,
    },
    [7] = {
        name = "talant-shop-don-exp-pack-3", description = "talant-shop-don-exp-pack-3-description", url = "images/custom_game/talants/scroll6.png", gems = 100, rait = 0, type = "donate", gane = 15000,
    },
}

require("data/talantdata")

if talants == nil then
	_G.talants = class({})
end


function talants:init()
    ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( talants, 'OnGameRulesStateChange'), self)
    CustomGameEventManager:RegisterListener("selectTalantButton", Dynamic_Wrap(talants, 'selectTalantButton'))
    CustomGameEventManager:RegisterListener("talant_shop", Dynamic_Wrap(talants, 'talant_shop'))
    ListenToGameEvent("player_reconnected", Dynamic_Wrap( talants, 'OnPlayerReconnected' ), self)
    CustomGameEventManager:RegisterListener("HeroesAmountInfo", Dynamic_Wrap(talants, 'HeroesAmountInfo'))
    talants.testing = {}
    talants.barakDestroy = false;
end



function talants:sendPlayer(nPlayerID)
    if progress[nPlayerID]["cheat"] == nil then
        local tab = CustomNetTables:GetTableValue("talants", tostring(nPlayerID))
        local arr = {
            sid = tab["sid"],
            heroname = heroname[nPlayerID],
            gameDonatExp = tab["gameDonatExp"],
            gameNormalExp = tab["gameNormalExp"],
            gametime = GameRules:GetGameTime(),
        }
        local req = CreateHTTPRequestScriptVM( "POST", _G.host .. "/backend/api/talants?reqtype=end&key=" .. _G.key ..'&match=' .. tostring(GameRules:Script_GetMatchID()) .. '&sid=' .. arr['sid'] )
        arr = json.encode(arr)
        req:SetHTTPRequestGetOrPostParameter('arr',arr)
        req:SetHTTPRequestAbsoluteTimeoutMS(100000)
        req:Send(function(res)
            if res.StatusCode == 200 then
                -- print(res.Body)
            end
        end)
    end
end

function talants:OnPlayerReconnected(keys)
	gamestate = GameRules:State_Get()
    if gamestate < DOTA_GAMERULES_STATE_PRE_GAME then
        Timers:CreateTimer(2, function()
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "pickInit", { progress = progress[keys.PlayerID], heroname = heroname[keys.PlayerID], herotalant = herotalant[keys.PlayerID], id = keys.PlayerID } )
        end)
    else
        Timers:CreateTimer(2, function()
            CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "talantTreeInit", { info = herotalant, players = pInfo, lvls = lvls, talant_shop = talant_shop } )
        end)
    end
end

function talants:talant_shop(t)
    if DataBase:isCheatOn() == true then
        return
    end
    local shop = CustomNetTables:GetTableValue("shopinfo", tostring(t.PlayerID))
    if t.cur == "gems" and tonumber(shop["coins"]) >= talant_shop[tonumber(t.i)]["gems"] then
        shop["coins"] = tonumber(shop["coins"]) - talant_shop[tonumber(t.i)]["gems"]
        Shop.pShop[tonumber(t.PlayerID)]["coins"] = shop["coins"]
    elseif t.cur == "rait" and tonumber(shop["mmrpoints"]) >= talant_shop[tonumber(t.i)]["rait"] then
        shop["mmrpoints"] = tonumber(shop["mmrpoints"]) - talant_shop[tonumber(t.i)]["rait"]
        Shop.pShop[tonumber(t.PlayerID)]["mmrpoints"] = shop["mmrpoints"]
    else
        return
    end
    if tonumber(t.i) == 1 then
        talants:unset({PlayerID = t.PlayerID, currency = t.cur, price = talant_shop[tonumber(t.i)][t.cur]})
    elseif tonumber(t.i) > 1 then
        talants:BuyExp({PlayerID = t.PlayerID, currency = t.cur, gane = talant_shop[tonumber(t.i)]["gane"], price = talant_shop[tonumber(t.i)][t.cur], type = talant_shop[tonumber(t.i)]["type"]})
    end
    
    CustomNetTables:SetTableValue("shopinfo", tostring(t.PlayerID), shop)
end
--------------------------------------------------------------- Стадии
function talants:OnGameRulesStateChange()
    local gamestate = GameRules:State_Get()
    if gamestate == DOTA_GAMERULES_STATE_HERO_SELECTION then
        
    elseif gamestate == DOTA_GAMERULES_STATE_PRE_GAME then
        Timers:CreateTimer(3, function() --300
            --------------------------------------------------------------- Загрузка дерева
            talants:loadTree()
            -- for i=0,4 do
            --     if PlayerResource:IsValidPlayer(i) then
                    
            --     end
            -- end
        end)
	elseif gamestate == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        --------------------------------------------------------------- DOTA_GAMERULES_STATE_GAME_IN_PROGRESS
        for nPlayerID = 0, 5 -1 do
            if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
                if PlayerResource:HasSelectedHero( nPlayerID ) and PlayerResource:GetSelectedHeroEntity( nPlayerID ) then
                    --------------------------------------------------------------- выдача опыта по таймеру
                    Timers:CreateTimer(30*60, function()
                        talants:tickExperience(nPlayerID)
                    end)
                end
            end
        end
	end
end

function talants:tickExperience(pid)

    local hero = PlayerResource:GetSelectedHeroEntity( pid )
    --------------------------------------------------------------- gave_exp
    local gave_exp = 1
    --------------------------------------------------------------- стрик
    local tab = CustomNetTables:GetTableValue("talants", tostring(pid))
    local streek = tonumber(tab["gamecout"])
    if streek > 0 then
        streek = streek * 0.05
        if streek > 1.1 then
            gave_exp = gave_exp + 1.1
        else
            gave_exp = gave_exp + streek
        end
    end
    --------------------------------------------------------------- опыт за сложности
    if diff_wave.rating_scale == 0 then gave_exp = gave_exp * 0.5 end
    if diff_wave.rating_scale == 1 then gave_exp = gave_exp * 1 end
    if diff_wave.rating_scale == 2 then gave_exp = gave_exp * 1.25 end
    if diff_wave.rating_scale == 3 then gave_exp = gave_exp * 1.50 end
    if diff_wave.rating_scale == 4 then gave_exp = gave_exp * 1.75 end
    tab["gave_exp"] = gave_exp
    CustomNetTables:SetTableValue("talants", tostring(pid), tab)
    Timers:CreateTimer(1, function()
        local connectState = PlayerResource:GetConnectionState(pid)	
        if bot(pid) or connectState == DOTA_CONNECTION_STATE_ABANDONED or connectState == DOTA_CONNECTION_STATE_FAILED or connectState == DOTA_CONNECTION_STATE_UNKNOWN or DataBase:isCheatOn() then --  
            return
        end
        
        
        if not hero:HasModifier("modifier_fountain_invulnerability") then
            talants:AddExperienceDonate(pid, gave_exp)
            talants:AddExperience(pid, gave_exp)
        end
        
        if wave_count == 0 or _G.kill_invoker == true or _G.destroyed_barracks == true then
            return nil
        end
        return 1
    end)
end

function talants:selectTalantButton(t)
    local id = t.PlayerID
    local arg = t.i .. t.j
    if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
        local tab = CustomNetTables:GetTableValue("talants", tostring(id))

        if tonumber(tab[t.i .. t.j]) == 1 then return end

        if t.j == 11 and tonumber(tab[t.i .. 8]) ~= 1 then talants:FastLearning(t) return end

        if t.j == 10 and tonumber(tab[t.i .. 7]) ~= 1 then talants:FastLearning(t) return end

        if t.j == 9 and tonumber(tab[t.i .. 6]) ~= 1 then talants:FastLearning(t) return end

        if (t.j == 6 or t.j == 7 or t.j == 8) and (tonumber(tab[t.i .. 5]) ~= 1 and tonumber(tab[t.i .. 6]) ~= 1 and tonumber(tab[t.i .. 7]) ~= 1 and tonumber(tab[t.i .. 8]) ~= 1) then talants:FastLearning(t) return end
        
        if t.j == 5 and tonumber(tab[t.i .. 4]) ~= 1 then talants:FastLearning(t) return end

        if t.j == 4 and tonumber(tab[t.i .. 3]) ~= 1 then talants:FastLearning(t) return end

        if t.j == 3 and tonumber(tab[t.i .. 2]) ~= 1 then talants:FastLearning(t) return end

        if t.j == 2 and tonumber(tab[t.i .. 1]) ~= 1 then talants:FastLearning(t) return end

        if t.j == 1 and t.i ~= "don" then 
            local boo = 0
            if tonumber(tab["int1"]) == 1 then boo = boo + 1 end
            if tonumber(tab["str1"]) == 1 then boo = boo + 1 end
            if tonumber(tab["agi1"]) == 1 then boo = boo + 1 end
            if boo >= tonumber(tab["cout"]) then
                return
            end
        elseif t.j == 1 and t.i == "don" and RATING["rating"][id+1]["patron"] ~= 1 and DataBase:isCheatOn() == false then
            return
        end
        if t.i == "don" and tonumber(tab["freedonpoints"]) > 0 then
            tab["freedonpoints"] = tonumber(tab["freedonpoints"]) - 1
            tab[arg] = 1
        elseif t.i ~= "don" and tonumber(tab["freepoints"]) > 0 then
            tab["freepoints"] = tonumber(tab["freepoints"]) - 1
            tab[arg] = 1
        else
            return
        end
        CustomNetTables:SetTableValue("talants", tostring(id), tab)
        local heroName = PlayerResource:GetSelectedHeroName(id)
		local hero = PlayerResource:GetSelectedHeroEntity(id)
        local tree = talantlist[heroName]
        local skillname = nil
        for skill_key, skill_value in pairs(tree) do
            for pos_key, pos_value in pairs(skill_value.place) do
                local s = pos_value
                local words = {}
                for w in (s .. " "):gmatch("([^ ]*) ") do 
                    table.insert(words, w) 
                end
                if words[1] == t.i and tonumber(words[2]) == tonumber(t.j) then
                    skillname = skill_key
                    break
                end
            end
            if skillname ~= nil then
                break
            end
        end
        if t.i == "don" then
            hero:AddNewModifier( hero, nil, skillname, {} )
        elseif t.i ~= "don" then
            hero:AddAbility(skillname):SetLevel(1)
        end
    elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_HERO_SELECTION then
        if t.i == "don" and tonumber(progress[id]["freedonpoints"]) > 0 then
            progress[id]["freedonpoints"] = tonumber(progress[id]["freedonpoints"]) - 1
            progress[id][arg] = 1
        elseif t.i ~= "don" and tonumber(progress[id]["freepoints"]) > 0 then
            progress[id]["freepoints"] = tonumber(progress[id]["freepoints"]) - 1
            progress[id][arg] = 1
        else
            return
        end
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( id ), "updatetab", { progress = progress[id] } )
    end
    if not DataBase:isCheatOn() and progress[id]["cheat"] == nil and not talants.testing[id] then
        talants:sendServer({PlayerID = id, changename = arg, value = 1, changetype = "set", chartype = "int", win_lose = nil})
    end
end

function talants:FastLearning(t)
    local levelNeed = 5
    if t.j < 5 then 
        levelNeed = t.j
    end
    if t.j == 6 or t.j == 7 or t.j == 8 then
        levelNeed = levelNeed + 1
    end
    if t.j == 6 or t.j == 7 or t.j == 8 then
        levelNeed = levelNeed + 2
    end
    if t.j == 12 then
        levelNeed = levelNeed + 3
    end
    local tab = CustomNetTables:GetTableValue("talants", tostring(t.PlayerID))
    local branch_count = 0
    for i = 1, 5 do
        if tab[t.i..i] == 1 then
            branch_count = branch_count + 1
        end
    end
    if tab[t.i..6] == 1 or tab[t.i..7] == 1 or tab[t.i..8] == 1 then
        branch_count = branch_count + 1
    end
    if tab[t.i..9] == 1 or tab[t.i..10] == 1 or tab[t.i..11] == 1 then
        branch_count = branch_count + 1
    end
    
    if (t.i == 'don' and tab['freedonpoints'] >= levelNeed - branch_count) or (t.i ~= 'don' and tab['freepoints'] >= levelNeed - branch_count) then
        if t.j >= 2 and tab[t.i..1] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 1})
        end
        if t.j >= 3 and tab[t.i..1] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 2})
        end
        if t.j >= 4 and tab[t.i..1] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 3})
        end
        if t.j >= 5 and tab[t.i..1] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 4})
        end
        if t.j >= 6 and tab[t.i..1] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 5})
        end
        if t.j == 9 and tab[t.i..1] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 6})
        end
        if t.j == 10 and tab[t.i..1] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 7})
        end
        if t.j == 11 and tab[t.i..1] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 8})
        end
        talants:selectTalantButton(t)
    end
end

function talants:giveExperienceFromQuest(id, n)
    local tab = CustomNetTables:GetTableValue("talants", tostring(id))
    talants:AddExperience(id, n)
    if RATING["rating"][id+1]["patron"] == 1 then
        talants:AddExperienceDonate(id, n)
    end
end

function talants:AddExperience(id, n)
    local tab = CustomNetTables:GetTableValue("talants", tostring(id))
    -- print("don2=",tab["don2"])
    if tab["don2"] == 1 then
        n = n * 1.15
    end
    -- tab["gave_exp"] = n
    this_lvl = 0
    totalexp = 0
    for k,v in pairs(lvls) do
        if tonumber(tab["totalexp"]) >= totalexp + v then -- 1750
            this_lvl = this_lvl + 1
            totalexp = totalexp + v
        else
            break
        end
    end
    if lvls[tonumber(tab["level"]) + 1] then
        local next_lvl = totalexp + lvls[tonumber(tab["level"]) + 1]

        if tonumber(tab["totalexp"]) < next_lvl and tonumber(tab["totalexp"]) + n >= next_lvl then
            tab["level"] = tonumber(tab["level"])+1
            if tonumber(tab["level"]) <= 14 or tonumber(tab["level"]) == 30 then
                tab["freepoints"] = tonumber(tab["freepoints"])+1
            end
        end
    end
    tab["totalexp"] = tonumber(tab["totalexp"]) + n
    if tab["gameNormalExp"] then
        tab["gameNormalExp"] = tonumber(tab["gameNormalExp"]) + n
    else
        tab["gameNormalExp"] = n
    end
    
    CustomNetTables:SetTableValue("talants", tostring(id), tab)
end

function talants:AddExperienceDonate(id, n)
    
    local tab = CustomNetTables:GetTableValue("talants", tostring(id))
    if RATING["rating"][id+1]["patron"] == nil or RATING["rating"][id+1]["patron"] == 0 then
        return
    end
    if tab['don2'] == 1 then
        n = n * 1.15
    end
    tab["donavailable"] = 1
    this_lvl = 0
    totalexp = 0
   
    for k,v in pairs(lvls) do
        if tonumber(tab["totaldonexp"]) >= totalexp + v then -- 1750
            this_lvl = this_lvl + 1
            totalexp = totalexp + v
        else
            break
        end
    end
    
    if lvls[tonumber(tab["donlevel"]) + 1] then
        local next_lvl = totalexp + lvls[tonumber(tab["donlevel"]) + 1]
        
        if tonumber(tab["totaldonexp"]) < next_lvl and tonumber(tab["totaldonexp"]) + n >= next_lvl then
            tab["donlevel"] = tonumber(tab["donlevel"])+1
            if tonumber(tab["donlevel"]) <= 7 or tonumber(tab["donlevel"]) == 30 then
                tab["freedonpoints"] = tonumber(tab["freedonpoints"])+1
            end
        end
    end

    if tab["gameDonatExp"] then
        tab["gameDonatExp"] = tonumber(tab["gameDonatExp"]) + n
    else
        tab["gameDonatExp"] = n
    end
    tab["totaldonexp"] = tonumber(tab["totaldonexp"]) + n

    CustomNetTables:SetTableValue("talants", tostring(id), tab)
end


------------------------------------------          Модифаеры
LinkLuaModifier( "modifier_don1", "abilities/talents/modifiers/modifier_don1", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don2", "abilities/talents/modifiers/modifier_don2", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don3", "abilities/talents/modifiers/modifier_don3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don4", "abilities/talents/modifiers/modifier_don4", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don5", "abilities/talents/modifiers/modifier_don5", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don6", "abilities/talents/modifiers/modifier_don6", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don7", "abilities/talents/modifiers/modifier_don7", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don8", "abilities/talents/modifiers/modifier_don8", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don9", "abilities/talents/modifiers/modifier_don9", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don10", "abilities/talents/modifiers/modifier_don10", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don11", "abilities/talents/modifiers/modifier_don11", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_don_last", "abilities/talents/modifiers/modifier_don_last", LUA_MODIFIER_MOTION_NONE )

------------------------------------------     Выдача скилов
function talants:addskill(nPlayerID, add)
    local arr = {}
    local heroName = PlayerResource:GetSelectedHeroName(nPlayerID)
    local hero = PlayerResource:GetSelectedHeroEntity(nPlayerID)
    local tab = CustomNetTables:GetTableValue("talants", tostring(nPlayerID))
    for k,v in pairs({"str", "agi", "int", "don"}) do
        for i = 1, 12 do
            local arg = v .. tostring(i)
            if tonumber(tab[arg]) > 0 then
                local tree = talantlist[heroName]
                local skillname = nil
                ------------------------------------------      цыкл по всем талантом этого героя
                for skill_key, skill_value in pairs(tree) do
                    for pos_key, pos_value in pairs(skill_value.place) do
                        local s = pos_value
				
                        local words = {}
                        for w in (s .. " "):gmatch("([^ ]*) ") do 
                            table.insert(words, w) 
                        end
                        ------------------------------------------     Поиск скила
                        if words[1] == v and tonumber(words[2]) == i then		
                            skillname = skill_key
                            break
                        end
                    end
                    if skillname ~= nil then
                        break
                    end
                end
                if v == "don" then
                    ------------------------------------------     модифаеры
                    if add == true and RATING["rating"][nPlayerID+1]["patron"] == 1 then
                        hero:AddNewModifier( hero, nil, skillname, {} )
                    elseif add == false then
                        hero:RemoveModifierByName( skillname )
                    end
                else
                    ------------------------------------------     скилы
                    if add == true then
                        -- print(v,i,skillname)
                        hero:AddAbility(skillname):SetLevel(1)
                    elseif add == false then
                        hero:RemoveAbility( skillname )
                    end
                end
            end
        end
    end
	
end

function talants:loadTree(PlayerID)
    --------------------------------------------------------------- Создание дерева
    -- print("loadTree INIT")
    for nPlayerID = 0, 5 -1 do
        if PlayerResource:GetTeam( nPlayerID ) == DOTA_TEAM_GOODGUYS then
            if PlayerResource:HasSelectedHero( nPlayerID ) then
                local heroname = PlayerResource:GetSelectedHeroName( nPlayerID )
                local index = PlayerResource:GetSelectedHeroEntity( nPlayerID ):entindex()
                local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
                pInfo[nPlayerID] = { heroname, index}
                CustomNetTables:SetTableValue("talants", tostring(nPlayerID), progress[nPlayerID])
-----------------------------------------------------------------------------------------------------------------------------	
                talants:addskill(nPlayerID, true)
            end
        end
    end
    CustomGameEventManager:Send_ServerToAllClients( "talantTreeInit", { info = herotalant, players = pInfo, lvls = lvls, talant_shop = talant_shop, match =  tostring(GameRules:Script_GetMatchID())} )
end

function talants:ReplaceTree()

end

function talants:ChangeHeroLoadTree(PlayerID)
    -- print("ChangeHeroLoadTree")
    pInfo[PlayerID] = {
        PlayerResource:GetSelectedHeroName( PlayerID ), 
        PlayerResource:GetSelectedHeroEntity( PlayerID ):entindex()
    }
    CustomGameEventManager:Send_ServerToAllClients( "ChangeHeroLoadTree", { info = herotalant, players = pInfo, lvls = lvls, talant_shop = talant_shop, PlayerID = PlayerID, match =  tostring(GameRules:Script_GetMatchID())} )
    CustomNetTables:SetTableValue("talants", tostring(PlayerID), progress[PlayerID])
end

function bot(nPlayerID)
return PlayerResource:GetSteamAccountID(nPlayerID) < 1000
end

function talants:pickinfo(PlayerID,AutoLoad)
    heroname[PlayerID] = PlayerResource:GetSelectedHeroName( PlayerID )
    herotalant[PlayerID] = talantlist[heroname[PlayerID]]
    local arr = {
		sid = PlayerResource:GetSteamAccountID( PlayerID ),
		heroname = heroname[PlayerID],
		name = PlayerResource:GetPlayerName( PlayerID ),
	}
    
	local req = CreateHTTPRequestScriptVM( "POST", _G.host .. "/backend/api/talants?reqtype=firstinit&key=" .. _G.key ..'&match=' .. tostring(GameRules:Script_GetMatchID()) .. '&sid=' .. arr['sid'] )
    arr = json.encode(arr)
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
            progress[PlayerID] = json.decode(res.Body)
            talants:fillTabel(PlayerID, DataBase:isCheatOn(), true)
            if AutoLoad then
                talants:ChangeHeroLoadTree(PlayerID)
                talants:addskill(PlayerID, true)
            end
        end
	end)
end
------------------------------------------     заполнение таблицы
function talants:fillTabel(PlayerID, isCheat, isload)
    ------------------------------------------     чит мод
    if isCheat then
        for k,v in pairs({'agi','int','don','str'}) do
            for i = 1, 12 do
                arg = v .. i
                progress[PlayerID][arg] = 0
            end
        end
        
        progress[PlayerID]["totalexp"] = 1500000
        progress[PlayerID]["totaldonexp"] = 1500000
    end
    ------------------------------------------     вторая ветка, если куплена карточка
    if Shop.pShop[PlayerID] and Shop.pShop[PlayerID][4] then
        for k,v in pairs(Shop.pShop[PlayerID][4]) do
            if v["hero"] and v["hero"] == heroname[PlayerID] and v["status"] == "active" then
                progress[PlayerID]["cout"] = 2
                break
            end
        end
    else
        progress[PlayerID]["cout"] = 1
    end
    ------------------------------------------     выдача донатного опыта
    if RATING["rating"][PlayerID+1]["patron"] == "1" then
        progress[PlayerID]["donavailable"] = 1
    end
    ------------------------------------------     подсчет уровня
    level = 0
    totalexp = 0
    for k,v in pairs(lvls) do
        if totalexp + v <= tonumber(progress[PlayerID]["totalexp"]) then
            level = level + 1
            totalexp = totalexp + v
        else
            break
        end
    end
    ----------------------------------------- выдача скил поинтов
    progress[PlayerID]["level"] = level
    freepoints = level
    if level > 14 then
        freepoints = 14
        if level >= 30 then 
            freepoints = 15
        end
    end

    for k,v in pairs({"int","str","agi"}) do
        for i = 1, 12 do
            arg = v .. i
            if progress[PlayerID][arg] == 1 then
                freepoints = freepoints -1
            end
        end
    end
    progress[PlayerID]["freepoints"] = freepoints
    donlevel = 0
    totaldonexp = 0
    for k,v in pairs(lvls) do
        if totaldonexp + v <= tonumber(progress[PlayerID]["totaldonexp"]) then
            donlevel = donlevel + 1
            totaldonexp = totaldonexp + v
        else
            break
        end
    end
    progress[PlayerID]["donlevel"] = donlevel
    freedonpoints = donlevel
    if donlevel > 7 then
        freedonpoints = 7
        if donlevel >= 30 then
            freedonpoints = 8
        end
    end
    -- if donlevel > 7 then 7 else donlevel end
    for i = 1, 12 do
        arg = "don" .. i
        if progress[PlayerID][arg] == 1 then
            freedonpoints = freedonpoints -1
        end
    end
    progress[PlayerID]["freedonpoints"] = freedonpoints

    if isCheat then

        progress[PlayerID]["donavailable"] = 1
        progress[PlayerID]["cout"] = 2

    end

    -- DeepPrintTable(progress[PlayerID])
    CustomNetTables:SetTableValue("talants", tostring(PlayerID), progress[PlayerID])

    -------------------------------- первая загрузк
    if isload == true then
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( PlayerID ), "pickInit", { progress = progress[PlayerID], heroname = heroname[PlayerID], herotalant = herotalant[PlayerID], id = nPlayerID } )
    end
    
end

function talants:sendServer(tab)
    -- {"sid":455872541,"heroname":"npc_dota_hero_juggernaut","name":"Shroedinger`s cat", "changename": "int1", "value": 1, "changetype": "set", "chartype": "int", "in_game_time": 600, "win_lose": 0, "stratege_time": 0}
    local arr = {
		sid = PlayerResource:GetSteamAccountID( tab.PlayerID ),
		heroname = tab.heroname or heroname[tab.PlayerID],
		name = PlayerResource:GetPlayerName( tab.PlayerID ),
		changename = tab.changename,
		value = tab.value,
		changetype = tab.changetype,
		chartype = tab.chartype,
        in_game_time = GameRules:GetGameTime(),
        win_lose = tab.win_lose,
        stratege_time = 0,
	}
    if GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME then
        arr["stratege_time"] = 1
    end

	local req = CreateHTTPRequestScriptVM( "POST", _G.host .. "/backend/api/talants?reqtype=edit&key=" .. _G.key ..'&match=' .. tostring(GameRules:Script_GetMatchID()) .. '&sid=' .. arr['sid'] )
    arr = json.encode(arr)
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
		
        end
	end)

end

function talants:BuyExp(t)
    -- print("talants:BuyExp",t.type)
    local arr = {
		sid = PlayerResource:GetSteamAccountID( t.PlayerID ),
		heroname = PlayerResource:GetSelectedHeroName( t.PlayerID ),
		name = PlayerResource:GetPlayerName( t.PlayerID ),
        in_game_time = GameRules:GetGameTime(),
        stratege_time = 0,
        currency = t.currency,
        gane = t.gane,
        price = t.price,
        type = t.type,
	}
    if GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME then
        arr[stratege_time] = 1
    end

	local req = CreateHTTPRequestScriptVM( "POST", _G.host .. "/backend/api/buy-exp?key=" .. _G.key ..'&match=' .. tostring(GameRules:Script_GetMatchID()) .. '&sid=' .. arr['sid'] )
    arr = json.encode(arr)
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
            -- print(res.Body)
		end
	end)
    local tab = CustomNetTables:GetTableValue("talants", tostring(t.PlayerID))
    if t.type == "normal" then
        tab['totalexp'] = tonumber(tab['totalexp']) + t.gane
        level = talants:coutExp(tonumber(tab['totalexp']))
        if level > tonumber(tab['level']) then
            local sp = tonumber(tab['level']) - level
            sp = sp * -1
            tab['freepoints'] = tonumber(tab['freepoints']) + sp
        end
        tab['level'] = level
    elseif t.type == "donate" then
        tab['totaldonexp'] = tonumber(tab['totaldonexp']) + t.gane
        donlevel = talants:coutExp(tonumber(tab['totaldonexp']))
        if donlevel > tonumber(tab['donlevel']) then
            local sp = tonumber(tab['donlevel']) - donlevel
            sp = sp * -1
            tab['freedonpoints'] = tonumber(tab['freedonpoints']) + sp
        end
        tab['donlevel'] = donlevel
    end
    progress[t.PlayerID]['totalexp'] = tab['totalexp']
    progress[t.PlayerID]['freepoints'] = tab['freepoints']
    progress[t.PlayerID]['totaldonexp'] = tab['totaldonexp']
    progress[t.PlayerID]['freedonpoints'] = tab['freedonpoints']
    -- DeepPrintTable(tab)
    CustomNetTables:SetTableValue("talants", tostring(t.PlayerID), tab)
end

function talants:unset(t)
    local arr = {
		sid = PlayerResource:GetSteamAccountID( t.PlayerID ),
		heroname = PlayerResource:GetSelectedHeroName( t.PlayerID ),
		name = PlayerResource:GetPlayerName( t.PlayerID ),
        in_game_time = GameRules:GetGameTime(),
        stratege_time = 0,
        currency = t.currency,
        price = t.price,

	}
    if GameRules:State_Get() < DOTA_GAMERULES_STATE_PRE_GAME then
        arr[stratege_time] = 1
    end
    if not talants.testing[t.PlayerID] then
        local req = CreateHTTPRequestScriptVM( "POST", _G.host .. "/backend/api/talants?reqtype=unset&key=" .. _G.key ..'&match=' .. tostring(GameRules:Script_GetMatchID()) .. '&sid=' .. arr['sid'] )
        arr = json.encode(arr)
        req:SetHTTPRequestGetOrPostParameter('arr',arr)
        req:SetHTTPRequestAbsoluteTimeoutMS(100000)
        req:Send(function(res)
            if res.StatusCode == 200 then
                -- print(res.Body)
            end
        end)
    end
    local tab = CustomNetTables:GetTableValue("talants", tostring(t.PlayerID))
    talants:addskill(t.PlayerID, false)
    for k,v in pairs({'agi','int','str','don'}) do
        for i = 1, 12 do
            arg = v .. i
            tab[arg] = 0
        end
    end
    progress[t.PlayerID] = tab
    talants:fillTabel(t.PlayerID, false, false)
end

function talants:coutExp(expnow)
    level = 0
    totalexp = 0
    for k,v in pairs(lvls) do
        if totalexp + v <= tonumber(expnow) then
            level = level + 1
            totalexp = totalexp + v
        else
            break
        end
    end
    return level
end

function talants:HeroesAmountInfo(t)
    DeepPrintTable(t)
    t.hero_name = progress[t.portID]["hero_name"]
    local count = DataBase:GetHeroesTalantCount(t)
    
end

talants:init()
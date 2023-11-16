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
    [31] = 18000,
    [32] = 18000,
    [33] = 18000,
    [34] = 18000,
    [35] = 18000,
    [36] = 18000,
    [37] = 18000,
    [38] = 18000,
    [39] = 18000,
    [40] = 18000,
    [41] = 18000,
    [42] = 18000,
    [43] = 18000,
    [44] = 18000,
    [45] = 18000,
    [46] = 18000,
    [47] = 18000,
    [48] = 18000,
    [49] = 18000,
    [50] = 18000,
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

if talants == nil then
	_G.talants = class({})
end


function talants:init()
    ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( talants, 'OnGameRulesStateChange'), self)
    CustomGameEventManager:RegisterListener("selectTalantButton", Dynamic_Wrap(talants, 'selectTalantButton'))
    CustomGameEventManager:RegisterListener("selectTalantCheat", Dynamic_Wrap(talants, 'selectTalantCheat'))
    CustomGameEventManager:RegisterListener("talant_shop", Dynamic_Wrap(talants, 'talant_shop'))
    ListenToGameEvent("player_reconnected", Dynamic_Wrap( talants, 'OnPlayerReconnected' ), self)
    CustomGameEventManager:RegisterListener("HeroesAmountInfo", Dynamic_Wrap(talants, 'HeroesAmountInfo'))
    talants.testing = {}
    talants.barakDestroy = false;
    talants.hell_game = {}
    talants.levelMax = #lvls
    talants.calculated_levels = {}
    talants.calculated_levels[0] = 0
    for i=1,talants.levelMax do
        talants.calculated_levels[i] = talants.calculated_levels[i-1] + lvls[i]
    end
    talants.tab = {}
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
    -- if DataBase:IsCheatMode() == true then
    --     return
    -- end
    local shop = CustomNetTables:GetTableValue("shopinfo", tostring(t.PlayerID))
    if t.cur == "gems" and tonumber(shop["coins"]) >= talant_shop[tonumber(t.i)]["gems"] then
        shop["coins"] = tonumber(shop["coins"]) - talant_shop[tonumber(t.i)]["gems"]
        Shop.pShop[tonumber(t.PlayerID)]["coins"] = shop["coins"]
    elseif t.cur == "rait" and tonumber(shop["mmrpoints"]) >= talant_shop[tonumber(t.i)]["rait"] then
        shop["mmrpoints"] = tonumber(shop["mmrpoints"]) - talant_shop[tonumber(t.i)]["rait"]
        Shop.pShop[tonumber(t.PlayerID)]["mmrpoints"] = shop["mmrpoints"]
    else
        CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID), "CreateIngameErrorMessage", {message="#dota_don_shop_error"})
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
            if PlayerResource:IsValidPlayer(nPlayerID) and PlayerResource:HasSelectedHero( nPlayerID ) and PlayerResource:GetSelectedHeroEntity( nPlayerID ) then
                --------------------------------------------------------------- выдача опыта по таймеру
                Timers:CreateTimer(30*60, function()
                    talants:tickExperience(nPlayerID)
                end)
            end
        end
	end
end

function talants:tickExperience(pid)

    local hero = PlayerResource:GetSelectedHeroEntity( pid )
    --------------------------------------------------------------- gave_exp
    local gave_exp = 1
    --------------------------------------------------------------- стрик
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
    talants.tab[pid]["gave_exp"] = gave_exp * diff_wave.talent_scale
    CustomNetTables:SetTableValue("talants", tostring(pid), talants.tab[pid])
    Timers:CreateTimer(1, function()
        local connectState = PlayerResource:GetConnectionState(pid)	
        if bot(pid) or connectState == DOTA_CONNECTION_STATE_ABANDONED or connectState == DOTA_CONNECTION_STATE_FAILED or connectState == DOTA_CONNECTION_STATE_UNKNOWN or DataBase:IsCheatMode() then --  
            return
        end
        
        
        if not hero:HasModifier("modifier_fountain_invulnerability") then
            talants:AddExperienceDonate(pid, gave_exp)
            talants:AddExperience(pid, gave_exp)
            talants:UpdateGainValue(pid, gave_exp)
        end
        
        if wave_count == 0 or _G.kill_invoker == true or _G.destroyed_barracks == true then
            return nil
        end
        return 1
    end)
end

function talants:AddAbilityFiltered(hero, skillname, place)
    if diff_wave.rating_scale == 0 and place == 12 then return end

    ability = hero:AddAbility(skillname)
    ability:SetLevel(1)
end

function talants:AddModifierFiltered(hero, skillname, place, level)
    if diff_wave.rating_scale == 0 and place == 12 then return end
    modifier = hero:AddNewModifier( hero, nil, skillname, {} )
    modifier:SetStackCount(level)
end

function talants:selectTalantCheat(t)
    if not talants.testing[t.PlayerID] then return end
    if ChatCommands:IsAvailable("selectTalantCheat", t.PlayerID) == false then return end
    local arg = t.i .. t.j
    if talants.tab[t.PlayerID][arg] == 1 then return end
    if t.i == "don" and tonumber(talants.tab[t.PlayerID]["freedonpoints"]) > 0 then
        talants.tab[t.PlayerID]["freedonpoints"] = tonumber(talants.tab[t.PlayerID]["freedonpoints"]) - 1
        talants.tab[t.PlayerID][arg] = 1
    elseif t.i ~= "don" and tonumber(talants.tab[t.PlayerID]["freepoints"]) > 0 then
        talants.tab[t.PlayerID]["freepoints"] = tonumber(talants.tab[t.PlayerID]["freepoints"]) - 1
        talants.tab[t.PlayerID][arg] = 1
    else
        return
    end
    CustomNetTables:SetTableValue("talants", tostring(t.PlayerID), talants.tab[t.PlayerID])
    local heroName = PlayerResource:GetSelectedHeroName(t.PlayerID)
    local hero = PlayerResource:GetSelectedHeroEntity(t.PlayerID)
    local tree = GetHeroTalentsData(heroName)
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
    if t.i == "don" or t.j <= 5 then
        talants:AddModifierFiltered(hero, skillname, t.j, tab[arg])
    elseif t.i ~= "don" then
        talants:AddAbilityFiltered(hero, skillname, t.j)
    end
end

function talants:selectTalantButton(t)
    local PlayerID = t.PlayerID
    local arg = t.i .. t.j
    if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
        if t.i == "don" and RATING["rating"][PlayerID]["patron"] ~= 1 and DataBase:IsCheatMode() == false then return end

        if t.codeCall then
            if tonumber(talants.tab[t.PlayerID][t.i .. t.j]) > 0 then return end
        else
            if t.j <= 5 and tonumber(talants.tab[t.PlayerID][t.i .. t.j]) == 6 then return end
            if t.j > 5 and tonumber(talants.tab[t.PlayerID][t.i .. t.j]) == 1 then return end
        end

        if t.j == 11 and tonumber(talants.tab[t.PlayerID][t.i .. 8]) ~= 1 then talants:FastLearning(t) return end

        if t.j == 10 and tonumber(talants.tab[t.PlayerID][t.i .. 7]) ~= 1 then talants:FastLearning(t) return end

        if t.j == 9 and tonumber(talants.tab[t.PlayerID][t.i .. 6]) ~= 1 then talants:FastLearning(t) return end

        if (t.j == 6 or t.j == 7 or t.j == 8) and (tonumber(talants.tab[t.PlayerID][t.i .. 5]) ~= 1 and tonumber(talants.tab[t.PlayerID][t.i .. 6]) ~= 1 and tonumber(talants.tab[t.PlayerID][t.i .. 7]) ~= 1 and tonumber(talants.tab[t.PlayerID][t.i .. 8]) ~= 1) then talants:FastLearning(t) return end
        
        if t.j == 5 and tonumber(talants.tab[t.PlayerID][t.i .. 4]) == 0 then talants:FastLearning(t) return end

        if t.j == 4 and tonumber(talants.tab[t.PlayerID][t.i .. 3]) == 0 then talants:FastLearning(t) return end

        if t.j == 3 and tonumber(talants.tab[t.PlayerID][t.i .. 2]) == 0 then talants:FastLearning(t) return end

        if t.j == 2 and tonumber(talants.tab[t.PlayerID][t.i .. 1]) == 0 then talants:FastLearning(t) return end

        if t.j == 1 and t.i ~= "don" then 
            local boo = 0
            if tonumber(talants.tab[t.PlayerID]["int1"]) > 0 and t.i ~= "int" then boo = boo + 1 end
            if tonumber(talants.tab[t.PlayerID]["str1"]) > 0 and t.i ~= "str" then boo = boo + 1 end
            if tonumber(talants.tab[t.PlayerID]["agi1"]) > 0 and t.i ~= "agi" then boo = boo + 1 end
            print(talants.tab[t.PlayerID]["cout"]," ",boo)
            if boo >= tonumber(talants.tab[t.PlayerID]["cout"]) then
                return
            end
        end
        if t.i == "don" and tonumber(talants.tab[t.PlayerID]["freedonpoints"]) > 0 then
            talants.tab[t.PlayerID]["freedonpoints"] = tonumber(talants.tab[t.PlayerID]["freedonpoints"]) - 1
            talants.tab[t.PlayerID][arg] = 1
        elseif t.i ~= "don" and tonumber(talants.tab[t.PlayerID]["freepoints"]) > 0 then
            talants.tab[t.PlayerID]["freepoints"] = tonumber(talants.tab[t.PlayerID]["freepoints"]) - 1
            if t.j > 5 then
                talants.tab[t.PlayerID][arg] = 1
            else
                talants.tab[t.PlayerID][arg] = talants.tab[t.PlayerID][arg] + 1
            end
        else
            return
        end
        CustomNetTables:SetTableValue("talants", tostring(PlayerID), talants.tab[PlayerID])
        local heroName = PlayerResource:GetSelectedHeroName(PlayerID)
		local hero = PlayerResource:GetSelectedHeroEntity(PlayerID)
        local tree = GetHeroTalentsData(heroName)
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
        if t.i == "don" or t.j <= 5 then
            talants:AddModifierFiltered(hero, skillname, t.j, tab[arg])
        elseif t.i ~= "don" then
            talants:AddAbilityFiltered(hero, skillname, t.j)
        end
    elseif GameRules:State_Get() >= DOTA_GAMERULES_STATE_HERO_SELECTION then
        if t.i == "don" and tonumber(progress[PlayerID]["freedonpoints"]) > 0 then
            progress[PlayerID]["freedonpoints"] = tonumber(progress[PlayerID]["freedonpoints"]) - 1
            progress[PlayerID][arg] = 1
        elseif t.i ~= "don" and tonumber(progress[PlayerID]["freepoints"]) > 0 then
            progress[PlayerID]["freepoints"] = tonumber(progress[PlayerID]["freepoints"]) - 1
            progress[PlayerID][arg] = 1
        else
            return
        end
        CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( PlayerID ), "updatetab", { progress = progress[PlayerID] } )
    end
    if not DataBase:IsCheatMode() and progress[PlayerID]["cheat"] == nil and not talants.testing[PlayerID] then
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
    if t.j == 9 or t.j == 10 or t.j == 11 then
        levelNeed = levelNeed + 2
    end
    if t.j == 12 then
        levelNeed = levelNeed + 3
    end
    local branch_count = 0
    for i = 1, 5 do
        if talants.tab[t.PlayerID][t.i..i] == 1 then
            branch_count = branch_count + 1
        end
    end
    if tonumber(talants.tab[t.PlayerID][t.i.."6"]) + tonumber(talants.tab[t.PlayerID][t.i.."7"]) + tonumber(talants.tab[t.PlayerID][t.i.."8"]) == 1 then
        branch_count = branch_count + 1
    end
    if tonumber(talants.tab[t.PlayerID][t.i.."9"]) + tonumber(talants.tab[t.PlayerID][t.i.."10"]) + tonumber(talants.tab[t.PlayerID][t.i.."11"]) == 1 then
        branch_count = branch_count + 1
    end
    
    if (t.i == 'don' and talants.tab[t.PlayerID]['freedonpoints'] >= levelNeed - branch_count) or (t.i ~= 'don' and talants.tab[t.PlayerID]['freepoints'] >= levelNeed - branch_count) then
        if t.j >= 2 and talants.tab[t.PlayerID][t.i.."1"] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 1, codeCall = true})
        end
        if t.j >= 3 and talants.tab[t.PlayerID][t.i.."2"] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 2, codeCall = true})
        end
        if t.j >= 4 and talants.tab[t.PlayerID][t.i.."3"] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 3, codeCall = true})
        end
        if t.j >= 5 and talants.tab[t.PlayerID][t.i.."4"] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 4, codeCall = true})
        end
        if t.j >= 6 and talants.tab[t.PlayerID][t.i.."5"] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 5, codeCall = true})
        end
        if t.j == 9 and talants.tab[t.PlayerID][t.i.."6"] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 6, codeCall = true})
        end
        if t.j == 10 and talants.tab[t.PlayerID][t.i.."7"] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 7, codeCall = true})
        end
        if t.j == 11 and talants.tab[t.PlayerID][t.i.."8"] ~= 1 then
            talants:selectTalantButton({PlayerID = t.PlayerID, i = t.i, j = 8, codeCall = true})
        end
        talants:selectTalantButton(t)
    end
end

function talants:giveExperienceFromQuest(id, n)
    n = n * MultiplierManager:GetTalentExperienceMultiplier(id)
    talants:AddExperience(id, n)
    if RATING["rating"][id]["patron"] == 1 then
        talants:AddExperienceDonate(id, n)
    end
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
    for k,v in pairs({"str", "agi", "int", "don"}) do
        for i = 1, 13 do
            local arg = v .. tostring(i)
            if talants.tab[nPlayerID][arg] > 0 then
                local tree = GetHeroTalentsData(heroName)
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
                if v == "don" or i <= 5 then
                    ------------------------------------------     модифаеры
                    if add == true and ( v ~= "don" or RATING["rating"][nPlayerID]["patron"] == 1) then
                        talants:AddModifierFiltered(hero, skillname, i, talants.tab[nPlayerID][arg])
                    elseif add == false then
                        hero:RemoveModifierByName( skillname )
                    end
                else
                    ------------------------------------------     скилы
                    if add == true then
                        -- print(v,i,skillname)
                        talants:AddAbilityFiltered(hero, skillname, i)
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
        if PlayerResource:IsValidPlayer(nPlayerID) and PlayerResource:HasSelectedHero( nPlayerID ) and PlayerResource:GetSelectedHeroEntity( nPlayerID ) then
            local heroname = PlayerResource:GetSelectedHeroName( nPlayerID )
            local index = PlayerResource:GetSelectedHeroEntity( nPlayerID ):entindex()
            local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
            pInfo[nPlayerID] = { heroname, index}
            talants.tab[nPlayerID] = progress[nPlayerID]
            CustomNetTables:SetTableValue("talants", tostring(nPlayerID), progress[nPlayerID])
-----------------------------------------------------------------------------------------------------------------------------	
            talants:addskill(nPlayerID, true)
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
    talants.tab[PlayerID] = progress[PlayerID]
    CustomNetTables:SetTableValue("talants", tostring(PlayerID), progress[PlayerID])
end

function bot(nPlayerID)
return PlayerResource:GetSteamAccountID(nPlayerID) < 1000
end

function talants:pickinfo(PlayerID,AutoLoad)
    heroname[PlayerID] = PlayerResource:GetSelectedHeroName( PlayerID )
    herotalant[PlayerID] = GetHeroTalentsData(heroname[PlayerID])
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
            talants:fillTabel(PlayerID, DataBase:IsCheatMode(), true)
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
            for i = 1, 13 do
                arg = v .. i
                progress[PlayerID][arg] = 0
            end
        end
        
        progress[PlayerID]["totalexp"] = 1500000
        progress[PlayerID]["totaldonexp"] = 1500000
    end
    ------------------------------------------     вторая ветка, если куплена карточка
    progress[PlayerID]["cout"] = 1
    for cKey, cValue in ipairs(Shop.pShop[PlayerID]) do
		for itemKey, item in ipairs(cValue) do
            if item.hero and item.hero == heroname[PlayerID] and item.now > 0 then
                progress[PlayerID]["cout"] = 2
            end
        end
    end
    ------------------------------------------     выдача донатного опыта
    if RATING["rating"][PlayerID]["patron"] == "1" then
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
    -- if level > 14 then
    --     freepoints = 14
    --     if level >= 30 then 
    --         freepoints = 15
    --     end
    -- end

    for k,v in pairs({"int","str","agi"}) do
        for i = 1, 13 do
            arg = v .. i
            if progress[PlayerID][arg] == nil then
                progress[PlayerID][arg] = 0
            end
            freepoints = freepoints - progress[PlayerID][arg]
            if DataBase:IsCheatMode() == false and diff_wave.wavedef == "Easy" and i == 12 then
                progress[PlayerID][arg] = 0
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
    for i = 1, 13 do
        arg = "don" .. i
        if progress[PlayerID][arg] == nil then
            progress[PlayerID][arg] = 0
        end
        if progress[PlayerID][arg] == 1 then
            freedonpoints = freedonpoints -1
        end
        if DataBase:IsCheatMode() == false and RATING["rating"][PlayerID]["patron"] ~= 1 then
            progress[PlayerID][arg] = 0
        end
    end
    progress[PlayerID]["freedonpoints"] = freedonpoints

    if isCheat then

        progress[PlayerID]["donavailable"] = 1
        progress[PlayerID]["cout"] = 2

    end

    -- DeepPrintTable(progress[PlayerID])
    talants.tab[PlayerID] = progress[PlayerID]
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
    if not talants.testing[t.PlayerID] and DataBase:IsCheatMode() == false then
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
    end
    if t.type == "normal" then
        talants.tab[t.PlayerID]['totalexp'] = tonumber(talants.tab[t.PlayerID]['totalexp']) + t.gane
        level = talants:coutExp(tonumber(talants.tab[t.PlayerID]['totalexp']))
        if level > tonumber(talants.tab[t.PlayerID]['level']) then
            local sp = tonumber(talants.tab[t.PlayerID]['level']) - level
            sp = sp * -1
            talants.tab[t.PlayerID]['freepoints'] = tonumber(talants.tab[t.PlayerID]['freepoints']) + sp
        end
        talants.tab[t.PlayerID]['level'] = level
    elseif t.type == "donate" then
        talants.tab[t.PlayerID]['totaldonexp'] = tonumber(talants.tab[t.PlayerID]['totaldonexp']) + t.gane
        donlevel = talants:coutExp(tonumber(talants.tab[t.PlayerID]['totaldonexp']))
        if donlevel > tonumber(talants.tab[t.PlayerID]['donlevel']) then
            local sp = tonumber(talants.tab[t.PlayerID]['donlevel']) - donlevel
            sp = sp * -1
            talants.tab[t.PlayerID]['freedonpoints'] = tonumber(talants.tab[t.PlayerID]['freedonpoints']) + sp
        end
        talants.tab[t.PlayerID]['donlevel'] = donlevel
    end
    progress[t.PlayerID]['totalexp'] = talants.tab[t.PlayerID]['totalexp']
    progress[t.PlayerID]['freepoints'] = talants.tab[t.PlayerID]['freepoints']
    progress[t.PlayerID]['totaldonexp'] = talants.tab[t.PlayerID]['totaldonexp']
    progress[t.PlayerID]['freedonpoints'] = talants.tab[t.PlayerID]['freedonpoints']
    CustomNetTables:SetTableValue("talants", tostring(t.PlayerID), talants.tab[t.PlayerID])
end

function talants:unset(t)
    -- if DataBase:IsCheatMode() == true then
    --     return
    -- end
    if not talants.testing[t.PlayerID] and DataBase:IsCheatMode() == false then
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
    talants:addskill(t.PlayerID, false)
    for k,v in pairs({'agi','int','str','don'}) do
        for i = 1, 13 do
            arg = v .. i
            talants.tab[t.PlayerID][arg] = 0
        end
    end
    progress[t.PlayerID] = talants.tab[t.PlayerID]
    talants:fillTabel(t.PlayerID, DataBase:IsCheatMode(), false)
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

function talants:EnableHellGame(pid)
    talants.hell_game[pid] = true
    local gain = -20
    local tick = 0
    EmitSoundOn( "yeeeeeaaaahhh", PlayerResource:GetSelectedHeroEntity(pid) )
    Timers:CreateTimer(1, function()
        print(tick)
        talants:AddExperienceDonate(pid, gain)
        talants:AddExperience(pid, gain)
        talants:UpdateGainValue(pid, gain)
        tick = tick + 1
        if tick % 15 == 0 then 
            gain = gain - 1
        end
        if talants.hell_game[pid] then
            return 1
        end
    end)
end
function talants:DisableHellGame(pid)
    talants.hell_game[pid] = false
    talants.tab[pid]["gave_exp"] = 0
    talants:UpdateGainValue(pid, 0)
    CustomNetTables:SetTableValue("talants", tostring(pid), talants.tab[pid])
end

function talants:UpdateGainValue(pid, value)
    talants.tab[pid].gave_exp = value * MultiplierManager:GetTalentExperienceMultiplier(pid)
    CustomNetTables:SetTableValue("talants", tostring(pid), talants.tab[pid])
end
function talants:CalculateLevelFromExperience(experience)
    for i = 1, talants.levelMax do
        if experience < talants.calculated_levels[i] then
            return i-1
        end
    end
    return talants.levelMax
end
function talants:CountLearnedNormalTalents(pid)
    local count = 0
    for _, t in pairs({"agi","int","str"}) do
        for i = 1, 13 do
            count = count + talants.tab[pid][t..i]
        end
    end
    return count
end
function talants:CountLearnedGoldenTalents(pid)
    local count = 0
    DeepPrintTable(talants.tab[pid])
    for i = 1, 13 do
        count = count + talants.tab[pid]["don"..i]
    end
    return count
end
function talants:AddExperience(pid, value)
    print(pid, value)
    if value > 0 then
        value = value * MultiplierManager:GetTalentExperienceMultiplier(pid)
        if talants.tab[pid].don2 > 0 then
            value = value * 1.15
        end
        if GameRules:GetGameTime() / 60 >= 120 then
            return false
        end
    end
    if talants.tab[pid].totalexp + value < 0 then 
        talants.tab[pid].totalexp = 0
        value = 0
    end
    local level = talants:CalculateLevelFromExperience(talants.tab[pid].totalexp + value)
    talants.tab[pid].freepoints = level - talants:CountLearnedNormalTalents(pid)
    talants.tab[pid].level = level
    talants.tab[pid].totalexp = talants.tab[pid].totalexp + value
    talants.tab[pid].gameNormalExp = (talants.tab[pid].gameNormalExp or 0) + value
    CustomNetTables:SetTableValue("talants", tostring(pid), talants.tab[pid])
end
function talants:AddExperienceDonate(pid, value)
    print(pid, value)
    if value > 0 then
        value = value * MultiplierManager:GetTalentExperienceMultiplier(pid)
        if talants.tab[pid].don2 > 0 then
            value = value * 1.15
        end
        if GameRules:GetGameTime() / 60 >= 120 then
            return false
        end
    end
    if talants.tab[pid].totaldonexp + value < 0 then 
        talants.tab[pid].totaldonexp = 0
        value = 0
    end
    if RATING["rating"][pid]["patron"] == nil or RATING["rating"][pid]["patron"] == 0 then
        return false
    end
    local level = talants:CalculateLevelFromExperience(talants.tab[pid].totaldonexp + value)
    talants.tab[pid].freepoints = level - talants:CountLearnedGoldenTalents(pid)
    talants.tab[pid].donlevel = level
    talants.tab[pid].totaldonexp = talants.tab[pid].totaldonexp + value
    talants.tab[pid].gameDonatExp = (talants.tab[pid].gameDonatExp or 0) + value
    CustomNetTables:SetTableValue("talants", tostring(pid), talants.tab[pid])
end





























talants:init()
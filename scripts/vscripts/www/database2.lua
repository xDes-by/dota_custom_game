if DataBase == nil then
    _G.DataBase = class({})
end

function DataBase:IsCheatMode()
	if _G.devmode then
		return false
	end
	return GameRules:IsCheatMode()
end

function DataBase:init()
	-- https://random-defence-adventure.ru/backend/api2/game-setup?key=0D5A1B05BC84FEF8AC2DA123198CCA9FECCD277D&match=0
	-- https://random-defence-adventure.ru/backend/api2/player-setup?key=0D5A1B05BC84FEF8AC2DA123198CCA9FECCD277D&match=0&arr={"sid":455872541, "name":""}
	DataBase.key = _G.key
	DataBase.matchID = tostring(GameRules:Script_GetMatchID())
	DataBase.gameSetupLink = _G.host .. "/backend/api2/game-setup?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.playerSetupLink = _G.host .. "/backend/api2/player-setup?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.DailyAwardLink = _G.host .. "/backend/api2/daily-award?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.start = _G.host .. "/backend/api/start?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.editPoints = _G.host .. "/backend/api2/edit-points?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.buy = _G.host .. "/backend/api/buy?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	--DataBase.controlUrl = _G.host .. "/control.php/?key=" .. DataBase.key
	DataBase.comment = _G.host .. "/backend/api/comment?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.updatecoins = _G.host .. "/backend/api/update-coins?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.rGems = _G.host .. "/backend/api/remove-gems?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.aGems = _G.host .. "/backend/api/add-gems?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.event2021 = _G.host .. "/backend/api2/event2021?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.event2 = _G.host .. "/backend/api2/event2?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.event3 = _G.host .. "/backend/api2/event3?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.punishment = _G.host .. "/backend/api/talant-punishment?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.upgradepet = _G.host .. "/backend/api/upgrade-pet?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.promo = _G.host .. "/backend/api2/promo?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.GetHeroInfo = _G.host .. "/backend/api/get-hero-talant-info?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.addRating = _G.host .. "/backend/api/add-rating?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.addFeed = _G.host .. "/backend/api/add-feed?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.addRaitPoint = _G.host .. "/backend/api/add-rait-points?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.addCoins = _G.host .. "/backend/api/add-coins?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.squirrel = _G.host .. "/backend/api/squirrel?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.AutoPet = _G.host .. "/backend/api/set-auto-pet?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.AutoQuestLink = _G.host .. "/backend/api/auto-quest-toggle?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.OpenTreasureLink = _G.host .. "/backend/api/open-treasure?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.SprayToggleActivateLink = _G.host .. "/backend/api/spray-toggle?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.ActivateTrialPeriodPetLink = _G.host .. "/backend/api/activate-trial-period-pet?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.GiveOutAllHotOfferItemsLink = _G.host .. "/backend/api/give-out-all-hot-offer-items?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( DataBase, 'OnGameRulesStateChange'), self)
	CustomGameEventManager:RegisterListener("CommentChange", Dynamic_Wrap( DataBase, 'CommentChange'))
	ListenToGameEvent( "player_chat", Dynamic_Wrap( DataBase, "OnChat" ), self )
	ListenToGameEvent("entity_killed", Dynamic_Wrap( self, 'OnEntityKilled' ), self )
	-- DataBase:GameSetup()
	-- for i = 0 , PlayerResource:GetPlayerCount()-1 do
	--     if PlayerResource:IsValidPlayer(i) then
	-- 		DataBase:PlayerSetup(i)
	-- 	end
	-- end
end

function DataBase:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		DataBase:GameSetup()
		for i = 0 , PlayerResource:GetPlayerCount()-1 do
			if PlayerResource:IsValidPlayer(i) then
				DataBase:PlayerSetup(i)
			end
		end
	end
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		print('DOTA_GAMERULES_STATE_GAME_IN_PROGRESS')

		

		for i = 0, PlayerResource:GetPlayerCount() -1 do
			if PlayerResource:IsValidPlayer(i) then
        		-- SendToServerConsole("kick " .. PlayerResource:GetPlayerName(i))
			end
		end

	end
end

function DataBase:OnEntityKilled(keys)
	
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	if killerEntity and killerEntity:IsRealHero() then
		killerEntity_playerID = killerEntity:GetPlayerID()
	end	
	if killedUnit:GetUnitName() == "raid_new_year" then
		DataBase:Event2021OnKill(killerEntity_playerID)
	end
	if killedUnit:GetUnitName() == "npc_boss_plague_squirrel" then
		DataBase:Squirrel(killerEntity:GetPlayerID())
	end
end
LinkLuaModifier( "modifier_cheat_move", "modifiers/modifier_cheat_move", LUA_MODIFIER_MOTION_NONE )
function DataBase:OnChat(t)
	local text = t.text 
	steamID = PlayerResource:GetSteamAccountID(t.playerid)
	----- PromoCode
	if text == "abs" then
		local hero = PlayerResource:GetSelectedHeroEntity( t.playerid )
		print(hero:GetAbsOrigin())
	end

	for _,word in pairs({"Hello new players"}) do
		if text == word then
			DataBase:PromoCode(word, t.playerid)
			break
		end
	end
end

function DataBase:PromoCode(text, PlayerID)
	local arr = {
		sid = PlayerResource:GetSteamAccountID(PlayerID),
		text = text
	}
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.promo )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			local arr = json.decode(res.Body)

			if arr.mmrpoints ~= nil then
				Shop.pShop[PlayerID].mmrpoints = Shop.pShop[PlayerID].mmrpoints + arr.mmrpoints
				local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(PlayerID))
				shopinfo.mmrpoints = Shop.pShop[PlayerID].mmrpoints
				CustomNetTables:SetTableValue("shopinfo", tostring(PlayerID), shopinfo)
			end

			if arr.coins ~= nil then
				Shop.pShop[PlayerID].coins = Shop.pShop[PlayerID].coins + arr.coins
				local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(PlayerID))
				shopinfo.coins = Shop.pShop[PlayerID].coins
				CustomNetTables:SetTableValue("shopinfo", tostring(PlayerID), shopinfo)
			end

		end
	end)
end

function DataBase:Squirrel(pid)
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local time = GameRules:GetGameTime() / 60
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.squirrel )
	req:SetHTTPRequestGetOrPostParameter('sid',tostring(steamID))
	req:SetHTTPRequestGetOrPostParameter('time',tostring(time))
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			-- print(res.StatusCode)
			-- print(res.Body)
		end
	end)
end

function DataBase:Event2021(PlayerID)
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.event2021 )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(
		{
			sid = PlayerResource:GetSteamAccountID(PlayerID),
			mode = diff_wave.rating_scale,
			match = DataBase.matchID,
		}
	))
	
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			if res.Body == "1" then
				GameRules:SendCustomMessage("Вы добавлены в список участников", 0, 0)
				GameRules:SendCustomMessage("You are added to the list of participants", 0, 0)
			else
				GameRules:SendCustomMessage("Вы уже участвуете в розыгрыше :(", 0, 0)
				GameRules:SendCustomMessage("You are already participating in the drawing :(", 0, 0)
			end
		end
	end)
end

function DataBase:Event2021OnKill(PlayerID)
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.event3 )
	arr = {
		sid = PlayerResource:GetSteamAccountID(PlayerID or 0),
		mode = diff_wave.rating_scale,
		time = GameRules:GetGameTime(),
		match = DataBase.matchID,
	}
	-- print(json.encode(arr))
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		-- print(res.StatusCode)
		if res.StatusCode == 200 and res.Body ~= nil then
			-- print(res.Body)
		end
	end)
end

function DataBase:Event2021Boss(PlayerID)
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.event2 )
	arr = {
		sid = PlayerResource:GetSteamAccountID(PlayerID),
		mode = diff_wave.rating_scale,
		time = GameRules:GetGameTime(),
		match = DataBase.matchID,
	}
	-- print(json.encode(arr))
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		-- print(res.StatusCode)
		if res.StatusCode == 200 and res.Body ~= nil then
			-- print(res.Body)
		end
	end)
end

function DataBase:GameSetup()
	_G.RATING = {
		rating = {},
		history = {},
	}
	_G.SHOP = {}
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.gameSetupLink )
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		print("GameSetup")
		print("StatusCode: ", res.StatusCode)
		print("Body: ", res.Body)
		if res.StatusCode == 200 and res.Body ~= nil then
			local obj = json.decode(res.Body)
			_G.RATING.top = obj.top
			_G.RATING.bg = obj.bg
			_G.RATING.seasons = obj.seasons
			DailyQuests:SetTodayTasks(obj.daily)
			Timers:CreateTimer(0 ,function()
				if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION or GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
					rating:pickInit(t)
					return nil
				end
				return 0.1
			end)
		end
	end)



	-- local arr = {}
	-- for i = 0 , PlayerResource:GetPlayerCount() do
	--     if PlayerResource:IsValidPlayer(i) then
	-- 		arr[i] = {
	-- 			sid = PlayerResource:GetSteamAccountID(i),
	-- 			name = PlayerResource:GetPlayerName(i),
	-- 		}
	-- 	end
	-- end
	-- arr = json.encode(arr)
	-- local req = CreateHTTPRequestScriptVM( "POST", DataBase.start )
	-- req:SetHTTPRequestGetOrPostParameter('arr',arr)
	-- req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	-- req:Send(function(res)
	-- 	if res.StatusCode == 200 and res.Body ~= nil then
	-- 		local obj = json.decode(res.Body)
			
			
	-- 		_G.RATING = {
	-- 			rating = obj.rating,
	-- 			top = obj.top,
	-- 			bg = obj.bg,
	-- 			seasons = obj.seasons,
	-- 			history = obj.history,
	-- 		}
	-- 		_G.SHOP = obj.shop
	-- 		Shop:createShop()
	-- 		Timers:CreateTimer(0 ,function()
	-- 			if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION or GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
	-- 				rating:pickInit(t)
	-- 				return nil
	-- 			end
	-- 			return 0.1
	-- 		end)
	-- 	end
	-- end)
end

function DataBase:PlayerSetup( pid )
	local data = json.encode({
		sid = PlayerResource:GetSteamAccountID(pid),
		name = PlayerResource:GetPlayerName(pid),
	})
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.playerSetupLink )
	req:SetHTTPRequestGetOrPostParameter('arr',data)
	print(data)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		print("PlayerSetup")
		print("StatusCode: ", res.StatusCode)
		print("Body: ", res.Body)
		if res.StatusCode == 200 and res.Body ~= nil then
			local obj = json.decode(res.Body)
			_G.RATING.rating[pid] = obj.rating
			_G.RATING.history[pid] = obj.history
			_G.SHOP[pid] = obj.shop
			DailyQuests:SetPlayerData(pid, obj.daily)
			Shop:PlayerSetup( pid )
			BattlePass:SetPlayerData(pid, obj)
			-- Shop:createShop()
			-- Timers:CreateTimer(0 ,function()
			-- 	if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION or GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
			-- 		rating:pickInit(t)
			-- 		return nil
			-- 	end
			-- 	return 0.1
			-- end)
		end
	end)
end

function DataBase:PointsChange(player, pEdit, isGameEnded)
	if DataBase:IsCheatMode() then return end
	
	local hero = PlayerResource:GetSelectedHeroEntity( player )
	

	local tab = CustomNetTables:GetTableValue("talants", tostring(player))
	local daily_counters = {}
	for i = 1, DailyQuests.tasksNumber do
		table.insert(daily_counters, {
			index = DailyQuests.player[player][i].index,
			now = DailyQuests.player[player][i].now,
		})
	end
	local arr = {
		sid = PlayerResource:GetSteamAccountID(player),
		pEdit = pEdit,
		hero_name = PlayerResource:GetSelectedHeroName(player),
		in_game_time = GameRules:GetGameTime(),
        gameDonatExp = tab["gameDonatExp"],
        gameNormalExp = tab["gameNormalExp"],
		auto_pet = Shop.Auto_Pet[player],
		trial_period_count = Quests.trialPeriodCount[player],
		hero_marci_trial = ChangeHero.heroes["npc_dota_hero_marci"].trialCount[player],
		hero_silencer_trial = ChangeHero.heroes["npc_dota_hero_silencer"].trialCount[player],
		daily_counters = daily_counters,
	}
	if hero:HasModifier("modifier_silent2") or GameRules:GetGameTime() < 360 or talants.testing[player] then
		arr['gameDonatExp'] = 0
		arr['gameNormalExp'] = 0
	end
	if isGameEnded then
		arr['isGameEnded'] = true
	end
	local req = CreateHTTPRequestScriptVM( "POST", DataBase.editPoints ..'&sid=' .. arr['sid'] )
    arr = json.encode(arr)
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
	end)
end

function DataBase:buyRequest(t)
	if DataBase:IsCheatMode() then return end
	
	if currency == nil then
		currency = "gems"
	end
	local arr = {
		sid = PlayerResource:GetSteamAccountID( t.PlayerID ),
		price = t.price,
		currency = t.currency,
		name = t.name,
		give = t.give,
		hero_name = PlayerResource:GetSelectedHeroName(t.PlayerID),
		amount = t.amount,
	}
	DeepPrintTable(arr)
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.buy .. '&sid=' .. arr['sid'] )
    arr = json.encode(arr)
	-- print(arr)
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			-- print(res.Body)
		end
	end)
end

function DataBase:CommentChange(t)
	if DataBase:IsCheatMode() then return end
	
	local from = tonumber(t.PlayerID)
	local to = tonumber(t.pid)
	local type = t.type
	if RATING and tonumber(RATING['rating'][from]['commens']) <= 0 then
		return
	end

	RATING['rating'][from]['commens'] = tonumber(RATING['rating'][from]['commens']) - 1
	if type == 'likes' then
		RATING['rating'][to]['likes'] = tonumber(RATING['rating'][to]['likes']) + 1
	elseif type == 'reports' then
		RATING['rating'][to]['reports'] = tonumber(RATING['rating'][to]['reports']) + 1
	end

	local arr = {
		from = PlayerResource:GetSteamAccountID(from),
		to = PlayerResource:GetSteamAccountID(to),
		type = type,
	}
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", DataBase.comment )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			-- print(res.Body)
		end
	end)
end

function DataBase:EdditGems(t)
	if DataBase:IsCheatMode() then return end
	
	local arr = {
		sid = PlayerResource:GetSteamAccountID(t.PlayerID),
		type = t.type,
		value = t.value,
	}
	arr = json.encode(arr)
	local req
	if t.action == 'remove' then
		req = CreateHTTPRequestScriptVM( "GET", DataBase.rGems )
	elseif t.action == 'add' then
		req = CreateHTTPRequestScriptVM( "GET", DataBase.aGems )
	end
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			-- print(res.Body)
		end
	end)
end

function DataBase:AutoGetPetOprion(t)
	
	local arr = {
		sid = PlayerResource:GetSteamAccountID(t.PlayerID),
		pet  = t.pet.name,
	}
	arr = json.encode(arr)
	req = CreateHTTPRequestScriptVM( "POST", DataBase.AutoPet )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			-- print(res.Body)
		end
	end)
end

function DataBase:AutoQuestToggle(t)
	
	local arr = {
		sid = PlayerResource:GetSteamAccountID(t.PlayerID),
		toggle_state  = t.toggle_state,
	}
	arr = json.encode(arr)
	req = CreateHTTPRequestScriptVM( "POST", DataBase.AutoQuestLink )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			-- print(res.Body)
		end
	end)
end

function DataBase:TalentPunishment(t)
	local tab = CustomNetTables:GetTableValue("talants", tostring(t.PlayerID))
	local arr = {
		hero_name = tab["hero_name"],
		PlayerID = PlayerResource:GetSteamAccountID(t.PlayerID),
		change = t.change,
		patron = RATING["rating"][t.PlayerID]["patron"],
	}
	-- normal exp
	tab["totalexp"] = tonumber(tab["totalexp"]) + t.change
	if tab["totalexp"] < 0 then
		tab["totalexp"] = 0
	end
	-- donate exp
	if RATING["rating"][t.PlayerID]["patron"] == 1 then
		tab["totaldonexp"] = tonumber(tab["totaldonexp"]) + t.change
		if tab["totaldonexp"] < 0 then
			tab["totaldonexp"] = 0
		end
	end
	CustomNetTables:SetTableValue("talants", tostring(t.PlayerID), tab)

	local req = CreateHTTPRequestScriptVM( "GET", DataBase.punishment )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		-- print(res.StatusCode)
		-- print(res.Body)
	end)
end

function DataBase:UpdatePet(name, pid, count)
	local arr = {
		name = name,
		sid = PlayerResource:GetSteamAccountID(pid),
		count = count,
	}
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.upgradepet )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		print(res.StatusCode)
		print(res.Body)
	end)

end

function DataBase:GetHeroesTalantCount(t)
	local arr = {
		sid = PlayerResource:GetSteamAccountID(t.PlayerID),
		hero_name = t.hero_name,
		pos = t.i .. t.j
	}
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.GetHeroInfo )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			print("res.Body",res.Body)
			local tab = CustomNetTables:GetTableValue("talants", tostring(t.portID))
			local count = res.Body
			tab[t.i..t.j.."count"] = count
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "ThrowHeroInfo", { count = count } )
			CustomNetTables:SetTableValue("talants", tostring(t.portID), tab)
		end
	end)
end


function DataBase:AddRating(pid, count)
	if DataBase:IsCheatMode() then return end

	local arr = {
		sid = PlayerResource:GetSteamAccountID(pid),
		count = count,
	}
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.addRating )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			
		end
	end)
end

function DataBase:AddFeed(pid, count)
	if DataBase:IsCheatMode() then return end
	
	Shop.pShop[pid].feed = Shop.pShop[pid].feed + count
	local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(pid))
	shopinfo.feed = Shop.pShop[pid].feed
	CustomNetTables:SetTableValue("shopinfo", tostring(pid), shopinfo)

	local arr = {
		sid = PlayerResource:GetSteamAccountID(pid),
		count = count,
	}
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.addFeed )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			
		end
	end)
end

function DataBase:AddRP(pid, count, db)
	if DataBase:IsCheatMode() then return end
	
	Shop:AddRP(pid, count)

	local arr = {
		sid = PlayerResource:GetSteamAccountID(pid),
		count = count,
	}
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.addRaitPoint )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			
		end
	end)
end

function DataBase:AddCoins(pid, count)
	if DataBase:IsCheatMode() then return end
	
	Shop:AddCoins(pid, count)

	local arr = {
		sid = PlayerResource:GetSteamAccountID(pid),
		count = count,
	}
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.addCoins )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			
		end
	end)
end

function DataBase:OpenTreasure(arr)
	if DataBase:IsCheatMode() then return end
	local req = CreateHTTPRequestScriptVM( "POST", DataBase.OpenTreasureLink )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	req:Send(function(res)
		print(res.StatusCode)
		print(res.Body)
		if res.StatusCode == 200 and res.Body ~= nil then
			
		end
	end)
end

function DataBase:SprayToggleActivate(t)
	if DataBase:IsCheatMode() then return end
	requestData = {
		sid = PlayerResource:GetSteamAccountID(t.PlayerID),
		sprayName = t.sprayName,
	}
	local req = CreateHTTPRequestScriptVM( "POST", DataBase.SprayToggleActivateLink )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(requestData))
	req:Send(function(res)
		print(res.StatusCode)
		print(res.Body)
		if res.StatusCode == 200 and res.Body ~= nil then
			
		end
	end)
end

function DataBase:ActivateTrialPeriodPet(t)
	if DataBase:IsCheatMode() then return end
	requestData = {
		sid = PlayerResource:GetSteamAccountID(t.PlayerID),
	}
	local req = CreateHTTPRequestScriptVM( "POST", DataBase.ActivateTrialPeriodPetLink )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(requestData))
	req:Send(function(res)
		print(res.StatusCode)
		print(res.Body)
		if res.StatusCode == 200 and res.Body ~= nil then
			
		end
	end)
end

function DataBase:GiveOutAllHotOfferItems(PlayerID, package_contents)
	if DataBase:IsCheatMode() then return end
	requestData = {
		sid = PlayerResource:GetSteamAccountID(PlayerID),
		package_contents = package_contents,
	}
	local req = CreateHTTPRequestScriptVM( "POST", DataBase.GiveOutAllHotOfferItemsLink )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(requestData))
	req:Send(function(res)
		print(res.StatusCode)
		print(res.Body)
		if res.StatusCode == 200 and res.Body ~= nil then
			
		end
	end)
end

function DataBase:DailyAward(pid, index, prize, now)
	if DataBase:IsCheatMode() then return end
	local arr = {
		sid = PlayerResource:GetSteamAccountID(pid),
		index = index,
		prize = prize,
		now = now,
	}
	print(json.encode(arr))
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.DailyAwardLink )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(arr))
	req:Send(function(res)
		print(res.StatusCode)
		print(res.Body)
		if res.StatusCode == 200 and res.Body ~= nil then
			
		end
	end)
end

DataBase:init()
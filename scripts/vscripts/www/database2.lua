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
	-- https://random-defence-adventure.ru/backend/init-shutdown/player-setup?key=0D5A1B05BC84FEF8AC2DA123198CCA9FECCD277D&match=0&arr={"name":"","sid":455872541}
	-- https://random-defence-adventure.ru/backend/api2/player-setup?key=0D5A1B05BC84FEF8AC2DA123198CCA9FECCD277D&match=0&arr={"sid":455872541, "name":""}
	DataBase.key = _G.key
	DataBase.matchID = tostring(GameRules:Script_GetMatchID())
	DataBase.link = {}
	

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
	DataBase.MapOverlayHintsLink = _G.host .. "/backend/api/map-hints?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	-----------------------------------------------------------------------------------------------------------------------------
	DataBase.playerSetupLink = _G.host .. "/backend/init-shutdown/player-setup?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.GameSetup = _G.host .. "/backend/init-shutdown/game-setup?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.ClaimReward = _G.host .. "/backend/player-actions/claim-reward?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.AddRP = _G.host .. "/backend/gameplay/add-rp?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.AddCoins = _G.host .. "/backend/gameplay/add-coins?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.AddGems = _G.host .. "/backend/gameplay/add-gems?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.ResetProgress = _G.host .. "/backend/player-actions/reset-progress?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.EndGameSession = _G.host .. "/backend/init-shutdown/end-game-session?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.FeedPet = _G.host .. "/backend/player-actions/feed-pet?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.BuyPetShop = _G.host .. "/backend/player-actions/buy-pet-shop?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.BuyPet = _G.host .. "/backend/player-actions/buy-pet?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.HeroVote = _G.host .. "/backend/player-actions/hero-vote?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.DailyReward = _G.host .. "/backend/player-actions/daily-reward?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.BpReward = _G.host .. "/backend/player-actions/bp-reward?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.BattlePassBuy = _G.host .. "/backend/player-actions/battle-pass-buy?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.SettingsSetMapHints = _G.host .. "/backend/player-actions/settings-set-map-hints?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.SettingsSetAutoPet = _G.host .. "/backend/player-actions/settings-set-auto-pet?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.SettingsSetParticle = _G.host .. "/backend/player-actions/settings-set-particle?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.SettingsSetAutoModels = _G.host .. "/backend/player-actions/settings-set-auto-models?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.SettingsSetAutoQuest = _G.host .. "/backend/player-actions/settings-set-auto-quest?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.BuyShop = _G.host .. "/backend/player-actions/buy-shop?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.BuyGems = _G.host .. "/backend/player-actions/buy-gems?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.BuyHotOffer = _G.host .. "/backend/player-actions/buy-hot-offer?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.TreasureReward = _G.host .. "/backend/player-actions/treasure-reward?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.SaveQuestsData = _G.host .. "/backend/gameplay/save-quests-data?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.RequestTalents = _G.host .. "/backend/init-shutdown/request-talents?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.TalentsBuy = _G.host .. "/backend/player-actions/talents-buy?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.TalentsDrop = _G.host .. "/backend/player-actions/talents-drop?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.TalentsExplore = _G.host .. "/backend/player-actions/talents-explore?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.TalentsSave = _G.host .. "/backend/gameplay/talents-save?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.TalentsBuySecondBranch = _G.host .. "/backend/player-actions/talents-buy-second-branch?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.GameSettingsToggle = _G.host .. "/backend/player-actions/game-settings-toggle?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.RefreshVoteCount = _G.host .. "/backend/player-actions/refresh-vote-count?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.link.RefreshMoney = _G.host .. "/backend/player-actions/refresh-money?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( DataBase, 'OnGameRulesStateChange'), self)
	CustomGameEventManager:RegisterListener("CommentChange", Dynamic_Wrap( DataBase, 'CommentChange'))
	ListenToGameEvent( "player_chat", Dynamic_Wrap( DataBase, "OnChat" ), self )
	ListenToGameEvent("entity_killed", Dynamic_Wrap( self, 'OnEntityKilled' ), self )
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
	DataBase:Send(DataBase.link.GameSetup, "GET", {}, nil, true, function(body)
		local obj = json.decode(body)
		_G.RATING.top = obj.top
		_G.RATING.bg = obj.bg
		_G.RATING.seasons = obj.seasons
		BattlePass.current_season = obj.current_season
		Pets:AddBattlePassPetsToPetList()
		BattlePass:UpdateRewardsForCurrentSeason()
		BattlePass:SetVoteList(obj.vote)
		CustomNetTables:SetTableValue("GameInfo", 'is_cheat_mode', {value = DataBase:IsCheatMode()})
		Timers:CreateTimer(0 ,function()
			if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION or GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
				rating:pickInit(t)
				return nil
			end
			return 0.1
		end)
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



function DataBase:buyRequest(t)
	-- local pid = t.PlayerID
	-- local send = {
	-- 	t.currency = t.price,
	-- 	name = t.name,
	-- 	give = t.give,
	-- 	hero_name = PlayerResource:GetSelectedHeroName(pid),
	-- 	amount = t.amount,
	-- }
	-- DataBase:Send(DataBase.link.BuyShop, "GET", send, pid, not DataBase:IsCheatMode(), nil)
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

function DataBase:MapOverlay_Hints(pid, hints)
	requestData = {
		sid = PlayerResource:GetSteamAccountID(pid),
		hints = hints,
	}
	local req = CreateHTTPRequestScriptVM( "GET", DataBase.MapOverlayHintsLink )
	req:SetHTTPRequestGetOrPostParameter('arr',json.encode(requestData))
	print(json.encode(requestData))
	req:Send(function(res)
		print(res.StatusCode)
		print(res.Body)
		if res.StatusCode == 200 and res.Body ~= nil then
			
		end
	end)
end
-------------------------------------------------------------------------------------------------------------------
function DataBase:PlayerSetup( pid )
	DataBase:Send(DataBase.playerSetupLink, "GET", {
		name = PlayerResource:GetPlayerName(pid)
	}, pid, true, function(body)
		print("PlayerSetup")
		print("Body: ", body)
		local obj = json.decode(body)
		_G.RATING.rating[pid] = obj.rating
		_G.RATING.history[pid] = obj.history
		_G.SHOP[pid] = obj.shop
		diff_wave:SetPlayerData(pid, obj.settings)
		rating:PlayerSetup(pid, obj.settings)
		MultiplierManager:SetPlayerData(pid, obj.items)
		Quests:SetPlayerData(pid, obj.daily, obj.bp, obj.settings)
		Pets:SetPlayerData(pid, obj.items, obj.settings)
		Shop:PlayerSetup( pid, obj.items)
		Talents:HeroSelectedListen(pid)
		BattlePass:SetPlayerData(pid, obj.battle_pass, obj.settings)
		BattlePass:UpdatePlayerCosmeticEffects(pid, obj.items)
		BattlePass:UpdatePlayerHeroModels(pid, obj.items)
		sInv:SetPlayerData(pid, obj.items)
	end)
end
function DataBase:EndGameSession(pid, rating_change)
	local game_over = true
	if _G.kill_invoker == false or not Entities:FindByName(nil, "npc_dota_goodguys_fort") then
		game_over = false
	end
	local game = {
		diff = diff_wave.rating_scale,
		in_game_time = GameRules:GetGameTime(),
		game_over = game_over,
	}
	local talents = {
		normal_experience = Talents.player[pid].earnedexp,
		golden_experience = Talents.player[pid].earneddonexp,
	}
	print(Talents.player[pid].earnedexp, Talents.player[pid].earneddonexp)
	Talents.player[pid].earnedexp = 0
    Talents.player[pid].earneddonexp = 0
	Talents:UpdateTable(pid)
	local trial = {
		hero_marci_trial = ChangeHero:GetMarciTrial(pid),
		hero_silencer_trial = ChangeHero:GetSilencerTrial(pid),
		auto_quest_trial = QuestSystem.trialPeriodCount[pid],
	}
	local player = {
		rating_change = rating_change,
		hero_name = PlayerResource:GetSelectedHeroName(pid),
		rp = 0,
	}
	local quest_counters = Quests:GetServerDataArray(pid)
	local battle_pass_experience = {
		
	}
	if _G.kill_invoker == false then 
		game.diff = 0
	end
	if PlayerResource:GetSelectedHeroEntity(pid):HasModifier("modifier_silent2") or Talents.player[pid].testing then
		talents.normal_experience = 0
		talents.golden_experience = 0
	end
	if rating_change > 0 then
		player.rp = CustomShop:AddRP(pid, rating_change, true, false)
	end
	DataBase:Send(DataBase.link.EndGameSession, "GET", {
		game = game,
		talents = talents,
		quest_counters = quest_counters,
		trial = trial,
		player = player,
		battle_pass_experience = battle_pass_experience,
	}, pid, not DataBase:IsCheatMode(), nil)
end

function DataBase:Send(path, method, data, pid, check, callback)
	if not check then return end
	local req = CreateHTTPRequestScriptVM( method, path )
	for key, value in pairs(data) do
		if type(value) == "table" then
			req:SetHTTPRequestGetOrPostParameter(key ,json.encode(value))
			print(key, json.encode(value))
		end
		if type(value) == "number" or type(value) == "string" then
			req:SetHTTPRequestGetOrPostParameter(key ,tostring(value))
			print(key, value)
		end
		if type(value) == "boolean" then
			if value then value = 1 else value = 0 end
			req:SetHTTPRequestGetOrPostParameter(key ,tostring(value))
			print(key, value)
		end
	end
	if pid then
		local sid = PlayerResource:GetSteamAccountID(pid)
		req:SetHTTPRequestGetOrPostParameter("sid", tostring(sid))
	end
	local hero_name = ""
	if pid and PlayerResource:HasSelectedHero(pid) and PlayerResource:GetSelectedHeroName(pid) then
		hero_name = PlayerResource:GetSelectedHeroName(pid)
	end
	req:SetHTTPRequestGetOrPostParameter("hero_name", hero_name)
	-- req:SetHTTPRequestGetOrPostParameter("rda_test", "1")
	req:Send(function(res)
		print(res.StatusCode)
		if res.StatusCode == 200 and res.Body ~= nil then
			if callback then
				callback(res.Body)
			end
		end
	end)
end

DataBase:init()
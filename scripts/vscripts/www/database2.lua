if DataBase == nil then
    _G.DataBase = class({})
end

function DataBase:isCheatOn()
	if _G.cheatmode then
		return false
	end
	return GameRules:IsCheatMode()
end

function DataBase:init()
	DataBase.key = _G.key
	DataBase.matchID = tostring(GameRules:Script_GetMatchID())
	DataBase.start = _G.host .. "/backend/api/start?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
	DataBase.editPoints = _G.host .. "/backend/api/edit-points?key=" .. DataBase.key ..'&match=' .. DataBase.matchID
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
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( DataBase, 'OnGameRulesStateChange'), self)
	CustomGameEventManager:RegisterListener("CommentChange", Dynamic_Wrap( DataBase, 'CommentChange'))
	ListenToGameEvent( "player_chat", Dynamic_Wrap( DataBase, "OnChat" ), self )
	ListenToGameEvent("entity_killed", Dynamic_Wrap( self, 'OnEntityKilled' ), self )
	DataBase:startGame()
	DataBase.units = {}
end

function DataBase:OnGameRulesStateChange()
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
	
	--if text == 'gg' and GameRules:GetGameTime() < 300 then
	--	GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	--end

	if steamID == 169401485 or steamID == 1062658804 or steamID == 455872541 or steamID == 393187346 or steamID == 81459554 or steamID == 351759722 then
		local hero = PlayerResource:GetSelectedHeroEntity(t.playerid)
		if text == 's1' then
			hero:AddItemByName('item_forest_soul')
		elseif text == 's2' then
			hero:AddItemByName('item_village_soul')
		elseif text == 's3' then
			hero:AddItemByName('item_mines_soul')
		elseif text == 's4' then
			hero:AddItemByName('item_dust_soul')
		elseif text == 's5' then
			hero:AddItemByName('item_swamp_soul')
		elseif text == 's6' then
			hero:AddItemByName('item_snow_soul')
		elseif text == 's7' then
			hero:AddItemByName('item_divine_soul')
		elseif text == 'test2' then
			for i = 0, 15 do
				item = hero:GetItemInSlot(i)
				if item then
					name = item:GetName()
					-- print(i,',',name)
				else
					-- print(i,',','none')
				end
			end
		elseif text == 'a1' or text == 'я гей' then
			hero:SetBaseIntellect(hero:GetBaseIntellect() + 1000000)
			hero:SetBaseAgility(hero:GetBaseAgility() + 1000000)
			hero:SetBaseStrength(hero:GetBaseStrength() + 1000000)    
			hero:AddNewModifier( hero, nil, "modifier_cheat_move", {} )
			hero:AddNewModifier( hero, nil, "modifier_magic_immune", {} )
		elseif text == 'a2' or text == 'я нормальный пидр' then
			if hero:GetBaseIntellect() > 1000000 and hero:GetBaseAgility() > 1000000 and hero:GetBaseStrength() > 1000000 then
				hero:SetBaseIntellect(hero:GetBaseIntellect() - 1000000)
				hero:SetBaseAgility(hero:GetBaseAgility() - 1000000)
				hero:SetBaseStrength(hero:GetBaseStrength() - 1000000)
				hero:RemoveModifierByName( "modifier_cheat_move" )
				hero:RemoveModifierByName( "modifier_magic_immune" )
			end
		elseif text == 'g1' then
			local totalgold = hero:GetGold() + 99999
			hero:SetGold(0 , false) 
			hero:SetGold(totalgold , false)
			charges = 0
			item = hero:FindItemInInventory('item_gold_brus')
			if item then
				charges = item:GetCurrentCharges()
			end
			hero:AddItemByName('item_gold_brus'):SetCurrentCharges(charges + 50)
		elseif text == 'box' then
			local box_1 = hero:AddItemByName('item_box_1')
		elseif string.find(text, 'gold') then
			local _, _, num1 = string.find(text, "(%d+)")
			num1 = num1 or 1
			local totalgold = hero:GetGold() + num1
			hero:SetGold(0 , false) 
			hero:SetGold(totalgold , false)
		elseif string.find(text, 'exp') then
			local _, _, num1 = string.find(text, "(%d+)")
			num1 = num1 or 1
			num1 = tonumber(num1)
			hero:AddExperience(num1, 0, false, true )
		elseif string.find(text, "create") then
			local name_string = string.gsub(text, 'create', "")
			local _, _, num1 = string.find(text, "(%d+)")
			if num1 ~= nil then
				name_string = string.gsub(name_string, num1, "")
			end
			name_string = string.gsub(name_string, " ", "")
			npc_units = LoadKeyValues("scripts/npc/npc_units_custom.txt")
			for k,v in pairs(npc_units) do
			--	print(k)
				if string.find(k, name_string) then
					if num1 ~= nil and num1 ~= 0 then
						table.insert(DataBase.units, CreateUnitByName( k, hero:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS ))
						DataBase.units[#DataBase.units]:SetControllableByPlayer(t.playerid, true)
    					DataBase.units[#DataBase.units]:SetOwner(hero)
					else
						table.insert(DataBase.units, CreateUnitByName( k, hero:GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS ))
					end
					break
				end
			end
			local name = 'npc_raid_earth'
		elseif text == 'clear' then
			for _, unit in pairs(DataBase.units) do
				unit:ForceKill(true)
			end
			DataBase.units = {}
		elseif text == "event" then
			statist:GameEnd({})
			print("rait",((_G.rating_wave * diff_wave.rating_scale) + (_G.mega_boss_bonus * diff_wave.rating_scale)))
			print(_G.rating_wave)
			print(diff_wave.rating_scale)
			print(_G.mega_boss_bonus)
		elseif text == "gey cock" then
			local heroPoint = hero:GetAbsOrigin()
			local itemsList = {
				{vector = Vector(heroPoint.x + 0, heroPoint.y + 275), name = "item_assault_lua7"},
				{vector = Vector(heroPoint.x + -50, heroPoint.y + 250), name = "item_sheepstick_lua7"},
				{vector = Vector(heroPoint.x + 50, heroPoint.y + 250), name = "item_satanic_lua7"},
				{vector = Vector(heroPoint.x + -75, heroPoint.y + 225), name = "item_ring_of_flux_lua7"},
				{vector = Vector(heroPoint.x + 75, heroPoint.y + 225), name = "item_bloodstone_lua7"},

				{vector = Vector(heroPoint.x + -100, heroPoint.y + -150), name = "item_radiance_lua7"},
				{vector = Vector(heroPoint.x + -100, heroPoint.y + -75), name = "item_desolator_lua7"},
				{vector = Vector(heroPoint.x + -100, heroPoint.y + 0), name = "item_butterfly_lua7"},
				{vector = Vector(heroPoint.x + -100, heroPoint.y + 75), name = "item_monkey_king_bar_lua7"},
				{vector = Vector(heroPoint.x + -100, heroPoint.y + 150), name = "item_bfury_lua7"},

				{vector = Vector(heroPoint.x + 100, heroPoint.y + -150), name = "item_veil_of_discord_lua7"},
				{vector = Vector(heroPoint.x + 100, heroPoint.y + -75), name = "item_shivas_guard_lua7"},
				{vector = Vector(heroPoint.x + 100, heroPoint.y + 0), name = "item_crimson_guard_lua7"},
				{vector = Vector(heroPoint.x + 100, heroPoint.y + 75), name = "item_heart_lua7"},
				{vector = Vector(heroPoint.x + 100, heroPoint.y + 150), name = "item_greater_crit_lua7"},

				{vector = Vector(heroPoint.x + -137, heroPoint.y + -210), name = "item_kaya_custom_lua7"},
				{vector = Vector(heroPoint.x + 137, heroPoint.y + -210), name = "item_ethereal_blade_lua7"},
				{vector = Vector(heroPoint.x + -160, heroPoint.y + -260), name = "item_vladmir_lua7"},
				{vector = Vector(heroPoint.x + 160, heroPoint.y + -260), name = "item_pipe_lua7"},
				{vector = Vector(heroPoint.x + -137, heroPoint.y + -312), name = "item_octarine_core_lua7"},
				{vector = Vector(heroPoint.x + 137, heroPoint.y + -312), name = "item_skadi_lua7"},
				{vector = Vector(heroPoint.x + -100, heroPoint.y + -335), name = "item_mjollnir_lua7"},
				{vector = Vector(heroPoint.x + 100, heroPoint.y + -335), name = "item_pudge_heart_lua7"},
				{vector = Vector(heroPoint.x + -62, heroPoint.y + -297), name = "item_mage_heart_lua7"},
				{vector = Vector(heroPoint.x + 62, heroPoint.y + -297), name = "item_agility_heart_lua7"},
				{vector = Vector(heroPoint.x + -25, heroPoint.y + -260), name = "item_moon_shard_lua7"},
				{vector = Vector(heroPoint.x + 25, heroPoint.y + -260), name = "item_hood_sword_lua7"},
			}

			for _, item in pairs(itemsList) do
				local newItem = CreateItem( item.name, hero, hero )
				local drop = CreateItemOnPositionForLaunch( heroPoint, newItem )
				newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, item.vector )
				newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 30 )
			end
		elseif text == 'book' then
			for _, item_name in pairs({"item_greed_agi", "item_greed_int", "item_greed_str"}) do
				local spawnPoint = hero:GetAbsOrigin()	
				local newItem = CreateItem( item_name, nil, nil )
				newItem:SetCurrentCharges(1000)
				local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
				local dropRadius = RandomFloat( 50, 100 )

				newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
				newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 30 )
			end
		elseif string.find(text, 'bags') then
			local _, _, num1 = string.find(text, "(%d+)")
			num1 = num1 or 1
			num1 = tonumber(num1)
			local step = 0
			Timers:CreateTimer(0.1 ,function()
				for i = 0, 3 do
					local spawnPoint = hero:GetAbsOrigin()	
					local newItem = CreateItem( "item_bag_of_gold_big", nil, nil )
					newItem:SetCurrentCharges(1000)
					local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
					local dropRadius = RandomFloat( 50, 100 )
	
					newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
					newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 30 )
				end
				step = step + 1
				if step < num1/3 then
					return 0.1
				end
				return nil
			end)
		end
	end

	----- PromoCode

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
			print(res.StatusCode)
			print(res.Body)
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

function DataBase:startGame()
	local arr = {}
	for i = 0 , PlayerResource:GetPlayerCount() do
	    if PlayerResource:IsValidPlayer(i) then
			arr[i] = {
				sid = PlayerResource:GetSteamAccountID(i),
				name = PlayerResource:GetPlayerName(i),
			}
		end
	end
	arr = json.encode(arr)
	local req = CreateHTTPRequestScriptVM( "POST", DataBase.start )
	req:SetHTTPRequestGetOrPostParameter('arr',arr)
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 and res.Body ~= nil then
			local obj = json.decode(res.Body)
			
			_G.RATING = {
				rating = obj.rating,
				top = obj.top,
				bg = obj.bg,
				seasons = obj.seasons,
				history = obj.history,
			}
			_G.SHOP = obj.shop
			Shop:createShop()
			Timers:CreateTimer(0.1 ,function()
				if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION or GameRules:State_Get() == DOTA_GAMERULES_STATE_STRATEGY_TIME then
					rating:pickInit(t)
					return nil
				end
				return 1
			end)
		end
	end)
end

function DataBase:PointsChange(player, pEdit, isGameEnded)
	if DataBase:isCheatOn() then return end
	
	local hero = PlayerResource:GetSelectedHeroEntity( player )
	

	local tab = CustomNetTables:GetTableValue("talants", tostring(player))
	local arr = {
		sid = PlayerResource:GetSteamAccountID(player),
		pEdit = pEdit,
		hero_name = PlayerResource:GetSelectedHeroName(player),
		in_game_time = GameRules:GetGameTime(),
        gameDonatExp = tab["gameDonatExp"],
        gameNormalExp = tab["gameNormalExp"],
		auto_pet = Shop.Auto_Pet[player],
	}
	if hero:HasModifier("modifier_silent2") or GameRules:GetGameTime() < 360 then
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
	local from = tonumber(t.PlayerID)
	local to = tonumber(t.pid)
	local type = t.type
	if RATING and tonumber(RATING['rating'][from+1]['commens']) <= 0 then
		return
	end

	RATING['rating'][from+1]['commens'] = tonumber(RATING['rating'][from+1]['commens']) - 1
	if type == 'likes' then
		RATING['rating'][to+1]['likes'] = tonumber(RATING['rating'][to+1]['likes']) + 1
	elseif type == 'reports' then
		RATING['rating'][to+1]['reports'] = tonumber(RATING['rating'][to+1]['reports']) + 1
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

function DataBase:TalentPunishment(t)
	local tab = CustomNetTables:GetTableValue("talants", tostring(t.PlayerID))
	local arr = {
		hero_name = tab["hero_name"],
		PlayerID = PlayerResource:GetSteamAccountID(t.PlayerID),
		change = t.change,
		patron = RATING["rating"][t.PlayerID+1]["patron"],
	}
	-- normal exp
	tab["totalexp"] = tonumber(tab["totalexp"]) + t.change
	if tab["totalexp"] < 0 then
		tab["totalexp"] = 0
	end
	-- donate exp
	if RATING["rating"][t.PlayerID+1]["patron"] == 1 then
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
			local tab = CustomNetTables:GetTableValue("talants", tostring(t.PlayerID))
			local count = res.Body
			tab[t.i..t.j.."count"] = count
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "ThrowHeroInfo", { count = count } )
			CustomNetTables:SetTableValue("talants", tostring(t.PlayerID), tab)
		end
	end)
end


function DataBase:AddRating(pid, count)
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

function DataBase:AddRP(pid, count)
	Shop.pShop[pid].mmrpoints = Shop.pShop[pid].mmrpoints + count
	local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(pid))
	shopinfo.mmrpoints = Shop.pShop[pid].mmrpoints
	CustomNetTables:SetTableValue("shopinfo", tostring(pid), shopinfo)

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
	Shop.pShop[pid].coins = Shop.pShop[pid].coins + count
	local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(pid))
	shopinfo.coins = Shop.pShop[pid].coins
	CustomNetTables:SetTableValue("shopinfo", tostring(pid), shopinfo)

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

DataBase:init()
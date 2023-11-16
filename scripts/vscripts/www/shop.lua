if Shop == nil then
    _G.Shop = class({})
end

function Shop:init()
	Shop.pShop = {}
    CustomGameEventManager:RegisterListener("giveItem", Dynamic_Wrap( Shop, 'giveItem' ))
	CustomGameEventManager:RegisterListener("buyItem", Dynamic_Wrap( Shop, 'buyItem' ))
    CustomGameEventManager:RegisterListener("takeOffEffect", Dynamic_Wrap( Shop, 'takeOffEffect' ))
	ListenToGameEvent("player_reconnected", Dynamic_Wrap( Shop, 'OnPlayerReconnected' ), self)
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( Shop, 'OnGameRulesStateChange'), self)
	CustomGameEventManager:RegisterListener("GetPets",function(_, keys)
        Shop:GetPets(keys)
    end)
	CustomGameEventManager:RegisterListener("UpdatePetButton",function(_, keys)
        Shop:UpdatePetButton(keys)
    end)
	CustomGameEventManager:RegisterListener("OpenTreasure",function(_, keys)
        Shop:OpenTreasure(keys)
    end)
	CustomGameEventManager:RegisterListener("SprayToggleActivate",function(_, keys)
        Shop:SprayToggleActivate(keys)
    end)
	
	ListenToGameEvent("player_chat", Dynamic_Wrap( Shop, "OnChat" ), self )
	Shop.marci = {name = "change_hero_marci", hero_name = "npc_dota_hero_marci", available={[0]=false,[1]=false,[2]=false,[3]=false,[4]=false}, selected={[0]=false,[1]=false,[2]=false,[3]=false,[4]=false}}
	Shop.pango = {name = "change_hero_pangolier", hero_name = "npc_dota_hero_pangolier",available={[0]=false,[1]=false,[2]=false,[3]=false,[4]=false}, selected={[0]=false,[1]=false,[2]=false,[3]=false,[4]=false}}
	Shop.pet = {}
	CustomGameEventManager:RegisterListener("GetPet",function(_, keys)
        Shop:GetPet(keys)
    end)
	CustomGameEventManager:RegisterListener("AutoGetPetOprion",function(_, keys)
        Shop:AutoGetPetOprion(keys)
    end)
	CustomGameEventManager:RegisterListener("CustomShopStash_TakeItem",function(_, keys)
        Shop:CustomShopStash_TakeItem(keys)
    end)
	CustomGameEventManager:RegisterListener("CustomShopStash_UseAllScroll",function(_, keys)
        Shop:UseAllScroll(keys)
    end)
	CustomGameEventManager:RegisterListener("CustomShopStash_ReturnItem",function(_, keys)
        Shop:CustomShopStash_ReturnItem(keys)
    end)
	CustomGameEventManager:RegisterListener("ActivateTrialPeriod_Pet",function(_, keys)
        Shop:ActivateTrialPeriod_Pet(keys)
    end)
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( Shop, "OnItemPickUp"), self)
	Shop.Auto_Pet = {}
	Shop.Change_Available = {}
	Shop.sprayCategory = 4
	Shop.spray = {}
	Shop.stashItems = {"item_boss_summon","item_ticket","item_forever_ward","item_armor_aura","item_base_damage_aura","item_expiriance_aura","item_move_aura","item_attack_speed_aura","item_hp_aura"}
end

function Shop:GetPets(keys)
	if RATING[ "rating" ][ keys.PlayerID ][ "pet_trial_ends" ] ~= nil then
		Shop:ActivateTrialPeriod_Pet({
			PlayerID = keys.PlayerID,
			affordable_pet = {"pet_15", "pet_13", "pet_14"},
		})
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "GetPets_Js", {
		shop = Shop.pShop[keys.PlayerID],
		exp = pets_exp,
		auto_pet = Shop.Auto_Pet[keys.PlayerID],
		pet_trial = {
			available = RATING[ "rating" ][ keys.PlayerID ][ "pet_trial_available" ],
			ends = RATING[ "rating" ][ keys.PlayerID ][ "pet_trial_ends" ],
			affordable_pet = {"pet_15", "pet_13", "pet_14"},
		},
	} )
end

function Shop:OnChat( event )
    local text = event.text
	local pid = event.playerid
	local steamID = PlayerResource:GetSteamAccountID(pid)
	if steamID == 169401485 or steamID == 1062658804 or steamID == 455872541 or steamID == 393187346 or steamID == 1250222698 then
		if text == "pet" then
			Shop:RefreshPet(pid)
		end
	end
end

function Shop:RefreshPet(PlayerID)
	local hero = PlayerResource:GetSelectedHeroEntity(PlayerID)
	item = hero:GetItemInSlot( 16 )
	if item == nil then
		return
	end
	hero:RemoveItem(item)

	for _,v in pairs(Shop.pShop[PlayerID][1]) do
		if type(v) == 'table' then
			if v.status == "issued" then
				v.status = "taik"
				break
			end
		end
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( PlayerID ), "shop_refresh_pets", Shop.pShop[PlayerID] )
end

function Shop:ActivateTrialPeriod_Pet(t)
	for categoryKey, category in ipairs(Shop.pShop[t.PlayerID]) do
		for itemKey, item in ipairs(category) do
			for _, trialPetName in pairs(t.affordable_pet) do
				if item.name == trialPetName then
					item.onStart = 13501
					item.now = 13501
				end
			end
		end
	end
	if RATING[ "rating" ][ t.PlayerID ][ "pet_trial_ends" ] == nil then
		DataBase:ActivateTrialPeriodPet(t)
	end
end

function Shop:OnGameRulesStateChange(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(2, function() 
			for i = 0 , PlayerResource:GetPlayerCount()-1 do --
				if PlayerResource:IsValidPlayer(i) then
					if Shop.Auto_Pet[i] then 
						Shop:GetPet({
							PlayerID = i,
							pet = {name = Shop.Auto_Pet[i]},
						})
					else
						Shop:GetPet({
							PlayerID = i,
							pet = {name = "spell_item_pet"},
						})
					end
					Shop.Change_Available[i] = true
					CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(i), "UpdatePetIcon", {
						can_change = Shop.Change_Available[i]
					} )
				end
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( i ), "initShop", Shop.pShop[i] )
			end
		end)	
	end
end

function Shop:OnItemPickUp(keys)
	if not table.has_value(Shop.stashItems, keys.itemname) then return end
    local hero = PlayerResource:GetSelectedHeroEntity( keys.PlayerID )
    local item = nil
    for i = 0, 8 do
        if hero:GetItemInSlot(i) then
            if hero:GetItemInSlot(i):GetName() == keys.itemname and hero:GetName() == hero:GetItemInSlot(i):GetPurchaser():GetName() then
                item = hero:GetItemInSlot(i)
            end
        end
    end
    if not item then return end
	for categoryKey, category in ipairs(Shop.pShop[keys.PlayerID]) do
		for itemKey, shopItem in ipairs(category) do
			if shopItem.itemname and shopItem.itemname == keys.itemname then
				shopItem.now = shopItem.now + item:GetCurrentCharges()
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "UpdateStore", {
					{categoryKey = categoryKey, productKey = itemKey, itemname = shopItem.itemname, count = shopItem.now},
				})
				hero:RemoveItem(item)
			end
		end
	end
end

function Shop:OnPlayerReconnected(keys)
	local sid = PlayerResource:GetSteamAccountID(keys.PlayerID)
	local req = CreateHTTPRequestScriptVM( "POST", DataBase.updatecoins  .. '&sid=' .. sid )
	req:SetHTTPRequestGetOrPostParameter('sid',tostring(sid))
	req:SetHTTPRequestAbsoluteTimeoutMS(100000)
	req:Send(function(res)
		if res.StatusCode == 200 then
			Shop.pShop[keys.PlayerID].coins = tonumber(res.Body)
		end
	end)
	if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(2, function() 
			local sid = PlayerResource:GetSteamAccountID( keys.PlayerID )
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "initShop", Shop.pShop[keys.PlayerID] )
			Shop:GetPets(keys)
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(keys.PlayerID), "UpdatePetIcon", {
				can_change = Shop.Change_Available[keys.PlayerID],
			} )
		end)
	end
end

function Shop:PlayerSetup( pid )
	local sid = PlayerResource:GetSteamAccountID(pid)
	local arr = {}
	for sKey, sValue in pairs(basicshop) do
		if type(sValue) == 'table' then
			arr[sKey] = {}
			for oKey, oValue in pairs(sValue) do
				arr[sKey][oKey] = {}
				if type(oValue) == 'table' then

					for pKey, pValue in pairs(oValue) do
						arr[sKey][oKey][pKey] = pValue
					end
					
					if _G.SHOP[pid][oValue.name] then
						arr[sKey][oKey].onStart = tonumber(_G.SHOP[pid][oValue.name])
						arr[sKey][oKey].now = tonumber(_G.SHOP[pid][oValue.name])
						if arr[sKey][oKey].type == "consumabl" then
							arr[sKey][oKey].status = 'consumabl'
						elseif tonumber(_G.SHOP[pid][oValue.name]) > 0 then
							if arr[sKey][oKey].type == "talant" or arr[sKey][oKey].type == "pet_change" then
								arr[sKey][oKey].status = 'active'
							else
								arr[sKey][oKey].status = 'taik'
							end
						else
							arr[sKey][oKey].status = 'buy'
						end
					else
						if arr[sKey][oKey].type == "hero_change" then
							arr[sKey][oKey].onStart = 1
							arr[sKey][oKey].now = 1
							if _G.SHOP[pid]["totaldonate"] >= 2000 then
								arr[sKey][oKey].status = 'shop_select'
							else
								arr[sKey][oKey].status = 'shop_lock'
							end
						else
							arr[sKey][oKey].onStart = 0
							arr[sKey][oKey].now = 0
							if arr[sKey][oKey].type == "consumabl" then
								arr[sKey][oKey].status = 'consumabl'
							else
								arr[sKey][oKey].status = 'buy'
							end
						end
					end
				elseif type(oValue) == 'string' then
					arr[sKey][oKey] = oValue
				end
			end
		end
	end

	arr.coins = _G.SHOP[pid].coins or 0
	arr.mmrpoints = _G.SHOP[pid].mmrpoints or 0
	arr.totaldonate = _G.SHOP[pid].totaldonate or 0
	arr.feed = _G.SHOP[pid].feed or 0
	arr.ban = _G.SHOP[pid].other_60 or 0
	arr.pet_change = _G.SHOP[pid].pet_change or 0
	arr.auto_pet = _G.SHOP[pid].auto_pet or ""
	arr.gems = {
		[1] = _G.SHOP[pid]["gem_1"],
		[2] = _G.SHOP[pid]["gem_2"],
		[3] = _G.SHOP[pid]["gem_3"],
		[4] = _G.SHOP[pid]["gem_4"],
		[5] = _G.SHOP[pid]["gem_5"],
	}
	Shop.pShop[pid] = arr
	CustomShop:UpdateShopInfoTable(pid)

	Shop.spray[pid] = _G.SHOP[pid].auto_spray
	Shop.Change_Available[pid] = true
	Timers:CreateTimer(function()
		if PlayerResource:GetPlayer(pid) == nil then
			return nil
		end
		if PlayerResource:HasSelectedHero(pid) then
			local heroName = PlayerResource:GetSelectedHeroName(pid)
			talants:pickinfo(pid,false)
			return nil
		else
		  --  print(PlayerResource:HasSelectedHero(i))
		end
		return 1.0
	end)
	ChangeHero:SetDonateHeroesDate(pid)
	if ChangeHero:IsMarciAvailable_PickStage(pid) then
		GameRules:AddHeroToPlayerAvailability(pid, DOTAGameManager:GetHeroIDByName( "npc_dota_hero_marci" ) )
	end
	if ChangeHero:IsSilencerAvailable_PickStage(pid) then
		GameRules:AddHeroToPlayerAvailability(pid, DOTAGameManager:GetHeroIDByName( "npc_dota_hero_silencer" ) )
	end
end

function Shop:giveItem(t)
	local pid = t.PlayerID
	local sid = PlayerResource:GetSteamAccountID(pid)
	local categoryKey = t.i
	local productKey = t.n
	if tonumber(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now']) <= 0 or Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] == "issued" then
		return
	end
	local hero = PlayerResource:GetSelectedHeroEntity( pid )
	-- print(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now'])
	Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now'] = tonumber(Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now']) - 1
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == 'pet' and Shop.pShop[pid][1][1].now == 1 then
		for PetKey,PetValue in pairs(Shop.pShop[pid][1]) do
			if PetValue.status == "issued" then
				PetValue.status = "taik"
				item16 = hero:GetItemInSlot( 16 )
				--print(item16)
				if item16 ~= nil then
					--print("remove:item16")
					hero:RemoveItem(item16)
				end
				PetValue.now = PetValue.now + 1
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( pid ), "change_pet", {1, PetKey} )
				break
			end
		end
	end
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['now'] == 0 and Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] ~= "consumabl" then 
		Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] = 'issued'
	end
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == "effect" then
		LinkLuaModifier( "modifier_" .. Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].name, "effects/" .. Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].name, LUA_MODIFIER_MOTION_NONE )
		hero:AddNewModifier( hero, nil, "modifier_" .. Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].name, {} )
		Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)]['status'] = 'takeoff'
	else
		local player = PlayerResource:GetSelectedHeroEntity(pid)
		local spawnPoint = player:GetAbsOrigin()
		local itemname = Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].itemname
		local new_item = player:AddItemByName(itemname)
		if t.IsControlDown and new_item:IsCooldownReady() and not player:HasModifier("modifier_"..itemname.."_cd") then
			player:SetCursorCastTarget(player)
			new_item:UseResources(false, false, false, true)
			new_item:OnSpellStart()
		end
	end
	if Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].type == "hero_change" then
		Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].status = "active"
		for heroChangeKey,heroChangeValue in pairs(Shop.pShop[pid][tonumber(categoryKey)]) do
			if heroChangeValue.type == "hero_change" and heroChangeKey ~= tonumber(productKey) then
				heroChangeValue.status = "shop_lock"
			end
		end
		Shop:ChangeHero(pid, Shop.pShop[pid][tonumber(categoryKey)][tonumber(productKey)].hero_name)
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( pid ), "UpdateStore", {
		{categoryKey = categoryKey, productKey = productKey, itemname = Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['itemname'], count = Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['now']},
	})
end

function Shop:takeOffEffect(t)
	local pid = t.PlayerID
	Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['now'] = tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['now']) + 1

    local hero = PlayerResource:GetSelectedHeroEntity( pid )
    hero:RemoveModifierByName( "modifier_" .. Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)].name)

end


function Shop:buyItem(t)
	local pid = t.PlayerID
	local i = tonumber(t.i)
	local n = tonumber(t.n)
	local shop_type = Shop.pShop[pid][i][n]["type"]
	if t.currency == 1 and Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] and tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] * t.amountBuy) > tonumber(Shop.pShop[pid].mmrpoints) then
		return
	elseif t.currency == 0 and Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don'] and tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don']*t.amountBuy) > tonumber(Shop.pShop[pid].coins) then
		return
	end
	if Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["type"] ~= "gem" and Shop.pShop[pid][i][n]["type"] ~= "loot-box" and Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["type"] ~= "feed" then
		Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['now'] = tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)].now) + t.amountBuy
		Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['onStart'] = tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['onStart']) + t.amountBuy
	end
	if t.currency == 1 then
		Shop.pShop[pid].mmrpoints = Shop.pShop[pid].mmrpoints - Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] * t.amountBuy
	else
		Shop.pShop[pid].coins = Shop.pShop[pid].coins - Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don'] * t.amountBuy
	end
	if Shop.pShop[pid][i][n].name == "hot_offer" then
		Shop:GiveOutAllHotOfferItems(pid, Shop.pShop[pid][i][n])
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( pid ), "UpdateStore", {
		{categoryKey = t.i, productKey = t.n, itemname = Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['itemname'], count = Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['now']},
	})
	if DataBase:IsCheatMode() == false then --
		local sql_name = {}
		local give = {}
		local currency = 'don'
		if t.currency == 1 then currency = 'rp' end
		local price = Shop.pShop[pid][i][n]['price'][currency]
		
		if Shop.pShop[pid][i][n]["type"] == "gem" then
			local gem_name = 'gem_' .. Shop.pShop[pid][i][n]['gem_type']
			sql_name[gem_name] = t.amountBuy
			give[gem_name] = Shop.pShop[pid][i][n]['give']
		elseif Shop.pShop[pid][i][n]["type"] == "loot-box" then
			-- loot box 
			for z = 1, t.amountBuy do
				local randomInt = RandomInt(1,100)
				local ds = 0
				local slt = nil
			end
		else
			local name = Shop.pShop[pid][i][n].name
			if Shop.pShop[pid][i][n].type == 'feed' then
				name = 'feed'
			end
			sql_name[name] = t.amountBuy
			give[name] = Shop.pShop[pid][i][n].give or 1
			Shop.pShop[pid]["feed"] = Shop.pShop[pid]["feed"] + sql_name[name] * give[name]
		end

		if shop_type == "talant" then
			talants:sendServer({PlayerID = pid, changename = "cout", value = 2, changetype = "set", chartype = "int", win_lose = nil, heroname = Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["hero"]})
			if Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["hero"] == PlayerResource:GetSelectedHeroName(pid) then
				local tab = CustomNetTables:GetTableValue("talants", tostring(pid))
				tab["cout"] = 2
				progress[t.PlayerID] = tab
				CustomNetTables:SetTableValue("talants", tostring(pid), tab)
			end
		elseif shop_type == "gem" then
			CustomShop:AddGems(t.PlayerID, { 
				[Shop.pShop[pid][i][n]["gem_type"]] = Shop.pShop[pid][i][n]["give"] * t.amountBuy 
			}, not DataBase:IsCheatMode())
		end
		DataBase:buyRequest({PlayerID = t.PlayerID, name = sql_name, give = give, price = price, amount = t.amountBuy, currency = currency})
		
		local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(pid))
		shopinfo['feed'] = Shop.pShop[pid]["feed"]
		shopinfo['coins'] = Shop.pShop[pid]["coins"]
		shopinfo['mmrpoints'] = Shop.pShop[pid]["mmrpoints"]
		CustomNetTables:SetTableValue("shopinfo", tostring(pid), shopinfo)
	end
end

function Shop:GiveOutAllHotOfferItems(PlayerID, hotOfferItem)
	local updateCount = {}
	local DBItemsName = {}
	for cKey, cValue in ipairs(Shop.pShop[PlayerID]) do
		for itemKey, item in ipairs(cValue) do
			for package_itemname, package_itemcount in pairs(hotOfferItem.package_contents) do
				if item.itemname and item.itemname == package_itemname then
					DBItemsName[item.name] = package_itemcount
					if package_itemcount > 0 then
						item.onStart = item.onStart + package_itemcount
						item.now = item.now + package_itemcount
					else
						item.onStart = 1
						item.now = 1
					end
					table.insert(updateCount, {
						categoryKey = cKey, productKey = itemKey, itemname = item.itemname, count = item.now
					})
				end
			end
		end
	end
	if DataBase:IsCheatMode() == false then
		DataBase:GiveOutAllHotOfferItems(PlayerID, DBItemsName)
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(PlayerID), "UpdateStore", updateCount)
end

function Shop:CustomShopStash_TakeItem(t)
	local thisItem = nil
	for categoryKey, category in ipairs(Shop.pShop[t.PlayerID]) do
		for itemKey, item in ipairs(category) do
			if item.itemname and item.itemname == t.itemname and item.now > 0 then
				thisItem = item
				thisItem.categoryKey = categoryKey
				thisItem.itemKey = itemKey
				break
			end
		end
	end
	-- t.IsControlDown
	if thisItem then
		Shop:giveItem({PlayerID = t.PlayerID , i = thisItem.categoryKey, n = thisItem.itemKey, IsControlDown = t.IsControlDown == 1})
	end
end

function Shop:CustomShopStash_ReturnItem(t)
	local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
	local found_item = hero:FindItemInInventory( t.itemname )
	if found_item then
		for categoryKey, category in ipairs(Shop.pShop[t.PlayerID]) do
			for itemKey, item in ipairs(category) do
				if item.itemname and item.itemname == found_item:GetName() then
					item.now = item.now + found_item:GetCurrentCharges()
					hero:RemoveItem(found_item)
					CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "UpdateStore", {
						{categoryKey = categoryKey, productKey = itemKey, itemname = item.itemname, count = item.now},
					})
					return
				end
			end
		end
	end
end

function Shop:UseAllScroll(t)
	local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
	for categoryKey, category in ipairs(Shop.pShop[t.PlayerID]) do
		for itemKey, item in ipairs(category) do
			if item.itemname and table.has_value(t, item.itemname) and item.now > 0 and not hero:HasModifier("modifier_"..item.itemname.."_cd") then
				Shop:giveItem({PlayerID = t.PlayerID , i = categoryKey, n = itemKey, IsControlDown = true})
			end
		end
	end
end

function Shop:AddRP(pid, value)
	SendPlayerNotification:AddRPAlert(pid, value)
	Shop.pShop[pid].mmrpoints = Shop.pShop[pid].mmrpoints + value
	local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(pid))
	shopinfo.mmrpoints = Shop.pShop[pid].mmrpoints
	CustomNetTables:SetTableValue("shopinfo", tostring(pid), shopinfo)
end

function Shop:AddCoins(pid, value)
	SendPlayerNotification:AddRPAlert(pid, value)
	Shop.pShop[pid].coins = Shop.pShop[pid].coins + value
	local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(pid))
	shopinfo.coins = Shop.pShop[pid].coins
	CustomNetTables:SetTableValue("shopinfo", tostring(pid), shopinfo)
end

-- петы
function GetLevel(exp)
	local level = 10
	local passed_exp = 0
	for i = 1, 10 do 
		passed_exp = passed_exp + pets_exp[i-1]
		if exp >= passed_exp and exp < passed_exp + pets_exp[i] then
			level = i-1
			break
		end
	end
	return level
end

function Shop:UpdatePetButton(t)
	local pid = t.PlayerID
	local count = t.count
	if tonumber(Shop.pShop[pid]["feed"]) < tonumber(count) then return end
	Shop.pShop[pid]["feed"] = Shop.pShop[pid]["feed"] - tonumber(count)
	local pet = nil
	for k,v in pairs(Shop.pShop[pid][1]) do
		if v.name == t.pet.name then
			if v.now == 0 then return end
			v.now = v.now + count
			pet = v
			break
		end
	end
	if not DataBase:IsCheatMode() then
		DataBase:UpdatePet(t.pet.name, pid, count)
	end
	local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(pid))
	shopinfo['feed'] = Shop.pShop[pid]["feed"]
	shopinfo['coins'] = Shop.pShop[pid]["coins"]
	shopinfo['mmrpoints'] = Shop.pShop[pid]["mmrpoints"]
	CustomNetTables:SetTableValue("shopinfo", tostring(pid), shopinfo)

	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	if Shop.pet[pid] == pet.itemname then
		hero:RemoveAbility(pet.itemname)
		hero:AddAbility(pet.itemname):SetLevel(GetLevel(pet.now))
	end
end



function Shop:GetPet(t)
	local pet_name = t.pet.name
	local pid = t.PlayerID
	local hero = PlayerResource:GetSelectedHeroEntity(pid)
	if not hero then return end
	local pet = nil
	for k, v in pairs(Shop.pShop[pid][1]) do
		if type(v) == 'table' and v.type == 'pet' and v.now > 0 then
			if v.name == pet_name then 
				pet = v
			end
		end
	end
	if not pet or pet.now == 0 then return end

	if Shop.pShop[pid][1][1].now == 0 and Shop.Change_Available[pid] == false then return end

	if Shop.pet[pid] ~= nil then
		hero:RemoveAbility(Shop.pet[pid])
	end
	
	if hero:HasAbility("spell_item_pet") then
		hero:RemoveAbility("spell_item_pet")
	end

	if pet and pet.itemname ~= Shop.pet[pid]  then
		hero:AddAbility(pet.itemname):SetLevel(GetLevel(pet.now))
		Shop.pet[pid] = pet.itemname
		CustomNetTables:SetTableValue("player_pets", tostring(pid), {pet = pet.itemname})
		if Shop.pShop[pid][1][1].now == 0 then
			Shop.Change_Available[pid] = false
		end
	else
		hero:AddAbility("spell_item_pet"):SetLevel(1)
		Shop.pet[pid] = nil
		CustomNetTables:SetTableValue("player_pets", tostring(pid), {pet = "spell_item_pet"})
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "UpdatePetIcon", {can_change = Shop.Change_Available[pid]} )
	
	
end

function Shop:AutoGetPetOprion(t)
	if t.pet == nil then
		Shop.Auto_Pet[t.PlayerID] = nil
	else
		Shop.Auto_Pet[t.PlayerID] = t.pet.name
	end
	DataBase:AutoGetPetOprion(t)
end

function Shop:OpenTreasure(t)
	for categoryKey, categoryValue in pairs(Shop.pShop[t.PlayerID]) do
		if type(categoryValue) == 'table' then
			for productKey, productValue in ipairs(categoryValue) do
				if productValue.name == t.treasureName then
					thisTreasure = productValue
					thisTreasure.categoryKey = categoryKey
					thisTreasure.productKey = productKey
				elseif productValue.source and productValue.source.treasury and productValue.source.treasury == t.treasureName then
					if not awardList then awardList = {} end
					local award = productValue
					award.categoryKey = categoryKey
					award.productKey = productKey
					table.insert(awardList, award)
					if award.name == "gems_award" then
						gemsAward = award
					end
				end
			end
		end
	end
	if thisTreasure == nil or thisTreasure.now < 1 then return end
	thisTreasure.now = thisTreasure.now - 1
	thisTreasure.onStart = thisTreasure.onStart - 1
	local itemPrize = awardList[RandomInt(1, #awardList)]
	while itemPrize.name == "gems_award" do
		itemPrize = awardList[RandomInt(1, #awardList)]
	end
	if RandomFloat(1, 100) <= 1.20 then
		itemPrize = gemsAward
	end
	local compensation = thisTreasure.compensation
	local data = {
		itemPool = {},
		itemPrize = itemPrize,
		glory = 0,
		skipAnimation = false,
	}
	for _,award in pairs(awardList) do
		table.insert(data.itemPool, award)
	end
	
	local requestData = {
		sid = PlayerResource:GetSteamAccountID(t.PlayerID),
		treasureName = t.treasureName,
	}
	if itemPrize.name == "gems_award" then
		DataBase:AddCoins(t.PlayerID, 500)
		-- requestData.gemAward = 500
	elseif itemPrize.counter and itemPrize.counter == true and itemPrize.onStart > 0 then
		itemPrize.now = itemPrize.now + 1
		itemPrize.onStart = itemPrize.onStart + 1
		requestData.itemAward = itemPrize.name
	elseif itemPrize.onStart == 0 then
		itemPrize.now = 1
		itemPrize.onStart = 1
		requestData.itemAward = itemPrize.name
	elseif itemPrize.onStart > 0 then
		Shop.pShop[t.PlayerID].mmrpoints = Shop.pShop[t.PlayerID].mmrpoints + compensation
		requestData.rpAward = compensation
		data.glory = compensation
	end
	DataBase:OpenTreasure(requestData)
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "ShowWheel", data )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "UpdateStore", {
		{categoryKey = thisTreasure.categoryKey, productKey = thisTreasure.productKey, itemname = "", count = thisTreasure.now},
		{categoryKey = itemPrize.categoryKey, productKey = itemPrize.productKey, itemname = "", count = itemPrize.now},
	})
	local shopinfo = CustomNetTables:GetTableValue("shopinfo", tostring(t.PlayerID))
	shopinfo['feed'] = Shop.pShop[t.PlayerID]["feed"]
	shopinfo['coins'] = Shop.pShop[t.PlayerID]["coins"]
	shopinfo['mmrpoints'] = Shop.pShop[t.PlayerID]["mmrpoints"]
	CustomNetTables:SetTableValue("shopinfo", tostring(t.PlayerID), shopinfo)
end

function Shop:SprayToggleActivate(t)
	local toggleState = t.toggleState == 1
	if toggleState == false then 
		Shop.spray[t.PlayerID] = nil
	else
		Shop.spray[t.PlayerID] = Shop.pShop[t.PlayerID][tonumber(t.categoryKey)][tonumber(t.productKey)].name
	end
	DataBase:SprayToggleActivate({
		PlayerID = t.PlayerID,
		sprayName = Shop.spray[t.PlayerID],
	})
end

if ChangeHero == nil then
    _G.ChangeHero = class({})
end

function ChangeHero:init()
	-- ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( self, 'OnGameRulesStateChange'), self)
	ListenToGameEvent( 'dota_player_gained_level', Dynamic_Wrap( self, 'dota_player_gained_level'), self)
	CustomGameEventManager:RegisterListener("ChangeHeroLua",function(_, keys)
        self:ChangeHeroLua(keys)
    end)

	self.heroes = {
		npc_dota_hero_marci = {unitName = "change_hero_marci", position = Vector(-640,-9926,512), minimumTotal = 1000, trialName = "hero_marci_trial", minimumOneTimeDon = 150},
		npc_dota_hero_silencer = {unitName = "change_hero_silencer", position = Vector(-474,-10162,512), minimumTotal = 2000, trialName = "hero_silencer_trial", minimumOneTimeDon = 200},
	}
	for name, heroData in pairs(self.heroes) do
		heroData.available = {}
		heroData.selected = {}
		heroData.trialCount = {}
		heroData.heroName = name
		for i = 0, 4 do
			heroData.available[i] = false
			heroData.selected[i] = false
		end
	end
end

function ChangeHero:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		-- Timers:CreateTimer(1, function()
		-- 	for heroName, heroData in pairs(self.heroes) do
		-- 		heroData.unit = CreateUnitByName(heroData.unitName , heroData.position, false, nil, nil, DOTA_TEAM_GOODGUYS)
		-- 		if heroData.unit then
		-- 			heroData.unit:AddNewModifier(heroData.unit,nil,"modifier_quest",{})
		-- 			heroData.unitIndex = heroData.unit:entindex()
		-- 			heroData.unit:SetForwardVector(heroData.unit:GetForwardVector() * -1)
		-- 		end
		-- 		for i = 0 , PlayerResource:GetPlayerCount()-1 do
		-- 			if PlayerResource:IsValidPlayer(i) then
		-- 				heroData.trialCount[i] = RATING["rating"][i][heroData.trialName]
		-- 				if Shop.pShop[i].totaldonate >= heroData.minimumTotal then
		-- 					heroData.trialCount[i] = -1
		-- 				end
		-- 				if Shop.pShop[i].totaldonate >= heroData.minimumTotal or DataBase:IsCheatMode() or heroData.trialCount[i] > 0 then
		-- 					heroData.available[i] = true
		-- 				end
		-- 				if heroName == "npc_dota_hero_marci" and RATING["rating"][i]["patron"] == 1 then
		-- 					heroData.trialCount[i] = -1
		-- 					heroData.available[i] = true
		-- 				end
		-- 				if heroName == "npc_dota_hero_silencer" and RATING["rating"][i]["silencer_date"] ~= nil then
		-- 					heroData.trialCount[i] = -1
		-- 					heroData.available[i] = true
		-- 				end
		-- 			end
		-- 		end
		-- 	end
			
		-- 	CustomGameEventManager:Send_ServerToAllClients( "UpdateChangeHeresInfo", self.heroes )
		-- end)
	end
end

function ChangeHero:SetDonateHeroesDate(pid)
	for heroName, heroData in pairs(self.heroes) do
		heroData.trialCount[pid] = RATING["rating"][pid][heroData.trialName]
		if Shop.pShop[pid].totaldonate >= heroData.minimumTotal then
			heroData.trialCount[pid] = -1
		end
		if Shop.pShop[pid].totaldonate >= heroData.minimumTotal or DataBase:IsCheatMode() or heroData.trialCount[pid] > 0 then
			heroData.available[pid] = true
		end
		if heroName == "npc_dota_hero_marci" and RATING["rating"][pid]["patron"] == 1 then
			heroData.trialCount[pid] = -1
			heroData.available[pid] = true
		end
		if heroName == "npc_dota_hero_silencer" and RATING["rating"][pid]["silencer_date"] ~= nil then
			heroData.trialCount[pid] = -1
			heroData.available[pid] = true
		end
	end
end

function ChangeHero:IsMarciAvailable_PickStage(PlayerID)
	local marci = ChangeHero.heroes.npc_dota_hero_marci
	return Shop.pShop[PlayerID].totaldonate >= marci.minimumTotal or DataBase:IsCheatMode() or marci.trialCount[PlayerID] > 0  or RATING["rating"][PlayerID]["patron"] == 1
end
function ChangeHero:GetMarciTrial(pid)
	return self.heroes["npc_dota_hero_marci"].trialCount[pid]
end
function ChangeHero:IsSilencerAvailable_PickStage(PlayerID)
	local silencer = ChangeHero.heroes.npc_dota_hero_silencer
	return Shop.pShop[PlayerID].totaldonate >= silencer.minimumTotal or DataBase:IsCheatMode() or silencer.trialCount[PlayerID] > 0  or RATING["rating"][PlayerID]["silencer_date"] ~= nil
end
function ChangeHero:GetSilencerTrial(pid)
	return self.heroes["npc_dota_hero_silencer"].trialCount[pid]
end
function ChangeHero:dota_player_gained_level(t)
	local player = EntIndexToHScript( t.player )
	local player_id = player:GetPlayerID()
	for _, heroData in pairs(self.heroes) do
		heroData.available[player_id] = false
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( player_id ), "UpdateChangeHeresInfo", self.heroes )
end

function ChangeHero:ChangeHeroLua(t)
	if self.heroes[t.heroName].available[t.PlayerID] == false then return end
	if Shop.pShop[t.PlayerID].totaldonate < self.heroes[t.heroName].minimumTotal then
		self.heroes[t.heroName].trialCount[t.PlayerID] = RATING["rating"][t.PlayerID][self.heroes[t.heroName].trialName] - 1
	end
	self.heroes[t.heroName].selected[t.PlayerID] = true
	for i = 0, 4 do
		if PlayerResource:IsValidPlayer(i) then
			self.heroes[t.heroName].available[i] = false
		end
	end 
	for _, heroData in pairs(self.heroes) do
		heroData.available[t.PlayerID] = false
	end
	local heroOld = PlayerResource:GetSelectedHeroName( t.PlayerID )
	local hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
	GoldNow = hero:GetGold()
	PlayerResource:ReplaceHeroWith(t.PlayerID,t.heroName,0,0)
	hero = PlayerResource:GetSelectedHeroEntity( t.PlayerID )
	hero:ModifyGoldFiltered(GoldNow, true, 0)
	CustomGameEventManager:Send_ServerToAllClients( "talant_replace_hero", { PlayerID = t.PlayerID, hero_name = heroOld} )
	talants:pickinfo(t.PlayerID,true)

	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( t.PlayerID ), "UpdateChangeHeresInfo", self.heroes )
	Shop.Change_Available[t.PlayerID] = true
	Shop.pet[t.PlayerID] = nil
	if Shop.Auto_Pet[t.PlayerID] then 
		Shop:GetPet({
			PlayerID = t.PlayerID,
			pet = {name = Shop.Auto_Pet[t.PlayerID]},
		})
	else
		Shop:GetPet({
			PlayerID = t.PlayerID,
			pet = {name = "spell_item_pet"},
		})
	end
	Shop.Change_Available[t.PlayerID] = true
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(t.PlayerID), "UpdatePetIcon", {
		can_change = Shop.Change_Available[t.PlayerID]
	} )
end

Shop:init()
ChangeHero:init()
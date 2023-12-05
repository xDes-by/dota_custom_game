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
	CustomGameEventManager:RegisterListener("UpdatePetButton",function(_, keys)
        Shop:UpdatePetButton(keys)
    end)
	CustomGameEventManager:RegisterListener("OpenTreasure",function(_, keys)
        Shop:OpenTreasure(keys)
    end)
	CustomGameEventManager:RegisterListener("SprayToggleActivate",function(_, keys)
        Shop:SprayToggleActivate(keys)
    end)
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
	CustomGameEventManager:RegisterListener("ShopRefreshMoney",function(_, keys)
        Shop:RefreshMoney(keys)
    end)
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( Shop, "OnItemPickUp"), self)
	Shop.Auto_Pet = {}
	Shop.Change_Available = {}
	Shop.sprayCategory = 4
	Shop.spray = {}
	Shop.stashItems = {"item_boss_summon","item_ticket","item_forever_ward","item_armor_aura","item_base_damage_aura","item_expiriance_aura","item_move_aura","item_attack_speed_aura","item_hp_aura"}
end

function Shop:OnGameRulesStateChange(keys)
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		Timers:CreateTimer(2, function() 
			for i = 0 , PlayerResource:GetPlayerCount()-1 do --
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

function Shop:RefreshMoney(keys)
	DataBase:Send(DataBase.link.RefreshMoney, "GET", {}, keys.PlayerID, true, function(body)
		local data = json.decode(body)
		Shop.pShop[keys.PlayerID].coins = data.coins or 0
		Shop.pShop[keys.PlayerID].mmrpoints = data.mmrpoints or 0
		CustomShop:UpdateShopInfoTable(keys.PlayerID)
    end)
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
			CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(keys.PlayerID), "UpdatePetIcon", {
				can_change = Shop.Change_Available[keys.PlayerID],
			} )
		end)
	end
end

function Shop:PlayerSetup( pid, itemsDB )
	local temp = {}
	for _, value in pairs(itemsDB) do
		if temp[value.name] == nil then
			temp[value.name] = value
		else
			temp[value.name].value = temp[value.name].value + value.value
		end
	end
	items = temp
	local sid = PlayerResource:GetSteamAccountID(pid)
	local arr = {}
	for category_key, category_value in ipairs(basicshop) do
		arr[category_key] = {}
		for product_key, product_value in pairs(category_value) do
			arr[category_key][product_key] = {}
			if type(product_value) == 'table' then

				for pKey, pValue in pairs(product_value) do
					arr[category_key][product_key][pKey] = pValue
				end
				
				if items[product_value.name] then
					arr[category_key][product_key].onStart = items[product_value.name].value
					arr[category_key][product_key].now = items[product_value.name].value
					if arr[category_key][product_key].type == "consumabl" then
						arr[category_key][product_key].status = 'consumabl'
					elseif items[product_value.name].value > 0 then
						if arr[category_key][product_key].type == "talant" or arr[category_key][product_key].type == "pet_change" then
							arr[category_key][product_key].status = 'active'
						else
							arr[category_key][product_key].status = 'taik'
						end
					else
						arr[category_key][product_key].status = 'buy'
					end
				else
					if arr[category_key][product_key].type == "hero_change" then
						arr[category_key][product_key].onStart = 1
						arr[category_key][product_key].now = 1
						if _G.SHOP[pid]["totaldonate"] >= 2000 then
							arr[category_key][product_key].status = 'shop_select'
						else
							arr[category_key][product_key].status = 'shop_lock'
						end
					else
						arr[category_key][product_key].onStart = 0
						arr[category_key][product_key].now = 0
						if arr[category_key][product_key].type == "consumabl" then
							arr[category_key][product_key].status = 'consumabl'
						else
							arr[category_key][product_key].status = 'buy'
						end
					end
				end
			elseif type(product_value) == 'string' then
				arr[category_key][product_key] = product_value
			end
		end
	end

	arr.coins = _G.SHOP[pid].coins or 0
	arr.mmrpoints = _G.SHOP[pid].mmrpoints or 0
	arr.totaldonate = _G.SHOP[pid].totaldonate or 0
	arr.feed = _G.SHOP[pid].feed or 0
	arr.ban = _G.SHOP[pid].other_60 or 0
	arr.pet_change = 0
	if items.pet_change and items.pet_change.value > 0 then
		arr.pet_change = items.pet_change.value
	end
	arr.auto_quest_trial = items.auto_quest_trial.value
	arr.golden_branch = items.golden_branch or false
	arr.talents_refresh = 0
	if items.talents_refresh then arr.talents_refresh = items.talents_refresh.value end
	arr.gems = {
		[1] = _G.SHOP[pid]["gem_1"],
		[2] = _G.SHOP[pid]["gem_2"],
		[3] = _G.SHOP[pid]["gem_3"],
		[4] = _G.SHOP[pid]["gem_4"],
		[5] = _G.SHOP[pid]["gem_5"],
	}
	arr.earned_gems = {
		[1] = 0,
		[2] = 0,
		[3] = 0,
		[4] = 0,
		[5] = 0,
	}
	Shop.pShop[pid] = arr
	Shop.pShop[pid].items = items
	CustomShop:UpdateShopInfoTable(pid)

	Shop.spray[pid] = _G.SHOP[pid].auto_spray
	Shop.Change_Available[pid] = true
	-- Timers:CreateTimer(function()
	-- 	if PlayerResource:GetPlayer(pid) == nil then
	-- 		return nil
	-- 	end
	-- 	if PlayerResource:HasSelectedHero(pid) then
	-- 		local heroName = PlayerResource:GetSelectedHeroName(pid)
	-- 		talants:pickinfo(pid,false)
	-- 		return nil
	-- 	else
	-- 	  --  print(PlayerResource:HasSelectedHero(i))
	-- 	end
	-- 	return 1.0
	-- end)
	ChangeHero:SetDonateHeroesDate(pid, temp)
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
	local currency = 'don'
	if t.currency == 1 then currency = 'rp' end
	local price = Shop.pShop[pid][i][n]['price'][currency]
	local give = Shop.pShop[pid][i][n]["give"] or 1
	local name = Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['name']
	local amount = t.amountBuy or 1
	if t.currency == 1 and Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] and tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] * t.amountBuy) > tonumber(Shop.pShop[pid].mmrpoints) then
		return
	elseif t.currency == 0 and Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don'] and tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don']*t.amountBuy) > tonumber(Shop.pShop[pid].coins) then
		return
	end
	if Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]["type"] ~= "gem" then
		Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['now'] = tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)].now) + t.amountBuy
		Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['onStart'] = tonumber(Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['onStart']) + t.amountBuy
	end
	if t.currency == 1 then
		Shop.pShop[pid].mmrpoints = Shop.pShop[pid].mmrpoints - Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['rp'] * t.amountBuy
	else
		Shop.pShop[pid].coins = Shop.pShop[pid].coins - Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['price']['don'] * t.amountBuy
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( pid ), "UpdateStore", {
		{categoryKey = t.i, productKey = t.n, itemname = Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['itemname'], count = Shop.pShop[pid][tonumber(t.i)][tonumber(t.n)]['now']},
	})
	CustomShop:UpdateShopInfoTable(pid)

	if shop_type == "talant" then
		if Shop.pShop[pid][i][n]["hero"] == PlayerResource:GetSelectedHeroName(pid) then
			Talents:ActivateSecondBranch(pid)
		end
	end
	if shop_type == "gem" then
		local gem_type = Shop.pShop[pid][i][n]["gem_type"]
		CustomShop:AddGems(pid, { 
			[gem_type] = give * amount 
		}, false)
		local send = {
			gem_type = gem_type,
			give = give,
			hero_name = PlayerResource:GetSelectedHeroName(pid),
			amount = amount,
		}
		if currency == 'don' then
			send.don = price
		else
			send.rp = price
		end
		DataBase:Send(DataBase.link.BuyGems, "GET", send, pid, not DataBase:IsCheatMode(), nil)
	elseif name == "hot_offer" then
		local send = {
			items = Shop:GiveOutAllHotOfferItems(pid, Shop.pShop[pid][i][n]),
		}
		if currency == 'don' then
			send.don = price
		else
			send.rp = price
		end
		DataBase:Send(DataBase.link.BuyHotOffer, "GET", send, pid, not DataBase:IsCheatMode(), nil)
	else
		local send = {
			name = name,
			give = give,
			hero_name = PlayerResource:GetSelectedHeroName(pid),
			amount = amount,
		}
		if currency == 'don' then
			send.don = price
		else
			send.rp = price
		end
		DataBase:Send(DataBase.link.BuyShop, "GET", send, pid, not DataBase:IsCheatMode(), nil)
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
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(PlayerID), "UpdateStore", updateCount)
	return DBItemsName
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
function Shop:AddItemByName(pid, name, amount)
	for categoryKey, categoryValue in pairs(Shop.pShop[pid]) do
		if type(categoryValue) == 'table' then
			for productKey, productValue in ipairs(categoryValue) do
				if type(productValue) == 'table' then
					if productValue.name == name then
						productValue.now = productValue.now + amount
						productValue.onStart = productValue.onStart + amount
						CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( pid ), "UpdateStore", {
							{categoryKey = categoryKey, productKey = productKey, itemname = productValue.itemname, count = productValue.now},
						})
						return
					end
				end
			end
		end
	end
end

function Shop:FindItemByName(pid, name)
	for categoryKey, categoryValue in pairs(Shop.pShop[pid]) do
		if type(categoryValue) == 'table' then
			for productKey, productValue in ipairs(categoryValue) do
				if type(productValue) == 'table' then
					if productValue.name == name then
						local item = productValue
						item.key1 = categoryKey
						item.key2 = productKey
						return item
					end
				end
			end
		end
	end
end
function Shop:FindTreasureRewardList(pid, name)
	local rewards = {}
	for categoryKey, categoryValue in pairs(Shop.pShop[pid]) do
		if type(categoryValue) == 'table' then
			for productKey, productValue in ipairs(categoryValue) do
				if type(productValue) == 'table' then
					if productValue.source and productValue.source.treasury and productValue.source.treasury == name then
						local item = productValue
						item.key1 = categoryKey
						item.key2 = productKey
						table.insert(rewards, item)
					end
				end
			end
		end
	end
	return rewards
end
function Shop:OpenTreasure(t)
	local pid = t.PlayerID
	local name = t.treasureName
	local treasure = Shop:FindItemByName(pid, name)
	local compensation = treasure.compensation
	local rewards = Shop:FindTreasureRewardList(pid, name)
	if treasure.now < 1 then return end
	Shop.pShop[pid][treasure.key1][treasure.key2].now = Shop.pShop[pid][treasure.key1][treasure.key2].now -1
	Shop.pShop[pid][treasure.key1][treasure.key2].onStart = Shop.pShop[pid][treasure.key1][treasure.key2].onStart -1
	local itemPrize = rewards[RandomInt(1, #rewards)]
	while itemPrize.source.main_prize do
		itemPrize = rewards[RandomInt(1, #rewards)]
	end
	for reward_name, reward_percentage in pairs(treasure.treasure_main_reward) do
		if RandomFloat(0, 100) <= reward_percentage then
			itemPrize = Shop:FindItemByName(pid, reward_name)
		end
	end
	local data = {
		itemPool = rewards,
		itemPrize = itemPrize,
		glory = 0,
		skipAnimation = false,
	}
	local send = {}
	send.treasure = treasure.name
	if itemPrize.name == 'rp_reward_100' then
		send.rp = CustomShop:AddRP(pid, 100 / MultiplierManager:GetCurrencyRpMultiplier(pid), false, false)
	elseif itemPrize.name == 'gems_reward_50' then
		send.don = CustomShop:AddCoins(pid, 50, false, false)
	elseif itemPrize.name == 'gems_reward_500' then
		send.don = CustomShop:AddCoins(pid, 500, false, false)
	elseif itemPrize.name == 'rp_reward_150' then
		send.rp = CustomShop:AddRP(pid, 150 / MultiplierManager:GetCurrencyRpMultiplier(pid), false, false)
	elseif itemPrize.name == 'gems_reward_75' then
		send.don = CustomShop:AddCoins(pid, 75, false, false)
	elseif itemPrize.name == 'gems_reward_750' then
		send.don = CustomShop:AddCoins(pid, 750, false, false)
	elseif itemPrize.name == 'roshan_reward_1' then
		send.name = 'rosh_1'
	elseif itemPrize.name == 'roshan_reward_2' then
		send.name = 'rosh_2'
	elseif itemPrize.counter and itemPrize.counter == true and itemPrize.onStart > 0 then
		itemPrize.now = itemPrize.now + 1
		itemPrize.onStart = itemPrize.onStart + 1
		send.name = itemPrize.name
	elseif itemPrize.onStart == 0 then
		itemPrize.now = 1
		itemPrize.onStart = 1
		send.name = itemPrize.name
	elseif itemPrize.onStart > 0 then
		send.rp = CustomShop:AddRP(pid, compensation / MultiplierManager:GetCurrencyRpMultiplier(pid), false, false)
		data.glory = compensation
	end
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( pid ), "ShowWheel", data )
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "UpdateStore", {
		{categoryKey = treasure.key1, productKey = treasure.key2, itemname = "", count = treasure.now},
		{categoryKey = itemPrize.key1, productKey = itemPrize.key2, itemname = "", count = itemPrize.now},
	})
	DataBase:Send(DataBase.link.TreasureReward, "GET", send, pid, not DataBase:IsCheatMode(), function(body)
		if table.has_value({'rosh_1', 'rosh_2'}, send.name) then
			Pets.player[pid].pets[send.name] = json.decode(body)
        	CustomNetTables:SetTableValue('Pets', tostring(pid), Pets.player[pid])
		end
	end)
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

function ChangeHero:SetDonateHeroesDate(pid, items)
	for heroName, heroData in pairs(self.heroes) do
		heroData.trialCount[pid] = items[heroData.trialName].value
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
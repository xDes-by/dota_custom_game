function HeroBuilder:GetHeroSelection(data)
	local player_id = data.PlayerID
	if not player_id then return end

	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		self:ShowRandomHeroSelection(player_id)
	end
end


function HeroBuilder:ShowRandomHeroSelection(player_id)
	if not PLAYER_PICK_SEEN_HEROES[player_id] then PLAYER_PICK_SEEN_HEROES[player_id] = {} end
	
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if self:CheckHeroMinState(hero, HERO_STATE_AWAITING_PRECACHE) then return end
	
	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end
	
	local heroes = HeroBuilder.hero_tables[player_id]
	local hero_client_stats = HeroBuilder:GetStatsFromHeroList(heroes)
	for _, hero_name in pairs(heroes) do
		if not table.contains(PLAYER_PICK_SEEN_HEROES[player_id], hero_name) then
			table.insert(PLAYER_PICK_SEEN_HEROES[player_id], hero_name)
		end
	end
	
	CustomGameEventManager:Send_ServerToPlayer(player,"ShowRandomHeroSelection", {
		heroes = heroes, replace = true, heroStats = hero_client_stats
	})
end

-- full_init is false when initializing the starter hero (happens immediately after hero pick, before actual hero finishes precaching)
function HeroBuilder:InitPlayerHero(hero, random_pick_gift, full_init)
	if not hero or hero:IsNull() then return end

	-- If the hero is in default state, they have already been initialized
	if HeroBuilder:CheckHeroMinState(hero, HERO_STATE_DEFAULT) then return end

	hero:SetCustomDeathXP(0)
	hero.original_attack_capability = hero:GetAttackCapability()

	-- Universal hero modifiers
	hero:AddNewModifier(hero, nil, "modifier_bat_handler", {})
	hero:AddNewModifier(hero, nil, "modifier_channel_listener", {})
	hero:AddNewModifier(hero, nil, "modifier_rerolls_remaining", {}):SetStackCount(2)
	hero:AddNewModifier(hero, nil, "modifier_spell_amplify_controller", nil)
	hero:AddNewModifier(hero, nil, "modifier_casttime_handler", {})

	-- Fountain modifiers since this is the first spawn
	if not Enfos:IsEnfosMode() and not GameMode:IsTeamFighting(hero:GetTeam()) then 
		hero:AddNewModifier(hero, nil, "modifier_hero_refreshing", {}) 
	end
	hero:AddNewModifier(hero, nil, "modifier_hero_fighting_pve", {})

	-- Remove the default TP
	local tp_scroll = hero:FindItemInInventory('item_tpscroll')
	if tp_scroll then tp_scroll:RemoveSelf() end

	-- Stop here if this is a temporary (dummy, starter) hero
	if (not full_init) then return end

	-- Add starting items
	if Enfos:IsEnfosMode() then
		hero:AddItemByName("item_flask")
		hero:AddItemByName("item_flask")
		hero:AddItemByName("item_clarity")
		hero:AddItemByName("item_clarity")
	elseif (not TestMode:IsTestMode()) then
		hero:AddItemByName("item_faerie_fire")
		hero:AddItemByName("item_faerie_fire")
	end

	hero:AddItemByName("item_ward_sentry")

	-- Gift for voluntarily randoming
	if random_pick_gift then
		local random_gift = hero:AddItemByName("item_random_gift")
		if random_gift and random_gift.SetPurchaseTime then random_gift:SetPurchaseTime(0) end
	end

	-- Map-dependant modifiers
	if Enfos:IsEnfosMode() then
		-- Enfos high ground speed
		hero:AddNewModifier(hero, nil, "modifier_enfos_high_ground", {})
	else
		-- Aegis stacks
		hero:AddNewModifier(hero, nil, "modifier_aegis", {}):SetStackCount(HeroBuilder.initial_aegis_count)
	end

	-- Talent correction modifiers, if needed
	local hero_name = hero:GetUnitName()
	if HeroBuilder.talent_enablers[hero_name] then
		hero:AddNewModifier(hero, nil, HeroBuilder.talent_enablers[hero_name], {})
	end

	-- Give Invoker special_bonus_attributes since he is the only hero that doesn't have it
	if hero:GetUnitName() == "npc_dota_hero_invoker" then
		hero:AddAbility("special_bonus_attributes")
	end

	-- Remove hero's standard abilities
	if not PlayerResource:IsFakeClient(hero:GetPlayerOwnerID()) then
		for i = 0, 23 do
			local ability = hero:GetAbilityByIndex(i)
			if ability then
				local ability_name = ability:GetAbilityName()
				if not string.find(ability_name, "special_bonus") and not table.contains(STARTING_ABILITIES, ability_name) then
					hero:RemoveAbility(ability_name)
				end
			end
		end
	else
		hero.state = HERO_STATE_DEFAULT
		hero.ability_count = hero.ability_count or 0
	end
	hero.abilities = hero.abilities or {}

	-- Placeholders for ability system
	for i = 0, 5 do
		local new_ability = hero:AddAbility("empty_"..i)
		new_ability.placeholder = i + 1
	end

	-- Init cosmetic abilities
	Cosmetics:InitCosmeticForUnit(hero)
end


function HeroBuilder:_OnHeroPrecacheFinished(player_id, hero_name, pick_is_random)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if hero and hero.state and hero.state >= HERO_STATE_DEFAULT then 
		print("_OnHeroPrecacheFinished wrong state", hero.state)
		return 
	end

	-- Waiting for player connection or current round ending (possible in Duos if player disconnected before hero pick)
	-- In Enfos player cant pick hero mid duel
	local team = PlayerResource:GetTeam(player_id)
	local player = PlayerResource:GetPlayer(player_id)
	if not player or RoundManager:IsRoundStarted() or EnfosPVP:IsPlayerDueling(team, player_id) then
		-- If player abandoned dont bother wait him
		if PlayerResource:GetConnectionState(player_id) ~= DOTA_CONNECTION_STATE_ABANDONED then
			Timers:CreateTimer(2, function()
				HeroBuilder:_OnHeroPrecacheFinished(player_id, hero_name, pick_is_random)
			end)
		end
		return
	end
	
	local old_hero = hero
	local old_hero_items = {}
	local old_gold = 600

	if old_hero and not old_hero:IsNull() then
		local player_id = old_hero:GetPlayerID()
		for i = 0, 16 do
			local item = old_hero:GetItemInSlot(i);
			if item and not item:IsNull() and item:GetPurchaser() and item:GetPurchaser():GetPlayerID() == player_id then
				local item_data = {}
				item_data.item_name = item:GetName()
				item_data.charges_count = item:GetCurrentCharges()
				table.insert(old_hero_items, item_data)
			end
		end
		old_gold = old_hero:GetGold()
		hero = PlayerResource:ReplaceHeroWith(player_id, hero_name, old_gold, 0)
	elseif not old_hero then
		hero = CreateHeroForPlayer(hero_name, player)
		player:SetSelectedHero(hero_name)
		player:SetAssignedHeroEntity(hero)
		hero:SetControllableByPlayer(player_id, true)
		hero:RemoveModifierByName("modifier_auto_attack")
		
		if Enfos:IsEnfosMode() then
			-- To move hero and player's camera to spawn position
			hero:RespawnHero(false, false)
		else
			RoundManager:MoveHeroToFountain(player_id, PLAYER_OPTIONS_CREEP_CAMERA_ENABLED[player_id], 1)
		end
	end
	
	if (not hero) or hero:IsNull() then
		hero = PlayerResource:GetSelectedHeroEntity(player_id)
		Timers:CreateTimer(2, function()
			HeroBuilder:_OnHeroPrecacheFinished(player_id, hero_name, pick_is_random)
		end)
		return
	end

	HeroBuilder:InitPlayerHero(hero, pick_is_random, true)
	hero.state = HERO_STATE_DEFAULT

	for _, item_data in ipairs(old_hero_items) do
		local item = CreateItem(item_data.item_name, hero, hero)
		item:SetCurrentCharges(item_data.charges_count)
		hero:AddItem(item)
	end

	--Start skill selection
	hero.ability_count = hero.ability_count or 0
	hero.abilities = hero.abilities or {}

	PENDING_HERO_PRECACHE[player_id] = nil

	--In case if hero picked when player reconnected after first round(in duos)
	if RoundManager:GetCurrentRoundNumber() >= INNATE_SELECTION_ROUND then
		HeroBuilder:ShowInnateAbilitySelection(player_id)
	else
		HeroBuilder:ShowRandomAbilitySelection(player_id)
	end

	-- DESTROY the old hero
	Timers:CreateTimer(0.5, function()
		if old_hero and not old_hero:IsNull() then
			old_hero:ForceKill(false)
			UTIL_Remove(old_hero)
		end
		UniquePortraits:UpdatePortraitsDataFromPlayer(player_id)
	end)

	Timers:CreateTimer(3, function()
		if not PlayerResource:IsValidPlayer(player_id) then return end
		
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if not hero then return end

		local aegis_modifier = hero:FindModifierByName("modifier_aegis")
		if aegis_modifier then
			CustomGameEventManager:Send_ServerToAllClients("player_show_aegis_init", { 
				playerId = player_id, 
				aegisCount = (aegis_modifier:GetStackCount())
			})
		else
			CustomGameEventManager:Send_ServerToAllClients("player_show_aegis_init", { 
				playerId = player_id, 
				aegisCount = 0
			})
		end

		local curse_modifier = hero:FindModifierByName("modifier_loser_curse")
		if curse_modifier then
			CustomGameEventManager:Send_ServerToAllClients("player_debuff_loser", { 
				playerId = player_id, 
				loserCount = curse_modifier:GetStackCount()
			})
		end

		_G.tPlayersChatWheelReady[player_id] = true
		local player = PlayerResource:GetPlayer(player_id)
		CustomGameEventManager:Send_ServerToPlayer(player, "ChatWheelCreated", {} )

		CustomGameEventManager:Send_ServerToAllClients("UpdateHistoryPlayerHero", {
			playerId = player_id
		})

		if WebApi.season_reset_info and WebApi.season_reset_info[player_id] then
			CustomGameEventManager:Send_ServerToPlayer(player, "leaderboard:show_season_results", WebApi.season_reset_info[player_id])
		end
	end)

	EventDriver:Dispatch("HeroBuilder:hero_init_finished", {
		hero = hero,
	})
end


function HeroBuilder:PreSelectHero(event)
	local player_id = event.PlayerID
	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	CustomGameEventManager:Send_ServerToTeam(PlayerResource:GetTeam(player_id), "TeammateSelectHero", {
		playerId = player_id,
		heroName = event.heroName,
		state = 0,
	})
end


function HeroBuilder:HeroSelected(keys, is_random_pick)
	local hero_name 	= keys.hero_name
	local player_id  	= keys.PlayerID
	local player 	 	= PlayerResource:GetPlayer(player_id)
	local hero 	 		= PlayerResource:GetSelectedHeroEntity(player_id)

	if not player then return end
	if hero and hero.state and hero.state >= HERO_STATE_AWAITING_PRECACHE then
		return 
	end

	if PENDING_HERO_PRECACHE[player_id] then return end
	
	if not hero_name or not HeroBuilder.hero_tables[player_id] then
		return
	end
	
	if not table.contains(HeroBuilder.hero_tables[player_id], hero_name) and not is_random_pick then
		hero_name = table.random(HeroBuilder.hero_tables[player_id])
	end

	PENDING_HERO_PRECACHE[player_id] = hero_name

	CustomGameEventManager:Send_ServerToPlayer(player,"HideHeroPrecacheCountDown",{})

	if hero and (not hero:IsNull()) then hero.state = HERO_STATE_AWAITING_PRECACHE end

	GameMode:ActivateTeam(PlayerResource:GetTeam(player_id))
	GameMode:SetPlayerState(player_id, PLAYER_STATE_ON_BASE)

	CustomGameEventManager:Send_ServerToTeam(PlayerResource:GetTeam(player_id), "TeammateSelectHero", {
		playerId = player_id,
		heroName = hero_name,
		state = 1,
	})

	if Enfos:IsEnfosMode() then
		EnfosTreasury:RegisterTreasuryTooltipsForPlayer(player_id)
	end

	PrecacheUnitByNameAsync(
		hero_name,
		function() HeroBuilder:_OnHeroPrecacheFinished(player_id, hero_name, is_random_pick) end,
		player_id
	)
end


function HeroBuilder:RandomHeroForPlayer(player)
	if not player then return end

	local player_id = player:GetPlayerID()
	local new_hero = table.random(HeroBuilder.hero_tables[player_id])

	HeroBuilder:HeroSelected({
		PlayerID = player_id, 
		hero_name = new_hero,
	})

	CustomGameEventManager:Send_ServerToPlayer(player,"HideHeroSelection",{particle = true})
end


function HeroBuilder:SelectRandomHero(data)
	local player_id = data.PlayerID
	if not player_id then return end
	
	local randomStatKey = RandomInt(1,3);
	local keys = {
		[1] = "str",
		[2] = "agi",
		[3] = "int",
	}
	local baseTable = HeroBuilder.tCommonHerosTable[keys[randomStatKey]]
	local newHeroName = table.random(baseTable)
	local oldTableLink = HeroBuilder.hero_tables[player_id] or {}
	
	table.remove_item(baseTable, newHeroName)
	table.insert(baseTable, oldTableLink[randomStatKey])
	oldTableLink[randomStatKey] = newHeroName

	HeroBuilder:HeroSelected({
		PlayerID = player_id, 
		hero_name = newHeroName,
	}, true)

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	CustomGameEventManager:Send_ServerToPlayer(player,"HideHeroSelection",{particle = true})
end


function HeroBuilder:ForceFinishHeroBuild(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if hero and not hero:IsNull() and hero.state and hero.state >= HERO_STATE_AWAITING_PRECACHE then return end

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	if not PlayerResource:IsFakeClient(player_id) and not PENDING_HERO_PRECACHE[player_id] then
		HeroBuilder:RandomHeroForPlayer(player)
	end

	if PlayerResource:GetConnectionState(player_id) ~= DOTA_CONNECTION_STATE_NOT_YET_CONNECTED then
		CustomGameEventManager:Send_ServerToPlayer(player, "HideHeroSelection", {
			particle = true
		})
	end
end

local MAX_REROLL_HEROES = 2
PLAYERS_REROLLS = {}


function HeroBuilder:CheckRerollsRemaining(event)
	local player_id = event.PlayerID
	if not player_id then return end

	if not PLAYERS_REROLLS[player_id] then
		PLAYERS_REROLLS[player_id] = MAX_REROLL_HEROES
	end

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	CustomGameEventManager:Send_ServerToPlayer(player, "ReplaceHeroCheckCountSetToClient", {
		count = PLAYERS_REROLLS[player_id]
	})
end


function HeroBuilder:RerollHeroChoices(event)
	event.cardNumber = tonumber(event.cardNumber)
	local player_id = event.PlayerID
	if not player_id then return end

	if not PLAYERS_REROLLS[player_id] or  PLAYERS_REROLLS[player_id] <= 0 then return end

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	local keys = {
		[1] = "str",
		[2] = "agi",
		[3] = "int",
	}
	local hero_client_stats = {}

	PLAYERS_REROLLS[player_id] = PLAYERS_REROLLS[player_id] - 1

	local current_heroes = {}
	for _, player_id in pairs(GameMode.all_players) do
		if HeroBuilder.hero_tables[player_id] then
			for _, hero_name in pairs(HeroBuilder.hero_tables[player_id]) do
				current_heroes[hero_name] = true
			end
		end
	end

	local focus_hero_name
	local base_hero_table = HeroBuilder.tCommonHerosTable[keys[event.cardNumber]]
	local base_heroes_pool = {}

	local get_heroes_pool = function(remove_seen_heroes)
		for _, hero_name in pairs(base_hero_table) do
			table.insert(base_heroes_pool, hero_name)
		end
		if remove_seen_heroes then
			for _, hero_name in pairs (PLAYER_PICK_SEEN_HEROES[player_id]) do
				table.remove_item(base_heroes_pool, hero_name)
			end
		end
		for hero_name, _ in pairs (current_heroes) do
			table.remove_item(base_heroes_pool, hero_name)
		end
	end

	get_heroes_pool(true)
	if #base_heroes_pool == 0 then
		get_heroes_pool(false)
	end
	
	if not HeroBuilder.hero_tables[player_id] then return end

	focus_hero_name = table.random(base_heroes_pool)
	table.insert(PLAYER_PICK_SEEN_HEROES[player_id], focus_hero_name)
	table.remove_item(base_hero_table, focus_hero_name)
	table.insert(base_hero_table, HeroBuilder.hero_tables[player_id][event.cardNumber])
	HeroBuilder.hero_tables[player_id][event.cardNumber] = focus_hero_name
	hero_client_stats = HeroBuilder:GetStatsFromHeroList(HeroBuilder.hero_tables[player_id])

	EmitSoundOnClient("custom_reroll_hero", player)
	
	CustomGameEventManager:Send_ServerToPlayer(player,"RerollHeroClient", {
		hero = focus_hero_name, 
		heroStats = hero_client_stats[focus_hero_name], 
		cardNumber = event.cardNumber
	})
end


function HeroBuilder:AbilityRerolled(keys)
	local player_id = keys.PlayerID
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return end

	local player = PlayerResource:GetPlayer(player_id)
	if not player or player:IsNull() then return end

	local selecting_ability = HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_ABILITY)
	local selecting_innate = HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_INNATE)
	local selecting_summon_ability = HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_SUMMON_ABILITY)

	if not (selecting_ability or selecting_innate or selecting_summon_ability) then return end

	local rerolls_modifier = hero:FindModifierByName("modifier_rerolls_remaining")

	if not rerolls_modifier or rerolls_modifier:IsNull() then
		CustomGameEventManager:Send_ServerToPlayer(player, "no_rerolls_left", {})
		CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", {
			message = "#no_rerolls_left" 
		})
	end

	HeroBuilder.player_rerolls[player_id] = HeroBuilder.player_rerolls[player_id] + 1

	local rerolls = rerolls_modifier:GetStackCount()

	if rerolls <= 1 then
		CustomGameEventManager:Send_ServerToPlayer(player, "no_rerolls_left", {})
		hero:RemoveModifierByName("modifier_rerolls_remaining")
	else
		rerolls_modifier:SetStackCount(rerolls - 1)
	end

	if selecting_innate then
		HeroBuilder:ShowInnateAbilitySelection(player_id, false, true)
	elseif selecting_summon_ability then
		HeroBuilder:ShowSummonAbilitySelection(player_id, true)
	else
		HeroBuilder:RerollAbilitySelection(player_id)
	end
end


function HeroBuilder:RerollAbilitySelection(player_id)
	local player = PlayerResource:GetPlayer(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not player or not hero then return end

	hero.state = HERO_STATE_SELECTING_ABILITY
	CustomGameEventManager:Send_ServerToPlayer(player, "ability_selection:show", {
		data_list = HeroBuilder:GetNewAbilitySelection(hero),
		ability_number = hero.ability_count + 1,
		rerolled = true
	})
end


function HeroBuilder:GetMaxRerolls(event)
	local steam_id = Battlepass:GetSteamId(event.PlayerID)
	if not BP_Inventory.player_items[steam_id] and not GameMode:IsTournamentMode() then
		Timers:CreateTimer(1, function()
			HeroBuilder:GetMaxRerolls(event)
			return
		end)
		return
	end
	local rerolls = 0
	if GameMode:IsTournamentMode() or BP_Inventory:IsItemOwned("ability_reroll_1", steam_id) then rerolls = rerolls + 1 end
	if GameMode:IsTournamentMode() or BP_Inventory:IsItemOwned("ability_reroll_2", steam_id) then rerolls = rerolls + 1 end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(event.PlayerID), "ability_selection:update_max_rerolls", {
		maxRerolls = rerolls,
		curRerolls = HeroBuilder.player_rerolls[event.PlayerID],
	})
end

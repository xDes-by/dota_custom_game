--Hero building logic
if HeroBuilder == nil then HeroBuilder = class({}) end

require("game/hero_builder/declarations")
require("game/hero_builder/reorder")
require("game/hero_builder/swap_abilities")
require("game/hero_builder/scepter")
require("game/hero_builder/shard")
require("game/hero_builder/attack_capability")
require("game/hero_builder/hero")
require("game/hero_builder/abilities")
require("game/hero_builder/innates")
require("game/hero_builder/rerolls")
require("game/hero_builder/attribute_bonus_reset")
require("heroes/hero_omniknight/purification_fix")
require("heroes/hero_primal_beast/uproar_creeps")
LinkLuaModifier("modifier_retraining_count", "items/item_relearn_book_lua", LUA_MODIFIER_MOTION_NONE)

function HeroBuilder:Init()
	HeroBuilder.hero_stats = LoadKeyValues("scripts/npc/npc_heroes.txt")

	-- hero selection
	RegisterCustomEventListener("hero_selection:get_selection", function(event) self:GetHeroSelection(event) end)
	RegisterCustomEventListener("hero_selection:get_rerolls", 	function(event) self:CheckRerollsRemaining(event) end)
	RegisterCustomEventListener("hero_selection:rerolled", 		function(event) self:RerollHeroChoices(event) end)
	RegisterCustomEventListener("hero_selection:randomed", 		function(event) self:SelectRandomHero(event) end)
	RegisterCustomEventListener("hero_selection:preselected", 	function(event) self:PreSelectHero(event) end)
	RegisterCustomEventListener("hero_selection:selected", 		function(event) self:HeroSelected(event) end)

	-- abilities / innates selection
	RegisterCustomEventListener("ability_selection:selected", 	function(event) self:AbilitySelectionEvent(event, ABILITY_SELECTION_SELECTED) end)
	RegisterCustomEventListener("ability_selection:cancelled", 	function(event) self:AbilitySelectionEvent(event, ABILITY_SELECTION_CANCELLED) end)
	RegisterCustomEventListener("ability_selection:rerolled", 	function(event) self:AbilityRerolled(event) end)
	RegisterCustomEventListener("ability_selection:get_rerolls",function(event) self:GetMaxRerolls(event) end)
	RegisterCustomEventListener("ability_selection:later",		function(event) self:AbilitySelectionPostponed(event) end)
	RegisterCustomEventListener("ability_selection:request_selection", 	function(event) self:AbilitySelectionRequested(event) end)

	RegisterCustomEventListener("relearn_book:selected", 		function(event) self:AbilitySelectionEvent(event, ABILITY_SELECTION_RELEARN_SELECTED) end)
	RegisterCustomEventListener("relearn_book:cancelled", 		function(event) self:AbilitySelectionEvent(event, ABILITY_SELECTION_RELEARN_CANCELLED) end)

	RegisterCustomEventListener("summon_book:selected", 		function(event) self:AbilitySelectionEvent(event, ABILITY_SELECTION_SUMMON_SELECTED) end)
	RegisterCustomEventListener("summon_book:cancelled", 		function(event) self:AbilitySelectionEvent(event, ABILITY_SELECTION_SUMMON_CANCELLED) end)

	RegisterCustomEventListener("innates:later", 				function(event) HeroBuilder:InnatePostponed(event) end)
	RegisterCustomEventListener("innates:request_selection", 	function(event) HeroBuilder:InnateSelectionRequested(event) end)

	EventDriver:Listen("Round:round_preparation_started", HeroBuilder.UpdateMaxAbilitiesLimit, HeroBuilder)
	EventDriver:Listen("Round:round_started", HeroBuilder.IndexAllHeroesPassives, HeroBuilder)

	HeroBuilder.innate_choices = {}

	if Enfos:IsEnfosMode() then
		HeroBuilder.innate_ability_list = LoadKeyValues("scripts/kv/5v5_innates.kv")
	else
		HeroBuilder.innate_ability_list = LoadKeyValues("scripts/kv/innate_abilities.kv")
	end

	--Processing skills list
	HeroBuilder.hero_abilities = {}
	--Map of heroes corresponding to skills
	HeroBuilder.ability_hero_map = {}
	--Link Skill Map Give your child skills when learning the main skills
	HeroBuilder.linked_abilities = {}

	--Link Skill Initial Level
	HeroBuilder.linked_abilities_level = {}

	--List of secondary skills
	HeroBuilder.additional_abilities = {}
	
	--List of aghanim shard/scepter additional abilties from dota's config
	HeroBuilder.agh_and_shard_abilities = {}

	HeroBuilder.round_deaths = {}

	local all_abilities = {}
	local used_abilities = {}

	local abilities_kv = LoadKeyValues("scripts/npc/npc_abilities_list.txt")
	local creep_abilities_kv = LoadKeyValues("scripts/kv/ability_types/creep.kv")
	local disabled_abilities_kv = LoadKeyValues("scripts/kv/ability_types/disabled.kv")
	local dota_abilities = KeyValues.AbilityKV
	
	if Enfos:IsEnfosMode() then
		for ability_name, value in pairs(LoadKeyValues("scripts/kv/ability_types/disabled_enfos.kv")) do
			if value == 0 then
				disabled_abilities_kv[ability_name] = nil
			else
				disabled_abilities_kv[ability_name] = true
			end
		end
	end

	HeroBuilder.disabled_abilities = disabled_abilities_kv
	HeroBuilder.hero_disabled_abilities = {}
	
	for hero_name, data in pairs(abilities_kv) do
		local hero_full_name = "npc_dota_hero_" .. hero_name
		HeroBuilder.hero_abilities[hero_full_name] = {}
		HeroBuilder.hero_disabled_abilities[hero_full_name] = {}
		if data and type(data) == "table" then 
			for key, value in pairs(data) do
				--Skill definition
				if type(value) ~= "table" then
					if not disabled_abilities_kv[value] and not used_abilities[value] then
						used_abilities[value] = 1
						table.insert(all_abilities, value)
						table.insert(HeroBuilder.hero_abilities[hero_full_name], value)
						HeroBuilder.ability_hero_map[value] = hero_name
					else
						table.insert(HeroBuilder.hero_disabled_abilities[hero_full_name], value)
						print(value, "was disabled by disabled_abilities.kv")
					end
					--Bonus Skills
				else
					HeroBuilder.linked_abilities[key]={}
					for k,v in pairs(value) do
						--Add bonus skills to the queue
						table.insert(HeroBuilder.linked_abilities[key], k)                        
						table.insert(HeroBuilder.additional_abilities, k)
						HeroBuilder.linked_abilities_level[k] = tonumber(v)
					end
				end
			end
		end
	end

	for ability_name, ability_info in pairs(dota_abilities) do
		if type(ability_info) == 'table' then
			local agh_filter = function(c_name)
				local add_ability = ability_info[c_name]
				if add_ability and add_ability ~= "" then
					table.insert(HeroBuilder.agh_and_shard_abilities, ability_name)
				end
			end
			agh_filter("IsGrantedByShard");
			agh_filter("IsGrantedByScepter");
		end
	end
	--Push secondary skills to the foreground
	for _, ability_name in pairs(HeroBuilder.additional_abilities) do
		CustomNetTables:SetTableValue("additional_abilities", ability_name, {abilityName = ability_name})
	end

	for ability_name, _ in pairs(UNREMOVABLE_ABILITIES_KV) do
		CustomNetTables:SetTableValue("additional_abilities", ability_name, {abilityName = ability_name})
	end

	for _, ability_name in pairs(HeroBuilder.innate_ability_list) do
		CustomNetTables:SetTableValue("additional_abilities", ability_name, {abilityName = ability_name})
	end

	for ability_name, abilities in pairs(HeroBuilder.linked_abilities) do
		CustomNetTables:SetTableValue("linked_abilities", ability_name, abilities)
	end
	
	for _, ability_name in pairs(HeroBuilder.agh_and_shard_abilities) do
		CustomNetTables:SetTableValue("agh_shard_scepter_abilities", ability_name, {abilityName = ability_name})
	end
	
	CustomNetTables:SetTableValue("game", "disabled_abilities", HeroBuilder.hero_disabled_abilities)

	for i=0, 25 do
		HeroBuilder.player_rerolls[i] = 0
	end

	HeroBuilder.all_abilities = all_abilities

	-- Add creep abilities to the precache queue
	for _, creep_ability in pairs(creep_abilities_kv) do
		PrecacheItemByNameAsync(creep_ability, function() end)

		local hero_owner_name = HeroBuilder.ability_hero_map[creep_ability]

		if hero_owner_name and not table.contains(PENDING_ABILITY_SOUND_PRECACHE, hero_owner_name) and not PRECACHED_ABILITY_SOUNDS[hero_owner_name] then
			table.insert(PENDING_ABILITY_SOUND_PRECACHE, HeroBuilder.ability_hero_map[creep_ability])  
		end
	end

  	self:ExcludeAbilitiesByMap()
end


function HeroBuilder:GetStatsFromHeroList(hero_list)
	local result = {}
	for _, hero_name in pairs(hero_list) do
		result[hero_name] = {}
		for stat_name, _ in pairs(HeroBuilder.client_stats) do
			local stat_value = 0
			if HeroBuilder.stats_keys[stat_name] then
				stat_value = HeroBuilder.hero_stats[hero_name][HeroBuilder.stats_keys[stat_name].stat] * HeroBuilder.stats_keys[stat_name].value
			end
			if HeroBuilder.hero_stats[hero_name][stat_name] then
				stat_value = stat_value + HeroBuilder.hero_stats[hero_name][stat_name]
			end
			if (stat_name == "AttackDamageMin") or (stat_name == "AttackDamageMax") then
				stat_value = stat_value + HeroBuilder.hero_stats[hero_name][HeroBuilder.main_stats[HeroBuilder.hero_stats[hero_name]["AttributePrimary"]]]
			end
			if type(HeroBuilder.client_stats[stat_name]) == "table" and HeroBuilder.client_stats[stat_name].base then 
				stat_value = stat_value + HeroBuilder.client_stats[stat_name].base 
			end
			result[hero_name][stat_name] = stat_value
		end
	end
	return result
end


function HeroBuilder:UpdateMaxAbilitiesLimit(event)
	if TestMode:IsTestMode() or GAME_OPTION_BENCHMARK_MODE then return end

	if RoundManager.max_ability_increase_rounds[event.round_number] or event.round_number == 1 then

		if RoundManager.max_ability_increase_rounds[event.round_number] then
			RoundManager.base_max_abilities_limit = RoundManager.base_max_abilities_limit + 1
			RoundManager:GetCurrentRound():ExtendPreparationTime(RoundManager.extra_ability_selection_round_preparation_time)
		end

		for _, player_id in pairs(GameMode.all_players) do
			if GameMode:HasPlayerSelectedHero(player_id) and (not PlayerResource:IsFakeClient(player_id)) then
				HeroBuilder:ShowRandomAbilitySelection(player_id)
			end
		end
	end

	if event.round_number == INNATE_SELECTION_ROUND then
		for _, player_id in pairs(GameMode.all_players) do
			if GameMode:HasPlayerSelectedHero(player_id) and (not PlayerResource:IsFakeClient(player_id)) then
				HeroBuilder:ShowInnateAbilitySelection(player_id)
			end
		end
	end
end

-- Creates a list of all of a hero's passive abilities, used by illusions when they spawn
function HeroBuilder:IndexAllHeroesPassives(data)
	for _, team in pairs(GameMode:GetAllAliveTeams()) do
		for _, player_id in ipairs(GameMode.team_player_id_map[team]) do
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero then
				hero.passive_abilities = {}

				for i = 0, (DOTA_MAX_ABILITIES - 1) do
					local ability = hero:GetAbilityByIndex(i)
					if ability and ability:IsPassive() and not string.find(ability:GetAbilityName(), "special_bonus") then
						hero.passive_abilities[ability:GetAbilityName()] = ability:GetLevel()
					end
				end
			end
		end
	end
end

function HeroBuilder:OnConnectFull(event)
	local player_id = event.PlayerID
	if not player_id then return end

	local steamID = PlayerResource:GetSteamAccountID(player_id)
	if not steamID then return end
	
	local permanent_kick = {
		[88765185] = 1,
		[135912126] = 1,
	}

	if permanent_kick[steamID] then
		SendToServerConsole("kick " .. PlayerResource:GetPlayerName(player_id))
	end

	CustomGameEventManager:Send_ServerToAllClients("PlayerConnectStateChanged", {playerId = player_id})

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	
	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	local team = player:GetTeam()
	
	if hero and hero.state and hero.state >= HERO_STATE_AWAITING_PRECACHE then
		CustomGameEventManager:Send_ServerToPlayer(player, "HideHeroSelection", { particle=true } )
	elseif not PlayerResource:IsFakeClient(player_id) then
		-- IsTeamAlive check added for duos mode, so second player after reconnect can normally play if team not defeated
		if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS 
		and (RoundManager:GetCurrentRoundNumber() <= 1 and GameMode:IsInPreparationPhase() or GameMode:IsTeamAlive(team)) then
			HeroBuilder:RandomHeroForPlayer(player)
		elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
			CustomUI:DynamicHud_Create(-1, "background_ingame", "file://{resources}/layout/custom_game/pick_menu/background_ingame.xml", nil)
		else
			Notifications:Bottom(player, {text = "#late_to_connect", duration = 30, style = {color = "Red"}})
		end
	end

	if not hero then return end
	
	hero:RemoveModifierByName("modifier_auto_attack")

	if GameMode:IsTeamAlive(hero:GetTeam()) then
		GameMode:SetPlayerAbandoned(player_id, false)
		GameMode.player_disconnected_time[player_id] = 0
	end 

	-- TODO: double check this part
	if HeroBuilder:CheckHeroMinState(hero, HERO_STATE_SELECTING_ABILITY) then
		local state = hero.state

		if state == HERO_STATE_REMOVING_ABILITY then
			CustomGameEventManager:Send_ServerToPlayer(player, "ShowRelearnBookAbilitySelection", {
				abilities = hero.abilities,
			})
		elseif state == HERO_STATE_REMOVING_ABILITY_FOR_SUMMON then
			CustomGameEventManager:Send_ServerToPlayer(player, "ability_selection:summon_relearn", {
				abilities = HeroBuilder:GetSortedAbilityList(hero),
			})
		elseif state == HERO_STATE_SELECTING_SUMMON_ABILITY then
			HeroBuilder:ShowSummonAbilitySelection(player_id)
		else
			HeroBuilder:ShowRandomAbilitySelection(player_id)
		end
	end

	if hero.innate_postponed then
		CustomGameEventManager:Send_ServerToPlayer(player, "innates:restore_decide_later", {})
	end

	if hero.ability_selection_postponed then
		CustomGameEventManager:Send_ServerToPlayer(player, "ability_selection:restore_decide_later", {})
	end
	
	local current_round = Enfos:IsEnfosMode() and Enfos:GetCurrentRoundNumber() or RoundManager:GetCurrentRoundNumber()
	if hero.state and hero.state > HERO_STATE_AWAITING_PRECACHE then
		if HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_INNATE)
		or (not hero.innate_selected and not hero.innate_postponed and current_round >= INNATE_SELECTION_ROUND) then
			local existing_choices = HeroBuilder.innate_choices[player_id] ~= nil
			HeroBuilder:ShowInnateAbilitySelection(player_id, existing_choices, false)
		else
			HeroBuilder:ShowRandomAbilitySelection(player_id)
		end
	end
	HeroBuilder:RefreshAbilityOrder(player_id)
end


function HeroBuilder:OnDisconnect( event )
	local player_id = event.PlayerID
	if not player_id then return end

	CustomGameEventManager:Send_ServerToAllClients("PlayerConnectStateChanged",{playerId = player_id})

	--Maybe player connection state changes slighty after disconnect event
	Timers:CreateTimer(0.1, function()
		if (not GameMode:HasPlayerAbandoned(player_id)) then self:CheckForPlayerAbandon(player_id) end
	end)

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if (not hero) or hero:IsNull() then return end

	print("[Disconnect] ", player_id, "has hero", hero:GetUnitName(), "adding auto-attack")

	-- Make wizard unstuck if necessary
	hero:RemoveModifierByName("modifier_enfos_wizard_casting_spell")

	-- Add auto-attack for dc'd hero
	hero:AddNewModifier(hero, nil, "modifier_auto_attack", {})
end


function HeroBuilder:CheckForPlayerAbandon(player_id)
	local connection_state = PlayerResource:GetConnectionState(player_id)

	if not connection_state then return end

	if connection_state == DOTA_CONNECTION_STATE_ABANDONED then
		GameMode:SetPlayerAbandoned(player_id, true)
		CustomGameEventManager:Send_ServerToAllClients("PlayerConnectStateChanged", {playerId = player_id})

		self:ValidateEarlyLeaver(player_id)
	elseif connection_state == DOTA_CONNECTION_STATE_DISCONNECTED then
		GameMode.player_disconnected_time[player_id] = (GameMode.player_disconnected_time[player_id] or 0) + 1
		print("[Abandon] player "..player_id.." disconnect time: "..GameMode.player_disconnected_time[player_id])

		if GameMode.player_disconnected_time[player_id] >= PLAYER_ABANDON_TIME then
			GameMode:SetPlayerAbandoned(player_id, true)
			CustomGameEventManager:Send_ServerToAllClients("PlayerConnectStateChanged", {playerId = player_id, forcedAbandon = true})

			self:ValidateEarlyLeaver(player_id)
		else
			Timers:CreateTimer(1, function() 
				HeroBuilder:CheckForPlayerAbandon(player_id) 
			end)
		end
	end
end


function HeroBuilder:ValidateEarlyLeaver(player_id)

	-- Wait some time before validating
	Timers:CreateTimer(30, function()

		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if not hero or hero:IsNull() then return end

		-- Game time
		if GameRules:GetDOTATime(false, false) > 900 then return end

		-- Already eliminated
		local team = hero:GetTeam()
		if GameMode:IsTeamDefeated(team) then return end

		local abandon_count = 0
		for _, id in pairs(GameMode.all_players) do
			if id ~= player_id and GameMode:HasPlayerAbandoned(id) then
				abandon_count = abandon_count + 1
				if team == PlayerResource:GetTeam(id) then return end
				if abandon_count >= 3 then return end
			end
		end

		hero.early_leaver = true
	end)
end


function HeroBuilder:RunAbilitySoundPrecache()
	Timers:CreateTimer(1, function()
		-- getting last from the table to later avoid entire table shifting
		local hero_name
		if PENDING_ABILITY_SOUND_PRECACHE and #PENDING_ABILITY_SOUND_PRECACHE > 0 then
			hero_name = PENDING_ABILITY_SOUND_PRECACHE[#PENDING_ABILITY_SOUND_PRECACHE]
		 	table.remove(PENDING_ABILITY_SOUND_PRECACHE, #PENDING_ABILITY_SOUND_PRECACHE)
		end

		if not hero_name then return 5 end

		PrecacheUnitByNameAsync("npc_precache_npc_dota_hero_"..hero_name, function()
			PRECACHED_ABILITY_SOUNDS[hero_name] = true
			HeroBuilder:RunAbilitySoundPrecache()
		end)
	end)
end


function HeroBuilder:RegisterHeroDeath(player_id)
	if not player_id then return end

	if not HeroBuilder.round_deaths[player_id] then
		HeroBuilder.round_deaths[player_id] = {}
	end

	table.insert(HeroBuilder.round_deaths[player_id], {
		round = RoundManager:GetCurrentRoundNumber(),
		name = RoundManager:GetCurrentRoundName(),
		totem = RoundManager:GetCurrentRoundTotem(),
	})
end


function HeroBuilder:GetPlayerRoundDeaths(player_id)
	if not player_id then return {} end
	return HeroBuilder.round_deaths[player_id] or {}
end


function HeroBuilder:GetPlayerMasteries(player_id)
	local masteries_names = WearFunc[CHC_ITEM_TYPE_MASTERIES] and WearFunc[CHC_ITEM_TYPE_MASTERIES][player_id] or {}
	local masteries = {}

	for _, name in pairs(masteries_names or {}) do
		table.insert(
			masteries, 
			name .. "_" .. tostring(BP_Masteries:GetMasteryLevel(player_id, name) or 1)
		)
	end

	return masteries
end


function HeroBuilder:GetPlayerItems(player_id)
	local items = {}

	if not player_id then return items end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)

	if not hero then return items end
	if not player_id then return items end

	for index = DOTA_ITEM_SLOT_1, DOTA_ITEM_NEUTRAL_SLOT do
		local item = hero:GetItemInSlot(index)
		if item and not item:IsNull() then
			items[index + 1] = item:GetAbilityName()
		else
			items[index + 1] = json.null
		end
	end

	return items
end


function HeroBuilder:ReindexAbilities(hero)
	local abilities = {}
	for index = 0, (DOTA_MAX_ABILITIES - 1) do
		local ability = hero:GetAbilityByIndex(index)
		if ability and not ability:IsNull() and not ability.placeholder and not ability.isCosmeticAbility 
		and not ability:IsHidden() and not ability:GetKeyValue("IsGrantedByScepter") and not ability:GetKeyValue("IsGrantedByShard") 
		and not ability:IsHiddenAsSecondaryAbility()
		then
			local ability_name = ability:GetAbilityName()

			if not ability_name:find("special_bonus_") and not ability_name:find("innate") then -- who cares about talents
				table.insert(abilities, ability_name)
			end
		end
	end
	return abilities
end


function HeroBuilder:GetPlayerAbilities(player_id)
	local abilities = {
		default = {},
		innate = nil,
	}

	if not player_id then return abilities end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return abilities end

	if hero.abilities then
		abilities.default = hero.abilities
	else
		abilities.default = HeroBuilder:ReindexAbilities(hero)
	end
	local innate = CustomNetTables:GetTableValue("game", "player_innate_" .. player_id)
	if innate then abilities.innate = innate.name end

	return abilities
end


function HeroBuilder:GetSortedAbilityList(hero)
	if not hero then return end

	local present_abilities_dict = {}
	local resulting_table = {}

	if not hero.abilities or #hero.abilities == 0 then
		hero.abilities = HeroBuilder:GetPlayerAbilities(hero:GetPlayerID()).default
		CustomNetTables:SetTableValue("game", "player_abilities"..hero:GetPlayerID(), hero.abilities)
	end

	for _, ability_name in pairs(hero.abilities) do
		present_abilities_dict[ability_name] = true
	end

	for i = 0, hero:GetAbilityCount() - 1 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and not ability:IsNull() then
			local ability_name = ability:GetAbilityName()
			if present_abilities_dict[ability_name] and not UNREMOVABLE_ABILITIES_KV[ability_name] then
				table.insert(resulting_table, ability_name)
			end
		end
	end
	return resulting_table
end


-- will return true if hero has passed state
function HeroBuilder:CheckHeroState(hero, req_state)
	if not hero or hero:IsNull() or not hero.state then return false end
	return hero.state == req_state
end


-- will return true if hero has passed state, OR ANY STATE THAT IS HIGHER
function HeroBuilder:CheckHeroMinState(hero, min_state)
	if not hero or hero:IsNull() or not hero.state then return false end
	return hero.state >= min_state
end

-- Returns the number of extra abilities this player can learn.
-- Book of Paragon = +1 ability, Book of Divinity = +1 ability per book.
function HeroBuilder:GetMaxAbilityCountForPlayer(player_id)
	if TestMode:IsTestMode() then return 6 end

	local max_abilities = (Enfos:IsEnfosMode() and Enfos.base_max_abilities_limit) or RoundManager.base_max_abilities_limit
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)

	if hero and (not hero:IsNull()) then
		for _, modifier in pairs(hero:FindAllModifiers()) do
			if modifier.GetModifierIncreaseMaxAbilityLimit then
				max_abilities = max_abilities + modifier:GetModifierIncreaseMaxAbilityLimit()
			end
		end
	end

	return max_abilities
end

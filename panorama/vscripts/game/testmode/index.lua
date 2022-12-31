_G.TestMode = TestMode or class({})
TestMode.data = require("game/TestMode/data")
TestMode.CreepData = TestMode.CreepData or {}

DEMO_BOT_PASSIVE = -1

LinkLuaModifier("modifier_demo_free_gold", "libraries/modifiers/test_mode/modifier_demo_free_gold", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demo_free_spells", "libraries/modifiers/test_mode/modifier_demo_free_spells", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demo_strength", "libraries/modifiers/test_mode/modifier_demo_strength", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demo_agility", "libraries/modifiers/test_mode/modifier_demo_agility", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demo_intellect", "libraries/modifiers/test_mode/modifier_demo_intellect", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demo_creep_invulnerable", "libraries/modifiers/test_mode/modifier_demo_creep_invulnerable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demo_creep_invulnerable_hero", "libraries/modifiers/test_mode/modifier_demo_creep_invulnerable_hero", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demo_invulnerable", "libraries/modifiers/test_mode/modifier_demo_invulnerable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demo_round_auto_start_disable", "libraries/modifiers/test_mode/modifier_demo_round_auto_start_disable", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_demo_out_of_game", "libraries/modifiers/test_mode/modifier_demo_out_of_game", LUA_MODIFIER_MOTION_NONE)

function TestMode:IsTestMode()
	local map_name = GetMapName_Engine()
	return map_name == "demo" or map_name == "demo_duos"
end

function TestMode:Init()

	if not TestMode:IsTestMode() then return end

	-- To make player can buy items for bots
	SendToServerConsole( "dota_easybuy 1" )

	self.invulnerable_creeps = false;
	self.__is_delay_spawn = false
	self.__disableAutoStart = false
	self.__delay_select_hero = false
	self.__duels_enabled = false

	self.bot_ai_level = DEMO_BOT_PASSIVE
	
	CustomGameEventManager:RegisterListener("DemoMode:SelectEvent",function(_, keys)
		self:OnSelectEvent(keys)
	end)

	EventDriver:Listen("Round:round_ended", TestMode.OnRoundEnded, TestMode)

	local abilityListKV = LoadKeyValues("scripts/npc/npc_abilities_list.txt")
	for heroName, abilities_List in pairs(HeroBuilder.hero_abilities) do 
		if (heroName ~= "npc_dota_hero_starter") then 

			local t = {}
			for k,v in pairs(abilities_List) do 
				local key = tonumber(table.findkey(abilityListKV[string.gsub(heroName,"npc_dota_hero_","")], v))
				t[key] = v
			end 

			CustomNetTables:SetTableValue("linked_abilities", "hero_data_" .. heroName,t)
		end
	end 

	local rounds_list = {
		normal = {},
		bosses = {}
	}

	local getAbilitiesForCreep = function(creepName)
		local dataByCreep = GetUnitKV(creepName)
		local data = {}
		for key,value in pairs(dataByCreep) do 
			if key:match("Ability") 
			and not value:match("ability_special") 
			and value ~= ""
			and  not (GetAbilityKV(value, "AbilityBehavior") or ""):match("DOTA_ABILITY_BEHAVIOR_HIDDEN") then 
				data[value] = {
					-- texturePath = GetAbilityKV(value, "AbilityTextureName") or value
					-- other data.
				}
			end 
		end 
		return data
	end 

	for round_name, round_data in pairs(RoundManager.round_data) do
		local units = {}

		for _, unit in pairs(round_data) do
			if type(unit) == "table" and unit.unit and not units[unit.unit] then
				units[unit.unit] = getAbilitiesForCreep(unit.unit)
			end
		end

		if round_name == "Round_FridgeBoss" then
			
		elseif round_data.is_boss then
			rounds_list.bosses[round_name] = {
				unit_count = round_data.enemy_count,
				units = units,
				tier = round_data.tier,
			}
		else
			rounds_list.normal[round_name] = {
				unit_count = round_data.enemy_count,
				units = units,
				tier = round_data.tier,
			}
		end
	end

	TestMode.CreepData = rounds_list

	CustomNetTables:SetTableValue("game","rounds_list",rounds_list)
	CustomNetTables:SetTableValue("game","TestModeEnum",TestMode.data.eEvents)

	local neutralItemList = {}
	for i = 1, 5 do
		neutralItemList[i] = {} 
	end

	local neutralItemKV = LoadKeyValues("scripts/npc/neutral_items.txt")
	for slevel, levelData in pairs(neutralItemKV) do
		if levelData and type(levelData) == "table" then
			for key,data in pairs(levelData) do
				if key =="items" then
					for k,v in pairs(data) do
						table.insert(neutralItemList[tonumber(slevel)], k)
					end
				end
			end
		end
	end

	CustomNetTables:SetTableValue("game","TestModeNeutralItemList", neutralItemList)

	local totems = {}
	for _,totem_name in pairs(RoundManager.totem_data) do
		totems[totem_name] = next(getAbilitiesForCreep(totem_name))
	end
	CustomNetTables:SetTableValue("game", "totem_list", totems)


	CreateUnitByName("npc_dota_hero_target_dummy", Vector(-2300, -6000, 150), true, nil, nil, DOTA_TEAM_NEUTRALS)

end 

-- disabled func
function TestMode:OnDataUpload()
	for i = 0, 23 do 
		local player = PlayerResource:GetPlayer(i)
		if player then 
			BP_Masteries:UpdateMasteriesForPlayer(i)
		end 
	end 
end 

function TestMode:OnLocalUpdateMasteries()
	local nNewState = GameRules:State_Get()

	for i=0,DOTA_MAX_PLAYERS - 1 do 
		local player = PlayerResource:GetPlayer(i)
		if player then 
			BP_Masteries:UpdateMasteriesForPlayer(i)
		end
	end 	
end 

function TestMode:OnSelectEvent(data)
	local pID = data.PlayerID 
	if not pID then return end
	local eventID = data.eventID 
	local eventList = TestMode.data.eEvents
	local hero = PlayerResource:GetSelectedHeroEntity(pID)
	local hPlayer = PlayerResource:GetPlayer(pID)
	local current_round = RoundManager:GetCurrentRound()
	if not TestMode:IsTestMode() then return end
	if not eventID then return end

	local target_player_id = pID

	-- Host player can manipulate bot stats
	if data.target_ent and GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then
		local target_ent = EntIndexToHScript(data.target_ent) ---@type CDOTA_BaseNPC_Hero

		if target_ent and target_ent:IsRealHero() and PlayerResource:IsFakeClient(target_ent:GetPlayerOwnerID()) then
			hero = target_ent
			target_player_id = hero:GetPlayerOwnerID()
		end
	end

	if eventID == eventList.DEMO_MODE_EVENT_SELECT_HERO and data.heroName and hero then 
		if (not GameMode:HasPlayerSelectedHero(target_player_id)) then return end

		if self.__delay_select_hero then 
			DisplayError(pID,"dota_hud_error_wait_delay_select_hero")
			return
		end 

		self.__delay_select_hero = true
		Timers:CreateTimer({
			useGameTime = false,
			endTime = 0.2, 
			callback = function()
				self.__delay_select_hero = false
			end
		})

		local aegisCount = 2
		if hero:HasModifier("modifier_aegis") then 
			aegisCount = hero:FindModifierByName("modifier_aegis"):GetStackCount()
		end 
		local heroName = data.heroName

		if heroName == hero:GetUnitName()  then
			DisplayError(pID,"dota_hud_error_not_selected_hero")
			return 
		end 

		local modifiersList = {}

		for _, hModifier in pairs(hero:FindAllModifiers()) do
			if hModifier:GetName():find("modifier_demo_") == 1 and not self.data.NoCopyModifiers[hModifier:GetName()] then 
				table.insert(modifiersList,hModifier:GetName())
			end
		end

		if hero.dummy_caster then
			hero.dummy_caster:ForceKill(false)
			hero.dummy_caster = nil
		end

		local items = {}
		for i = 0,8 do
			if hero:GetItemInSlot(i) then
				table.insert(items, hero:GetItemInSlot(i):GetAbilityName())
			end
		end
		if hero:GetItemInSlot(16) then
			table.insert(items, hero:GetItemInSlot(16):GetAbilityName())
		end

		local hHero = PlayerResource:ReplaceHeroWith(target_player_id,heroName,hero:GetGold(),0)
		HeroBuilder:InitPlayerHero(hHero, false, true)

		hHero:SetControllableByPlayer(pID, true)

		Cosmetics:InitCosmeticForUnit(hHero)

		hHero.ability_count = 0
		hHero.abilities = {}
		hHero.state = HERO_STATE_DEFAULT

		Timers:CreateTimer(0.1, function()
			if hHero and not hHero:IsNull() then
				for _,modifierName in pairs(modifiersList) do 
					hHero:AddNewModifier(hHero,nil,modifierName,{})
				end
				for _,itemTransfer in pairs(items) do
					hHero:AddItemByName(itemTransfer)
				end
			end
		end)

		hero:AddNewModifier(hero,nil,"modifier_demo_out_of_game",{})
		if aegisCount > 0 then 
			hHero:AddNewModifier(hHero,nil,"modifier_aegis",{}):SetStackCount(aegisCount)
		end

		-- Test Mode Buffs
		hHero:AddNewModifier(hHero, nil, "modifier_demo_free_gold", {})

		Timers:CreateTimer(0.5, function()
			if hero and not hero:IsNull() then
				hero:ForceKill(false)
				UTIL_Remove(hero)
			end
		end)

	end 

	if eventID == eventList.DEMO_MODE_EVENT_SELECT_ABILITY 
	and data.abilityName 
	and HeroBuilder.ability_hero_map[data.abilityName] then 

		local ability = hero:FindAbilityByName(data.abilityName)
		if ability then 
			if ability.removal_timer then 
				Timers:RemoveTimer(ability.removal_timer)
				ability.removal_timer = nil
				ability:RemoveSelf()
			else 
				return 
			end
		end

		if hero.ability_count >= HeroBuilder:GetMaxAbilityCountForPlayer(target_player_id) then 
			DisplayError(target_player_id,"dota_hud_have_maximum_abilities")
			return 
		end
		print(data.abilityName .. " includes in abilities list - ",table.contains(hero.abilities,data.abilityName))
		if table.contains(hero.abilities,data.abilityName) then return end -- fix for ping

		hero.ability_count = hero.ability_count+1
		table.insert(hero.abilities, data.abilityName)	
		CustomNetTables:SetTableValue("game", "player_abilities"..pID, hero.abilities)
		HeroBuilder:AddAbility(target_player_id, data.abilityName)

	end

	if eventID == eventList.DEMO_MODE_EVENT_SELECT_INNATE_ABILITY 
	and data.innateAbility 
	and table.contains(HeroBuilder.innate_ability_list,data.innateAbility)
	and not hero:HasAbility(data.abilityName) then 
		local innate = CustomNetTables:GetTableValue("game", "player_innate_" .. target_player_id)
		for i=0,24 do 
			local ability = hero:GetAbilityByIndex(i)
			if ability and string.match(ability:GetAbilityName(), "innate") then 
				
				for _, hModifier in pairs(hero:FindAllModifiers()) do
					if hModifier:GetAbility() == ability then
						hModifier:Destroy()
					end
				end
				
				hero:RemoveAbility(ability:GetAbilityName())
			end 
		end
		hero.innate_selected = false
		HeroBuilder:LearnInnate(target_player_id, data.innateAbility)
		
	end

	if eventID == eventList.DEMO_MODE_EVENT_ADDED_AEGIS then 

		local modifier = hero:FindModifierByName("modifier_aegis") or hero:AddNewModifier(hero, nil, "modifier_aegis", {})
		if (not modifier) then return end
		modifier:SetStackCount( modifier:GetStackCount() + 1 )
		CustomGameEventManager:Send_ServerToAllClients("player_update_aegis", { playerId = target_player_id, AegisCount = modifier:GetStackCount()})

	end 

	if eventID == eventList.DEMO_MODE_EVENT_ADDED_FREE_GOLD and data.type then 
		if data.type == 1 then 
			hero:AddNewModifier(hero,nil,"modifier_demo_free_gold",{})
		else 
			hero:RemoveModifierByName("modifier_demo_free_gold")
		end 
	end 

	if eventID == eventList.DEMO_MODE_EVENT_ADDED_FREE_SPELLS and data.type then 
		if data.type == 1 then 
			hero:AddNewModifier(hero,nil,"modifier_demo_free_spells",{})
			Util:RefreshAbilityAndItem(hero)
			AbilityCharges:RefreshCharges(hero, true)
		else 
			hero:RemoveModifierByName("modifier_demo_free_spells")
		end 
	end 

	if eventID == eventList.DEMO_MODE_EVENT_ADDED_INVULNERABLE and data.type then 
		if data.type == 1 then 
			hero:AddNewModifier(hero,nil,"modifier_demo_invulnerable",{})
		else 
			hero:RemoveModifierByName("modifier_demo_invulnerable")
		end 
	end 

	if eventID == eventList.DEMO_MODE_EVENT_ADDED_STRENGTH and data.type then 

		if data.type == 4 then 
			hero:RemoveModifierByName("modifier_demo_strength")
			hero:RemoveModifierByName("custom_modifier_book_stat_strength")
			return;
		end 

		local modifier = hero:FindAbilityByName("modifier_demo_strength") or hero:AddNewModifier(hero,nil,"modifier_demo_strength",{})
		if modifier and data.type == 1 then 
			modifier:SetStackCount(modifier:GetStackCount() + 10 )
		end
		if modifier and data.type == 2 then  
			modifier:SetStackCount(modifier:GetStackCount() + 100 )
		end 
		if modifier and data.type == 3 then  
			modifier:SetStackCount(modifier:GetStackCount() + 1000 )
		end 

		hero:CalculateStatBonus(false)
	end 

	if eventID == eventList.DEMO_MODE_EVENT_ADDED_AGILITY and data.type then 

		if data.type == 4 then 
			hero:RemoveModifierByName("modifier_demo_agility")
			hero:RemoveModifierByName("custom_modifier_book_stat_agility")
			return;
		end 

		local modifier = hero:FindAbilityByName("modifier_demo_agility") or hero:AddNewModifier(hero,nil,"modifier_demo_agility",{})
		if modifier and data.type == 1 then 
			modifier:SetStackCount(modifier:GetStackCount() + 10 )
		end
		if modifier and data.type == 2 then  
			modifier:SetStackCount(modifier:GetStackCount() + 100 )
		end 
		if modifier and data.type == 3 then  
			modifier:SetStackCount(modifier:GetStackCount() + 1000 )
		end 

		hero:CalculateStatBonus(false)
	end 

	if eventID == eventList.DEMO_MODE_EVENT_ADDED_INTELLECT and data.type then 

		if data.type == 4 then 
			hero:RemoveModifierByName("modifier_demo_intellect")
			hero:RemoveModifierByName("custom_modifier_book_stat_intelligence")
			return;
		end 

		local modifier = hero:FindAbilityByName("modifier_demo_intellect") or hero:AddNewModifier(hero,nil,"modifier_demo_intellect",{})
		if modifier and data.type == 1 then 
			modifier:SetStackCount(modifier:GetStackCount() + 10 )
		end
		if modifier and data.type == 2 then  
			modifier:SetStackCount(modifier:GetStackCount() + 100 )
		end 
		if modifier and data.type == 3 then  
			modifier:SetStackCount(modifier:GetStackCount() + 1000 )
		end 

		hero:CalculateStatBonus(false)
	end 

	if eventID == eventList.DEMO_MODE_EVENT_ADDED_LEVEL and data.type then 
		if data.type == 0 then 
			for i=1,1 do 
				hero:HeroLevelUp(i == 1)
			end 
		end 

		if data.type == 1 then 
			for i=1,10 do 
				hero:HeroLevelUp(i == 10)
			end 
		end

		if data.type == 2 then 
			local max = table.count(GameRules.xpTable)
			if hero:GetLevel() >= max then return end
			for i=1,max do 
				hero:HeroLevelUp(i == max)
			end 
		end

	end 

	if eventID == eventList.DEMO_MODE_EVENT_SELECT_ROUND and RoundManager:GetRoundData(data.type) then
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end

		local isBoss = RoundManager:GetRoundData(data.type).is_boss
		local current_round = RoundManager:GetCurrentRoundNumber()

		if isBoss then
			RoundManager:DebugMoveToRound({
				round_number = 10 * math.ceil((current_round + 1) / 10), 
				round_name = data.type, 
				totem_name = data.totem
			})
		else 
			RoundManager:DebugMoveToRound({round_name = data.type, totem_name = data.totem})
		end

	end 

	if eventID == eventList.DEMO_MODE_EVENT_GO_TO_ROUND and data.round then
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end

		local round_number = string.match(data.round, "%d+")
		if not round_number then return end

		RoundManager:DebugMoveToRound({round_number = round_number})
	end
	
	if eventID == eventList.DEMO_MODE_EVENT_INCREASED_ROUND and data.type then
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end

		if data.type == 0 then 
			local current_round = RoundManager:GetCurrentRoundNumber()
			RoundManager:DebugMoveToRound({round_number = current_round + 1})
		end

		if data.type == 1 then 
			local current_round = RoundManager:GetCurrentRoundNumber()
			RoundManager:DebugMoveToRound({round_number = current_round + 5})
		end

		if data.type == 2 then 
			local current_round = RoundManager:GetCurrentRoundNumber()
			RoundManager:DebugMoveToRound({round_number = 10 * math.ceil((current_round + 1) / 10)})
		end

	end 

	if eventID == eventList.DEMO_MODE_EVENT_ADDED_INVULNERABLE_CREEPS  then
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end

		self.invulnerable_creeps = data.type == 1
		if RoundManager:GetCurrentRound() and RoundManager:GetCurrentRound().spawners then 
			local spawners = RoundManager:GetCurrentRound().spawners

			for teamID,spawner in pairs(RoundManager:GetCurrentRound().spawners) do 
				for _,unit in pairs(spawner.current_creeps or {}) do
					if unit and not unit:IsNull() then
						if self.invulnerable_creeps then 
							unit:AddNewModifier(unit, nil, "modifier_demo_creep_invulnerable", {})
							hero:AddNewModifier(hero, nil, "modifier_demo_creep_invulnerable_hero", {})
						else
							unit:RemoveModifierByName("modifier_demo_creep_invulnerable")
							hero:RemoveModifierByName("modifier_demo_creep_invulnerable_hero")
						end
					end
				end
			end 
		end

		CustomGameEventManager:Send_ServerToAllClients("DemoMode:invuln_creeps_state", {state = self.invulnerable_creeps})
	end 

	if eventID == eventList.DEMO_MODE_EVENT_PAUSED then 
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end
		PauseGame(not GameRules:IsGamePaused())
	end 

	if eventID == eventList.DEMO_MODE_EVENT_QUIT then 
		--if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end
		GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
	end 

	if eventID == eventList.DEMO_MODE_EVENT_TIME_SCALE and data.scale and data.scale >= 0.1 and data.scale <= 4 then
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end
		Convars:SetFloat("host_timescale", data.scale)
		CustomGameEventManager:Send_ServerToAllClients("DemoMode:timescale", {scale = data.scale})
	end

	if eventID == eventList.DEMO_MODE_EVENT_SELECT_MASTERY and data.MasteryName and data.Level then
		local category_table = WearFunc[CHC_ITEM_TYPE_MASTERIES]

		if category_table and not not table.contains((category_table[target_player_id] or {}),data.MasteryName) or #(category_table[target_player_id] or {}) <= MAX_MASTERIES + 1 then
			local masteries = (category_table[target_player_id] or {})
			if table.contains(masteries,data.MasteryName) then
				self:TakeOffOneMastery(target_player_id, data.MasteryName)
			end

			if (#(category_table[target_player_id] or {}) >= MAX_MASTERIES) then
				self:TakeOffOneMastery(target_player_id, category_table[target_player_id][1])
			end

			BP_Masteries.players_owned_masteries[target_player_id][data.MasteryName] = {}
			for i=1, data.Level + 1 do
				BP_Masteries.players_owned_masteries[target_player_id][data.MasteryName][i] = true
			end

			WearFunc:EquipItemInCategory(target_player_id, CHC_ITEM_TYPE_MASTERIES, data.MasteryName)
		end
	end

	if eventID == eventList.DEMO_MODE_EVENT_REMOVE_MASTERY and data.MasteryName then
		local category_table = WearFunc[CHC_ITEM_TYPE_MASTERIES]
		if category_table and category_table[target_player_id] and #category_table[target_player_id] > 0 then
			local masteries = table.shallowcopy(category_table[target_player_id])
			WearFunc:TakeOffItemInCategory(target_player_id, CHC_ITEM_TYPE_MASTERIES, data.MasteryName)
		end
	end 

	if eventID == eventList.DEMO_MODE_EVENT_CLEAR_ALL_ABILITIES then

		for i = 0, 23 do
			local ability = hero:GetAbilityByIndex(i)
			if ability then
				local ability_name = ability:GetAbilityName()
				if ability_name == "special_bonus_attributes" or (not string.find(ability_name, "special_bonus") and not table.contains(STARTING_ABILITIES, ability_name)) then
					hero:RemoveAbility(ability_name)
				end
			end
		end

			-- Placeholders for ability system
		for i = 0, 5 do
			local new_ability = hero:AddAbility("empty_"..i)
			new_ability.placeholder = i + 1
		end

		hero:SetAbilityPoints(hero:GetLevel())
		hero.ability_count = 0
		hero.abilities = {}
		CustomNetTables:SetTableValue("game", "player_abilities"..pID, hero.abilities)
	end 

	if eventID == eventList.DEMO_MODE_EVENT_TOGGLE_ROUND_AUTO_START and data.type then
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end

		self.__disableAutoStart = data.type == 1
		if self.__disableAutoStart then 
			hero:AddNewModifier(hero,nil,"modifier_demo_round_auto_start_disable",{})

			if current_round then
				current_round:ForceStopRound()
			end
		else 
			hero:RemoveModifierByName("modifier_demo_round_auto_start_disable")

			if GameMode:GetModeState() ~= GAME_STATE_ROUND_ENDED then return end

			local roundNumber = 0
			if RoundManager:GetCurrentRound() then 
				roundNumber = RoundManager:GetCurrentRoundNumber()
			end 
			roundNumber = roundNumber + 1

			RoundManager:DebugMoveToRound({round_number = roundNumber})
		end

		CustomGameEventManager:Send_ServerToAllClients("DemoMode:round_auto_start_state", {state = self.__disableAutoStart})
	end 

	if eventID == eventList.DEMO_MODE_EVENT_SELECT_NEUTRAL_ITEM and data.itemname then
		local currentItem = hero:GetItemInSlot(DOTA_ITEM_NEUTRAL_SLOT)

		if currentItem then
			if currentItem:GetAbilityName() == data.itemname then return end
			hero:RemoveItem(currentItem)
		end

		hero:AddItemByName(data.itemname)
	end

	if eventID == eventList.DEMO_MODE_EVENT_KILL_ALL then
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end
		TestMode:KillAllCreeps()
	end 

	if eventID == eventList.DEMO_MODE_EVENT_ADDED_CURSE then
		hero:IncrementCurseCount()
	end

	if eventID == eventList.DEMO_MODE_EVENT_REMOVED_CURSE then
		hero:DecrementCurseCount()
	end

	if eventID == eventList.DEMO_MODE_EVENT_TOGGLE_DUELS then
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end

		self.__duels_enabled = data.state == 1
		CustomGameEventManager:Send_ServerToAllClients("DemoMode:duels_enabled", {state = self.__duels_enabled})

		if self.__duels_enabled then
			local round = RoundManager:GetCurrentRound()
			if GameMode:IsInPreparationPhase() and round then
				round.is_pvp_round = PvpManager:WillThisRoundHavePvp(round.round_number, round.is_boss_round, round.round_name)
				
				PvpManager:OnRoundPreparationStarted({ 
					round_number = round.round_number,
					round_name = round.round_name,
					is_boss_round = round.is_boss_round,
				})

				local roundInfo = round.round_preparation_panel_data
				if roundInfo then
					roundInfo.maxround_time = roundInfo.maxround_time + RoundManager.extra_pvp_round_preparation_time[GetMapName()]
					roundInfo.round_start_time = roundInfo.round_start_time + RoundManager.extra_pvp_round_preparation_time[GetMapName()]
					CustomGameEventManager:Send_ServerToAllClients("PrepareRoundExtendTime", roundInfo)
				end

				for _,team in pairs(PvpManager.current_pvp_teams) do
					local spawner = round.spawners[team]
					if spawner then 
						spawner:ForceDestroyCreeps()
					end
				end
			end
		end
	end

	if eventID == eventList.DEMO_MODE_EVENT_ADD_BOT then
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end

		if self.bot_creation_pending then
			DisplayError(pID, "dota_hud_error_bot_creation_pending")
			return
		end

		self.bot_creation_pending = true
		local creation_started = AI_Core:AddBots(1, function(bot)
			self.bot_creation_pending = false
			bot:SetControllableByPlayer(pID, true)
		end)

		-- If we here then no free slots for bot
		if not creation_started then
			DisplayError(pID, "dota_hud_error_max_bot_count")
			self.bot_creation_pending = false
		end
	end

	if eventID == eventList.DEMO_MODE_EVENT_BOT_DIFFICULTY then
		if not GameRules:PlayerHasCustomGameHostPrivileges(hPlayer) then return end

		self.bot_ai_level = data.difficulty

		for bot_id = 0, 24 do
			if PlayerResource:IsValidPlayerID(bot_id) and PlayerResource:IsFakeClient(bot_id) then
				local bot_hero = PlayerResource:GetSelectedHeroEntity(bot_id)
				local modifier = bot_hero:FindModifierByName("modifier_auto_attack")

				if modifier then
					modifier.state = self.bot_ai_level

					if self.bot_ai_level == DEMO_BOT_PASSIVE then
						bot_hero:Stop()
					end
				end
			end
		end

	end
end 
function TestMode:KillAllCreeps()
	if not GameMode:HasGameStarted() then return end

	local spawners = RoundManager:GetCurrentRoundSpawner()

	for _, spawner in pairs(spawners) do
		for _, creep in pairs(spawner.current_creeps) do
			if creep and (not creep:IsNull()) and creep:IsAlive() then
				creep:EmitSound("Revenge.Explosion")

				local explosion_pfx = ParticleManager:CreateParticle("particles/units/heroes/hero_techies/techies_suicide.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControl(explosion_pfx, 0, creep:GetAbsOrigin())
				ParticleManager:SetParticleControl(explosion_pfx, 1, Vector(100, 0, 0))
				ParticleManager:SetParticleControl(explosion_pfx, 2, creep:GetAbsOrigin())
				ParticleManager:ReleaseParticleIndex(explosion_pfx)
			end
		end
	end

	if self.__disableAutoStart then
		local round = RoundManager:GetCurrentRound()
		if round then round:ForceStopRound() end
	else
		RoundManager:DebugMoveToRound({round_number = RoundManager:GetCurrentRoundNumber() + 1})
	end
end

function TestMode:OnRoundEnded(data)
	if self.__disableAutoStart then
		CustomGameEventManager:Send_ServerToAllClients("HiddenRoundBar", {})
	end
end

function TestMode:TakeOffOneMastery(player_id, mastery_name)
	WearFunc:TakeOffItemInCategory(player_id, CHC_ITEM_TYPE_MASTERIES, mastery_name)
end

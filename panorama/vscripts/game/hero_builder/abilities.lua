function HeroBuilder:ExcludeAbility(ability_name)
	disabled_abilities[ability_name] = true
end


function HeroBuilder:ExcludeAbilityCombination(first_ability_name, second_ability_name)
	if not table.contains(ABILITY_EXCLUSIONS_KV[first_ability_name], second_ability_name) then
		table.insert(ABILITY_EXCLUSIONS_KV[first_ability_name], second_ability_name)
	end
	if not table.contains(ABILITY_EXCLUSIONS_KV[second_ability_name], first_ability_name) then
		table.insert(ABILITY_EXCLUSIONS_KV[second_ability_name], first_ability_name)
	end
end


function HeroBuilder:ExcludeAbilitiesByMap()
	-- Serves to alter global variable values in a unique way for the map that is being played. Should only be called in HeroBuilder:Init()
	local map_name = GetMapName()
	
	if map_name == "ffa" or map_name == "demo" then
		-- self:ExcludeAbilityCombination("drow_ranger_marksmanship", "faceless_void_time_lock")
	elseif map_name == "duos" then
		-- self:ExcludeAbilityCombination("drow_ranger_marksmanship", "faceless_void_time_lock")
	elseif map_name == "enfos" then
		--self:ExcludeAbility("slark_essence_shift_lua")
	else
		self:ExcludeAbilityCombination("drow_ranger_marksmanship", "faceless_void_time_lock")
	end
end


-- should called from round preparation phase
function HeroBuilder:ShowRandomAbilitySelection(player_id, is_relearn)
	local player = PlayerResource:GetPlayer(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not player or not hero then return end

	if (not HeroBuilder:CheckHeroMinState(hero, HERO_STATE_DEFAULT)) then return end

	if HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_INNATE) then return end
	if HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_SUMMON_ABILITY) then return end

	if hero.ability_selection_postponed then return end

	if hero.randomAbilityNames then
		local random_ability_names_with_linked = {}
		for _, ability_name in pairs(hero.randomAbilityNames) do
			local ability_info = {}
			ability_info.ability_name = ability_name
			if HeroBuilder.linked_abilities[ability_name] then
				ability_info.linked_abilities = HeroBuilder.linked_abilities[ability_name]
			end
			table.insert(random_ability_names_with_linked, ability_info)
		end

		hero.state = HERO_STATE_SELECTING_ABILITY
		CustomGameEventManager:Send_ServerToPlayer(player, "ability_selection:show", {
			data_list = random_ability_names_with_linked,
			ability_number = hero.ability_count + 1
		})
		return 
	end

	if TestMode:IsTestMode() and not is_relearn then return end

	hero.ability_count = hero.ability_count or 0
	if hero.ability_count >= HeroBuilder:GetMaxAbilityCountForPlayer(player_id) then return end

	-- ability selection from rounds overrides relearn book, gotta return it
	if HeroBuilder:CheckHeroState(hero, HERO_STATE_REMOVING_ABILITY) then
		HeroBuilder:ReturnRelearnBook(hero)
	end

	if HeroBuilder:CheckHeroState(hero, HERO_STATE_REMOVING_ABILITY_FOR_SUMMON) then
		local hItem = CreateItem("item_summon_book_lua", hero, hero)
		hero:AddItem(hItem)
	end

	print('[Hero Builder] showing abilities for ', hero:GetUnitName())
	hero.state = HERO_STATE_SELECTING_ABILITY
	CustomGameEventManager:Send_ServerToPlayer(player, "ability_selection:show", {
		data_list = HeroBuilder:GetNewAbilitySelection(hero),
		ability_number = hero.ability_count + 1
	})
	SwapAbilities:SendAbilitySelectionState(player, hero, true)
end


function HeroBuilder:ShowSummonAbilitySelection(player_id, rerolled)
	local player = PlayerResource:GetPlayer(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not player or not hero then return end

	hero.state = HERO_STATE_SELECTING_SUMMON_ABILITY

	local count = 2
	local grand_librarian = hero:FindAbilityByName("innate_flexible")

	if grand_librarian then
		count = count + grand_librarian:GetLevelSpecialValueFor("bonus_choices_summon_book", 1)
	end

	local abilities_list = hero.current_summon_abilities_selection

	if not abilities_list or rerolled then
		abilities_list = HeroBuilder:ChooseRandomSummonAbilities(hero, count)
		hero.current_summon_abilities_selection = abilities_list
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "ability_selection:summon_select", {
		data_list = abilities_list,
		ability_number = hero.ability_count + 1, 
		rerolled = rerolled
	})
end


function HeroBuilder:GetNewAbilitySelection(hero, amount, filters)
	local all_abilities = table.deepcopy(HeroBuilder.all_abilities)
	local hero_abilities = table.deepcopy(HeroBuilder.hero_abilities[hero:GetUnitName()]) or {}
	amount = amount or 8
	filters = filters or {}

	-- Flexible Innate: Increase ability choices
	if hero:FindAbilityByName("innate_flexible") then
		local flexible_bonus_choices = hero:FindAbilityByName("innate_flexible"):GetLevelSpecialValueFor("bonus_choices", 1)
		amount = amount + flexible_bonus_choices
	elseif hero.flag_flexible then
		amount = amount + GetAbilitySpecial("innate_flexible", "bonus_choices", 1, nil)
	end

	hero.ability_count = hero.ability_count or 0
	hero.abilities = hero.abilities or {}

	for _, filter in pairs(filters) do
        local returned_tables = filter({all_abilities = all_abilities, hero_abilities = hero_abilities})
		if returned_tables then
			all_abilities = returned_tables.all_abilities or all_abilities
			hero_abilities = returned_tables.hero_abilities or hero_abilities
		end
	end

	for _, ability_name in ipairs(hero.abilities) do
		-- Removes already owned abilities
		table.remove_item(all_abilities, ability_name)
		table.remove_item(hero_abilities, ability_name)

		for _, abilityName in pairs(ABILITY_EXCLUSIONS_KV[ability_name] or {}) do
			-- Removes banned ability combinations
			table.remove_item(all_abilities, abilityName)
			table.remove_item(hero_abilities, abilityName)
		end
	end

	if hero.prev_removed_ability then
        -- Removes the ability that was discarded if viable
		table.remove_item(all_abilities, hero.prev_removed_ability)
		table.remove_item(hero_abilities, hero.prev_removed_ability)
	end

	for ability_name, hero_name in pairs(HERO_EXCLUSIONS_KV) do
		if hero:GetUnitName() ~= hero_name then
			-- Removes abilities that are reserved for a different hero
			table.remove_item(all_abilities, ability_name)
			table.remove_item(hero_abilities, ability_name)
		end
	end

	local limited_abilities_count = 0
	for _, ability_name in pairs(hero.abilities) do
		if self.limited_abilities[ability_name] then
			limited_abilities_count = limited_abilities_count + 1
		end
	end

	if limited_abilities_count >= self.limited_abilities_max_count then
		for ability_name, _ in pairs(self.limited_abilities) do
			table.remove_item(all_abilities, ability_name)
			table.remove_item(hero_abilities, ability_name)
		end
	end

	local random_ability_names = {}
	-- If (x% chance or this is the first ability) and there is a hero ability to random then
	local chance = 100
	if (RollPercentage(chance) or hero.ability_count <= 0) and #hero_abilities > 0 and amount > 1 and not hero.choosing_random_ability then
		local random_hero_ability = table.random(hero_abilities)
		if random_hero_ability then
			-- Remove the hero ability from the pool of all abilities
			table.remove_item(all_abilities, random_hero_ability)
		end
		random_ability_names = table.join({random_hero_ability}, table.random_some(all_abilities, amount - 1))
	else
		random_ability_names = table.random_some(all_abilities, amount)
	end

	hero.randomAbilityNames = random_ability_names

	-- Makes a table of the random ability names with info regarding linked abilities
	local random_ability_names_with_linked = {}
	for _, ability_name in pairs(hero.randomAbilityNames) do
		local ability_info = {}
		ability_info.ability_name = ability_name
		if HeroBuilder.linked_abilities[ability_name] then
			ability_info.linked_abilities = HeroBuilder.linked_abilities[ability_name]
		end
		table.insert(random_ability_names_with_linked, ability_info)
	end
	return random_ability_names_with_linked
end


function HeroBuilder:AbilitySelectionEvent(event, event_type)
	local ability_name = event.ability_name

	local player_id = event.PlayerID
	if not player_id then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero or hero:IsNull() then return end

	local player = hero:GetPlayerOwner()
	if not player then return end

	local handler = ABILITY_SELECTION_HANDLERS[event_type]
	if not handler then
		print("[Hero Builder] => Ability Selection => no handler for selection event type", event_type)
		return
	end
	-- having all checks above, we may not check for these in subsequent handlers
	ErrorTracking.Try(handler, HeroBuilder, {
		event = event,
		player_id = player_id,
		hero = hero,
		player = player,
		ability_name = ability_name,
	})

	--Select again up to the skill limit
	if hero.ability_count < HeroBuilder:GetMaxAbilityCountForPlayer(player_id) and not TestMode:IsTestMode() then
		HeroBuilder:ShowRandomAbilitySelection(player_id)
	else
		SwapAbilities:SendAbilitySelectionState(player, hero, false)
	end
end


function HeroBuilder:AbilitySelected(event)
	local ability_name = event.ability_name
	local player_id = event.player_id
	local hero = event.hero
	local player = event.player

	-- checking for innate selection, if it's true, it will be processed by innates.lua
	if HeroBuilder:CheckForInnateSelection(hero, player_id, ability_name) then return end

	if not (
		HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_ABILITY) 
		or HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_SUMMON_ABILITY)
	) then return end

	if hero.randomAbilityNames and not HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_SUMMON_ABILITY) then
		if not table.contains(hero.randomAbilityNames, ability_name) then
			SwapAbilities:SendAbilitySelectionState(player, hero, false)
			return
		end
	end

	hero.ability_count = hero.ability_count + 1
	table.insert(hero.abilities, ability_name)
	CustomNetTables:SetTableValue("game", "player_abilities"..player_id, hero.abilities)

	HeroBuilder:AddAbility(player_id, ability_name)
	hero.state = HERO_STATE_DEFAULT
	hero.prev_removed_ability = nil
	hero.randomAbilityNames = nil
	hero.current_summon_abilities_selection = nil
end


--Select skill record
function HeroBuilder:RelearnBookAbilitySelected(event)
	local ability_name = event.ability_name
	local player_id = event.player_id
	local hero = event.hero
	local player = event.player
	local hero_entindex = hero:GetEntityIndex()

	if not HeroBuilder:CheckHeroState(hero, HERO_STATE_REMOVING_ABILITY) then return end

	--Player gives up choice
	ProgressTracker:EventTriggered("CUSTOM_EVENT_RETRAINING_TOME_CONSUMED", {caster = hero})

	if UNREMOVABLE_ABILITIES_KV[ability_name] then return end

	local ability = hero:FindAbilityByName(ability_name)
	if not ability or ability:IsNull() then return end
	if not table.contains(hero.abilities, ability_name) then return end

	HeroBuilder:RemoveAbility(hero, ability, ability_name, true)
	hero.state = HERO_STATE_DEFAULT
	HeroBuilder:ShowRandomAbilitySelection(player_id, true)
	HeroBuilder:RefreshAbilityOrder(player_id)

	local counter_mod = hero:FindModifierByName("modifier_retraining_count")
	if not counter_mod then
		counter_mod = hero:AddNewModifier(hero, nil, "modifier_retraining_count", {})
	end
	-- somehow even after explicit check and creation it still can be nil/null
	-- presumably on dying/disconnecting heroes, or cause of modifier filter
	if counter_mod and not counter_mod:IsNull() then
		counter_mod:IncrementStackCount()
	end
end


function HeroBuilder:SummonBookAbilitySelected(event)
	local ability_name = event.ability_name
	local player_id = event.player_id
	local hero = event.hero
	local player = event.player
	local hero_entindex = hero:GetEntityIndex()

	if not HeroBuilder:CheckHeroState(hero, HERO_STATE_REMOVING_ABILITY_FOR_SUMMON) then return end

	if UNREMOVABLE_ABILITIES_KV[ability_name] then return end

	local ability = hero:FindAbilityByName(ability_name)
	if not ability or ability:IsNull() then return end
	if not table.contains(hero.abilities, ability_name) then return end

	HeroBuilder:RemoveAbility(hero, ability, ability_name, true)
	hero.state = HERO_STATE_DEFAULT
	HeroBuilder:ShowSummonAbilitySelection(player_id)
end

function HeroBuilder:AbilitySelectionCancelled(event)
	local player_id = event.player_id
	local player = event.player
	local hero = event.hero

	if HeroBuilder:CheckForInnateSelection(hero, player_id, nil) then
		return
	end

	if not HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_ABILITY) then return end

	local ability_name = HeroBuilder:ChooseRandomAbility(player_id)
	hero.ability_count = hero.ability_count + 1
	table.insert(hero.abilities, ability_name)
	CustomNetTables:SetTableValue("game", "player_abilities"..player_id, hero.abilities)

	HeroBuilder:AddAbility(player_id, ability_name)
	hero.state = HERO_STATE_DEFAULT
	hero.randomAbilityNames = nil

	SwapAbilities:SendAbilitySelectionState(player, hero, false)
end


function HeroBuilder:CheckForInnateSelection(hero, player_id, ability_name)
	if HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_INNATE) then
		if ability_name == "innate_flexible" then
			hero.flag_flexible = true
		end

		if HeroBuilder:ValidateInnate(player_id, ability_name) then
			hero.state = HERO_STATE_DEFAULT
			HeroBuilder:ShowRandomAbilitySelection(player_id)
		end
		return true
    end
end


function HeroBuilder:RelearnBookCancelled(event)
	local hero = event.hero
	local player = event.player

	if hero.state == HERO_STATE_REMOVING_ABILITY then
		HeroBuilder:ReturnRelearnBook(hero)
		SwapAbilities:SendAbilitySelectionState(player, hero, false)
		hero.state = HERO_STATE_DEFAULT
	end
end


function HeroBuilder:ReturnRelearnBook(hero)
	hero.nRelearnedBooksUsed = hero.nRelearnedBooksUsed and hero.nRelearnedBooksUsed - 1 or 1
	local relearn_book
	if hero.relearn_book_metadata then
		local original_owner = hero.relearn_book_metadata.original_owner
		local purchase_time = hero.relearn_book_metadata.purchase_time
		relearn_book = CreateItem(
			"item_relearn_book_lua", 
			original_owner, 
			original_owner
		)
		-- spawn is setting purchase time, we have to override it again
		Timers:CreateTimer(0, function() 
			if not relearn_book or relearn_book:IsNull() then return end
			if not hero or hero:IsNull() then return end

			relearn_book:SetPurchaseTime(purchase_time)
			relearn_book.purchase_time = purchase_time
			relearn_book:SetPurchaser(original_owner)
			hero.relearn_book_metadata = nil
		end)
	else
		relearn_book = CreateItem("item_relearn_book_lua", hero, hero)
	end

	hero:AddItem(relearn_book)
end


function HeroBuilder:SummonBookCancelled(event)
	local hero = event.hero
	local player = event.player
	local relearn_book = CreateItem("item_summon_book_lua", hero, hero)

	if hero.state == HERO_STATE_REMOVING_ABILITY_FOR_SUMMON then
		hero:AddItem(relearn_book)
		SwapAbilities:SendAbilitySelectionState(player, hero, false)
		hero.state = HERO_STATE_DEFAULT
	end

	hero.summoner_scrolls_used_count = hero.summoner_scrolls_used_count and hero.summoner_scrolls_used_count - 1 or 1
end

function HeroBuilder:RemoveLinkedAbilities(hero, ability_name, refund_skill_points)
	if HeroBuilder.linked_abilities[ability_name] then
		for _, linked_ability_name in ipairs(HeroBuilder.linked_abilities[ability_name]) do
			if not HeroBuilder:HasMainAbilityForLinked(hero, linked_ability_name) then
				local linked_ability = hero:FindAbilityByName(linked_ability_name)
				if linked_ability then
					if refund_skill_points and HeroBuilder.refundable_subabilities[linked_ability_name] then
						hero:SetAbilityPoints(hero:GetAbilityPoints() + linked_ability:GetLevel())
					end

					if linked_ability:IsHidden() then
						hero:RemoveAbilityForEmpty(linked_ability_name)
					else
						hero:RemoveAbilityWithRestructure(linked_ability_name)
					end
				end
			end
		end
	end
end

function HeroBuilder:HasMainAbilityForLinked(hero, target_ability_name)
	for _, ability_name in pairs(hero.abilities) do
		local linked_abilities = HeroBuilder.linked_abilities[ability_name]
		
		if linked_abilities then
			for _, linked_ability_name in pairs(linked_abilities) do
				if linked_ability_name == target_ability_name then
					return true
				end
			end
		end
	end

	return false
end

function HeroBuilder:RemoveAbility(hero, ability, ability_name, refund_skill_points)
	local ability_level = ability:GetLevel()

	--Decrease the number of skills
	hero.ability_count = hero.ability_count - 1
	table.remove_item(hero.abilities, ability_name)
	CustomNetTables:SetTableValue("game", "player_abilities"..hero:GetPlayerOwnerID(), hero.abilities)
	-- Delete skill
	ScepterAbilities:OnScepterAbilityLost(hero, ability)
	hero:RemoveAbilityForEmpty(ability_name)
	hero.prev_removed_ability = ability_name

	HeroBuilder:RemoveLinkedAbilities(hero, ability_name, refund_skill_points)

	-- Clean up cobwebs, etc.
	Util:RemoveAbilityClean(hero, ability_name)

	--Return skill points to players
	if refund_skill_points then
		hero:SetAbilityPoints(hero:GetAbilityPoints() + ability_level)
	end
	
	-- it is kind of safe to supply ability here since it is removed after at least 1 second of delay
	EventDriver:Dispatch("HeroBuilder:ability_removed", {
		hero = hero,
		ability = ability,
		ability_name = ability_name,
		player_id = hero:GetPlayerOwnerID()
	})
end


function HeroBuilder:SetAbilityToSlot(hero, ability)
	if not hero or hero:IsNull() then return end
	if not ability or ability:IsNull() then return end

	for i=0, 5 do
		local slot_ability = hero:GetAbilityByIndex(i)

		if not slot_ability or slot_ability:IsNull() then
			slot_ability = hero:AddAbility("empty_"..i)
			slot_ability.placeholder = i + 1
		end

		if slot_ability.placeholder then
			hero:SwapAbilities(slot_ability:GetAbilityName(), ability:GetAbilityName(), false, true)
			ability:SetAbilityIndex(slot_ability.placeholder - 1)
			return
		end
	end
end


function HeroBuilder:AddAbility(player_id, ability_name, starting_cooldown, add_to_ability_list)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return end
	
	PrecacheItemByNameAsync(ability_name, function()
		HeroBuilder:_OnPrecacheAbilityFinished(hero, ability_name, player_id, starting_cooldown)
	end)
	
	if add_to_ability_list then
		table.insert(hero.abilities, ability_name)
		CustomNetTables:SetTableValue("game", "player_abilities"..player_id, hero.abilities)
	end
end


function HeroBuilder:_OnPrecacheAbilityFinished(hero, ability_name, player_id, starting_cooldown)
	if not hero or hero:IsNull() then return end
	local new_ability = hero:AddAbility(ability_name)

	if not new_ability then return end

	-- this should be a brand new ability, but just in case it's not
	-- and somehow reused by mr Gaben
	if new_ability:CancelRemovalTimer(1, false) then
		return 
	end

	print("[Hero Builder] Added ability", new_ability:GetAbilityName())

	-- Enable ref count to prevent spell amplification after ability retrained and deleted
	if self.disable_spell_amp[ability_name] or self.enable_ref_count[ability_name] then
		new_ability:SetRefCountsModifiers(true)
	end

	new_ability:ClearFalseInnateModifiers(true)
	-- more ensurance that hud and everything will be updated correctly
	new_ability:MarkAbilityButtonDirty()
	hero:CalculateStatBonus(false)

	if starting_cooldown then
		new_ability:StartCooldown(starting_cooldown)
	end

	Timers:CreateTimer(0.1, function()
		if not new_ability or new_ability:IsNull() then return end
		
		HeroBuilder:SetAbilityToSlot(hero, new_ability)
		HeroBuilder:AddLinkedAbilities(hero, ability_name, new_ability:GetLevel())
		HeroBuilder:RefreshAbilityOrder(player_id)
	end)

	local hero_owner_name = HeroBuilder.ability_hero_map[ability_name]
	if hero_owner_name and not table.contains(PENDING_ABILITY_SOUND_PRECACHE, hero_owner_name) and not PRECACHED_ABILITY_SOUNDS[hero_owner_name] then
		table.insert(PENDING_ABILITY_SOUND_PRECACHE, HeroBuilder.ability_hero_map[ability_name])  
	end

	EventDriver:Dispatch("HeroBuilder:ability_added", {
		hero = hero,
		ability = new_ability,
		ability_name = ability_name,
		player_id = player_id
	})
end


function HeroBuilder:AddLinkedAbilities(hero, ability_name, ability_level)
	local linked_abilities = HeroBuilder.linked_abilities[ability_name] 
	if not linked_abilities then
		return 
	end
	local new_linked_ability
	--Add matching skills
	for _, linked_ability_name in ipairs(linked_abilities) do
		local present_ability = hero:FindAbilityByName(linked_ability_name)
		if present_ability then
			local hidden = present_ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_HIDDEN)
			present_ability:CancelRemovalTimer(ability_level, hidden)
		else
			new_linked_ability = hero:AddAbility(linked_ability_name)
			
			if new_linked_ability and not new_linked_ability:IsNull() then
				AbilityCharges:OnAbilityAdded(new_linked_ability)
				if new_linked_ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_HIDDEN) then
					new_linked_ability:SetHidden(true)
				end
				if linked_ability_name == "lone_druid_true_form_druid" or linked_ability_name == "lone_druid_true_form_battle_cry" then
					new_linked_ability:SetHidden(false)
				end
				if HeroBuilder.linked_abilities_level[linked_ability_name] > 0 then
					new_linked_ability:SetLevel(HeroBuilder.linked_abilities_level[linked_ability_name])
				elseif HeroBuilder.linked_abilities_level[linked_ability_name] < 0 then
					new_linked_ability:SetLevel(math.abs(HeroBuilder.linked_abilities_level[linked_ability_name]))
					new_linked_ability:SetActivated(false)
				end
				new_linked_ability:MarkAbilityButtonDirty()
			end
		end

		Timers:CreateTimer(0.1, function()
			if new_linked_ability and not new_linked_ability:IsNull() and not new_linked_ability:IsHidden() then 
				HeroBuilder:SetAbilityToSlot(hero, new_linked_ability) 
			end
		end)
	end
end

function HeroBuilder:ChooseRandomAbility(player_id)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	-- We don't care about the linked abilities since those are only use for displaying to panorama, HeroBuilder:AddAbility
	-- will account for the linked abilities so we only need the name which is set in hero.randomAbilityNames during
	-- HeroBuilder:GetNewAbilitySelection
	hero.choosing_random_ability = true
	HeroBuilder:GetNewAbilitySelection(hero, 1, {
		RemoveAbilitySelectionFromDiscardResult = function(provided_tables)
			for _, ability_name in pairs(hero.randomAbilityNames) do
				table.remove_item(provided_tables.all_abilities, ability_name)
				table.remove_item(provided_tables.hero_abilities, ability_name)
			end
			return provided_tables
		end
	})
	hero.choosing_random_ability = false
	return table.random(hero.randomAbilityNames)
end


function HeroBuilder:RefreshAbilityOrder(player_id)
    local player = PlayerResource:GetPlayer(player_id)
    if not player then return end

    local hero = PlayerResource:GetSelectedHeroEntity(player_id)
    if not hero or hero:IsNull() then return end

    local ent_index = hero:GetEntityIndex()
	local team_number = hero:GetTeamNumber()

	Timers:CreateTimer(0.1, function()
		CustomGameEventManager:Send_ServerToPlayer(player, "dota_ability_changed", {entityIndex = ent_index})
   	 	CustomGameEventManager:Send_ServerToPlayer(player, "RefreshAbilityOrder", {})
	end)

	Timers:CreateTimer(0.3, function()
		CustomGameEventManager:Send_ServerToTeam(team_number, "AddAbility", {})
		HeroBuilder:UpdateAbilityBarModifier(hero)
	end)
end


function HeroBuilder:ChooseRandomSummonAbilities(hero, count)
    local summon_abilities_kv_copy = table.deepcopy(SUMMON_ABILITIES_KV)
    local resulting_table = {}
	
    for _, ability_name in ipairs(hero.abilities) do
		if ABILITY_EXCLUSIONS_KV[ability_name] then
			for _, m_ability_name in pairs(ABILITY_EXCLUSIONS_KV[ability_name]) do
				table.remove_item(summon_abilities_kv_copy, m_ability_name)
			end
		end
	end

	for i, ability_name in pairs(summon_abilities_kv_copy) do
		local is_duplicate = false
		for _, m_ability_name in ipairs(hero.abilities) do
    		if ability_name == m_ability_name then
    			is_duplicate = true
    		end
    	end

    	if not is_duplicate and not self.disabled_abilities[ability_name] then table.insert(resulting_table, ability_name) end
	end

    return table.random_some(resulting_table, count)
end 


function HeroBuilder:UpdateAbilityBarModifier(hero)
	local ability_bar_modifier = hero:FindModifierByName("modifier_ability_bar_scaling")
	if ability_bar_modifier then
		ability_bar_modifier:Destroy()
	end

	local ability_count = 1
	for i = 0, hero:GetAbilityCount() - 1 do
		local ability = hero:GetAbilityByIndex(i)
		if ability then
			local ability_name = ability:GetAbilityName()
			if not ability:IsHidden() and not ability_name:find("special_bonus_") then 
				ability_count = ability_count + 1 
			end
		end
	end

	hero:AddNewModifier(hero, nil, "modifier_ability_bar_scaling", {count = ability_count})
end

function HeroBuilder:AbilitySelectionPostponed(event)
	local player_id = event.PlayerID
	if not player_id then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return end

	if not HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_ABILITY) or not hero.randomAbilityNames then return end

	hero.ability_selection_postponed = true
	hero.postponed_abilities = hero.randomAbilityNames
	hero.randomAbilityNames = nil
	hero.state = HERO_STATE_DEFAULT
end

function HeroBuilder:AbilitySelectionRequested(data)
	local player_id = data.PlayerID
	if not player_id then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return end

	if not HeroBuilder:CheckHeroState(hero, HERO_STATE_DEFAULT) then
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "ability_selection:restore_decide_later", {})
		return 
	end

	if not hero.ability_selection_postponed then return end
	hero.ability_selection_postponed = false

	hero.randomAbilityNames = hero.postponed_abilities
	hero.postponed_abilities = nil

	HeroBuilder:ShowRandomAbilitySelection(player_id, false)
end

-- Checks if player will have exluded ability combination after swap
function HeroBuilder:WillHaveExcludedAbilitiesCombination(hero, ability_name, ignore_ability)
	
	local abilities_list = table.deepcopy(hero.abilities)

	-- We ignore ability only in case if hero already has it
	if ignore_ability then 
		table.remove_item(abilities_list, ignore_ability)
	end

	if hero.randomAbilityNames then
		table.extend(abilities_list, hero.randomAbilityNames)
	end

	if hero.postponed_abilities then
		table.extend(abilities_list, hero.postponed_abilities)
	end

	local limited_abilities_count = 0
	for _, ability_name in pairs(abilities_list) do
		if self.limited_abilities[ability_name] then
			limited_abilities_count = limited_abilities_count + 1
		end
	end

	if limited_abilities_count >= 2 and self.limited_abilities[ability_name] and not self.limited_abilities[ignore_ability] then return true end

	if not ABILITY_EXCLUSIONS_KV[ability_name] then return false end

	for _, hero_ability_name in pairs(abilities_list) do
		if table.contains(ABILITY_EXCLUSIONS_KV[ability_name], hero_ability_name) then
			return true
		end
	end

	return false
end

-- WARNING: this placement is intentional
-- why? because lua compiler is very simple, and can't look ahead, so we can't declare tables with functions that are declated afterwards
-- we must have those functions already declared
ABILITY_SELECTION_HANDLERS = {
	[ABILITY_SELECTION_SELECTED] = HeroBuilder.AbilitySelected,
	[ABILITY_SELECTION_CANCELLED] = HeroBuilder.AbilitySelectionCancelled,
	[ABILITY_SELECTION_RELEARN_SELECTED] = HeroBuilder.RelearnBookAbilitySelected,
	[ABILITY_SELECTION_RELEARN_CANCELLED] = HeroBuilder.RelearnBookCancelled,
	[ABILITY_SELECTION_SUMMON_SELECTED] = HeroBuilder.SummonBookAbilitySelected,
	[ABILITY_SELECTION_SUMMON_CANCELLED] = HeroBuilder.SummonBookCancelled,
}

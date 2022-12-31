function HeroBuilder:ShowInnateAbilitySelection(player_id, existing_innates, rerolled)
	if TestMode:IsTestMode() then return end

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end
	
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return end

	if hero.innate_selected then return end

	if (not HeroBuilder:CheckHeroMinState(hero, HERO_STATE_DEFAULT)) then return end

	if GameMode.is_solo_pve_game then
		for k,innate_name in pairs(HeroBuilder.innate_ability_list) do
			if self.solo_disabled_innate[innate_name] then
				HeroBuilder.innate_ability_list[k] = nil
			end
		end
	end

	hero.state = HERO_STATE_SELECTING_INNATE
	if not existing_innates or (existing_innates and not HeroBuilder.innate_choices[player_id]) then
		HeroBuilder.innate_choices[player_id] = table.random_some(HeroBuilder.innate_ability_list, 12)
	end

	local supporter_level = 2 -- Supporters:GetLevel(player_id)
	CustomGameEventManager:Send_ServerToPlayer(player, "ShowInnateAbilitySelection", {
		playerChoices = HeroBuilder.innate_choices[player_id], 
		playerSupporterLevel = supporter_level, 
		rerolled = rerolled
	})

	SwapAbilities:SendAbilitySelectionState(player, hero, true)
end


function HeroBuilder:ValidateInnate(player_id, ability_name)
	-- Random innate (discard button)
	if not ability_name then
		local random_innate = table.random_some(HeroBuilder.innate_ability_list, 1)
		if random_innate[1] then
			HeroBuilder:LearnInnate(player_id, random_innate[1])
		end
		return true
	end

	if table.contains(HeroBuilder.innate_choices[player_id], ability_name) then
		HeroBuilder:LearnInnate(player_id, ability_name)
		return true
	end
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if hero and not hero:IsNull() then
		SwapAbilities:SendAbilitySelectionState(hero:GetPlayerOwner(), hero, false)
	end
	return false
end


function HeroBuilder:LearnInnate(player_id, ability_name)
	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return end

	if hero.innate_selected then return end

	hero.innate_selected = true
	hero.innate_postponed = false

	PrecacheItemByNameAsync(ability_name, function()
		HeroBuilder:_OnPrecacheAbilityFinishedInnate(hero, ability_name, player_id)
	end)

	SwapAbilities:SendAbilitySelectionState(hero:GetPlayerOwner(), hero, false)
end


function HeroBuilder:_OnPrecacheAbilityFinishedInnate(hero, ability_name, player_id)
	if not hero or hero:IsNull() then 
		hero.innate_selected = nil
		return
	end

	local new_ability = hero:AddAbility(ability_name)
	if not new_ability then 
		hero.innate_selected = nil
		return 
	end

	CustomNetTables:SetTableValue("game", "player_innate_" .. player_id, {name=ability_name, entindex=new_ability:entindex()})

	print("[Hero Builder] Added innate ability", new_ability:GetAbilityName())

	new_ability:SetHidden(true)
	new_ability:SetLevel(1)

	-- more ensurance that hud and everything will be updated correctly
	new_ability:MarkAbilityButtonDirty()
	hero:CalculateStatBonus(false)

	Timers:CreateTimer(0.1, function()
		HeroBuilder:RefreshAbilityOrder(player_id)
	end)

	local hero_owner_name = HeroBuilder.ability_hero_map[ability_name]
	if hero_owner_name and not table.contains(PENDING_ABILITY_SOUND_PRECACHE, hero_owner_name) and not PRECACHED_ABILITY_SOUNDS[hero_owner_name] then
		table.insert(PENDING_ABILITY_SOUND_PRECACHE, HeroBuilder.ability_hero_map[ability_name])  
	end
end


function HeroBuilder:InnatePostponed(data)
	local player_id = data.PlayerID
	if not player_id then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return end

	if not HeroBuilder:CheckHeroState(hero, HERO_STATE_SELECTING_INNATE) then return end

	hero.innate_postponed = true
	hero.state = HERO_STATE_DEFAULT

	SwapAbilities:SendAbilitySelectionState(hero:GetPlayerOwner(), hero, false)

	HeroBuilder:ShowRandomAbilitySelection(player_id)
end


function HeroBuilder:InnateSelectionRequested(data)
	local player_id = data.PlayerID
	if not player_id then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero then return end

	if not HeroBuilder:CheckHeroState(hero, HERO_STATE_DEFAULT) then 
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "innates:restore_decide_later", {})
		return 
	end

	if not hero.innate_postponed then return end
	hero.innate_postponed = false

	HeroBuilder:ShowInnateAbilitySelection(player_id, true)
end

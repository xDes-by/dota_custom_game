if SwapAbilities == nil then SwapAbilities = class({}) end

-- WARNING: prints are here temporarily, till i'm sure it's all works fine
-- TODO: remove prints

function SwapAbilities:Init()
	RegisterCustomEventListener("swap_abilities:accepted", 				function(data) SwapAbilities:SwapPlayersAbilities(data) end)
	RegisterCustomEventListener("swap_abilities:declined", 				function(data) SwapAbilities:ResetSwapWindow(data) end)
	RegisterCustomEventListener("swap_abilities:request_swap", 			function(data) SwapAbilities:ProposeSwap(data) end)
	RegisterCustomEventListener("swap_abilities:request_blocked", 		function(data) SwapAbilities:SendBlockedCombinations(data) end)
	RegisterCustomEventListener("swap_abilities:request_ability_lists", function(data) SwapAbilities:SendAbilityLists(data) end)

	self.pending_swaps = {}
	self.swap_cooldown = {}
	self.SWAP_COOLDOWN = 10
end


function SwapAbilities:ProposeSwap(event)
	local result = SwapAbilities:_ProposeSwap(event)
	if not result then
		self:ResetSwapWindow(event)
	end
end


function SwapAbilities:_ProposeSwap( event )
	if not event.own or not event.other then return end

	local first_ability = EntIndexToHScript(event.own)
	local second_ability = EntIndexToHScript(event.other)

	if not first_ability or first_ability:IsNull() or not first_ability.GetCaster then return end
	if not second_ability or second_ability:IsNull() or not second_ability.GetCaster then return end

	local first_hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
	local second_hero = second_ability:GetCaster()

	if not first_hero or first_hero:IsNull() then return end
	if not second_hero or second_hero:IsNull() then return end

	if first_ability:GetCaster() ~= first_hero then return end

	local first_player_id = first_hero:GetPlayerOwnerID()
	if PlayerResource:IsFakeClient(first_player_id) then
		HeroBuilder:GetSortedAbilityList(first_hero)
		first_hero.ability_count = first_hero.ability_count or 4 
		first_hero.state = HERO_STATE_DEFAULT 
	end

	local second_player_id = second_hero:GetPlayerOwnerID()
	if PlayerResource:IsFakeClient(second_player_id) then
		HeroBuilder:GetSortedAbilityList(second_hero)
		second_hero.ability_count = second_hero.ability_count or 4 
		second_hero.state = HERO_STATE_DEFAULT 
	end

	if self.swap_cooldown[event.PlayerID] then return end

	self.swap_cooldown[event.PlayerID] = true
	Timers:CreateTimer(self.SWAP_COOLDOWN, function() self.swap_cooldown[event.PlayerID] = nil end)

	if first_hero:HasAbility(second_ability:GetAbilityName()) then return end
	if second_hero:HasAbility(first_ability:GetAbilityName()) then return end

	if not HeroBuilder:CheckHeroState(first_hero, HERO_STATE_DEFAULT) 
	or not HeroBuilder:CheckHeroState(second_hero, HERO_STATE_DEFAULT) then return end

	local first_name = first_ability:GetAbilityName()
	local second_name = second_ability:GetAbilityName()

	if HeroBuilder:WillHaveExcludedAbilitiesCombination(first_hero, second_name, first_name)
	or HeroBuilder:WillHaveExcludedAbilitiesCombination(second_hero, first_name, second_name) then
		return 
	end

	--store data to verify later
	local verification_string = tostring(event.own) .. "_" .. tostring(event.other)
	self.pending_swaps[verification_string] = event

	-- bots will auto-accept swaps without client-sending (and also cause they don't have one lol)
	if PlayerResource:IsFakeClient(second_player_id) or GameMode:HasPlayerAbandoned(second_player_id) then
		local result = self:SwapPlayersAbilities(event, true)
		if not result then
			self:ResetSwapWindow(event)
		end
		return true
	end

	local second_player = second_hero:GetPlayerOwner()
	if not second_player or second_player:IsNull() then return end

	first_ability.is_swap = true
	second_ability.is_swap = true
	CustomGameEventManager:Send_ServerToTeam(second_ability:GetCaster():GetTeamNumber(), "swap_abilities:lock_swapped", event)

	Timers:CreateTimer(1/15, function() 
		CustomGameEventManager:Send_ServerToPlayer(second_player, "swap_abilities:swap_proposed", event)
	end)

	-- set up timer to auto-decline timeout swaps
	Timers:CreateTimer(verification_string, {
		useGameTime = false,
		endTime = 29.8,
		callback = function()
			self:ResetSwapWindow(event)
		end 
	})

	return true
end


function SwapAbilities:SwapPlayersAbilities(event, auto_accept)
	if not event.own or not event.other then return end
	-- verify data to prevent cheating/abusing
	local verification_string = tostring(event.own) .. "_" .. tostring(event.other)
	if not self.pending_swaps[verification_string] then return end
	local queued_swap = self.pending_swaps[verification_string]
	if queued_swap.own ~= event.own or queued_swap.other ~= event.other then return end

	local first_ability = EntIndexToHScript(event.own)
	local second_ability = EntIndexToHScript(event.other)
	if not first_ability or first_ability:IsNull() or not first_ability.GetCaster then return end
	if not second_ability or second_ability:IsNull() or not second_ability.GetCaster then return end

	if first_ability.removal_timer or second_ability.removal_timer then return end

	if not first_ability.fountain_disabled and not first_ability:IsActivated() then return end
	if not second_ability.fountain_disabled and not second_ability:IsActivated() then return end
	
	local first_hero = first_ability:GetCaster()
	local second_hero = second_ability:GetCaster()

	if first_hero:HasAbility(second_ability:GetAbilityName()) then return end
	if second_hero:HasAbility(first_ability:GetAbilityName()) then return end

	if not HeroBuilder:CheckHeroState(first_hero, HERO_STATE_DEFAULT) 
	or not HeroBuilder:CheckHeroState(second_hero, HERO_STATE_DEFAULT) then return end

	local first_name = first_ability:GetAbilityName()
	local second_name = second_ability:GetAbilityName()

	if HeroBuilder:WillHaveExcludedAbilitiesCombination(first_hero, second_name, first_name)
	or HeroBuilder:WillHaveExcludedAbilitiesCombination(second_hero, first_name, second_name) then 
		return 
	end

	if not first_hero.GetAbilityPoints or not second_hero.GetAbilityPoints then return end

	local first_player_id = first_hero:GetPlayerOwnerID()
	local second_player_id = second_hero:GetPlayerOwnerID()
	if not auto_accept then
		if event.PlayerID ~= second_player_id and not PlayerResource:IsFakeClient(second_player_id) then
			return 
		end
	end

	Timers:RemoveTimer(verification_string)

	local first_cooldown = first_ability:GetCooldownTimeRemaining()
	local second_cooldown = second_ability:GetCooldownTimeRemaining()

	-- (hero, ability, ability_name, refund_skill_points)
	HeroBuilder:RemoveAbility(first_hero, first_ability, first_name, true)
	HeroBuilder:RemoveAbility(second_hero, second_ability, second_name, true)

	HeroBuilder:AddAbility(second_player_id, first_name, first_cooldown, true)
	HeroBuilder:AddAbility(first_player_id, second_name, second_cooldown, true)
	-- add ability doesn't increase ability number by default
	first_hero.ability_count = first_hero.ability_count + 1
	second_hero.ability_count = second_hero.ability_count + 1


	Timers:CreateTimer(0.2, function()
		-- reset ability panel, locking specific ability names to be safe
		event.update_abilities = {
			[first_player_id] = first_hero.abilities,
			[second_player_id] = second_hero.abilities
		}
		self:ResetSwapWindow(event, true)
	end)
	return true
end


function SwapAbilities:ResetSwapWindow(event, accepted)
	if not event or not event.own or not event.other then return end
	-- verify data to prevent cheating/abusing
	local verification_string = tostring(event.own) .. "_" .. tostring(event.other)
	if not self.pending_swaps[verification_string] then return end

	if not accepted then accepted = false end

	event.accepted = accepted

	self.pending_swaps[verification_string] = nil

	local ability = EntIndexToHScript(event.own)
	local second_ability = EntIndexToHScript(event.other)
	if not ability or ability:IsNull() or not ability.GetCaster then return end
	local team = ability:GetCaster():GetTeamNumber()

	ability.is_swap = false
	if second_ability then 
		second_ability.is_swap = false
	end
	
	if not accepted then
		self.swap_cooldown[event.PlayerID] = nil
	end

	-- send event to unlock abilities
	CustomGameEventManager:Send_ServerToTeam(team, "swap_abilities:unlock_swapped", event)
end


function SwapAbilities:SendBlockedCombinations(event)
	local player_id = event.PlayerID
	if not player_id then return end
	
	local player = PlayerResource:GetPlayer(player_id)
	if not player or player:IsNull() then return end

	CustomGameEventManager:Send_ServerToPlayer(player, "swap_abilities:set_blocked", ABILITY_EXCLUSIONS_KV)
end


function SwapAbilities:SendAbilitySelectionState(player, hero, state)
	if not player or player:IsNull() then return end
	if not hero or hero:IsNull() then return end

	local team = hero:GetTeamNumber()

	CustomGameEventManager:Send_ServerToTeam(team, "swap_abilities:set_selecting_abilities", {
		player_id = player:GetPlayerID(),
		state = state
	})
end


function SwapAbilities:SendAbilityLists(data)
	local player_id = data.PlayerID
	if not player_id then return end

	local player = PlayerResource:GetPlayer(player_id)
	if not player or player:IsNull() then return end

	local abilities = {}

	local team = PlayerResource:GetTeam(player_id)
	for n = 1, PlayerResource:GetPlayerCountForTeam(team) do
		local m_player_id = PlayerResource:GetNthPlayerIDOnTeam(team, n)
		local hero = PlayerResource:GetSelectedHeroEntity(m_player_id)
		if hero then
			abilities[m_player_id] = HeroBuilder:GetSortedAbilityList(hero)
		else
		end
	end
	CustomGameEventManager:Send_ServerToPlayer(player, "swap_abilities:set_abilities", abilities)
end


function SwapAbilities:IsPendingAbilitySwap(hero)
	for index = 0, hero:GetAbilityCount() - 1 do
		local ability = hero:GetAbilityByIndex(index)
		if ability and ability.is_swap then return true end
	end

	return false
end


SwapAbilities:Init()

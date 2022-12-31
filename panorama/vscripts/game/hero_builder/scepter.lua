-- scepter abilities system
ScepterAbilities = ScepterAbilities or class({})


function ScepterAbilities:Init()
	ScepterAbilities.scepter_mods = LoadKeyValues("scripts/kv/ability_types/scepter.kv")
	ScepterAbilities.scepter_owner = {}
	ScepterAbilities.prevented_purchase = {}

	EventDriver:Listen("Hero:scepter_received", ScepterAbilities.OnScepterReceived, ScepterAbilities)
	EventDriver:Listen("HeroBuilder:ability_added", ScepterAbilities.OnAbilityAdded, ScepterAbilities)
end


function ScepterAbilities:RegisterScepterOwner(hero)
	if not hero or not hero:IsMainHero() then return end
	self.scepter_owner[hero:GetEntityIndex()] = hero
end


function ScepterAbilities:UnregisterScepterOwner(hero)
	if not hero or not hero:IsMainHero() then return end
	
	local entindex = hero:GetEntityIndex()
	if self.scepter_owner[entindex] then
		self.scepter_owner[entindex] = nil
	end
end


function ScepterAbilities:OnAbilityAdded(event)
	Timers:CreateTimer(0.15, function()
		ScepterAbilities:ProcessAbility(event.hero, event.ability)
	end)
end


function ScepterAbilities:ProcessAbility(hero, ability)
	if not hero or not hero:IsMainHero() or not hero:HasScepter() then return end
	if not ability or ability:IsNull() or ability:IsHidden() then return end
	--print("on scepter ability gained", ability:GetAbilityName())

	-- abilities which are hero specific and should be spell specific
	-- if scepter is bought BEFORE the ability
	local ability_name = ability:GetAbilityName()
	if HeroBuilder.scepter_hero_specific[ability_name] then
		hero:AddNewModifier(hero, ability, HeroBuilder.scepter_hero_specific[ability_name], {})
	end

	local scepter_abilities = self:ProcessScepterAbilities(hero, ability)
	if next(scepter_abilities) ~= nil then --NOT EMPTY
		ability.scepter_host_ability = true
	   	for i,scepter_ab in ipairs(scepter_abilities) do
	   		self:_ScepterAbilityAdded(hero, scepter_ab)
	   	end
	end		
	HeroBuilder:RefreshAbilityOrder(hero:GetPlayerOwnerID())
end


function ScepterAbilities:ProcessScepterAbilities(hero, ability)
	local scepter_abilities = {}

	if not hero or not hero:IsMainHero() or not ability or ability:IsNull() then  
		return scepter_abilities
	end

	local linked_ability_name = ability:GetKeyValue("AbilityDraftUltScepterAbility")
	if linked_ability_name then
		table.insert(scepter_abilities, {linked_ability_name, "normal"})
	end

	local hidden_linked_ability_name = ability:GetKeyValue("AbilityDraftPreAbility")
	if hidden_linked_ability_name then
		table.insert(scepter_abilities, {hidden_linked_ability_name, "hidden"})
	end

	local hidden_linked_ability_name_2 = ability:GetKeyValue("AbilityDraftUltScepterPreAbility")
	if hidden_linked_ability_name_2 then
		table.insert(scepter_abilities, {hidden_linked_ability_name_2, "normal"})
	end

	return scepter_abilities
end


function ScepterAbilities:_ScepterAbilityAdded(hero, ability)
	local ability_name = ability[1]
	local ability_visibility = ability[2]

	local present_ability = hero:FindAbilityByName(ability_name)

	if present_ability then
		present_ability:CancelRemovalTimer(1, false)
		return 
	end

	local new_ability = hero:AddAbility(ability_name)
	if not new_ability then return end

	new_ability.scepter_ability = true
	new_ability:SetLevel(1)
	
	if ability_visibility == "normal" then
		new_ability:SetHidden(false)
		Timers:CreateTimer(0.1, function()
			HeroBuilder:SetAbilityToSlot(hero, new_ability)
			HeroBuilder:RefreshAbilityOrder(hero:GetPlayerOwnerID())
		end)
	elseif ability_visibility == "hidden" then
		new_ability:SetHidden(true)
	end

	HeroBuilder:AddLinkedAbilities(hero, ability_name, 1)
	AbilityCharges:OnAbilityAdded(new_ability)

	print("Scepter ability added " .. ability_name)
end


function ScepterAbilities:OnScepterReceived(event)
	local hero = event.hero
	if not hero or not hero:IsMainHero() then return end
	if not hero:HasScepter() then return end

	-- returning true cancels the event propagation, because here we refund the scepter
	if not ScepterAbilities:HasScepterUpgrades(hero) then 
		ScepterAbilities:RefundScepter(hero)
		return true 
	end

	self:RegisterScepterOwner(hero)

	-- abilities which are hero specific and should be spell specific
	-- if scepter is bought AFTER the ability
	local destroy_modifiers = {}

	for ability_name, modifier_name in pairs(HeroBuilder.scepter_hero_specific) do
		local ability = hero:FindAbilityByName(ability_name)
		if ability and not ability:IsNull() then
			hero:AddNewModifier(hero, ability, modifier_name, {})
			destroy_modifiers[modifier_name] = false
		else
			-- this makes sure the modifier is not hero specific
			if destroy_modifiers[modifier_name] ~= false then
				destroy_modifiers[modifier_name] = true
			end
		end
	end

	Timers:CreateTimer(0.1, function()	-- sometimes we don't catch the modifier
		if hero and not hero:IsNull() then
			for modifier_name, should_destroy in pairs(destroy_modifiers) do
				if should_destroy then
					hero:RemoveModifierByName(modifier_name)
				end
			end
		end
	end)

	for i = 0, hero:GetAbilityCount() - 1 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and not ability:IsNull() and not (ability:IsHidden() and ability:GetLevel() == 0) then
			local scepter_abilities = self:ProcessScepterAbilities(hero, ability)
			if next(scepter_abilities) ~= nil then --NOT EMPTY
				ability.scepter_host_ability = true
			   	for i,scepter_ab in ipairs(scepter_abilities) do
			   		self:_ScepterAbilityAdded(hero, scepter_ab)
			   	end
			end			
		end
	end
	--HeroBuilder:RefreshAbilityOrder(hero:GetPlayerOwnerID())
end


function ScepterAbilities:OnScepterLost(hero)
	if not hero or not hero:IsMainHero() then return end

	self:UnregisterScepterOwner(hero)

	for i = 0, hero:GetAbilityCount() - 1 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and ability.scepter_ability then
			local ability_name = ability:GetAbilityName()
			hero:RemoveAbilityWithRestructure(ability_name)
			self:CleanScepterModifiers(hero, ability_name)
			HeroBuilder:RemoveLinkedAbilities(hero, ability_name)
		end
	end

	HeroBuilder:RefreshAbilityOrder(hero:GetPlayerOwnerID())
	
	EventDriver:Dispatch("Hero:scepter_lost", {
		hero = hero
	})
end


function ScepterAbilities:OnScepterAbilityLost(hero, ability)
	if not ability or not hero then return end
	if not hero or not hero:IsMainHero() or not ability or not ability.scepter_host_ability then return end

	local scepter_abilities = self:ProcessScepterAbilities(hero, ability)
	if next(scepter_abilities) ~= nil then --NOT EMPTY
		for i,scepter_ab in ipairs(scepter_abilities) do
			local ability_name = scepter_ab[1]

			hero:RemoveAbilityWithRestructure(ability_name)
			HeroBuilder:RefreshAbilityOrder(hero:GetPlayerOwnerID())
			self:CleanScepterModifiers(hero, ability_name)
			HeroBuilder:RemoveLinkedAbilities(hero, ability_name)
	   	end
	end		
end


function ScepterAbilities:CleanScepterModifiers(hero, ability_name)
	local scepter_mods_list = ScepterAbilities.scepter_mods[ability_name]
	if scepter_mods_list then
		hero:RemoveModifierByName(scepter_mods_list)
	end
end


function ScepterAbilities:ProcessScepterOwners()
	for entindex, hero in pairs(self.scepter_owner) do
		if hero and not hero:IsNull() and not hero:HasScepter() then
			self:OnScepterLost(hero)
		end
	end
end


function ScepterAbilities:HasScepterUpgrades(hero)
	-- scan player abilities for ones that have scepter upgrade
	if not hero or hero:IsNull() then return end

	local player_id = hero:GetPlayerOwnerID()
	if not player_id then return end

	-- innate should not trigger popup, also checking for procs and options
	if hero.received_aghs_blessing then return true end
	if hero:HasAbility("innate_aghanims_blessing") or hero:HasModifier("modifier_innate_aghanims_blessing") then return true end
	if ScepterAbilities.prevented_purchase[player_id] then return true end
	if not PLAYER_OPTIONS_AGHS_CHECK_ENABLED[player_id] then return true end

	local source_modifier = hero:FindModifierByName("modifier_item_ultimate_scepter")
	if source_modifier and not source_modifier:IsNull() then
		local source_handle = source_modifier:GetAbility()
		if source_handle.treasury_item then return true end
	end

	for i, ability_name in pairs(hero.abilities or {}) do
		local ability = hero:FindAbilityByName(ability_name)
		if ability and not ability:IsNull() then
			local scepter_linked_ability_1 = ability:GetKeyValue("AbilityDraftUltScepterAbility")
			local scepter_linked_ability_2 = ability:GetKeyValue("AbilityDraftPreAbility")
			local scepter_linked_ability_3 = ability:GetKeyValue("AbilityDraftUltScepterPreAbility")
			local scepter_status = ability:GetKeyValue("HasScepterUpgrade")

			if scepter_linked_ability_1 or scepter_linked_ability_2 
			or scepter_linked_ability_3 or scepter_status then 
				return true 
			end
		end
	end
	return false
end


function ScepterAbilities:RefundScepter(hero, proc_count)
	if not hero or hero:IsNull() then return end
	if proc_count and proc_count >= 10 then return end

	local scepter = hero:FindItemInInventory("item_ultimate_scepter")

	local player = hero:GetPlayerOwner()
	if not player then return end

	if scepter and not scepter:IsNull() then
		local cost = scepter:GetCost()
		hero:RemoveItem(scepter)
		hero:RemoveModifierByName("modifier_item_ultimate_scepter")
		hero:ModifyGold(cost, true, DOTA_ModifyGold_SellItem)

		ScepterAbilities.prevented_purchase[hero:GetPlayerOwnerID()] = true
		CustomGameEventManager:Send_ServerToPlayer(player, "OpenAghsPreventNotification", {})
	else
		-- item creation in inventory usually takes 1-2 frames, might need to time it out
		Timers:CreateTimer(0, function()
			local proc_count = (proc_count or 0) + 1
			ScepterAbilities:RefundScepter(hero, proc_count)
		end)
	end
end


ScepterAbilities:Init()

local MODIFIERS_COST = { -- cost for 1 stack
	["modifier_item_moon_shard_consumed"] = GetItemCost("item_moon_shard"),
	["custom_modifier_book_stat_strength"] = 166.66667,
	["custom_modifier_book_stat_agility"] = 166.66667,
	["custom_modifier_book_stat_intelligence"] = 166.66667,
	["modifier_item_ultimate_scepter_consumed"] = GetItemCost("item_ultimate_scepter_2"),
	["modifier_innate_aghanims_blessing"] = -GetItemCost("item_ultimate_scepter_2"),
	["modifier_item_aghanims_shard"] = GetItemCost("item_aghanims_shard")
}

local OVERRIDE_COST = {
	["item_random_gift"] = 600,
	["item_comeback_gift"] = 1500,
}

function GetItemCostWithCharges(item)
	local cost = item:GetCost()
	
	local initial_charges, current_charges = item:GetInitialCharges(), item:GetCurrentCharges()

	if current_charges > 0 and initial_charges > 0 then
		cost = cost / initial_charges * current_charges
	end
	
	local item_name = item:GetAbilityName()
	if item_name and OVERRIDE_COST[item_name] then
		cost = OVERRIDE_COST[item_name]
	end
	
	return cost
end

function CDOTA_BaseNPC:GetCurrentItemsCost()
	local total_cost = 0

	for i = 0, 16 do
		local item = self:GetItemInSlot(i)
		if item then
			local item_cost = GetItemCostWithCharges(item)
			total_cost = total_cost + item_cost
		end
	end

	for i=0, GameRules:NumDroppedItems() do
		local physical_item = GameRules:GetDroppedItem(i)
		if physical_item then
			local item = physical_item:GetContainedItem()
			if item then
				if self == item:GetPurchaser() then
					local item_cost = GetItemCostWithCharges(item)
					total_cost = total_cost + item_cost
				end
			end
		end
	end

	local player_id = self:GetPlayerOwnerID()

	if ItemLoot.player_choices and ItemLoot.player_choices[player_id] then
		--All neutral items from the same tier cost the same amount of gold
		local item_name = ItemLoot.player_choices[player_id][1]
		total_cost = total_cost + GetItemCost(item_name)
	end

	return total_cost
end


function CDOTA_BaseNPC:GetModifiersCost()
	local total_modifiers_cost = 0

	for modifier_name, modifier_cost in pairs(MODIFIERS_COST) do
		if self:HasModifier(modifier_name) then
			local modifier = self:FindModifierByName(modifier_name)
			local stack_count = modifier:GetStackCount() > 0 and modifier:GetStackCount() or 1
			total_modifiers_cost = math.floor(modifier_cost * stack_count) + total_modifiers_cost
		end
	end

	return total_modifiers_cost
end


function CDOTA_BaseNPC:GetAbilitiesBookCost()
	local total_cost = 0

	if self.nRelearnedBooksUsed then
		total_cost = total_cost + self.nRelearnedBooksUsed * GetItemCost("item_relearn_book_lua")
	end

	if self.nParagonsBooksUsed then
		total_cost = total_cost + self.nParagonsBooksUsed * GetItemCost("item_upgrade_book")
	end

	if self.mastery_scroll_used_count then
		total_cost = total_cost + self.mastery_scroll_used_count * GetItemCost("item_mastery_scroll")
	end
	
	if self.summoner_scrolls_used_count then
		total_cost = total_cost + self.summoner_scrolls_used_count * GetItemCost("item_summon_book_lua")
	end

	return total_cost
end


function CDOTA_BaseNPC:GetSummonedBear()
	if IsValidEntity(self.current_spirit_bear) then
		return self.current_spirit_bear
	end
end

function CDOTA_BaseNPC:GetBearGold()
	local total_cost = 0
	local bear = self:GetSummonedBear()
	if bear then
		total_cost = bear:GetCurrentItemsCost()
	end
	return total_cost
end


function CDOTA_BaseNPC:GetNetworthCHC()
	return math.floor(self:GetCurrentItemsCost() + self:GetGold() + self:GetModifiersCost() + self:GetAbilitiesBookCost() + self:GetBearGold())
end


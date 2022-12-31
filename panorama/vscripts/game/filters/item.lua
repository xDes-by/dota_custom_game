Filters.direct_consumables = {
	["item_book_of_strength"] 		= true,
	["item_book_of_strength_2"] 	= true,
	["item_book_of_agility"] 		= true,
	["item_book_of_agility_2"] 		= true,
	["item_book_of_intelligence"] 	= true,
	["item_book_of_intelligence_2"] = true,
	["item_relearn_book_lua"] 		= true,
	["item_summon_book_lua"] 		= true,
	["item_upgrade_book"] 			= true,
	
	["item_flask"] 					= true,
	["item_salve_2"] 				= true,
	["item_salve_3"] 				= true,
	["item_dust"] 					= true,
	["item_clarity"] 				= true,
	["item_clarity_2"] 				= true,
	["item_enchanted_mango"] 		= true,
	["item_smoke_of_deceit"] 		= true,
	["item_faerie_fire"] 			= true,
	
	["item_mastery_book"] 			= true,
	["item_mastery_scroll"] 		= true,
}

function Filters:ItemAddedToInventoryFilter(keys)
	if not keys.item_entindex_const then return true end
	if not keys.inventory_parent_entindex_const then return true end
	
	local item = EntIndexToHScript( keys.item_entindex_const )
	local inventory_owner = EntIndexToHScript( keys.inventory_parent_entindex_const )
	
	if not item or not inventory_owner then return true end
	
	local item_name = item:GetAbilityName()
	local purchaser = item:GetPurchaser()

	-- Player can give items to bot
	-- Fix for treasure dropped Salves being muted
	if TestMode:IsTestMode() or (Enfos:IsEnfosMode() and not purchaser) then
		item:SetPurchaser(inventory_owner)
		item:SetOwner(inventory_owner)
	end
	
	if purchaser then
		local correct_inventory = inventory_owner:IsRealHero() or (inventory_owner:GetClassname() == "npc_dota_lone_druid_bear") or inventory_owner:IsCourier()
		
		if (keys.item_parent_entindex_const > 0) and item and correct_inventory then
			if not purchaser:IsMaxItemsForPlayer(item) then
				if item then UTIL_Remove(item) end
				return false
			end
		end
	end

	Timers:CreateTimer(0, function() 
		if not item or item:IsNull() then return end
		AbilityCharges:OnAbilityAdded(item)
	end)
	
	local player_owner_id = inventory_owner:GetPlayerOwnerID()
	local player = PlayerResource:GetPlayer(player_owner_id)
	if IsDirectlyConsumable(item_name) and (not purchaser or purchaser:GetPlayerOwnerID() == player_owner_id)  then
		if inventory_owner:GetClassname() == "npc_dota_lone_druid_bear" then return true end
		if not player_owner_id then return true end
		
		local has_stack = FindItemOfHero(inventory_owner, item_name) ~= nil
		
		if player and not player:IsNull() then
			CustomGameEventManager:Send_ServerToPlayer(player, "immediate_purchase:key_check", {
				item = item:entindex(),
				has_stack = has_stack,
				item_name = has_stack and item_name or nil,
			})
		end
	end
	
	return true
end


function IsDirectlyConsumable(item_name)
	return Filters.direct_consumables[item_name]
end


function FindItemOfHero(hero, item_name)
	for i=0, 30 do
		local item = hero:GetItemInSlot(i)
		if item and not item:IsNull() and item:GetAbilityName() == item_name then
			return item
		end
	end
	return nil
end


RegisterCustomEventListener("immediate_purchase:response", function(data)
	local player_id = data.PlayerID
	if not player_id then return end

	local result = data.result
	local has_stacked_items = data.has_stack == 1 -- event sending has bools as 0/1

	local player = PlayerResource:GetPlayer(player_id)
	if not player or player:IsNull() then return end

	local hero = player:GetAssignedHero()
	if not hero or hero:IsNull() then return end

	local item

	if not has_stacked_items then
		item = EntIndexToHScript(data.item)
	else
		if not data.item_name then return end
		item = FindItemOfHero(hero, data.item_name)
	end

	if not item or item:IsNull() or (item.GetContainer and item:GetContainer()) then return end

	if result == 1 then
		
		Timers:CreateTimer(0.07, function()
			if not item or item:IsNull() or item:GetContainer() then return end
			if item:IsCooldownReady() then
				ProgressTracker:EventTriggered("MODIFIER_EVENT_ON_ABILITY_FULLY_CAST", {unit = hero, ability = item})
				hero:SetCursorCastTarget(hero) -- for self casting targeted items like clarity or moon shard
				item:OnSpellStart()
			end
		end)
		 
	end
end)




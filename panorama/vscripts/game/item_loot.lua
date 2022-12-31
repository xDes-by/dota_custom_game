if ItemLoot == nil then ItemLoot = class({}) end

-- Item Drop Manager

function ItemLoot:Init()

	CustomGameEventManager:RegisterListener("BossRewardChosen", Dynamic_Wrap(ItemLoot, 'BossRewardChosen'))
	CustomGameEventManager:RegisterListener("CheckPendingBossReward", Dynamic_Wrap(ItemLoot, 'CheckPendingBossReward'))
	EventDriver:Listen("Spawner:all_creeps_killed", ItemLoot.OnAllCreepsKilled, ItemLoot)
	  
	-- Drop tables
	ItemLoot.loot_pool = {} 
	ItemLoot.player_choices = {}
	ItemLoot.loot_stingers = {}
	ItemLoot.loot_stingers[1] = "Loot_Drop_Sfx"
	ItemLoot.loot_stingers[2] = "Loot_Drop_Stinger_Rare"
	ItemLoot.loot_stingers[3] = "Loot_Drop_Stinger_Mythical"
	ItemLoot.loot_stingers[4] = "Loot_Drop_Stinger_Ancient"
	ItemLoot.loot_stingers[5] = "Loot_Drop_Stinger_Immortal"

	for i = 1, 5 do
		ItemLoot.loot_pool[i] = {} 
	end
	
	local neutral_items_kv = LoadKeyValues("scripts/npc/neutral_items.txt")
	for level, description in pairs(neutral_items_kv) do
		if description and type(description) == "table" then
			for description_type, data in pairs(description) do
				if description_type == "items" then
					for k, v in pairs(data) do
						table.insert(ItemLoot.loot_pool[tonumber(level)], k)
					end
				end
			end
		end
	end
end

-- Fires when a team finishes killing their creeps
function ItemLoot:OnAllCreepsKilled(keys)
	if (not keys.is_boss) then return end

	if Enfos:IsEnfosMode() then return end

	local data_for_client = {}
	
	for _, player_id in pairs(GameMode.team_player_id_map[keys.team]) do
		local drop_tier = math.min(4, math.ceil(keys.round / 10))
		local drop_count = 3
		local player = PlayerResource:GetPlayer(player_id)
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)

		-- Contraband innate
		if hero and hero:HasModifier("modifier_innate_extra_delivery") then
			local extra_delivery_innate = hero:FindAbilityByName("innate_extra_delivery")
			if extra_delivery_innate then
				drop_tier = drop_tier + extra_delivery_innate:GetSpecialValueFor("tier_increase")
				drop_count = drop_count + extra_delivery_innate:GetSpecialValueFor("bonus_items")
			end
		end

		ItemLoot.player_choices[player_id] = table.random_some(ItemLoot.loot_pool[drop_tier] or ItemLoot.loot_pool[1], drop_count)
		data_for_client[player_id] = ItemLoot.player_choices[player_id];
		if player then
			EmitSoundOnClient(ItemLoot.loot_stingers[drop_tier], player)
		end
	end

	-- Small delay so players don't lose items to spam clicking
	Timers:CreateTimer(1.5, function()
		CustomGameEventManager:Send_ServerToTeam(keys.team, "showBossRewards", data_for_client)
	end)
end

function ItemLoot:CheckPendingBossReward(event)
	local player_id = event.PlayerID
	if not player_id then return end

	local team = PlayerResource:GetTeam(player_id)
	if not team then return end

	local data_for_client = {}
	
	for _player_id, items in pairs(ItemLoot.player_choices) do
		local _team = PlayerResource:GetTeam(_player_id)
		if team == _team then
			data_for_client[_player_id] = items
		end
	end
	if data_for_client[player_id] then
		CustomGameEventManager:Send_ServerToTeam(team, "showBossRewards", data_for_client)
	end
end

function ItemLoot:BossRewardChosen(event)
	local player_id = event.PlayerID
	if not player_id then return end

	local chosen_item_number = tonumber(event.itemNumber)

	local player_choices = ItemLoot.player_choices[player_id]
	if not player_choices then return end

	local chosen_item_name = ItemLoot.player_choices[player_id][chosen_item_number]
	if not chosen_item_name then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)

	if DoesHeroHasFreeSlotForNeutral(hero) then
		hero:AddItemByName(chosen_item_name):SetPurchaser(hero)
	else
		local item = CreateItem(chosen_item_name, nil, nil)
		item:SetPurchaser(hero)

		local drop = CreateItemOnPositionSync(hero:GetAbsOrigin(), item)
		item:LaunchLoot(false, 400, 0.65, hero:GetAbsOrigin() + RandomVector(135))
	end
	ItemLoot.player_choices[player_id] = nil
end

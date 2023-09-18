if GameMode == nil then
	_G.GameMode = class({})
end

normal_drop = {
		{items = {"item_points_small"}, chance = 1, limit = 10, units = {"forest_creep_big_2","forest_creep_big_3","forest_creep_big_1","village_creep_1","village_creep_3","mines_creep_1","mines_creep_3","dust_creep_1","dust_creep_3","dust_creep_6","cemetery_creep_2","cemetery_creep_4","swamp_creep_2","swamp_creep_4"}},
		
		{items = {"item_gems_1","item_gems_2","item_gems_3","item_gems_4","item_gems_5"}, chance = 4, duration = 30, units = {"village_creep_1","village_creep_2","village_creep_3","mines_creep_1","mines_creep_2","mines_creep_3","dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6","cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4","swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4","snow_creep_1","snow_creep_3","snow_creep_3","snow_creep_4","last_creep_1","last_creep_2","last_creep_3","last_creep_4"}},
		
		{items = {"item_gems_1","item_gems_2","item_gems_3","item_gems_4","item_gems_5"}, chance = 4, duration = 30, units = {"creep_1","comandir_creep_1","creep_2","comandir_creep_2","creep_3","comandir_creep_3","creep_4","comandir_creep_4","creep_5","comandir_creep_5","creep_6","comandir_creep_6","creep_7","comandir_creep_7", "creep_8", "comandir_creep_8", "creep_9", "comandir_creep_9","creep_10","comandir_creep_10"}},
		
		{items = {"item_trap_ticket"}, chance = 1, limit = 1, units = {"snow_creep_1","snow_creep_3","snow_creep_2","snow_creep_4"}},		

		{items = {"item_points_20"}, chance = 50, units = {"raid_new_year"}},
		{items = {"item_points_20"}, chance = 100, units = {"npc_2023"}},
}

hard_drop = {
		{items = {"item_points_small"}, chance = 1, limit = 15, units = {"forest_creep_big_2","forest_creep_big_3","forest_creep_big_1","village_creep_1","village_creep_3","mines_creep_1","mines_creep_3","dust_creep_1","dust_creep_3","dust_creep_6","cemetery_creep_2","cemetery_creep_4","swamp_creep_2","swamp_creep_4"}},	
		
		{items = {"item_gems_1","item_gems_2","item_gems_3","item_gems_4","item_gems_5"}, chance = 5, duration = 30, units = {"village_creep_1","village_creep_2","village_creep_3","mines_creep_1","mines_creep_2","mines_creep_3","dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6","cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4","swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4","snow_creep_1","snow_creep_3","snow_creep_3","snow_creep_4","last_creep_1","last_creep_2","last_creep_3","last_creep_4"}},

		{items = {"item_gems_1","item_gems_2","item_gems_3","item_gems_4","item_gems_5"}, chance = 4, duration = 30, units = {"creep_1","comandir_creep_1","creep_2","comandir_creep_2","creep_3","comandir_creep_3","creep_4","comandir_creep_4","creep_5","comandir_creep_5","creep_6","comandir_creep_6","creep_7","comandir_creep_7", "creep_8", "comandir_creep_8", "creep_9", "comandir_creep_9","creep_10","comandir_creep_10"}},		
		
		{items = {"item_trap_ticket"}, chance = 1, limit = 1, units = {"snow_creep_1","snow_creep_3","snow_creep_2","snow_creep_4"}},	
		
		{items = {"item_points_30"}, chance = 50, units = {"raid_new_year"}},
		{items = {"item_points_30"}, chance = 100, units = {"npc_2023"}},
}

ultra_drop = {
		{items = {"item_points_small"}, chance = 1, limit = 20, units = {"forest_creep_big_2","forest_creep_big_3","forest_creep_big_1","village_creep_1","village_creep_3","mines_creep_1","mines_creep_3","dust_creep_1","dust_creep_3","dust_creep_6","cemetery_creep_2","cemetery_creep_4","swamp_creep_2","swamp_creep_4"}},
		
		{items = {"item_gems_1","item_gems_2","item_gems_3","item_gems_4","item_gems_5"}, chance = 6, duration = 30, units = {"village_creep_1","village_creep_2","village_creep_3","mines_creep_1","mines_creep_2","mines_creep_3","dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6","cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4","swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4","snow_creep_1","snow_creep_3","snow_creep_3","snow_creep_4","last_creep_1","last_creep_2","last_creep_3","last_creep_4"}},
		
		{items = {"item_gems_1","item_gems_2","item_gems_3","item_gems_4","item_gems_5"}, chance = 4, duration = 30, units = {"creep_1","comandir_creep_1","creep_2","comandir_creep_2","creep_3","comandir_creep_3","creep_4","comandir_creep_4","creep_5","comandir_creep_5","creep_6","comandir_creep_6","creep_7","comandir_creep_7", "creep_8", "comandir_creep_8", "creep_9", "comandir_creep_9","creep_10","comandir_creep_10"}},
		
		{items = {"item_trap_ticket"}, chance = 1, limit = 1, units = {"snow_creep_1","snow_creep_3","snow_creep_2","snow_creep_4"}},	
		
		{items = {"item_points_40"}, chance = 50, units = {"raid_new_year"}},
		{items = {"item_points_40"}, chance = 100, units = {"npc_2023"}},
}

insane_drop = {
		{items = {"item_points_small"}, chance = 1, limit = 25, units = {"forest_creep_big_2","forest_creep_big_3","forest_creep_big_1","village_creep_1","village_creep_3","mines_creep_1","mines_creep_3","dust_creep_1","dust_creep_3","dust_creep_6","cemetery_creep_2","cemetery_creep_4","swamp_creep_2","swamp_creep_4"}},
		
		{items = {"item_gems_1","item_gems_2","item_gems_3","item_gems_4","item_gems_5"}, chance = 6, duration = 30, units = {"village_creep_1","village_creep_2","village_creep_3","mines_creep_1","mines_creep_2","mines_creep_3","dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6","cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4","swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4","snow_creep_1","snow_creep_3","snow_creep_3","snow_creep_4","last_creep_1","last_creep_2","last_creep_3","last_creep_4"}},
		
		{items = {"item_gems_1","item_gems_2","item_gems_3","item_gems_4","item_gems_5"}, chance = 4, duration = 30, units = {"creep_1","comandir_creep_1","creep_2","comandir_creep_2","creep_3","comandir_creep_3","creep_4","comandir_creep_4","creep_5","comandir_creep_5","creep_6","comandir_creep_6","creep_7","comandir_creep_7", "creep_8", "comandir_creep_8", "creep_9", "comandir_creep_9","creep_10","comandir_creep_10"}},
		
		{items = {"item_trap_ticket"}, chance = 1, limit = 1, units = {"snow_creep_1","snow_creep_3","snow_creep_2","snow_creep_4"}},
		
		{items = {"item_points_40"}, chance = 100, units = {"raid_new_year"}},
		{items = {"item_points_40"}, chance = 100, units = {"npc_2023"}},
}

item_drop = {
		{items = {"item_raid_soul"}, chance = 100, units = {"raid_boss", "raid_boss2", "raid_boss3", "raid_boss4"}},
		
		{items = {"item_cheese_lua"}, chance = 100,  duration = 30, units = {"roshan_npc"}},
		
		{items = {"item_flask","item_enchanted_mango"}, chance = 20,  duration = 30, units = {"forest_creep_mini_2","forest_creep_big_2","forest_creep_mini_3","forest_creep_big_3","forest_creep_mini_1","forest_creep_big_1"}},
		
		{items = {"item_quest_blue_stone"}, chance = 5,  duration = 30, units = {"forest_creep_mini_2","forest_creep_big_2","forest_creep_mini_3","forest_creep_big_3","forest_creep_mini_1","forest_creep_big_1"}},
		
		{items = {"item_kristal"}, chance = 1,  duration = 30, units = {"comandir_creep_1","comandir_creep_2","comandir_creep_3","comandir_creep_4","comandir_creep_5","comandir_creep_6","comandir_creep_7", "comandir_creep_8", "comandir_creep_9","comandir_creep_10"}},

		{items = {"item_box_1"}, chance = 2,  duration = 30, units = {"creep_box_1"}},
		{items = {"item_box_1"}, chance = 0.7,  duration = 30, units = {"creep_box_2"}},
		{items = {"item_box_1"}, chance = 0.5,  duration = 30, units = {"creep_box_3"}},

		{items = {"item_box_2"}, chance = 0.7,  duration = 30, units = {"creep_box_1"}},
		{items = {"item_box_2"}, chance = 0.9,  duration = 30, units = {"creep_box_2"}},
		{items = {"item_box_2"}, chance = 0.5,  duration = 30, units = {"creep_box_3"}},

		{items = {"item_box_3"}, chance = 0.5,  duration = 30, units = {"creep_box_2"}},
		{items = {"item_box_3"}, chance = 0.7,  duration = 30, units = {"creep_box_3"}},
}

neutral_items_drop = {
		{items = {"item_tier1_token"}, tier = 1, chance = 5, timer = 360, limit = 5, units = {"forest_creep_mini_1","forest_creep_big_1","forest_creep_mini_2","forest_creep_big_2","forest_creep_mini_3","forest_creep_big_3", "village_creep_1","village_creep_2","village_creep_3","mines_creep_1","mines_creep_2","mines_creep_3","dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6","cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4","swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4","snow_creep_1","snow_creep_3","snow_creep_3","snow_creep_4","last_creep_1","last_creep_2","last_creep_3","last_creep_4"}},
		
		{items = {"item_tier2_token"}, tier = 2, chance = 5, timer = 960, limit = 5, units = {"forest_creep_mini_1","forest_creep_big_1","forest_creep_mini_2","forest_creep_big_2","forest_creep_mini_3","forest_creep_big_3", "village_creep_1","village_creep_2","village_creep_3","mines_creep_1","mines_creep_2","mines_creep_3","dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6","cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4","swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4","snow_creep_1","snow_creep_3","snow_creep_3","snow_creep_4","last_creep_1","last_creep_2","last_creep_3","last_creep_4"}},
		
		{items = {"item_tier3_token"}, tier = 3, chance = 5, timer = 1560, limit = 5, units = {"forest_creep_mini_1","forest_creep_big_1","forest_creep_mini_2","forest_creep_big_2","forest_creep_mini_3","forest_creep_big_3", "village_creep_1","village_creep_2","village_creep_3","mines_creep_1","mines_creep_2","mines_creep_3","dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6","cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4","swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4","snow_creep_1","snow_creep_3","snow_creep_3","snow_creep_4","last_creep_1","last_creep_2","last_creep_3","last_creep_4"}},

		{items = {"item_tier4_token"}, tier = 4, chance = 5, timer = 2160, limit = 5, units = {"forest_creep_mini_1","forest_creep_big_1","forest_creep_mini_2","forest_creep_big_2","forest_creep_mini_3","forest_creep_big_3", "village_creep_1","village_creep_2","village_creep_3","mines_creep_1","mines_creep_2","mines_creep_3","dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6","cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4","swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4","snow_creep_1","snow_creep_3","snow_creep_3","snow_creep_4","last_creep_1","last_creep_2","last_creep_3","last_creep_4"}},

		{items = {"item_tier5_token"}, tier = 5, chance = 5, timer = 2760, limit = 5, units = {"forest_creep_mini_1","forest_creep_big_1","forest_creep_mini_2","forest_creep_big_2","forest_creep_mini_3","forest_creep_big_3", "village_creep_1","village_creep_2","village_creep_3","mines_creep_1","mines_creep_2","mines_creep_3","dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6","cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4","swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4","snow_creep_1","snow_creep_3","snow_creep_3","snow_creep_4","last_creep_1","last_creep_2","last_creep_3","last_creep_4"}},		
}

quest_drop = {
	{name = "item_quest_line_helm", items = {"item_quest_line_helm"}, chance = 15,  duration = 30, units = {"creep_4","comandir_creep_4","creep_5","comandir_creep_5","creep_6","comandir_creep_6","creep_7","comandir_creep_7", "creep_8", "comandir_creep_8", "creep_9", "comandir_creep_9","creep_10","comandir_creep_10"}},
	{name = "item_quest_line_koren", items = {"item_quest_line_koren"}, chance = 15,  duration = 30, units = {"creep_1","comandir_creep_1","creep_2","comandir_creep_2","creep_3","comandir_creep_3","creep_7","comandir_creep_7", "creep_8", "comandir_creep_8", "creep_9", "comandir_creep_9","creep_10","comandir_creep_10"}},
	{name = "item_quest_line_ring", items = {"item_quest_line_ring"}, chance = 15,  duration = 30, units = {"creep_1","comandir_creep_1","creep_2","comandir_creep_2","creep_3","comandir_creep_3","creep_4","comandir_creep_4","creep_5","comandir_creep_5","creep_6","comandir_creep_6","creep_10","comandir_creep_10"}},
	{name = "item_quest_line_skull", items = {"item_quest_line_skull"}, chance = 15,  duration = 30, units = {"creep_1","comandir_creep_1","creep_2","comandir_creep_2","creep_3","comandir_creep_3","creep_4","comandir_creep_4","creep_5","comandir_creep_5","creep_6","comandir_creep_6","creep_7","comandir_creep_7", "creep_8", "comandir_creep_8"}},
	{name = "item_quest_line_sword", items = {"item_quest_line_sword"}, chance = 15,  duration = 30, units = {"creep_1","comandir_creep_1","creep_2","comandir_creep_2","creep_3","comandir_creep_3","creep_4","comandir_creep_4","creep_5","comandir_creep_5","creep_6","comandir_creep_6","creep_7","comandir_creep_7", "creep_8", "comandir_creep_8", "creep_9", "comandir_creep_9","creep_10","comandir_creep_10"}},
	{name = "item_quest_necronomicon", items = {"item_quest_necronomicon"}, chance = 50,  duration = 30, units = {"boss_1","boss_2","boss_3","boss_4","boss_5","boss_6","boss_7","boss_8","boss_9"}},
	{name = "item_quest_blue_ice", items = {"item_quest_blue_ice"}, chance = 10,  duration = 30, units = {"snow_creep_1","snow_creep_2","snow_creep_3","snow_creep_4"}},
}


function GameMode:InitGameMode()
	ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)
end

function GameMode:getDropList()
	return item_drop
end

function GameMode:newDropList(list)
	item_drop = list
end

function GameMode:OnEntityKilled( keys )
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
	local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
	local team = killedUnit:GetTeam()
	if killedUnit and not killedUnit:IsRealHero() then
		RollItemDrop(killedUnit)
		RollNeutralItemDrop(killedUnit, killerEntity)
		RollItemDrop_diff(killedUnit)
		RollQuestDrop(killedUnit, killerEntity)
		-- RollBlueStone(killedUnit, killerEntity)
	end
end

function RollItemDrop_diff(unit)
	local unit_name = unit:GetUnitName()
	
	if wave_count ~= 0 then
	
	if diff_wave.wavedef == "Easy" then
	return
	end
	if diff_wave.wavedef == "Normal" then
		diff_drop = normal_drop
	end
	if diff_wave.wavedef == "Hard" then
		diff_drop = hard_drop
	end	
	if diff_wave.wavedef == "Ultra" then
		diff_drop = ultra_drop
	end	
	if diff_wave.wavedef == "Insane" then
		diff_drop = insane_drop
	end
	
	for _,drop in ipairs(diff_drop) do
		local items = drop.items or nil
		local items_num = #items
		local units = drop.units or nil 
		local chance = drop.chance or 100 
		local loot_duration = drop.duration or nil
		local limit = drop.limit or nil 
		local item_name = items[1]
		local roll_chance = RandomFloat(0, 100)
			
		if units then 
			for _,current_name in pairs(units) do
				if current_name == unit_name then
					units = nil
					break
				end
			end
		end

		if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
			if limit then
				drop.limit = drop.limit - 1
			end

			if items_num > 1 then
				item_name = items[RandomInt(1, #items)]
			end

			spawnPoint = unit:GetAbsOrigin()	
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 50, 100 )

			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
			if loot_duration then
				newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, loot_duration )
			end
		end
	end
	end
end

function RollItemDrop(unit)
	local unit_name = unit:GetUnitName()
	for _,drop in ipairs(item_drop) do
		local items = drop.items or nil
		local items_num = #items
		local units = drop.units or nil 
		local chance = drop.chance or 100 
		local loot_duration = drop.duration or nil
		local limit = drop.limit or nil 
		local item_name = items[1]
		local roll_chance = RandomFloat(0, 100)
			
		if units then 
			for _,current_name in pairs(units) do
				if current_name == unit_name then
					units = nil
					break
				end
			end
		end

		if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
			if limit then
				drop.limit = drop.limit - 1
			end

			if items_num > 1 then
				item_name = items[RandomInt(1, #items)]
			end

			spawnPoint = unit:GetAbsOrigin()	
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 50, 100 )

			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
			if loot_duration then
				newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, loot_duration )
			end
		end
	end
end

function RollNeutralItemDrop(unit, killer)
	local unit_name = unit:GetUnitName()
	for _,drop in ipairs(neutral_items_drop) do
		local items = drop.items or nil
		local items_num = #items
		local units = drop.units or nil 
		local chance = drop.chance or 100 
		local loot_duration = drop.duration or nil
		local limit = drop.limit or nil 
		local item_name = items[1]
		local roll_chance = RandomFloat(0, 100)
		local timer = drop.timer or 0
		local tier = drop.tier or nil
			
		if units then 
			for _,current_name in pairs(units) do
				if current_name == unit_name then
					units = nil
					break
				end
			end
		end

		if units == nil and (limit == nil or limit > 0) and roll_chance < chance and timer < GameRules:GetGameTime() then
			if limit then
				drop.limit = drop.limit - 1
			end
			if items_num > 1 then
				item_name = items[RandomInt(1, #items)]
			end
			
			if timer > 0 and  drop.limit > 0 then
				for i, item in ipairs(drop.items) do
					if item_name == item then
					-- table.remove( drop.items, i )
					end
				end	
			end
			local item = DropNeutralItemAtPositionForHero(item_name, unit:GetAbsOrigin(), killer, tier, false)
			if killer.LastNeutralTeerDroped == tier then
				if killer:IsRealHero() then
					PlayerResource:AddNeutralItemToStash(killer:GetPlayerID(), killer:GetTeamNumber(), item:GetContainedItem())
				else
					PlayerResource:AddNeutralItemToStash(killer:GetOwnerEntity():GetPlayerID(), killer:GetTeamNumber(), item:GetContainedItem())
				end
				UTIL_Remove(item)
			end
			if killer:IsRealHero() then
				killer.LastNeutralTeerDroped = tier
			else
				killer:GetOwnerEntity().LastNeutralTeerDroped = tier
			end
		end
	end
end

function RollQuestDrop( unit, killerEntity )
	local unit_name = unit:GetUnitName()
	for _,drop in ipairs(quest_drop) do
		local items = drop.items or nil
		local items_num = #items
		local units = drop.units or nil 
		local name = drop.name or nil 
		local chance = drop.chance or 100 
		local loot_duration = drop.duration or nil
		local limit = drop.limit or nil 
		local item_name = items[1]
		local roll_chance = RandomFloat(0, 100)
		if units then 
			for _,current_name in pairs(units) do
				if current_name == unit_name and Quests.dropListArray[name] and Quests.dropListArray[name].active == true then
					units = nil
					break
				end
			end
		end

		if units == nil and (limit == nil or limit > 0) and roll_chance < chance then
			if limit then
				drop.limit = drop.limit - 1
			end

			if items_num > 1 then
				item_name = items[RandomInt(1, #items)]
			end

			spawnPoint = unit:GetAbsOrigin()	
			local newItem = CreateItem( item_name, nil, nil )
			local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
			local dropRadius = RandomFloat( 50, 100 )

			newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( dropRadius ) )
			if loot_duration then
				newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, loot_duration )
			end
		end
	end
end

function RollBlueStone( unit, killerEntity )
	local unit_name = unit:GetUnitName()
	local item_blue_stone = nil
	local check = false
	if not killerEntity:IsRealHero() then return end
	if not killerEntity:HasItemInInventory("item_quest_blue_stone") then return end
	for i=DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
        item_blue_stone = killerEntity:GetItemInSlot(i)
        if item_blue_stone ~= nil and item_blue_stone:GetName() == "item_quest_blue_stone" and killerEntity:GetName() == item_blue_stone:GetPurchaser():GetName() then
			check = true
			break
		end
    end
	if check == false then return end
	if RandomInt(1, 100) > 5 then return end

	local spawnPoint = unit:GetAbsOrigin()	
	local newItem = CreateItem( "item_quest_blue_stone", killerEntity, killerEntity )

	if item_blue_stone:GetCurrentCharges() > 0 and item_blue_stone:GetCurrentCharges() < 10 then
		newItem:SetCurrentCharges(1)
	elseif item_blue_stone:GetCurrentCharges() >= 10 and item_blue_stone:GetCurrentCharges() < 20 then
		newItem:SetCurrentCharges(2)
	elseif item_blue_stone:GetCurrentCharges() >= 20 and item_blue_stone:GetCurrentCharges() < 30 then
		newItem:SetCurrentCharges(3)
	elseif item_blue_stone:GetCurrentCharges() >= 30 then
		newItem:SetCurrentCharges(4)
	end

	local drop = CreateItemOnPositionForLaunch( spawnPoint, newItem )
	newItem:LaunchLootInitialHeight( false, 0, 150, 0.5, spawnPoint + RandomVector( RandomFloat( 50, 100 ) ) )
	newItem:SetContextThink( "KillLoot", function() return KillLoot( newItem, drop ) end, 30 )
end

function KillLoot( item, drop )
	if drop:IsNull() then
		return
	end

	local nFXIndex = ParticleManager:CreateParticle( "particles/items2_fx/veil_of_discord.vpcf", PATTACH_CUSTOMORIGIN, drop )
	ParticleManager:SetParticleControl( nFXIndex, 0, drop:GetOrigin() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 35, 35, 25 ) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	UTIL_Remove( item )
	UTIL_Remove( drop )
end

GameMode:InitGameMode()
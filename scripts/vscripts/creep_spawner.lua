require("data/data")

if creep_spawner == nil then
	creep_spawner = class({})
end

LinkLuaModifier( "modifier_unit_on_death", "modifiers/modifier_unit_on_death", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_unit_on_death2", "modifiers/modifier_unit_on_death2", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_creep_antilag", "modifiers/modifier_hide_zone_units", LUA_MODIFIER_MOTION_NONE )

creeps_zone1 = {"forest_creep_mini_1","forest_creep_big_1","forest_creep_mini_2","forest_creep_big_2","forest_creep_mini_3","forest_creep_big_3"}
creeps_zone2 = {"village_creep_1","village_creep_2","village_creep_3"}
creeps_zone3 = {"mines_creep_1","mines_creep_2","mines_creep_3"}
creeps_zone4 = {"dust_creep_1","dust_creep_2","dust_creep_3","dust_creep_4","dust_creep_5","dust_creep_6"}
creeps_zone5 = {"cemetery_creep_1","cemetery_creep_2","cemetery_creep_3","cemetery_creep_4"}
creeps_zone6 = {"swamp_creep_1","swamp_creep_2","swamp_creep_3","swamp_creep_4"}
creeps_zone7 = {"snow_creep_1","snow_creep_2","snow_creep_3","snow_creep_4"}
creeps_zone8 = {"last_creep_1","last_creep_2","last_creep_3","last_creep_4"}
bosses = {"npc_forest_boss","npc_village_boss","npc_mines_boss","npc_dota_gaven_stone","npc_dust_boss","npc_swamp_boss","medusa_ward","npc_snow_boss","npc_dota_creature_tusk",
"npc_mega_boss","npc_dota_custom_tower_dire_1","npc_dota_custom_tower_dire_2","npc_dota_custom_tower_dire_3","npc_dota_custom_tower_dire_4","raid_boss","raid_boss2","raid_boss3","raid_boss4", "npc_boss_location8", "npc_boss_plague_squirrel"}

function add_modifier_death(unit, unitname)
	unit:AddNewModifier(unit, nil, "modifier_unit_on_death", {
		posX = unit:GetAbsOrigin().x,
		posY = unit:GetAbsOrigin().y,
		posZ = unit:GetAbsOrigin().z,
		name = unitname
	})
end

-- ////////////////////////////////////////////////////////////////////////////////////

function creep_spawner:spawn_2023()
	EmitGlobalSound("greevil_mega_spawn_Stinger")
	Notifications:TopToAll({text="2023",style={color="green",["font-size"]="60px"}, duration=10})
	Notifications:TopToAll({text="20231",style={color="blue",["font-size"]="40px"}, duration=10})
	Notifications:TopToAll({text="20232",style={color="red",["font-size"]="30px"}, duration=10})
	local unit = CreateUnitByName("npc_2023", Vector(-1285, -37, 384), true, nil, nil, DOTA_TEAM_BADGUYS)
	Rules:difficality_modifier(unit)
	b1 = 0
	while b1 < 6 do
	add_item = items_level_5[RandomInt(1,#items_level_5)]
		while not unit:HasItemInInventory(add_item) do
			b1 = b1 + 1
			unit:AddItemByName(add_item)
		end
	end
	Timers:CreateTimer(600, function()
		if unit:IsAlive() then
			Notifications:TopToAll({text="20233",style={color="red",["font-size"]="30px"}, duration=3})
			UTIL_Remove(unit)
		end
	end)
end

-- ////////////////////////////////////////////////////////////////////////////////////

function creep_spawner:spawn_creeps_forest()
	local count = 0
	Timers:CreateTimer(0, function()
	if count < 12 then
		count = count + 1
		pt = point_forest[count]
		local point = Vector(pt[1],pt[2],pt[3])
			if count == 1 or count == 7 or count == 9 or count == 10 then
				for i = 1, 4 do
					if i == 4 then
						local unit = CreateUnitByName("forest_creep_big_1", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "forest_creep_big_1")
					else	
						local unit = CreateUnitByName("forest_creep_mini_1", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "forest_creep_mini_1")
					end	
				end
			else if count == 2 or count == 4 or count == 5 or count == 11 then
				for i = 1, 4 do
					if i == 4 then
						local unit = CreateUnitByName("forest_creep_big_2", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "forest_creep_big_2")
					else	
						local unit = CreateUnitByName("forest_creep_mini_2", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "forest_creep_mini_2")
					end	
				end
			else 
				for i = 1, 4 do
					if i == 4 then
						local unit = CreateUnitByName("forest_creep_big_3", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "forest_creep_big_3")
					else	
						local unit = CreateUnitByName("forest_creep_mini_3", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "forest_creep_mini_3")
					end	
				end
			end	
		end
		return 0.1
	else
		return nil
		end
	end)
	creep_spawner:bosses()	
end


function creep_spawner:bosses()	
	local enemies = FindUnitsInRadius(DOTA_TEAM_NEUTRALS,  Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE,  DOTA_UNIT_TARGET_TEAM_BOTH,  DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	 for _,unit in pairs(enemies) do
		for _,t in ipairs(bosses) do
			if t and t == unit:GetUnitName() then 
				Rules:difficality_modifier(unit)
				creep_spawner:add_items(unit)
				unit:AddNewModifier( unit, nil, "modifier_hp_regen_boss", { } )
			end
		end			
	end	
	local points = Entities:FindByName( nil, "big_points"):GetAbsOrigin()
	local newItem = CreateItem( "item_points_big", nil, nil )
	local drop = CreateItemOnPositionForLaunch( points, newItem )
end
	
function creep_spawner:add_items(unit)	
	if unit:GetUnitName() == "npc_forest_boss" or unit:GetUnitName() == "npc_village_boss" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_1[RandomInt(1,#items_level_1)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end
	
	if unit:GetUnitName() == "npc_mines_boss" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_2[RandomInt(1,#items_level_2)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end

	if unit:GetUnitName() == "npc_dust_boss" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_3[RandomInt(1,#items_level_3)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end

	if unit:GetUnitName() == "npc_swamp_boss" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_4[RandomInt(1,#items_level_4)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end

	if unit:GetUnitName() == "npc_snow_boss" or unit:GetUnitName() == "raid_boss" or unit:GetUnitName() == "raid_boss2" or unit:GetUnitName() == "raid_boss3" or unit:GetUnitName() == "raid_boss4" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_5[RandomInt(1,#items_level_5)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end

	if unit:GetUnitName() == "npc_boss_location8" or unit:GetUnitName() == "npc_mega_boss" or unit:GetUnitName() == "npc_boss_plague_squirrel" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_6[RandomInt(1,#items_level_6)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end	

	local mega = Entities:FindByName( nil, "npc_mega_boss")
	mega:AddNewModifier( mega, nil, "modifier_invulnerable", { } )
end

function spawn_creeps_village()
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 5 then
			count = count + 1
			pt = point_village[count]
			local point = Vector(pt[1],pt[2],pt[3])
			for i = 1, 3 do
				local unit = CreateUnitByName("village_creep_"..i, point + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
				add_modifier_death(unit, "village_creep_"..i)
				Rules:difficality_modifier(unit)
			end	
		return 0.1
	else
		return nil
	end
	end)
end	

function spawn_creeps_mines()
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 7 then
			count = count + 1
			pt = point_mines[count]
			local point = Vector(pt[1],pt[2],pt[3])
			for i = 1, 3 do
				local unit = CreateUnitByName("mines_creep_"..i, point + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
				add_modifier_death(unit, "mines_creep_"..i)
				Rules:difficality_modifier(unit)	
			end
		return 0.1
	else
		return nil
	end
	end)
end	

function spawn_creeps_dust()
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 6 then
			count = count + 1
			pt = point_dust[count]
			local point = Vector(pt[1],pt[2],pt[3])
			if count == 1 or count == 4 then
				for i = 1, 4 do
					if i == 4 then
						local unit = CreateUnitByName("dust_creep_2", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "dust_creep_2")
					else
						local unit = CreateUnitByName("dust_creep_1", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "dust_creep_1")
					end	
				end	
			end	
			if count == 2 or count == 5 then
				for i = 1, 4 do
					if i == 4 then
						local unit = CreateUnitByName("dust_creep_4", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "dust_creep_4")
					else
						local unit = CreateUnitByName("dust_creep_3", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "dust_creep_3")
					end	
				end	
			end	
			if count == 3 or count == 6 then
				for i = 1, 4 do
					if i == 4 then
						local unit = CreateUnitByName("dust_creep_6", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "dust_creep_6")
					else
						local unit = CreateUnitByName("dust_creep_5", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "dust_creep_5")
					end
				end
			end	
		return 0.1
	else
		return nil
	end
	end)
end	

function spawn_creeps_cemetery()
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 6 then
			count = count + 1
			pt = point_cemetery[count]
			local point = Vector(pt[1],pt[2],pt[3])
			if count == 1 or count == 5 then
				for i = 1, 5 do
					if i == 4 or i == 5 then
						local unit = CreateUnitByName("cemetery_creep_2", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "cemetery_creep_2")
					else
						local unit = CreateUnitByName("cemetery_creep_1", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "cemetery_creep_1")
					end	
				end	
			end	
			if count == 3 or count == 4 then
				for i = 1, 4 do
					if i == 3 or i == 4 then
						local unit = CreateUnitByName("cemetery_creep_2", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "cemetery_creep_2")
					else
						local unit = CreateUnitByName("cemetery_creep_3", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "cemetery_creep_3")
					end	
				end	
			end	
			if count == 2 or count == 6 then
				for i = 1, 5 do
					if i == 4 or i == 5 then
						local unit = CreateUnitByName("cemetery_creep_4", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "cemetery_creep_4")
					else
						local unit = CreateUnitByName("cemetery_creep_3", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "cemetery_creep_3")
					end
				end
			end	
		return 0.1
	else
		return nil
	end
	end)
end	

function spawn_creeps_swamp()
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 6 then
			count = count + 1
			pt = point_swamp[count]
			local point = Vector(pt[1],pt[2],pt[3])
			if count == 1 or count == 5 then
				for i = 1, 5 do
					if i == 4 or i == 5 then
						local unit = CreateUnitByName("swamp_creep_2", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "swamp_creep_2")
					else
						local unit = CreateUnitByName("swamp_creep_1", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "swamp_creep_1")
					end	
				end	
			end	
			if count == 3 or count == 4 then
				for i = 1, 4 do
					if i == 3 or i == 4 then
						local unit = CreateUnitByName("swamp_creep_4", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "swamp_creep_4")
					else
						local unit = CreateUnitByName("swamp_creep_1", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "swamp_creep_1")
					end	
				end	
			end	
			if count == 2 or count == 6 then
				for i = 1, 5 do
					if i == 4 or i == 5 then
						local unit = CreateUnitByName("swamp_creep_4", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "swamp_creep_4")
					else
						local unit = CreateUnitByName("swamp_creep_3", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "swamp_creep_3")
					end
				end
			end	
		return 0.1
	else
		return nil
	end
	end)
end	

function spawn_creeps_snow()
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 6 then
			count = count + 1
			pt = point_snow[count]
			local point = Vector(pt[1],pt[2],pt[3])
			if count == 1 or count == 5 then
				for i = 1, 4 do
					if i == 3 or i == 4 then
						local unit = CreateUnitByName("snow_creep_2", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "snow_creep_2")
					else
						local unit = CreateUnitByName("snow_creep_1", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "snow_creep_1")
					end	
				end	
			end	
			if count == 2 or count == 6 then
				for i = 1, 4 do
					if i == 3 or i == 4 then
						local unit = CreateUnitByName("snow_creep_4", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "snow_creep_4")
					else
						local unit = CreateUnitByName("snow_creep_3", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "snow_creep_3")
					end	
				end	
			end	
			if count == 3 or count == 4 then
				for i = 1, 4 do
					if i == 3 or i == 4 then
						local unit = CreateUnitByName("snow_creep_4", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "snow_creep_4")
					else
						local unit = CreateUnitByName("snow_creep_1", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "snow_creep_1")
					end
				end
			end	
		return 0.1
	else
		return nil
	end
	end)
end	
		
function spawn_creeps_last()
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 6 then
			count = count + 1
			pt = point_last[count]
			local point = Vector(pt[1],pt[2],pt[3])
			if count % 2 == 0 then
				for i = 1, 4 do
					if i == 4 then
						local unit = CreateUnitByName("last_creep_2", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "last_creep_2")
					else
						local unit = CreateUnitByName("last_creep_1", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "last_creep_1")
					end	
				end	
			else
				for i = 1, 4 do
					if i == 4 then
						local unit = CreateUnitByName("last_creep_4", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "last_creep_4")
					else
						local unit = CreateUnitByName("last_creep_3", point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
						Rules:difficality_modifier(unit)
						add_modifier_death(unit, "last_creep_3")
					end	
				end	
			end	
		return 0.1
	else
		return nil
	end
	end)
end		
		
function creep_spawner:spawn_farm_zones()
	local count = 0
	Timers:CreateTimer(0, function()
		if count < 5 then
			count = count + 1
			local point = Entities:FindByName( nil, "farm_zone_point_"..count):GetAbsOrigin()
			for i = 1, 4 do
				local unit = CreateUnitByName("farm_zone_dragon", point  + RandomVector( RandomInt(50, 100)), true, nil, nil, DOTA_TEAM_BADGUYS)
				Rules:difficality_modifier(unit)
				add_modifier_death(unit, "farm_zone_dragon")
			end	
		return 0.1
	else
		return nil
	end
	end)
end		
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

_G.don_spawn_level = 0

function donate_level()
	_G.don_spawn_level = _G.don_spawn_level + 1
end

function check_trigger_actiate()
	local triggerName = thisEntity:GetName()

	if _G.kill_invoker then 
		spawn_creeps(triggerName, "farm_zone_dragon", "farm_zone_dragon")
		return
	end

	if _G.don_spawn_level == 0 then 
		mini_creep = forest_mini[RandomInt(1,#forest_mini)]
		big_creep = forest_big[RandomInt(1,#forest_big)]
	end
	if _G.don_spawn_level == 1 then 
		mini_creep = village_mini[RandomInt(1,#village_mini)]
		big_creep = village_big[RandomInt(1,#village_big)]
	end
	if _G.don_spawn_level == 2 then 
		mini_creep = mines_mini[RandomInt(1,#mines_mini)]
		big_creep = mines_big[RandomInt(1,#mines_big)]
	end
	if _G.don_spawn_level == 3 then 
		mini_creep = dust_mini[RandomInt(1,#dust_mini)]
		big_creep = dust_big[RandomInt(1,#dust_big)]
	end
	if _G.don_spawn_level == 4 then 
		mini_creep = cemetery_mini[RandomInt(1,#cemetery_mini)]
		big_creep = cemetery_big[RandomInt(1,#cemetery_big)]
	end
	if _G.don_spawn_level == 5 then  
		mini_creep = swamp_mini[RandomInt(1,#swamp_mini)]
		big_creep = swamp_big[RandomInt(1,#swamp_big)]
	end
	if _G.don_spawn_level == 6 then 
		mini_creep = snow_mini[RandomInt(1,#snow_mini)]
		big_creep = snow_big[RandomInt(1,#snow_big)]
	end
	if _G.don_spawn_level == 7 then 
		mini_creep = last_mini[RandomInt(1,#last_mini)]
		big_creep = last_big[RandomInt(1,#last_big)]
	end
	
	spawn_creeps(triggerName, mini_creep, big_creep)
end

function spawn_creeps(triggerName, mini_creep, big_creep)
	local point = Entities:FindByName( nil, triggerName ):GetAbsOrigin()
	for i = 1, 3 do	  
		local minispawn = CreateUnitByName( mini_creep, point + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS )
		Rules:difficality_modifier(minispawn)
		add_modifier_death2(minispawn)	
	end
	local minispawn = CreateUnitByName( big_creep, point + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS )	 
	Rules:difficality_modifier(minispawn)	
	add_modifier_death2(minispawn)	
end

function add_modifier_death2(unit)
	unit:AddNewModifier(unit, nil, "modifier_unit_on_death2", {})
end


---------------------------------------------------------------------------------------------------
--------------------Gold Creep
---------------------------------------------------------------------------------------------------

-- ListenToGameEvent('npc_spawned', Dynamic_Wrap(creep_spawner, "GoldCreeps"), creep_spawner)	
ListenToGameEvent('npc_spawned', Dynamic_Wrap(creep_spawner, "FixCreepLags"), creep_spawner)	

function creep_spawner:FixCreepLags(data)
	local unit = EntIndexToHScript(data.entindex)
	if unit:CanTakeModifier() then
		unit:AddNewModifier(nil, nil, "modifier_creep_antilag", nil)
	end
end

function creep_spawner:GoldCreeps(data)
	local unit = EntIndexToHScript(data.entindex)
	if RandomFloat(0, 100) < 0.1 and unit:CanTakeModifier() and unit:GetTeamNumber() == DOTA_TEAM_BADGUYS then
		unit:AddNewModifier(unit, nil, "modifier_gold_creep", nil)
	end
end

function CDOTA_BaseNPC:CanTakeModifier()
	return creep_spawner.ZoneUnitNames[self:GetUnitName()]
end

creep_spawner.ZoneUnitNames = {
	["forest_creep_mini_1"]=true,
	["forest_creep_big_1"]=true,
	["forest_creep_mini_2"]=true,
	["forest_creep_big_2"]=true,
	["forest_creep_mini_3"]=true,
	["forest_creep_big_3"]=true,
	["village_creep_1"]=true,
	["village_creep_2"]=true,
	["village_creep_3"]=true,
	["mines_creep_1"]=true,
	["mines_creep_2"]=true,
	["mines_creep_3"]=true,
	["dust_creep_1"]=true,
	["dust_creep_2"]=true,
	["dust_creep_3"]=true,
	["dust_creep_4"]=true,
	["dust_creep_5"]=true,
	["dust_creep_6"]=true,
	["cemetery_creep_1"]=true,
	["cemetery_creep_2"]=true,
	["cemetery_creep_3"]=true,
	["cemetery_creep_4"]=true,
	["swamp_creep_1"]=true,
	["swamp_creep_2"]=true,
	["swamp_creep_3"]=true,
	["swamp_creep_4"]=true,
	["snow_creep_1"]=true,
	["snow_creep_2"]=true,
	["snow_creep_3"]=true,
	["snow_creep_4"]=true,
	["last_creep_1"]=true,
	["last_creep_2"]=true,
	["last_creep_3"]=true,
	["last_creep_4"]=true,
	["farm_zone_dragon"]=true,
}


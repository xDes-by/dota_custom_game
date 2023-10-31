require("data/data")

if creep_spawner == nil then
	creep_spawner = class({})
end

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
"npc_mega_boss","raid_boss","raid_boss2","raid_boss3","raid_boss4", "npc_boss_location8", "npc_boss_plague_squirrel"}

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

local creep_name_TO_item_level = {
	["npc_forest_boss_fake"] = 1,
	["npc_village_boss_fake"] = 1,
	["npc_mines_boss_fake"] = 2,
	["npc_dust_boss_fake"] = 3,
	["npc_cemetery_boss_fake"] = 3,
	["npc_swamp_boss_fake"] = 4,
	["npc_snow_boss_fake"] = 5,
	["npc_boss_location8_fake"] = 6,
	["npc_boss_magma_fake"] = 7,

	["npc_forest_boss"] = 1,
	["npc_village_boss"] = 1,
	["npc_mines_boss"] = 2,
	["npc_dust_boss"] = 3,
	["npc_cemetery_boss"] = 3,
	["npc_swamp_boss"] = 4,
	["npc_snow_boss"] = 5,
	["npc_boss_location8"] = 6,
	["npc_boss_magma"] = 7,

	["raid_boss"] = 8,
	["raid_boss2"] = 8,
	["raid_boss3"] = 8,
	["raid_boss4"] = 8,
	
	["npc_mega_boss"] = 9,
	["npc_boss_plague_squirrel"] = 9,
}

function CDOTA_BaseNPC:add_items(level)
	local name = self:GetUnitName()
	if not level then
		level = creep_name_TO_item_level[name]
	end
	if not level then
		print("cant add item level not setted")
		return
	end
	local empty_slots = 0
	for i=0,5 do
		if self:GetItemInSlot(i) == nil then
			empty_slots = empty_slots + 1
		end
	end
	local names = table.random_some(avaliable_creeps_items, empty_slots)
	for _,item_name in pairs(names) do
		local item = self:AddItemByName(item_name)
		item:SetLevel(level)
	end
end

---------------------------------------------------------------------------------------------------
-------------------------- Locations Creeps
---------------------------------------------------------------------------------------------------

function creep_spawner:bosses()	
	local enemies = FindUnitsInRadius(DOTA_TEAM_NEUTRALS,  Vector(0,0,0), nil, FIND_UNITS_EVERYWHERE,  DOTA_UNIT_TARGET_TEAM_BOTH,  DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	 for _,unit in pairs(enemies) do
		for _,t in ipairs(bosses) do
			if t and t == unit:GetUnitName() then 
				Rules:difficality_modifier(unit)
				unit:add_items()
				unit:AddNewModifier( unit, nil, "modifier_hp_regen_boss", { } )
			end
		end			
	end	
	local points = Entities:FindByName( nil, "big_points"):GetAbsOrigin()
	local newItem = CreateItem( "item_points_big", nil, nil )
	local drop = CreateItemOnPositionForLaunch( points, newItem )
end

function creep_spawner:spawn_creeps_forest()
    local count = 0
	while count < 12 do
		count = count + 1
		local point = Vector(point_forest[count][1],point_forest[count][2],point_forest[count][3])
		local creepName = count % 4 == 0 and "forest_creep_mini_1" or count % 4 == 1 and "forest_creep_mini_2" or "forest_creep_mini_3"
		local creepNameBig = count % 4 == 0 and "forest_creep_big_1" or count % 4 == 1 and "forest_creep_big_2" or "forest_creep_big_3"
		for i = 1, 4 do
			local name = i % 4 == 0 and creepNameBig or creepName
			CreateUnitByName_WithoutLags(name, point  + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
		end
	end
	creep_spawner:bosses()	
end

function spawn_creeps_village()
	local count = 0
	while count < 5 do
		count = count + 1
		pt = point_village[count]
		local point = Vector(pt[1],pt[2],pt[3])
		for i = 1, 3 do
			CreateUnitByName_WithoutLags("village_creep_"..i, point + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
		end	
	end
end	

function spawn_creeps_mines()
	local count = 0
	while count < 7 do
		count = count + 1
		pt = point_mines[count]
		local point = Vector(pt[1],pt[2],pt[3])
		for i = 1, 3 do
			CreateUnitByName_WithoutLags("mines_creep_"..i, point + RandomVector( RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
		end
	end
end	

function spawn_creeps_dust()
	local count = 0
	local creepNames = {
		{ "dust_creep_1", "dust_creep_2" },
		{ "dust_creep_3", "dust_creep_4" },
		{ "dust_creep_5", "dust_creep_6" }
	}

	while count < 3 do
		count = count + 1
		pt = point_dust[count]
		local point = Vector(pt[1], pt[2], pt[3])

		for i = 1, 4 do
			if i == 4 then
				CreateUnitByName_WithoutLags(creepNames[count][2], point + RandomVector(RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
			else
				CreateUnitByName_WithoutLags(creepNames[count][1], point + RandomVector(RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
			end
		end
	end
end

function spawn_creeps_cemetery()
	local count = 0
	local creepData = {
		{ count = 5, creepName = "cemetery_creep_1", creep2Name = "cemetery_creep_2" },
		{ count = 5, creepName = "cemetery_creep_3", creep2Name = "cemetery_creep_4" },
		{ count = 4, creepName = "cemetery_creep_3", creep2Name = "cemetery_creep_2" },
		{ count = 4, creepName = "cemetery_creep_2", creep2Name = "cemetery_creep_1" },
		{ count = 5, creepName = "cemetery_creep_1", creep2Name = "cemetery_creep_2" },
		{ count = 5, creepName = "cemetery_creep_3", creep2Name = "cemetery_creep_4" }
	}

	while count < 6 do
		count = count + 1
		local pt = point_cemetery[count]
		local point = Vector(pt[1], pt[2], pt[3])
		local data = creepData[count]

		for i = 1, data.count do
			local creepName = data.creepName
			if i == 4 or i == 5 then
				creepName = data.creep2Name
			end
			CreateUnitByName_WithoutLags(creepName, point + RandomVector(RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
		end
	end
end

function spawn_creeps_swamp()
    local count = 0
    local creepNames = {
        {1, 5, "swamp_creep_2"},
        {3, 4, "swamp_creep_4"},
        {2, 6, "swamp_creep_3"},
    }
    
    while count < 6 do
        count = count + 1
        local point = Vector(point_swamp[count][1], point_swamp[count][2], point_swamp[count][3])
        local randomVector = RandomVector(RandomInt(50, 200))
        local creepName = "swamp_creep_1"
        
        for _, creepInfo in ipairs(creepNames) do
            if count == creepInfo[1] or count == creepInfo[2] then
                creepName = creepInfo[3]
                break
            end
        end
        
        for i = 1, 5 do
            CreateUnitByName_WithoutLags(creepName, point + randomVector, true, nil, nil, DOTA_TEAM_BADGUYS)
        end
    end
end

function spawn_creeps_snow()
	local count = 0
	local creepNames = {
		{ "snow_creep_1", "snow_creep_2" },
		{ "snow_creep_3", "snow_creep_4" },
		{ "snow_creep_1", "snow_creep_4" },
		{ "snow_creep_1", "snow_creep_4" },
		{ "snow_creep_2", "snow_creep_2" },
		{ "snow_creep_3", "snow_creep_4" },
	}

	while count < 6 do
		count = count + 1
		local pt = point_snow[count]
		local point = Vector(pt[1], pt[2], pt[3])
		local randomVector = RandomVector(RandomInt(50, 200))

		local creepNamesForCount = creepNames[count]
		for i = 1, 4 do
			if i == 3 or i == 4 then
				CreateUnitByName_WithoutLags(creepNamesForCount[2], point + randomVector, true, nil, nil, DOTA_TEAM_BADGUYS)
			else
				CreateUnitByName_WithoutLags(creepNamesForCount[1], point + randomVector, true, nil, nil, DOTA_TEAM_BADGUYS)
			end
		end
	end
end
		
function spawn_creeps_last()
	local count = 0
	while count < 6 do
		count = count + 1
		local point = Vector(point_last[count][1], point_last[count][2], point_last[count][3])
		local creepType = count % 2 == 0 and "last_creep_1" or "last_creep_3"
		local creep4Type = count % 2 == 0 and "last_creep_2" or "last_creep_4"
		for i = 1, 4 do
			local unitName = i == 4 and creep4Type or creepType
			CreateUnitByName_WithoutLags(unitName, point + RandomVector(RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
		end
	end	
end		

function spawn_creeps_magma()
	local count = 0
	while count < 6 do
		count = count + 1
		local point = Vector(point_magma[count][1], point_magma[count][2], point_magma[count][3])
		local creepType = "magma_creep_1"
		local creep4Type = "magma_creep_2"
		for i = 1, 4 do
			local unitName = i == 4 and creep4Type or creepType
			CreateUnitByName_WithoutLags(unitName, point + RandomVector(RandomInt(50, 200)), true, nil, nil, DOTA_TEAM_BADGUYS)
		end
	end	
end	

function creep_spawner:spawn_farm_zones()
	local count = 0
	while count < 5 do
		count = count + 1
		local point = Entities:FindByName( nil, "farm_zone_point_"..count):GetAbsOrigin()
		for i = 1, 4 do
			CreateUnitByName_WithoutLags("farm_zone_dragon", point  + RandomVector( RandomInt(50, 100)), true, nil, nil, DOTA_TEAM_BADGUYS)
		end	
	end
end		

---------------------------------------------------------------------------------------------------
-------------------------- Donate Creeps
---------------------------------------------------------------------------------------------------

_G.don_spawn_level = 0

function donate_level()
	_G.don_spawn_level = _G.don_spawn_level + 1

	if _G.don_spawn_level > 3 and (not _G.npc_smithy_mound or _G.npc_smithy_mound:IsNull() or not _G.npc_smithy_mound:IsAlive()) then
		_G.npc_smithy_mound = CreateUnitByName("npc_smithy_mound", Vector(-10417, 1217, 389), true, nil, nil, DOTA_TEAM_GOODGUYS)
		_G.npc_smithy_mound:AddNewModifier(_G.npc_smithy_mound, nil, "modifier_kill", {duration = 300})
		_G.npc_smithy_mound:AddNewModifier(_G.npc_smithy_mound, nil, "modifier_attack_immune", {})
		for iPlayerID = 0,PlayerResource:GetPlayerCount() do
			if PlayerResource:IsValidPlayer(iPlayerID) then
				hHero = PlayerResource:GetSelectedHeroEntity(iPlayerID)
				hHero:AddItemByName("item_smithy_pickaxe")
			end
		end
	end
end

local creepDict = {
    [0] = {mini = forest_mini, big = forest_big},
    [1] = {mini = village_mini, big = village_big},
    [2] = {mini = mines_mini, big = mines_big},
    [3] = {mini = dust_mini, big = dust_big},
    [4] = {mini = cemetery_mini, big = cemetery_big},
    [5] = {mini = swamp_mini, big = swamp_big},
    [6] = {mini = snow_mini, big = snow_big},
    [7] = {mini = last_mini, big = last_big},
    [8] = {mini = magma_mini, big = magma_big}
}

function check_trigger_actiate()
	local triggerName = thisEntity:GetName()
	local point = "point_donate_creeps_"..string.sub(triggerName, -1)

	if _G.kill_invoker then 
		spawn_creeps(point, "farm_zone_dragon", "farm_zone_dragon")
		return
	end

    if creepDict[_G.don_spawn_level] then
        local levelCreeps = creepDict[_G.don_spawn_level]
        local mini_creep = levelCreeps.mini[RandomInt(1, #levelCreeps.mini)]
        local big_creep = levelCreeps.big[RandomInt(1, #levelCreeps.big)]
        spawn_creeps(point, mini_creep, big_creep)
    end
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
-------------------------- Gold Creep
---------------------------------------------------------------------------------------------------

ListenToGameEvent('npc_spawned', Dynamic_Wrap(creep_spawner, "GoldCreeps"), creep_spawner)	
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
	["magma_creep_1"]=true,
	["magma_creep_2"]=true,
	["farm_zone_dragon"]=true,
}

---------------------------------------------------------------------------------------------------
-------------------------- function ot fix lag when new location open
---------------------------------------------------------------------------------------------------
_G.CreateUnitByName_WithoutLags_UnitsTable = {}
function StartSpawnSchedule()
	Timers:CreateTimer(1,function()
		if _G.CreateUnitByName_WithoutLags_UnitsTable[1] then
			--Get params to spawn from table
			local UnitName = _G.CreateUnitByName_WithoutLags_UnitsTable[1]["unitName"]
			local vLocation = _G.CreateUnitByName_WithoutLags_UnitsTable[1]["vLocation"]
			local bFindClearSpace = _G.CreateUnitByName_WithoutLags_UnitsTable[1]["bFindClearSpace"]
			local team = _G.CreateUnitByName_WithoutLags_UnitsTable[1]["team"]

			local unit = CreateUnitByName(UnitName, vLocation, bFindClearSpace, nil, nil, team)
			add_modifier_death(unit, UnitName)
			Rules:difficality_modifier(unit)

			table.remove(_G.CreateUnitByName_WithoutLags_UnitsTable, 1)
		end
		return FrameTime() * 5
	end)
end

function CreateUnitByName_WithoutLags(unitName, vLocation, bFindClearSpace, npcOwner, entityOwner, team)
	table.insert( _G.CreateUnitByName_WithoutLags_UnitsTable, {unitName = unitName, vLocation = vLocation, bFindClearSpace = bFindClearSpace, team = team})
end
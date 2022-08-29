require("data/data")

item_boss_summon = class({})

--------------------------------------------------------------------------------
_G.donate_bosses_count = {}

function item_boss_summon:OnSpellStart()
		self.caster = self:GetCaster()	
		local forest = Entities:FindByName( nil, "forest_dummy" )
		local village = Entities:FindByName( nil, "village_dummy" )
		local mines = Entities:FindByName( nil, "mines_dummy" )
		local dust = Entities:FindByName( nil, "dust_dummy" )
		local cemetery = Entities:FindByName( nil, "cemetery_dummy" )
		local snow = Entities:FindByName( nil, "snow_dummy" )
		
		if _G.donate_spawn_level == 0 then 
			boss_spawn = "npc_forest_boss_fake"
		end
		if _G.donate_spawn_level == 1 then 
			boss_spawn = "npc_forest_boss_fake"
		end
		if _G.donate_spawn_level == 2 then 
			boss_spawn = "npc_village_boss_fake"
		end
		if _G.donate_spawn_level == 3 then 
			boss_spawn = "npc_mines_boss_fake"	
		end
		if _G.donate_spawn_level == 4 then 
			boss_spawn = "npc_dust_boss_fake"
		end
		if _G.donate_spawn_level == 5 then  
			boss_spawn = "npc_swamp_boss_fake"
		end
		if _G.donate_spawn_level == 6 then  
			boss_spawn = "npc_snow_boss_fake"
		end
		if _G.donate_spawn_level >= 7 then  
			boss_spawn = "npc_boss_location8_fake"
		end

		if boss_spawn ~= nil then
			local point = Entities:FindByName( nil, "point_boss" ):GetAbsOrigin()
			if #_G.donate_bosses_count < 5 then
				local unit = CreateUnitByName( boss_spawn, point + RandomVector( RandomInt( 0, 150 )), true, nil, nil, DOTA_TEAM_BADGUYS )
				table.insert(_G.donate_bosses_count, unit)
				self:add_items(unit)	
				donate_modifier(unit)
				self.caster:RemoveItem(self)
			end
	end
end

function item_boss_summon:add_items(unit)	
	if unit:GetUnitName() == "npc_forest_boss_fake" or unit:GetUnitName() == "npc_village_boss_fake" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_1[RandomInt(1,#items_level_1)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end
	
	if unit:GetUnitName() == "npc_mines_boss_fake" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_2[RandomInt(1,#items_level_2)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end

	if unit:GetUnitName() == "npc_dust_boss_fake" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_3[RandomInt(1,#items_level_3)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end

	if unit:GetUnitName() == "npc_swamp_boss_fake" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_4[RandomInt(1,#items_level_4)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end

	if unit:GetUnitName() == "npc_snow_boss_fake" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_5[RandomInt(1,#items_level_5)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end

	if unit:GetUnitName() == "npc_boss_location8_fake" then
		b1 = 0
		while b1 < 5 do
			add_item = items_level_6[RandomInt(1,#items_level_6)]
			while not unit:HasItemInInventory(add_item) do
				b1 = b1 + 1
				unit:AddItemByName(add_item)
			end
		end
	end	
end

LinkLuaModifier( "modifier_easy", "abilities/difficult/easy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_normal", "abilities/difficult/normal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hard", "abilities/difficult/hard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ultra", "abilities/difficult/ultra", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_insane", "abilities/difficult/insane", LUA_MODIFIER_MOTION_NONE )

function donate_modifier(unit)
	if diff_wave.wavedef == "Easy" then
		unit:AddNewModifier(unit, nil, "modifier_easy", {})
	end
	if diff_wave.wavedef == "Normal" then
		unit:AddNewModifier(unit, nil, "modifier_normal", {})
	end
	if diff_wave.wavedef == "Hard" then
		unit:AddNewModifier(unit, nil, "modifier_hard", {})
	end	
	if diff_wave.wavedef == "Ultra" then
		unit:AddNewModifier(unit, nil, "modifier_ultra", {})
	end	
	if diff_wave.wavedef == "Insane" then
		unit:AddNewModifier(unit, nil, "modifier_insane", {})
		new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
		unit:AddAbility(new_abil_passive):SetLevel(4)
	end		
end	
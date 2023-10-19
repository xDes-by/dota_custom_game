require("data/data")

item_boss_summon = class({})

--------------------------------------------------------------------------------
_G.don_bosses_count = {}

local bossTable = {
    [0] = "npc_forest_boss_fake",
    [1] = "npc_forest_boss_fake",
    [2] = "npc_village_boss_fake",
    [3] = "npc_mines_boss_fake",
    [4] = "npc_dust_boss_fake",
    [5] = "npc_swamp_boss_fake",
    [6] = "npc_snow_boss_fake",
    [7] = "npc_boss_location8_fake"
    -- [8] = "npc_boss_magma_fake"
}

local itemsTable = {
    ["npc_forest_boss_fake"] = items_level_1,
    ["npc_village_boss_fake"] = items_level_1,
    ["npc_mines_boss_fake"] = items_level_2,
    ["npc_dust_boss_fake"] = items_level_3,
    ["npc_swamp_boss_fake"] = items_level_4,
    ["npc_snow_boss_fake"] = items_level_5,
    ["npc_boss_location8_fake"] = items_level_6
    ["npc_boss_magma_fake"] = items_level_7  -- добавить items_level_7 в файл data
}

function item_boss_summon:OnSpellStart()
		local boss_spawn = bossTable[_G.don_spawn_level]
		if boss_spawn then
			local point = Entities:FindByName(nil, "point_donate_creeps_"..self:GetCaster():GetPlayerID()):GetAbsOrigin()
			if #_G.don_bosses_count < 5 then
				local unit = CreateUnitByName(boss_spawn, point + RandomVector(RandomInt(0, 150)), true, nil, nil, DOTA_TEAM_BADGUYS)
				table.insert(_G.don_bosses_count, unit)
				self:add_items(unit)
				unit:AddNewModifier(unit, nil, "modifier_hp_regen_boss", {})
				Rules:difficality_modifier(unit)
	
				if self:GetCurrentCharges() > 1 then
					self:SetCurrentCharges(self:GetCurrentCharges() - 1)
				else
					self:GetCaster():RemoveItem(self)
				end
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


LinkLuaModifier( "modifier_item_boss_summon_cd", "items/boss_summon", LUA_MODIFIER_MOTION_NONE )
modifier_item_boss_summon_cd = class({})
function modifier_item_boss_summon_cd:IsHidden() return true end
function modifier_item_boss_summon_cd:IsDebuff() return false end
function modifier_item_boss_summon_cd:IsPurgable() return false end
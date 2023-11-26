LinkLuaModifier( "modifier_item_boss_summon_cd", "items/boss_summon", LUA_MODIFIER_MOTION_NONE )
modifier_item_boss_summon_cd = class({})
function modifier_item_boss_summon_cd:IsHidden() return false end
function modifier_item_boss_summon_cd:IsDebuff() return false end
function modifier_item_boss_summon_cd:IsPurgable() return false end

if not IsServer() then
	require("creep_spawner")
end

item_boss_summon = class({})

--------------------------------------------------------------------------------
_G.don_bosses_count = {}

local bossTable = {
    [0] = "npc_forest_boss_fake",
    [1] = "npc_forest_boss_fake",
    [2] = "npc_village_boss_fake",
    [3] = "npc_mines_boss_fake",
    [4] = "npc_dust_boss_fake",
    [5] = "npc_cemetery_boss_fake",
    [6] = "npc_swamp_boss_fake",
    [7] = "npc_snow_boss_fake",
    [8] = "npc_boss_location8_fake",
    [9] = "npc_boss_magma_fake"
}

function item_boss_summon:OnSpellStart()
	if #_G.don_bosses_count < 5 then
		print(self:GetCaster():GetCooldownReduction())
		print(self:GetCooldown(self:GetLevel()))
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( self:GetCaster():GetPlayerID() ), "item_boss_summon_panorama", {
			spawn_level = _G.don_spawn_level,
		} )
		self.caster = self:GetCaster()
		local duration = self:GetCooldown(self:GetLevel())* self.caster:GetCooldownReduction()
		local cd = self.caster:AddNewModifier(self.caster, self, "modifier_item_boss_summon_cd", {duration = duration})
		cd:SetDuration(duration, true)
		if self:GetCurrentCharges() > 1 then
			self:SetCurrentCharges(self:GetCurrentCharges() - 1)
		else
			self:GetCaster():RemoveItem(self)
		end
	end

	-- local boss_spawn = bossTable[_G.don_spawn_level]
	-- if boss_spawn then
	-- 	local point = Entities:FindByName(nil, "point_donate_creeps_"..self:GetCaster():GetPlayerID()):GetAbsOrigin()
	-- 	if #_G.don_bosses_count < 5 then
	-- 		local unit = CreateUnitByName(boss_spawn, point + RandomVector(RandomInt(0, 150)), true, nil, nil, DOTA_TEAM_BADGUYS)
	-- 		table.insert(_G.don_bosses_count, unit)
	-- 		unit:add_items()
	-- 		unit:AddNewModifier(unit, nil, "modifier_hp_regen_boss", {})
	-- 		Rules:difficality_modifier(unit)

	-- 		if self:GetCurrentCharges() > 1 then
	-- 			self:SetCurrentCharges(self:GetCurrentCharges() - 1)
	-- 		else
	-- 			self:GetCaster():RemoveItem(self)
	-- 		end
	-- 	end
	-- end
end



-- local bossTable = {
--     [1] = "npc_forest_boss_fake",
--     [2] = "npc_forest_boss_fake",
--     [3] = "npc_village_boss_fake",
--     [4] = "npc_mines_boss_fake",
--     [5] = "npc_dust_boss_fake",
--     [6] = "npc_cemetery_boss_fake",
--     [7] = "npc_swamp_boss_fake",
--     [8] = "npc_snow_boss_fake",
--     [9] = "npc_boss_location8_fake",
--     [10] = "npc_boss_magma_fake"
-- }

-- function item_boss_summon:OnSpellStart()
-- 	local boss_spawn = bossTable[self:GetAbility():GetName()]
-- 	if boss_spawn then
-- 		local point = Entities:FindByName(nil, "point_donate_creeps_"..self:GetCaster():GetPlayerID()):GetAbsOrigin()
-- 		if #_G.don_bosses_count < 5 then
-- 			local unit = CreateUnitByName(boss_spawn, point + RandomVector(RandomInt(0, 150)), true, nil, nil, DOTA_TEAM_BADGUYS)
-- 			table.insert(_G.don_bosses_count, unit)
-- 			unit:add_items()
-- 			unit:AddNewModifier(unit, nil, "modifier_hp_regen_boss", {})
-- 			Rules:difficality_modifier(unit)

-- 			if self:GetCurrentCharges() > 1 then
-- 				self:SetCurrentCharges(self:GetCurrentCharges() - 1)
-- 			else
-- 				self:GetCaster():RemoveItem(self)
-- 			end
-- 		end
-- 	end
-- end

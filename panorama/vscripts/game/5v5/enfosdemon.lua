if EnfosDemon == nil then EnfosDemon = class({}) end

EnfosDemon.upgrade_data = require("game/5v5/demon_upgrade_data")

LinkLuaModifier("modifier_enfos_demon_armor", "creatures/abilities/5v5/modifier_enfos_demon_bonuses", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_demon_as", "creatures/abilities/5v5/modifier_enfos_demon_bonuses", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_demon_ms", "creatures/abilities/5v5/modifier_enfos_demon_bonuses", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_demon_mr", "creatures/abilities/5v5/modifier_enfos_demon_bonuses", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_demon_damage_block", "creatures/abilities/5v5/modifier_enfos_demon_bonuses", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_demon_status_resist", "creatures/abilities/5v5/modifier_enfos_demon_bonuses", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_demon_damage_mitigation", "creatures/abilities/5v5/modifier_enfos_demon_bonuses", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_demon_attack_range", "creatures/abilities/5v5/modifier_enfos_demon_bonuses", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_demon_elite_bonus", "creatures/abilities/5v5/modifier_enfos_demon_bonuses", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_demon_evasion", "creatures/abilities/5v5/modifier_enfos_demon_bonuses", LUA_MODIFIER_MOTION_NONE)

function EnfosDemon:Spawn()
	self.upgrades = {}

	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		self.upgrades[team] = {}

		for _, category in pairs(self.upgrade_data.categories) do
			self.upgrades[team][category] = {}
			self.upgrades[team][category].level = 0
		end
	end

	self.demons = {}
	self.demons[DOTA_TEAM_GOODGUYS] = CreateUnitByName("npc_enfos_demon", Entities:FindByName(nil, "radiant_demon"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
	self.demons[DOTA_TEAM_BADGUYS] = CreateUnitByName("npc_enfos_demon", Entities:FindByName(nil, "dire_demon"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)

	local forward_vector = RotatePosition(Vector(1, 0, 0), QAngle(0, 300, 0), Vector(100, 0, 0)):Normalized()

	for _, unit in pairs(self.demons) do
		unit:SetAbsOrigin(unit:GetAbsOrigin() + Vector(0, 0, 60))
		unit:SetForwardVector(forward_vector)
	end

	CustomNetTables:SetTableValue("game", "enfos_demon_upgrades", self.upgrades)
end

function EnfosDemon:GetDemon(team)
	return self.demons[team]
end

function EnfosDemon:GetUpgradeLevel(team, category)
	return self.upgrades[team][category].level
end

function EnfosDemon:UpgradeCategory(team, category)
	self.upgrades[team][category].level = self.upgrades[team][category].level + 1

	CustomNetTables:SetTableValue("game", "enfos_demon_upgrades", self.upgrades)
end

function EnfosDemon:UpgradeRandomCategory(team)
	local candidates = {}
	local min_level = 999

	for category, info in pairs(self.upgrades[team]) do
		if category ~= "elite_power" then
			if info.level < min_level then
				min_level = info.level

				if next(candidates) then
					candidates = {}
				end
			end

			if info.level == min_level then
				table.insert(candidates, category)
			end
		end
	end

	self:UpgradeCategory(team, table.random(candidates))
end

function EnfosDemon:GetEliteSpawnInterval(team)
	return ENFOS_ELITE_SPAWN_INTERVAL
end

function EnfosDemon:GetEliteAbilityLevel(team)
	return 1 + self:GetUpgradeLevel(team, "elite_power")
end

local function mul_stack(value, level)
	return 1 - ((1 - value) ^ level)
end

local function exp_stack(value, level)
	return (1 + value) ^ level
end

function EnfosDemon:GetBonusDamageMultiplier(team)
	local damage_bonus = exp_stack(ENFOS_DEMON_DAMAGE_BONUS, self:GetUpgradeLevel(team, "damage"))
	return damage_bonus
end

function EnfosDemon:GetBonusHealthMultiplier(team)
	local health_bonus = exp_stack(ENFOS_DEMON_HEALTH_BONUS, self:GetUpgradeLevel(team, "health"))
	return health_bonus
end

function EnfosDemon:GetBonusArmor(team)
	local armor_bonus = ENFOS_DEMON_ARMOR_BONUS * self:GetUpgradeLevel(team, "armor") 
	return armor_bonus
end

function EnfosDemon:GetBonusMoveSpeed(team)
	local move_speed_bonus = ENFOS_DEMON_MOVE_SPEED_BONUS * self:GetUpgradeLevel(team, "boots")
	return move_speed_bonus
end

function EnfosDemon:GetBonusMagicResistance(team)
	local magic_resist = mul_stack(ENFOS_DEMON_MAGIC_RESISTANCE_BONUS, self:GetUpgradeLevel(team, "magic_resist"))
	return magic_resist * 100
end

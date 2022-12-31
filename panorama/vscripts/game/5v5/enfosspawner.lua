if EnfosSpawner == nil then EnfosSpawner = class(Spawner) end

ENFOS_ROUND_DURATION = 20
ENFOS_ELITE_SPAWN_INTERVAL = 8

local creep_color_table = {
	[0] = Vector(255, 255, 255), --default color
	[1] = Vector(102, 255, 102), -- Light green
	[2] = Vector(102, 178, 255), -- Light Blue
	[3] = Vector(255, 128, 0), -- Orange
	[4] = Vector(255, 255, 102), -- Yellow
	[5] = Vector(0, 153, 0), -- Green
	[6] = Vector(0, 0, 255), -- Blue
	[7] = Vector(255, 0, 0), -- Red
	[8] = Vector(178, 102, 255), -- Purple
	[9] = Vector(0, 0, 0) -- Black
}

function EnfosSpawner:InitializeSpawnPoints()
	self.spawn_points = {}
	self.spawn_points[DOTA_TEAM_GOODGUYS] = {}

	table.insert(self.spawn_points[DOTA_TEAM_GOODGUYS], {
		path_start = Entities:FindByName(nil, "radiant_left_path_1"),
		position = Entities:FindByName(nil, "radiant_left_spawn"):GetAbsOrigin()
	})
	table.insert(self.spawn_points[DOTA_TEAM_GOODGUYS], {
		path_start = Entities:FindByName(nil, "radiant_right_path_1"),
		position = Entities:FindByName(nil, "radiant_right_spawn"):GetAbsOrigin()
	})

	self.spawn_points[DOTA_TEAM_BADGUYS] = {}

	table.insert(self.spawn_points[DOTA_TEAM_BADGUYS], {
		path_start = Entities:FindByName(nil, "dire_left_path_1"),
		position = Entities:FindByName(nil, "dire_left_spawn"):GetAbsOrigin()
	})
	table.insert(self.spawn_points[DOTA_TEAM_BADGUYS], {
		path_start = Entities:FindByName(nil, "dire_right_path_1"),
		position = Entities:FindByName(nil, "dire_right_spawn"):GetAbsOrigin()
	})
end

function EnfosSpawner:Init(round, team)

	self.round = round
	self.round_number = round.round_number
	self.team = team
	self.round_data = round.round_data
	self.is_boss_round = round.is_boss_round
	self.creep_color = creep_color_table[math.min(9, math.floor((self.round_number - 1) / #Enfos.round_creeps))]
	self.spawn_count = round.spawn_count
	self.elite_ability_level = EnfosDemon:GetEliteAbilityLevel(Enfos.enemy_team[team])
	self.spawn_interval = ENFOS_ROUND_DURATION / (self.spawn_count - 1)
	self.current_spawn = 1
	self.paused = false
	local objective = Enfos.team_objectives[self.team]

	-- Calculate unit stats
	local effective_round = math.min(300, self.round_number)

	self.creep_health = math.floor(Enfos.round_stats.health[effective_round] * EnfosDemon:GetBonusHealthMultiplier(Enfos.enemy_team[team]))
	self.elite_health = 2 * self.creep_health
	self.min_creep_damage = math.floor(Enfos.round_stats.damage[effective_round] * EnfosDemon:GetBonusDamageMultiplier(Enfos.enemy_team[team]))
	self.min_elite_damage = 1.25 * self.min_creep_damage
	self.max_creep_damage = math.floor(1.2 * self.min_creep_damage)
	self.max_elite_damage = math.floor(1.2 * self.min_elite_damage)
	self.bat = Enfos.round_stats.bat[effective_round]
	self.bonus_as = Enfos.round_stats.as[effective_round]
	self.bonus_armor = Enfos.round_stats.armor[effective_round]
	self.damage_reduction = Enfos.round_stats.damage_reduction[effective_round]

	-- Other demon-based bonuses
	self.elite_spawn_interval = EnfosDemon:GetEliteSpawnInterval(Enfos.enemy_team[team])
	self.first_elite_spawn = math.floor(0.5 * self.elite_spawn_interval)
	self.bonus_armor = self.bonus_armor + EnfosDemon:GetBonusArmor(Enfos.enemy_team[team])
	self.bonus_ms = EnfosDemon:GetBonusMoveSpeed(Enfos.enemy_team[team])
	self.bonus_mr = EnfosDemon:GetBonusMagicResistance(Enfos.enemy_team[team])

	-- In boss rounds, all creeps are bosses
	if self.is_boss_round then
		self.elite_spawn_interval = 1
		self.first_elite_spawn = 0
	end

	local total_gold_bounty = Enfos.round_stats.gold_bounty[effective_round]
	local total_exp_bounty = Enfos.round_stats.xp_bounty[effective_round]

	-- The math below amounts to: number of creeps in a round, x2 for each elite (since elites grant x2 rewards)
	-- It ensures total round gold/exp rewards are the same no matter how many elites spawn
	local effective_creeps = math.floor(self.spawn_count / self.elite_spawn_interval)
	effective_creeps = effective_creeps + (((self.spawn_count % self.elite_spawn_interval) >= self.first_elite_spawn and 1) or 0)
	effective_creeps = self.spawn_count + effective_creeps
	effective_creeps = effective_creeps * 2

	self.gold_bounty = math.floor(total_gold_bounty / effective_creeps)
	self.xp_bounty = math.ceil(total_exp_bounty / effective_creeps)

	-- Start spawning units
	Timers:CreateTimer(0, function()

		if self.paused then return 0.1 end

		if GameMode:GetTeamState(self.team) == TEAM_STATE_DEFEATED then
			self.round:SpawnerFinished(self.team)
			return
		end

		-- The math below amounts to: the [self.first_elite_spawn]th creep is an elite, then after that another elite is spawned every self.elite_spawn_interval creeps
		-- e.g. if self.first_elite_spawn = 5 and self.elite_spawn_interval = 10 then elites will spawn instead of the 5th, 15th, 25th... etc. creeps 
		local is_elite = (self.current_spawn % self.elite_spawn_interval == self.first_elite_spawn)

		local unit_name = (is_elite and self.round_data.elite_creep) or self.round_data.basic_creep

		for _, spawn_point in pairs(self.spawn_points[self.team]) do

			local unit = CreateUnitByName(unit_name, spawn_point.position, true, nil, nil, DOTA_TEAM_NEUTRALS)
--			print("Create unit:", unit_name)
			unit:SetForwardVector(Vector(0, -1, 0))
			--unit:SetInitialGoalEntity(spawn_point.path_start)
			--unit:SetMustReachEachGoalEntity(false)

			-- Force units to move to portal after 90 seconds
			unit.objective = objective
			unit:AddNewModifier(unit, nil, "modifier_enfos_creep_run", { duration = 90 })

--			print("MoveToPositionAgressive:", unit:GetUnitName())
			Timers:CreateTimer(0.5, function()
				if unit and (not unit:IsNull()) then unit:MoveToPositionAggressive(objective) end
			end)

			unit.spawner_team = self.team
			unit:SetRenderColor(self.creep_color.x, self.creep_color.y, self.creep_color.z)
			self:CreaturePowerUp(unit, is_elite)

			if is_elite then unit:AddNewModifier(unit, nil, "modifier_creature_true_sight", {}) end

			self:PlayPortalSpawnEffects(unit, spawn_point.position)

			table.insert(Enfos.current_creeps[self.team], unit)
			Enfos:UpdateCreepCount(self.team)

			-- If this team is overflowing, teleport the creeps directly to the end portal
			if Enfos:GetCreepCount(self.team) >= ENFOS_MAX_CREEPS then
				FindClearSpaceForUnit(unit, objective + Vector(0, -250, 0), true)
			end
		end

		if self.current_spawn >= self.spawn_count then
			self.round:SpawnerFinished(self.team)
			self:Finish()
		else
			self.current_spawn = self.current_spawn + 1
			return self.spawn_interval
		end
	end)
end

function EnfosSpawner:CreaturePowerUp(unit, is_elite)
--	print("EnfosSpawner:CreaturePowerUp:", unit, is_elite)
	-- Adjust stats
	local creep_health = (is_elite and self.elite_health) or self.creep_health	
	local min_damage = (is_elite and self.min_elite_damage) or self.min_creep_damage	
	local max_damage = (is_elite and self.max_elite_damage) or self.max_creep_damage
	local gold_bounty = self.gold_bounty
	local xp_bounty = self.xp_bounty
	local bat = self.bat

	if is_elite then
		gold_bounty = 2 * gold_bounty
		xp_bounty = 2 * xp_bounty
		unit.is_elite = true
	end

	-- Avoid integer overflow and lategame lag
	creep_health = math.min(creep_health, 10 * ROUND_MANAGER_CREEP_STATS_CAP)
	min_damage = math.min(min_damage, ROUND_MANAGER_CREEP_STATS_CAP)
	max_damage = math.min(max_damage, ROUND_MANAGER_CREEP_STATS_CAP)

	unit:CreatureLevelUp(self.round_number - 1)
	unit:SetBaseMaxHealth(creep_health)
	unit:SetMaxHealth(creep_health)
	unit:SetHealth(creep_health)
	unit:SetBaseDamageMin(min_damage)
	unit:SetBaseDamageMax(max_damage)
	unit:SetBaseAttackTime(bat)

	-- Level up abilities
	for index = 0, 9 do
		local ability = unit:GetAbilityByIndex(index)
		if ability then
			ability:SetLevel(math.min(self.elite_ability_level, ability:GetMaxLevel()))
		end
	end

	-- Set up bounties
--	print("Setup bounties:", gold_bounty, xp_bounty)
	unit:AddNewModifier(unit, nil, "modifier_enfos_creep_stats", {gold_bounty = gold_bounty, xp_bounty = xp_bounty})

	-- Add other bonuses
	if is_elite then unit:AddNewModifier(unit, nil, "modifier_enfos_demon_elite_bonus", {}) end
	if self.damage_reduction > 0 then unit:AddNewModifier(unit, nil, "modifier_enfos_demon_damage_mitigation", {value = self.damage_reduction}) end
	if self.bonus_armor > 0 then unit:AddNewModifier(unit, nil, "modifier_enfos_demon_armor", {value = self.bonus_armor}) end
	if self.bonus_as > 0 then unit:AddNewModifier(unit, nil, "modifier_enfos_demon_as", {value = self.bonus_as}) end
	if self.bonus_ms > 0 then unit:AddNewModifier(unit, nil, "modifier_enfos_demon_ms", {value = self.bonus_ms}) end
	if self.bonus_mr > 0 then unit:AddNewModifier(unit, nil, "modifier_enfos_demon_mr", {value = self.bonus_mr}) end
end

function EnfosSpawner:SetPaused(paused)
	self.paused = paused
end

-- Clean up this spawner
function EnfosSpawner:Finish()

	-- Send event to other modules telling them this round has "ended"
	-- Only works with a few modules, mainly to keep abilities that depend on round end functional
	EventDriver:Dispatch("Spawner:all_creeps_killed", {
		team = self.team,
		round = self.round_number,
		is_boss = self.is_boss_round,
	})

	-- self.round = nil
	-- self.round_number = nil
	-- self.team = nil
	-- self.round_data = nil
	-- self.is_boss_round = nil
	-- self.creep_color = nil
	-- self.spawn_count = nil
	-- self.elite_ability_level = nil
	-- self.spawn_interval = nil
	-- self.current_spawn = nil
	-- self.paused = nil

	-- self.creep_health = nil
	-- self.elite_health = nil
	-- self.min_creep_damage = nil
	-- self.min_elite_damage = nil
	-- self.max_creep_damage = nil
	-- self.max_elite_damage = nil
	-- self.bat = nil
	-- self.gold_bounty = nil
	-- self.xp_bounty = nil

	-- self.elite_spawn_interval = nil
	-- self.first_elite_spawn = nil
	-- self.bonus_armor = nil
	-- self.bonus_as = nil
	-- self.bonus_ms = nil
	-- self.bonus_mr = nil
	-- self.bonus_damage_block = nil
	-- self.bonus_status_resist = nil
	-- self.bonus_damage_mitigation = nil
	-- self.bonus_attack_range = nil
	-- self.bonus_accuracy = nil
	-- self.bonus_evasion = nil

	-- self = nil
end

function EnfosSpawner:PlayPortalSpawnEffects(unit, position)
	EmitSoundOnLocationWithCaster(position, "Enfos.CreepPortalSpawn", unit)

	local spawn_pfx = ParticleManager:CreateParticle("particles/5v5/custom/teleport_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, unit)
	ParticleManager:SetParticleControl(spawn_pfx, 0, position)
	ParticleManager:SetParticleControl(spawn_pfx, 1, position)
	ParticleManager:SetParticleControl(spawn_pfx, 2, Vector(167, 75, 213))
	ParticleManager:SetParticleControl(spawn_pfx, 11, Vector(0, 1, 0))
	ParticleManager:ReleaseParticleIndex(spawn_pfx)
end

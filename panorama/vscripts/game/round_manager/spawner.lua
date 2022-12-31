if Spawner == nil then Spawner = class({}) end


function Spawner:Init(team, round, start_delay)

	-- Basic data
	self.team = team
	self.round = round
	self.round_number = self.round:GetRoundNumber()
	self.round_name = self.round:GetRoundName()
	self.totem_name = self.round:GetTotemName()
	self.is_boss_round = self.round:IsBossRound()
	self.spawn_count = self.round:GetSpawnCount()
	self.spawn_interval = math.min(math.max(0.03, ROUND_MANAGER_CREEP_SPAWN_TIME / self.spawn_count), ROUND_MANAGER_MAX_CREEP_SPAWN_INTERVAL)
	self.creep_bounty = 11 + math.ceil(0.33 * self.round:GetGoldBounty() / self.spawn_count)

	self.round_spawn_data = RoundManager:GetRoundData(self.round_name)
	self.original_tier = self.round_spawn_data.tier
	self.spawn_color = ROUND_MANAGER_WAVE_COLORS[math.min(9, math.max(0, math.ceil(self.round_number / ROUND_MANAGER_ROUNDS_PER_TIER) - self.original_tier))]

	-- Creep tracking
	self.current_totems = {}
	self.current_creeps = {}

	self.current_spawn = 0
	self.creeps_killed = 0
	self.summon_count = 0
	self.all_creeps_killed = false

	self.max_health_unit = nil

	-- Spawn geometry
	self.spawn_origin = GameMode.enemy_spawn_points[self.team]
	self.front_direction = (GameMode.arena_centers[self.team] - self.spawn_origin):Normalized()
	self.side_direction = RotatePosition(Vector(0, 0, 0), QAngle(0, 90, 0), self.front_direction)

	-- State variables
	self.extra_spawns_allowed = true
	self.preventing_round_end = false
	self.speed_up = false

	-- Creep health tracking (used for some rounds)
	self.uses_health_based_tracking = ROUND_MANAGER_HEALTH_TRACKING_ROUNDS[self.round_name]
	self.total_creep_health = 0
	self.creep_health_tracking_multiplier = 1

	-- Prevents overflow and potential clientside lag due to large numbers
	if GameRules.health_table[self.round_number] then
		self.creep_health_tracking_multiplier = 10 / GameRules.health_table[self.round_number]
	end

	-- True sight creep counter
	self.true_sight_creeps = math.floor(self.round_number / ROUND_MANAGER_ROUNDS_PER_TRUESIGHT_CREEP)

	-- Monster modifier-based scaling
	self.first_boost_step = math.max(0, self.round_number - 10)
	self.second_boost_step = math.max(0, self.round_number - 30)
	self.boost = math.max(0, self.round_number - 40)

	self.armor_boost = 0.1 * self.first_boost_step + 0.5 * self.boost + 2 * math.max(0, self.boost - 100)
	self.magic_resist_boost = 75 * (1 - (0.985 ^ self.second_boost_step))
	self.status_resist_boost = 10 * math.ceil(self.boost / 10)
	self.attack_speed_boost = math.min(600, 3 * self.second_boost_step)
	self.spell_amp_boost = math.min(1000, 100 * (1.03 ^ self.boost - 1))
	self.move_speed_boost = math.min(80, self.boost)
	self.accuracy_boost = 10 * math.ceil(self.boost / 10)
	self.damage_reduction_boost = 8 * math.ceil(self.boost / 10)

	-- Listeners
	self.round_started_listener = EventDriver:Listen("Round:round_started", self.OnRoundStarted, self)

	-- Spawn round totem, if appropriate
	self.totem_spawning_timer = Timers:CreateTimer(start_delay, function()
		if RoundManager:IsTotemMap() then self:SpawnTotem() end
	end)

	-- Start spawns after a small delay, in order to stagger them
	self.creep_spawning_timer = Timers:CreateTimer(start_delay, function()

		self.current_spawn = self.current_spawn + 1
		local unit_data = self.round_spawn_data[self.current_spawn]

		if unit_data then
			local unit_name = unit_data.unit
			local unit_position = self:GetRelativeSpawnPosition(unit_data.x, unit_data.y)

			self:SpawnUnit(unit_name, unit_position, false)
		end

		if self.current_spawn < self.spawn_count then
			return (self.speed_up and 0.01) or self.spawn_interval
		else
			self.has_finished_spawning = true
		end
	end)
end

-- Returns a unit's world spawn position when it is defined by (x, y) coordinates in the round data KV.
function Spawner:GetRelativeSpawnPosition(x, y)
	return self.spawn_origin + x * self.side_direction + y * self.front_direction
end

-- Spawn this round's totem, if any.
function Spawner:SpawnTotem()
	local totem_location = GameMode.arena_centers[self.team]
	local center_offset = RoundManager.totem_center_offset[GetMapName()]

	if center_offset then totem_location = totem_location + center_offset end

	local totem = CreateUnitByName(self.totem_name, totem_location, true, nil, nil, DOTA_TEAM_NEUTRALS)

	totem:SetForwardVector(Vector(0, -1, 0))
	totem:AddNewModifier(totem, nil, "modifier_creature_pre_round_frozen", {})
	
	-- Register the totem (for floating tooltip purposes)
	CustomGameEventManager:Send_ServerToAllClients("totems:register", {
		entindex = totem:GetEntityIndex(),
		position_x = totem_location.x,
		position_y = totem_location.y,
		position_z = totem_location.z,
		index = self.team,
	})

	table.insert(self.current_totems, totem)
end

-- Spawns a unit on the provided location with the proper stats for the current round.
-- is_summon is true if this unit is being spawned *during* the round, instead of during its preparation phase.
function Spawner:SpawnUnit(unit_name, position, is_summon)
--	print("Spawner:SpawnUnit:", unit_name)

	local unit = CreateUnitByName(unit_name, position, true, nil, nil, DOTA_TEAM_NEUTRALS)
	self:CreaturePowerUp(unit, self.round_number)

	if not IsValidEntity(self.max_health_unit) then 
		self.max_health_unit = unit 
	elseif unit:GetMaxHealth() > self.max_health_unit:GetMaxHealth() then
		self.max_health_unit = unit
	end


	unit:SetRenderColor(self.spawn_color.x, self.spawn_color.y, self.spawn_color.z)
	unit:SetForwardVector(self.front_direction)

	-- Markers and modifiers
	unit.spawn_team = self.team
	unit.spawn_round = self.round
	if self.is_boss_round then unit.is_boss = true end

	if (not is_summon) then unit:AddNewModifier(unit, nil, "modifier_creature_pre_round_frozen", {}) end
	if TestMode.invulnerable_creeps then unit:AddNewModifier(unit, nil, "modifier_demo_creep_invulnerable", {}) end

	-- Handle true sight
	if self.true_sight_creeps > 0 then
		unit:AddNewModifier(unit, nil, "modifier_creature_true_sight", {})
		self.true_sight_creeps = self.true_sight_creeps - 1
	end

	-- Other stat boosts
	unit:AddNewModifier(unit, nil, "modifier_creature_empower", {
		boost = self.boost,
		armor_boost = self.armor_boost,
		magic_resist_boost = self.magic_resist_boost,
		status_resist_boost = self.status_resist_boost,
		attack_speed_boost = self.attack_speed_boost,
		spell_amp_boost = self.spell_amp_boost,
		move_speed_boost = self.move_speed_boost,
		accuracy_boost = self.accuracy_boost,
		damage_reduction_boost = self.damage_reduction_boost
	})

	-- Summon handling
	if is_summon then
		unit.is_summon = true

		unit:AddNewModifier(unit, nil, "modifier_creature_true_sight", {})

		if self:IsOvertimeActive() then
			local overtime_stacks = self:GetOvertimeStacks()
			local overtime_modifier = unit:AddNewModifier(unit, nil, "modifier_creature_berserk", {})
			if overtime_stacks and overtime_modifier then
				overtime_modifier:SetStackCount(overtime_stacks)
			end
		end
	end

	-- Track this unit's existence
	table.insert(self.current_creeps, unit)
--[[
	Timers:CreateTimer(1.0, function()
		print("--------------------------")
		print("Unit name:", unit:GetUnitName())
		for _, modifier in pairs(unit:FindAllModifiers()) do
			if modifier.GetName then
				print(modifier:GetName())
			end
		end

		return 1.0
	end)
--]]
	return unit
end

function Spawner:OnRoundStarted(keys)
	if self.round_started_listener then
		EventDriver:CancelListener("Round:round_started", self.round_started_listener)
	end

	self:RandomizeCreepCooldowns()
	self:ActivateCreeps(0.4)

	if self.uses_health_based_tracking then
		self:StartHealthBasedTracking()
	end
end

-- Puts creeps' abilities on a random amount of cooldown, in order for them not to use their abilities all at the same time.
-- Bosses use their abilities faster.
function Spawner:RandomizeCreepCooldowns()
	if not self.round then return end

	local ability_exceptions = {
		roshan_spell_block = true,
	}

	for _, creep in pairs(self.current_creeps) do
		if creep and (not creep:IsNull()) and creep:IsAlive() then
			for index = 0, (creep:GetAbilityCount() - 1) do
				local ability = creep:GetAbilityByIndex(index)
				if ability then
					local ability_cooldown = ability:GetCooldown(ability:GetLevel())
					if ability_cooldown and ability_cooldown > 0 and (not ability_exceptions[ability:GetAbilityName()]) then
						if self.is_boss_round then
							ability:StartCooldown(0.1 * RandomInt(0, 15))
						else
							ability:StartCooldown(0.1 * RandomInt(2, 5) * ability_cooldown)
						end
					end
				end
			end
		end
	end
end

function Spawner:StartHealthBasedTracking()
	if self.health_tracker_timer then
		Timers:RemoveTimer(self.health_tracker_timer)
	end
	self.health_tracker_timer = Timers:CreateTimer(0, function()
		CustomGameEventManager:Send_ServerToAllClients("UpdateTeamProgress", {
			teamId = self.team,
			max_value = self.total_creep_health,
			current_value = self.total_creep_health - self:GetCurrentTotalCreepHealth()
		})

		return 1
	end)
end

-- Returns the total (current) health of all alive creeps 
function Spawner:GetCurrentTotalCreepHealth()
	local current_health = 0

	for _, creep in pairs(self.current_creeps) do
		if creep and (not creep:IsNull()) and creep:IsAlive() then
			current_health = current_health + creep:GetHealth() * self.creep_health_tracking_multiplier
		end
	end

	return current_health
end

-- Kill monitor
function Spawner:OnEntityKilled(unit)
--	print("OnEntityKilled:", unit:GetUnitName(), unit.is_summon)
	-- Grant gold bounty to all players on team
	for _, player_id in pairs(GameMode.team_player_id_map[self.team]) do
		if (not unit.is_summon) then
			RoundManager:GiveGoldToPlayer(player_id, self.creep_bounty, self.round_number, ROUND_MANAGER_GOLD_SOURCE_CREEPS)
		end
	end

	-- Update round progress
	self.creeps_killed = self.creeps_killed + 1

	if (not self.uses_health_based_tracking) then
		CustomGameEventManager:Send_ServerToAllClients("UpdateTeamProgress", {teamId = self.team, max_value = self.spawn_count, current_value = self.creeps_killed})
	end

	-- End the round, if appropriate
	if self.creeps_killed >= (self.spawn_count + self.summon_count) and (not self:IsPreventingRoundEnd()) then
		self:Finish()
	end
end

-- Fires when all this spawner's creeps are defeated or spawner is interrupted forcibly for some other reason.
function Spawner:Finish()

	-- Clean up listeners and timers
	if self.health_tracker_timer then Timers:RemoveTimer(self.health_tracker_timer) end
	if self.totem_spawning_timer then Timers:RemoveTimer(self.totem_spawning_timer) end
	if self.creep_spawning_timer then Timers:RemoveTimer(self.creep_spawning_timer) end

	if self.round_started_listener then
		EventDriver:CancelListener("Round:round_started", self.round_started_listener)
	end

	-- Destroy any remaining units
	self:DestroyTotems()

	-- Update state vars
	self.extra_spawns_allowed = false
	self.preventing_round_end = false
	self.all_creeps_killed = true

	-- If this team is not alive anymore (should only happen during the first round), stop here
	if (not GameMode:IsTeamAlive(self.team)) then return end

	-- Figure out which position this team ended in, and the corresponding prize
	self.round:AddTeamToFinishPositions(self.team)
	self.team_finish_position = self.round:GetTeamFinishPosition(self.team)
	self.prize_gold = math.ceil(self.round:GetGoldBountyForPosition(self.team_finish_position))

	-- Level up the team's heroes
	for _, player_id in ipairs(GameMode.team_player_id_map[self.team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero and (not hero:IsNull()) then
			hero:HeroLevelUpWithMinValue(self.round_number, true)
		end
	end

	-- Announce team winnings
	local barrage_data = {}
	barrage_data.type = "round_finish"
	barrage_data.teamId = self.team
	barrage_data.order = self.team_finish_position
	barrage_data.player_name = ""
	barrage_data.gold_value = tostring(self.prize_gold)

	if GameMode:IsSoloMap() then barrage_data.type = "round_finish_solo" end

	-- Keep building barrage announcement
	for _, player_id in ipairs(GameMode.team_player_id_map[self.team]) do
		barrage_data.playerId = player_id
		barrage_data.player_name = barrage_data.player_name .. PlayerResource:GetPlayerName(player_id) .." "
		
		-- Grant each player gold and experience
		RoundManager:GiveGoldToPlayer(player_id, self.prize_gold, self.round_number, ROUND_MANAGER_GOLD_SOURCE_ROUND_PRIZE)
	end

	-- Make the announcements
	Barrage:FireBullet(barrage_data)

	-- Fire appropriate event to other modules
	EventDriver:Dispatch("Spawner:all_creeps_killed", {
		team = self.team,
		position = self.team_finish_position,
		prize_gold = self.prize_gold,
		round = self.round_number,
		round_name = self.round_name,
		is_boss = self.is_boss_round,
		duration = GameRules:GetGameTime() - self.round.start_time
	})

	CustomGameEventManager:Send_ServerToAllClients("TeamFinishRound", {
		teamId = self.team,
		gold = self.prize_gold,
		gametime = GameRules:GetGameTime() - 60,
		playerFinishedNumber = self.team_finish_position
	})
end

-- Update a creep's stats to match the power level of a certain round
function Spawner:CreaturePowerUp(unit, round)
	round = math.min(ROUND_MANAGER_MAX_CREEP_LEVEL, round)

	-- Health and damage
	local max_health = unit:GetMaxHealth() * GameRules.health_table[round]
	local min_damage = unit:GetBaseDamageMin() * GameRules.damage_table[round]
	local max_damage = unit:GetBaseDamageMax() * GameRules.damage_table[round]
	local bat = GameRules.bat_table[round]

	-- Mana
	if unit:GetMaxMana() > 0 then
		unit:AddNewModifier(unit, nil, "modifier_creature_extra_mana", {}):SetStackCount(200 * 2 ^ (math.ceil(round / 10) - 1) + 1)
		Timers:CreateTimer(0.1, function()
			unit:SetMana(unit:GetMaxMana())
		end)
	end

	if GetMapName() == "duos" then
		max_health = max_health * 1.5
		min_damage = min_damage * 1.08
		max_damage = max_damage * 1.08
	end

	-- Avoid integer overflow and lategame lag
	max_health = math.min(max_health, 10 * ROUND_MANAGER_CREEP_STATS_CAP)
	min_damage = math.min(min_damage, ROUND_MANAGER_CREEP_STATS_CAP)
	max_damage = math.min(max_damage, ROUND_MANAGER_CREEP_STATS_CAP)

	unit:SetBaseMaxHealth(max_health)
	unit:SetMaxHealth(max_health)
	unit:SetHealth(max_health)
	unit:SetBaseDamageMin(min_damage)
	unit:SetBaseDamageMax(max_damage)
	unit:SetBaseAttackTime(bat)

	-- Track health, if appropriate
	if self.uses_health_based_tracking then
		self.total_creep_health = self.total_creep_health + max_health * self.creep_health_tracking_multiplier
	end

	-- Level up abilities
	local max_ability_level = math.min(5, math.ceil(round / 10))
	for index = 0, 9 do
		local ability = unit:GetAbilityByIndex(index)
		if ability then
			ability:SetLevel(math.min(max_ability_level, ability:GetMaxLevel()))
		end
	end

	unit:AddNewModifier(unit, nil, "modifier_creature_level_indicator", {}):SetStackCount(max_ability_level)
end

-- Speeds up unit creation, since all players are marked as ready for the next round
function Spawner:SpeedUpSpawning()
	self.speed_up = true
end

-- Frees up creeps to move after a round starts
function Spawner:ActivateCreeps(delay)
	Timers:CreateTimer(delay, function()
		for _, creep in pairs(self.current_creeps) do
			if creep and (not creep:IsNull()) and creep:IsAlive() then
				creep:RemoveModifierByName("modifier_creature_pre_round_frozen")
			end
		end
	end)
end

-- Immediately stop spawning creeps. Normally only useful for debugging and demo mode.
function Spawner:ForceStop()
	if self.totem_spawning_timer then Timers:RemoveTimer(self.totem_spawning_timer) end
	if self.creep_spawning_timer then Timers:RemoveTimer(self.creep_spawning_timer) end
	if self.round_started_listener then EventDriver:CancelListener("Round:round_started", self.round_started_listener) end

	self.spawn_count = self.current_spawn

	self.summon_count = 0
	self.extra_spawns_allowed = false
	self.preventing_round_end = false
	self.has_finished_spawning = true
end

-- Force kills all currently alive creeps, while preventing any extra spawns
function Spawner:ForceDestroyCreeps()
	self:ForceStop()

	for _, creep in pairs(self.current_creeps) do
		if creep and (not creep:IsNull()) and creep:IsAlive() then
			creep:RemoveModifierByName("modifier_creature_pre_round_frozen")
			creep:RemoveModifierByName("modifier_demo_creep_invulnerable")

			creep:ForceKill(false)
		end
	end
end

-- Kills any currently spawned totems
function Spawner:DestroyTotems()
	for _, totem in pairs(self.current_totems) do
		if totem and (not totem:IsNull()) and totem:IsAlive() then
			totem:RemoveModifierByName("modifier_totem_base_state")
			totem:ForceKill(false)
			totem:Destroy()
		end
	end
end

-- If false, prevents creeps from spawning/summoning additional creeps this round
function Spawner:AreExtraSpawnsAllowed()
	return self.extra_spawns_allowed
end

function Spawner:SetExtraSpawnsAllowed(state)
	self.extra_spawns_allowed = state
end

function Spawner:IsPreventingRoundEnd()
	return self.preventing_round_end
end

function Spawner:SetPreventingRoundEnd(state)
	self.preventing_round_end = state
end

function Spawner:HasFinishedSpawning()
	return self.has_finished_spawning
end

-- Returns true if all of this spawner's creeps have been defeated
function Spawner:AreAllCreepsKilled()
	return self.all_creeps_killed
end

-- Returns true if this spawner's overtime buff is active
function Spawner:IsOvertimeActive()
	return self.round:IsOvertimeActive()
end

-- Returns the current amount of overtime stacks on this spawner
function Spawner:GetOvertimeStacks()
	return self.round:GetElapsedOvertime()
end

-- Grants creeps the overtime buff and stacks it up continuously.
function Spawner:StartOvertime()
	if self:IsOvertimeActive() or self.all_creeps_killed then return end

	local should_play_sound = true
	for _, creep in pairs(self.current_creeps) do
		if creep and (not creep:IsNull()) and creep:IsAlive() then
			creep:AddNewModifier(creep, nil, "modifier_creature_berserk", {})

			if should_play_sound then
				creep:EmitSound("CHC.FFA.Overtime")
				creep:EmitSound("CHC.FFA.Overtime2")
				should_play_sound = false
			end
		end
	end
end

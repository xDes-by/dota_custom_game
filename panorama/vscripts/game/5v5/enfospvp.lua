if EnfosPVP == nil then EnfosPVP = class(PvpManager) end

LinkLuaModifier("modifier_enfos_duel_creep_freeze", "creatures/abilities/5v5/modifier_enfos_duel_creep_freeze", LUA_MODIFIER_MOTION_NONE)

ENFOS_DUEL_INTERVAL = 30
ENFOS_SINGLE_DUEL_DURATION = 50
ENFOS_GROUP_DUEL_DURATION = 75

ENFOS_SOULS_BASE = 10
ENFOS_SOULS_PER_LEVEL = 1

function EnfosPVP:Init()
	self.player_spawns = {}

	self.player_spawns[DOTA_TEAM_GOODGUYS] = {}
	self.player_spawns[DOTA_TEAM_GOODGUYS].single = Entities:FindByName(nil, "pvp_single_spawn_radiant"):GetAbsOrigin()

	self.player_spawns[DOTA_TEAM_GOODGUYS].group = {}
	for _, group_spawn in pairs(Entities:FindAllByName("pvp_group_spawn_radiant")) do
		table.insert(self.player_spawns[DOTA_TEAM_GOODGUYS].group, group_spawn:GetAbsOrigin())
	end
	
	self.player_spawns[DOTA_TEAM_BADGUYS] = {}
	self.player_spawns[DOTA_TEAM_BADGUYS].single = Entities:FindByName(nil, "pvp_single_spawn_dire"):GetAbsOrigin()

	self.player_spawns[DOTA_TEAM_BADGUYS].group = {}
	for _, group_spawn in pairs(Entities:FindAllByName("pvp_group_spawn_dire")) do
		table.insert(self.player_spawns[DOTA_TEAM_BADGUYS].group, group_spawn:GetAbsOrigin())
	end

	self.single_arena_center = 0.5 * (self.player_spawns[DOTA_TEAM_GOODGUYS].single + self.player_spawns[DOTA_TEAM_BADGUYS].single)

	CreateUnitByNameAsync("npc_dummy", self.single_arena_center, false, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
		unit:AddNewModifier(unit, nil, "modifier_invisible_dummy_unit", {})
		self.single_arena_center_sound_dummy = unit
	end)

	self.group_arena_countdown_spots = {}
	self.group_arena_countdown_dummies = {}

	for _, group_countdown_spot in pairs(Entities:FindAllByName("pvp_countdown_location")) do
		table.insert(self.group_arena_countdown_spots, group_countdown_spot:GetAbsOrigin())
	end

	for _, countdown_location in pairs(self.group_arena_countdown_spots) do
		CreateUnitByNameAsync("npc_dummy", countdown_location, false, nil, nil, DOTA_TEAM_NEUTRALS, function(unit)
			unit:AddNewModifier(unit, nil, "modifier_invisible_dummy_unit", {})
			table.insert(self.group_arena_countdown_dummies, unit)
		end)
	end

	self.rune_spawns = {}

	self.rune_spawns.group = {}
	for _, rune_spawn in pairs(Entities:FindAllByName("pvp_group_spawn_rune")) do
		table.insert(self.rune_spawns.group, rune_spawn:GetAbsOrigin())
	end

	self.rune_spawns.single = {}
	for _, rune_spawn in pairs(Entities:FindAllByName("pvp_single_spawn_rune")) do
		table.insert(self.rune_spawns.single, rune_spawn:GetAbsOrigin())
	end

	self.duel_runes = {
		DOTA_RUNE_DOUBLEDAMAGE,
		DOTA_RUNE_HASTE,
		DOTA_RUNE_ILLUSION,
		DOTA_RUNE_ARCANE
	}

	self.current_pvp_teams = {DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS}
	self.current_pvp_players = {}
	self.pvp_history = {}

	-- Set up listeners
	self.kill_listener = ListenToGameEvent("dota_player_killed", Dynamic_Wrap(EnfosPVP, "OnHeroKilled"), EnfosPVP)

	RegisterCustomEventListener("RequestDuelInfoReconnect", function(keys) EnfosPVP:RebuildDuelUI(keys) end)

	EventDriver:Listen("GameMode:team_defeated", EnfosPVP.OnTeamDefeated, EnfosPVP)
end

function EnfosPVP:OnTeamDefeated(event)
	self.prevent_pvp = true

	if EnfosPVP:IsTeamDueling(event.team) then
		EnfosPVP:FinishDuelWithWinner(Enfos.enemy_team[event.team])
	end
end

function EnfosPVP:Start()
	self.current_pvp_players = {}
	self.current_pvp_players[DOTA_TEAM_GOODGUYS] = {}
	self.current_pvp_players[DOTA_TEAM_BADGUYS] = {}

	EnfosPVP:ReindexTeams()

	self.next_matchups = {}
	self:GenerateSingleMatchups()

	self.next_single_match = 1

	self:PrepareNextRound()
end

function EnfosPVP:ReindexTeams()
	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		for _, player_id in pairs(GameMode.team_player_id_map[team]) do
			-- Player must have hero to participate in duels
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero and not table.contains(self.current_pvp_players[team] or {}, player_id) then
				table.insert(self.current_pvp_players[team], player_id)
			end
		end
	end
end

function EnfosPVP:GenerateSingleMatchups()
	EnfosPVP:ReindexTeams()
	local radiant_players = table.shuffle(self.current_pvp_players[DOTA_TEAM_GOODGUYS])
	local dire_players = table.shuffle(self.current_pvp_players[DOTA_TEAM_BADGUYS])

	for i = 1, 5 do
		if #radiant_players > 0 and #dire_players > 0 then
			self.next_matchups[i] = {}
			table.insert(self.next_matchups[i], table.remove(radiant_players))
			table.insert(self.next_matchups[i], table.remove(dire_players))
		end
	end
end

function EnfosPVP:PrepareNextRound()
	if self.prevent_pvp then return end

	if self.next_matchups[self.next_single_match] then
		self:PrepareSingleMatch(self.next_matchups[self.next_single_match][1], self.next_matchups[self.next_single_match][2])
		self.next_single_match = self.next_single_match + 1
	else
		self:PrepareGroupMatch()
		self:GenerateSingleMatchups()
		self.next_single_match = 1
	end
end

function EnfosPVP:PrepareSingleMatch(radiant_id, dire_id)
	CustomGameEventManager:Send_ServerToAllClients("enfos_pvp_countdown_single", {time = ENFOS_DUEL_INTERVAL, radiant_id = radiant_id, dire_id = dire_id})

	Timers:CreateTimer(ENFOS_DUEL_INTERVAL, function()
		if self.prevent_pvp then return end
		self:StartSingleMatch(radiant_id, dire_id)
	end)
end

function EnfosPVP:StartSingleMatch(radiant_id, dire_id)
	CustomGameEventManager:Send_ServerToAllClients("enfos_pvp_start_single", {time = ENFOS_SINGLE_DUEL_DURATION, radiant_id = radiant_id, dire_id = dire_id})

	GameMode:SetModeState(GAME_STATE_ENFOS_PVP_SINGLE)

	local radiant_hero = PlayerResource:GetSelectedHeroEntity(radiant_id)
	local dire_hero = PlayerResource:GetSelectedHeroEntity(dire_id)

	self.dueling_heroes = {}
	self.dueling_heroes[DOTA_TEAM_GOODGUYS] = {radiant_hero}
	self.dueling_heroes[DOTA_TEAM_BADGUYS] = {dire_hero}

	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		for _, hero in pairs(self.dueling_heroes[team]) do

			self:MoveHeroToDuelArena(hero)

			hero.previous_gold = hero:GetGold()

			-- hero:SetRespawnsDisabled(true)

			hero:EmitSound("CHC.Duel")

			Timers:CreateTimer(3, function()
				hero:StopSound("CHC.Duel")
				hero:EmitSound("CHC.Overwhelming.Location")
			end)
		end
	end

	-- Duel start and countdown effect
	local countdown = 3

	local pvp_start_pfx = ParticleManager:CreateParticle("particles/custom/duel_start_ring_big.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(pvp_start_pfx, 0, GetGroundPosition(self.single_arena_center, nil))
	ParticleManager:SetParticleControl(pvp_start_pfx, 7, GetGroundPosition(self.single_arena_center, nil))

	local countdown_pfx = ParticleManager:CreateParticle("particles/custom/duel_overhead_countdown.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(countdown_pfx, 0, self.single_arena_center)
	ParticleManager:SetParticleControl(countdown_pfx, 1, Vector(0, countdown, 0))

	Timers:CreateTimer(1, function()
		countdown = countdown - 1
		ParticleManager:SetParticleControl(countdown_pfx, 1, Vector(0, countdown, 0))

		if countdown > 0 then
			return 1
		else
			ParticleManager:DestroyParticle(countdown_pfx, false)
			ParticleManager:ReleaseParticleIndex(countdown_pfx)

			ParticleManager:DestroyParticle(pvp_start_pfx, false)
			ParticleManager:ReleaseParticleIndex(pvp_start_pfx)

			if self.current_pvp_teams and #self.current_pvp_teams > 0 then
				EventDriver:Dispatch("PvpManager:pvp_countdown_ended", {
					teams = self.current_pvp_teams,
				})
			end
		end
	end)

	self.runes = {}

	for _, rune_spot in pairs(self.rune_spawns.single) do
		table.insert(self.runes, CreateRune(rune_spot, self.duel_runes[RandomInt(1, #self.duel_runes)]))
	end

	for _, rune in pairs(self.runes) do rune:SetModelScale(1.4) end

	self.duel_timer = Timers:CreateTimer(ENFOS_SINGLE_DUEL_DURATION, function()
		self:ForceDuelEnd()
	end)
end

function EnfosPVP:PrepareGroupMatch()
	CustomGameEventManager:Send_ServerToAllClients("enfos_pvp_countdown_group", {time = ENFOS_DUEL_INTERVAL})

	Timers:CreateTimer(ENFOS_DUEL_INTERVAL, function()
		if self.prevent_pvp then return end
		self:StartGroupMatch()
	end)
end

function EnfosPVP:StartGroupMatch()
	CustomGameEventManager:Send_ServerToAllClients("enfos_pvp_start_group", {time = ENFOS_GROUP_DUEL_DURATION})

	GameMode:SetModeState(GAME_STATE_ENFOS_PVP_TEAM)

	self:FreezeCreeps()
	--GameRules:SetHeroRespawnEnabled(false)

	self.dueling_heroes = {}

	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		self.dueling_heroes[team] = {}

		for _, player_id in pairs(self.current_pvp_players[team]) do

			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			table.insert(self.dueling_heroes[team], hero)

			hero.previous_gold = hero:GetGold()

			-- hero:SetRespawnsDisabled(true)
		end

		self:MoveTeamToDuelArena(team)
	end

	-- Duel start and countdown effect
	local countdown = 3

	local countdown_pfx = {}
	for i, countdown_location in pairs(self.group_arena_countdown_spots) do
		countdown_pfx[i] = ParticleManager:CreateParticle("particles/custom/duel_overhead_countdown.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(countdown_pfx[i], 0, countdown_location)
		ParticleManager:SetParticleControl(countdown_pfx[i], 1, Vector(0, countdown, 0))
	end

	for _, dummy in pairs(self.group_arena_countdown_dummies) do
		dummy:EmitSound("CHC.Duel")

		Timers:CreateTimer(countdown, function()
			dummy:StopSound("CHC.Duel")
			dummy:EmitSound("CHC.Overwhelming.Location")

			EventDriver:Dispatch("PvpManager:pvp_countdown_ended", {
				teams = self.current_pvp_teams,
			})
		end)
	end

	Timers:CreateTimer(1, function()
		countdown = countdown - 1

		for _, pfx in pairs(countdown_pfx) do
			ParticleManager:SetParticleControl(pfx, 1, Vector(0, countdown, 0))
		end

		if countdown > 0 then
			return 1
		else
			for _, pfx in pairs(countdown_pfx) do
				ParticleManager:DestroyParticle(pfx, false)
				ParticleManager:ReleaseParticleIndex(pfx)
			end
		end
	end)

	self.runes = {}

	for _, rune_spot in pairs(self.rune_spawns.group) do
		table.insert(self.runes, CreateRune(rune_spot, self.duel_runes[RandomInt(1, #self.duel_runes)]))
	end

	for _, rune in pairs(self.runes) do rune:SetModelScale(1.4) end

	self.duel_timer = Timers:CreateTimer(ENFOS_GROUP_DUEL_DURATION, function()
		self:ForceDuelEnd()
	end)
end

function EnfosPVP:OnHeroKilled(keys)
	local player_id = keys.PlayerID

	if (not player_id) then return end

	local killed_hero = PlayerResource:GetSelectedHeroEntity(player_id)
	local killed_team = killed_hero:GetTeam()

	if Enfos:IsPvpActive() and table.contains(self.dueling_heroes[killed_team], killed_hero) then

		-- Reincarnation isn't a real "death"
		if killed_hero:IsReincarnating() then
			killed_hero:SetTimeUntilRespawn(3)
			return
		end

		-- Make sure heroes don't respawn during team duel
		if Enfos:IsGroupPvpActive() then
			killed_hero:SetTimeUntilRespawn(ENFOS_GROUP_DUEL_DURATION)
			EnfosDemon:UpgradeRandomCategory(Enfos.enemy_team[killed_team])
		end

		if (not self:TeamHasAliveDuelist(killed_team)) then
			for _, hero in pairs(self.dueling_heroes[Enfos.enemy_team[killed_team]]) do
				if IsValidEntity(hero) and hero:IsAlive() then
					hero:AddNewModifier(hero, nil, "modifier_invuln", {duration = 0.1})
					hero:Heal(hero:GetMaxHealth(), nil)
					hero:GiveMana(hero:GetMaxMana())
					hero:Purge(false, true, false, true, true)
					hero:InterruptMotionControllers(true)
					ProjectileManager:ProjectileDodge(hero)
				end
			end

			Timers:CreateTimer(0.1, function()
				self:FinishDuelWithWinner(Enfos.enemy_team[killed_team])
			end)
		end
	else
		if killed_hero:IsReincarnating() then
			killed_hero:SetTimeUntilRespawn(3)
		else
			if GameMode:GetTeamState(killed_team) == TEAM_STATE_DEFEATED then
				killed_hero:SetTimeUntilRespawn(99999)
			else
				killed_hero:SetTimeUntilRespawn(math.min(ENFOS_RESPAWN_TIME_MAX, ENFOS_RESPAWN_TIME_BASE + killed_hero:GetLevel() * ENFOS_RESPAWN_TIME_PER_LEVEL))
			end
		end
	end
end

-- Returns true if at least one player in this team is alive *or* reincarnating.
function EnfosPVP:TeamHasAliveDuelist(team)
	for _, hero in pairs(EnfosPVP.dueling_heroes[team]) do
		if hero:IsAlive() or hero:IsReincarnating() then
			return true
		end
	end

	return false
end

function EnfosPVP:ForceDuelEnd()
	local radiant_alive = self:TeamHasAliveDuelist(DOTA_TEAM_GOODGUYS)
	local dire_alive = self:TeamHasAliveDuelist(DOTA_TEAM_BADGUYS)

	if radiant_alive and (not dire_alive) then
		self:FinishDuelWithWinner(DOTA_TEAM_GOODGUYS)
	elseif dire_alive and (not radiant_alive) then
		self:FinishDuelWithWinner(DOTA_TEAM_BADGUYS)

	-- Both teams alive, break tie using lives
	else
		local team_lives = {}
		local team_health = {}

		for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
			team_lives[team] = 0
			team_health[team] = 0

			for _, hero in pairs(self.dueling_heroes[team]) do
				if hero:IsAlive() then
					team_lives[team] = team_lives[team] + 1
					team_health[team] = team_health[team] + hero:GetHealthPercent()
				end
			end
		end

		if team_lives[DOTA_TEAM_GOODGUYS] > team_lives[DOTA_TEAM_BADGUYS] then
			self:FinishDuelWithWinner(DOTA_TEAM_GOODGUYS)
		elseif team_lives[DOTA_TEAM_BADGUYS] > team_lives[DOTA_TEAM_GOODGUYS] then
			self:FinishDuelWithWinner(DOTA_TEAM_BADGUYS)

		-- Both teams have the same amount of heroes alive, break tie using health
		else
			if team_health[DOTA_TEAM_GOODGUYS] > team_health[DOTA_TEAM_BADGUYS] then
				self:FinishDuelWithWinner(DOTA_TEAM_GOODGUYS)
			elseif team_health[DOTA_TEAM_BADGUYS] > team_health[DOTA_TEAM_GOODGUYS] then
				self:FinishDuelWithWinner(DOTA_TEAM_BADGUYS)

			-- Both teams have the same amount of health, tie the duel
			else
				self:FinishDuelWithWinner(nil)
			end
		end
	end
end

function EnfosPVP:FinishDuelWithWinner(winner_team)
	if self.duel_timer then 
		Timers:RemoveTimer(self.duel_timer)
		self.duel_timer = nil
	else
		-- To prevent duel end twise if hero killed right before duel force ended (due to timer in EnfosPVP:OnHeroKilled)
		return
	end

	for _, rune in pairs(self.runes) do
		if (not rune:IsNull()) then rune:Destroy() end
	end

	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		if Enfos:IsGroupPvpActive() then self:ReturnTeamToBase(team) end

		if self.dueling_heroes and self.dueling_heroes[team] then
			for _, hero in pairs(self.dueling_heroes[team]) do
				local player_id = hero:GetPlayerID()
				local player = PlayerResource:GetPlayer(player_id)
				local previous_gold = (hero and hero.previous_gold) or 0
				if player then History:AddDuelLine(player_id, {prize = hero:GetGold() - previous_gold}) end

				hero.previous_gold = nil

				if Enfos:IsSinglePvpActive() then self:ReturnHeroToBase(hero) end

				hero:SetRespawnsDisabled(false)
			end
		end
	end

	if (not winner_team) then
		winner_team = RandomInt(DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS)
	end

	if Enfos:IsGroupPvpActive() then
		self:UnfreezeCreeps()
		--GameRules:SetHeroRespawnEnabled(true)

		self:PlayGroupVictoryEffects(winner_team)

		EnfosWizard:GrantWinnerBuff(winner_team)

		self:UpdateGroupDuelRecords(winner_team)

		for _, location in pairs(self.group_arena_countdown_spots) do
			CleanSparkWraith(location, 2500)
			CleanTreantEyes(location, 2500)
		end

		ProgressTracker:EventTriggered("CUSTOM_EVENT_DUEL_WON", {team = winner_team})

		EnfosDemon:UpgradeCategory(winner_team, "elite_power")
	end

	if Enfos:IsSinglePvpActive() then
		local winner_hero = self.dueling_heroes[winner_team][1]
		local loser_hero = self.dueling_heroes[Enfos.enemy_team[winner_team]][1]

		if winner_hero and (not winner_hero:IsNull()) then
			self:PlayVictoryEffects(winner_hero)
			ProgressTracker:EventTriggered("CUSTOM_EVENT_DUEL_WON", {hero = winner_hero})
		end

		local winner_player_id = winner_hero:GetPlayerOwnerID()
		local winner_record = CustomNetTables:GetTableValue("pvp_record", tostring(winner_player_id)) or {}
		winner_record.win = (winner_record.win and winner_record.win + 1) or 1
		CustomNetTables:SetTableValue("pvp_record", tostring(winner_player_id), winner_record)

		local loser_player_id = loser_hero:GetPlayerOwnerID()
		local winner_record = CustomNetTables:GetTableValue("pvp_record", tostring(loser_player_id)) or {}
		winner_record.win = (winner_record.win and winner_record.win + 1) or 1
		CustomNetTables:SetTableValue("pvp_record", tostring(loser_player_id), winner_record)

		CleanSparkWraith(self.single_arena_center, 3000)
		CleanTreantEyes(self.single_arena_center, 3000)

		EnfosDemon:UpgradeRandomCategory(winner_team)

		if winner_hero:HasAbility("innate_duelist") then
			EnfosDemon:UpgradeRandomCategory(winner_team)
		end
	end

	self.dueling_heroes = {}
	GameMode:SetModeState(GAME_STATE_ENFOS_PVE)

	CustomGameEventManager:Send_ServerToAllClients("enfos_pvp_end", {winner = winner_team})

	Summon:EnfosKillPvpSummons()
	EnfosPVP:PrepareNextRound()

	-- Tell the other modules that the duel has ended
	EventDriver:Dispatch("PvpManager:pvp_ended", {
		winner_team = winner_team,
		loser_team = Enfos.enemy_team[winner_team],
	})
end

function EnfosPVP:UpdateGroupDuelRecords(winner_team)
	local loser_team = Enfos.enemy_team[winner_team]

	for _, player_id in pairs(GameMode.team_player_id_map[winner_team]) do
		local winner_record = CustomNetTables:GetTableValue("pvp_record", tostring(player_id)) or {}
		winner_record.win = (winner_record.win and winner_record.win + 1) or 1
		CustomNetTables:SetTableValue("pvp_record", tostring(player_id), winner_record)
	end

	for _, player_id in ipairs(GameMode.team_player_id_map[loser_team]) do
		local loser_record = CustomNetTables:GetTableValue("pvp_record", tostring(player_id)) or {}
		loser_record.lose = (loser_record.lose and loser_record.lose + 1) or 1
		CustomNetTables:SetTableValue("pvp_record", tostring(player_id), loser_record)
	end
end

function EnfosPVP:RefreshHero(hero)
	if (not hero:IsAlive()) then hero:RespawnHero(false, false) end

	Util:RefreshAbilityAndItem(hero, {
		item_refresher = true,
	})

	hero:SetHealth(hero:GetMaxHealth())
	hero:SetMana(hero:GetMaxMana())
end

function EnfosPVP:FreezeCreeps()
	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		if Enfos:GetCurrentRound().has_started then 
			local spawner = Enfos:GetCurrentRound().spawners[team]

			if spawner then
				spawner:SetPaused(true)
			end
		end

		for _, unit in pairs(Enfos.current_creeps[team]) do
			unit:AddNewModifier(unit, nil, "modifier_enfos_duel_creep_freeze", {})
		end
	end
end

function EnfosPVP:UnfreezeCreeps()
	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		if Enfos:GetCurrentRound().has_started then Enfos:GetCurrentRound().spawners[team]:SetPaused(false) end

		for _, unit in pairs(Enfos.current_creeps[team]) do
			unit:RemoveModifierByName("modifier_enfos_duel_creep_freeze")
		end
	end
end

function EnfosPVP:MoveHeroToDuelArena(hero, override_location, override_facing)
	local player_id = hero:GetPlayerID()
	local player = PlayerResource:GetPlayer(player_id)
	local team = hero:GetTeam()
	local spawn_point = override_location or self.player_spawns[team].single
	local facing_target = self.player_spawns[Enfos.enemy_team[team]].single
	local forward_vector = override_facing or (facing_target - spawn_point):Normalized()

	if (not hero:IsAlive()) then hero:RespawnHero(false, false) end

	-- Save hero's original position
	hero.original_position = hero:GetAbsOrigin()
	hero:SetHealth(hero:GetMaxHealth())
	hero:SetMana(hero:GetMaxMana())

	-- Clean up movement modifiers
	Util:RemoveMovementModifiers(hero)
	ProjectileManager:ProjectileDodge(hero)

	-- Set proper duel/pve modifiers and state
	hero:RemoveModifierByName("modifier_hero_fighting_pve")
	hero:RemoveModifierByName("modifier_lifestealer_infest_caster")
	hero:RemoveModifierByName("modifier_creature_armor_reduction_boost")
	hero:AddNewModifier(hero, nil, "modifier_hero_dueling", {})

	-- Flush timelapse modifier to prevent teleporting outside arena
	local modifier_timelapse = hero:FindModifierByName("modifier_weaver_timelapse")
	if modifier_timelapse then
		local timelapse = modifier_timelapse:GetAbility()
		modifier_timelapse:Destroy()
		hero:AddNewModifier(hero, timelapse, "modifier_weaver_timelapse", nil)
	end

	-- Teleport the hero and any summon
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hero)

	GameMode:SetPlayerState(player_id, PLAYER_STATE_ENFOS_SINGLE_PVP)

	FindClearSpaceForUnit(hero, spawn_point, false)
	hero:SetForwardVector(forward_vector)

	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	hero:EmitSound("DOTA_Item.BlinkDagger.Activate")

	Summon:TeleportSummonsToHero(hero, SUMMON_DESTINATION_PVP, nil)

	-- Adjust player camera
	if player then
		Camera:SetCameraToPosition(player, spawn_point)
	end

	-- Make sure the hero is really where we want them to be
	Timers:CreateTimer(0.1, function()
		local target_distance = (hero:GetAbsOrigin() - spawn_point):Length()
		if target_distance > 1500 then
			FindClearSpaceForUnit(hero, spawn_point, false)
			return 0.1
		end
	end)
end

function EnfosPVP:MoveTeamToDuelArena(team)
	local destinations = table.shallowcopy(EnfosPVP.player_spawns[team].group)
	local facing = ((team == DOTA_TEAM_GOODGUYS) and Vector(100, 0, 0)) or Vector(-100, 0, 0)

	for _, player_id in pairs(self.current_pvp_players[team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		EnfosPVP:MoveHeroToDuelArena(hero, table.remove(destinations), facing)
	end
end

function EnfosPVP:ReturnHeroToBase(hero, override_position)
	local player_id = hero:GetPlayerID()
	local player = PlayerResource:GetPlayer(player_id)
	local team = hero:GetTeam()
	local destination = override_position or hero.original_position

	self:RefreshHero(hero)

	-- Clean up movement modifiers
	Util:RemoveMovementModifiers(hero)
	ProjectileManager:ProjectileDodge(hero)

	hero:Purge(false, true, false, true, true)

	for _, modifier_name in pairs(HeroBuilder.fountain_removed_modifiers) do
		for __, modifier in pairs(hero:FindAllModifiersByName(modifier_name)) do
			modifier:Destroy()
		end
	end

	-- Set proper duel/pve modifiers and state
	hero:RemoveModifierByName("modifier_innate_rend_tear")
	hero:RemoveModifierByName("modifier_hero_dueling")
	hero:RemoveModifierByName("modifier_lifestealer_infest_caster")
	hero:AddNewModifier(hero, nil, "modifier_hero_fighting_pve", {})

	-- Teleport the hero and any summon
	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, hero)

	GameMode:SetPlayerState(player_id, PLAYER_STATE_ON_BASE)

	FindClearSpaceForUnit(hero, destination, false)
	hero:SetForwardVector(Vector(0, -100, 0))

	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
	hero:EmitSound("DOTA_Item.BlinkDagger.Activate")

	Summon:TeleportSummonsToHero(hero, SUMMON_DESTINATION_PVE, nil)

	hero:AddNewModifier(hero, nil, "modifier_aegis_buff_invul", {duration = 3.5})
	hero:AddNewModifier(hero, nil, "modifier_silence_mute", { duration = 1 })

	-- Adjust player camera
	if player then
		Camera:SetCameraToPosition(player, destination)
	end

	-- Make sure the hero is really where we want them to be
	Timers:CreateTimer(0.1, function()
		local target_distance = (hero:GetAbsOrigin() - destination):Length()
		if target_distance > 1500 then
			FindClearSpaceForUnit(hero, destination, false)
			return 0.1
		end
	end)
end

function EnfosPVP:ReturnTeamToBase(team)
	local backup_destinations = table.shallowcopy(GameMode.team_fountain_spawn_points[team])

	for _, player_id in pairs(self.current_pvp_players[team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if (not hero) or (not hero.original_position) then
			EnfosPVP:ReturnHeroToBase(hero, table.remove(backup_destinations))
		else
			EnfosPVP:ReturnHeroToBase(hero)
		end
	end
end


function EnfosPVP:IsPlayerDueling(team_number, player_id)
	if not self.dueling_heroes then return false end
	if not self.dueling_heroes[team_number] then return false end
	for _, hero in pairs(self.dueling_heroes[team_number]) do
		if hero:GetPlayerID() == player_id then return true end
	end
	return false
end


function EnfosPVP:IsTeamDueling(team_number)
	if not self.dueling_heroes then return false end
	if not self.dueling_heroes[team_number] then return false end
	return #self.dueling_heroes[team_number] > 1  -- more then 1 player from team in duel list == group duel
end

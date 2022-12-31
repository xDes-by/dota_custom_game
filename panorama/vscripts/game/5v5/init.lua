Enfos = Enfos or class({})

ENFOS_MAX_ROUND = 300
ENFOS_MAX_CREEPS = 80
ENFOS_STARTING_LIVES = (IsInToolsMode() and 50) or 50
ENFOS_ELITE_LIVES = 3
ENFOS_BOSS_LIVES = 3
ENFOS_RESPAWN_TIME_BASE = 10
ENFOS_RESPAWN_TIME_PER_LEVEL = 0.75
ENFOS_RESPAWN_TIME_MAX = 50

-- Unit arena-based position enum, used with npc:GetEnfosArena()
ENFOS_ARENA_RADIANT = 1
ENFOS_ARENA_PVP = 2
ENFOS_ARENA_DIRE = 3

ENFOS_ARENA_CENTER = {
	[DOTA_TEAM_GOODGUYS] = Vector(-7168, -1344, 0),
	[DOTA_TEAM_BADGUYS] = Vector(7168, -1344, 0),
	["PVP_TEAM"] = Vector(0, 1920, 0),
	["PVP_SOLO"]= Vector(0, -4736, 0)
}

--[[
local arena_size = Vector(-2624, -5568, 0)
ENFOS_ARENA_BOUNDS_MINS = {
	[DOTA_TEAM_GOODGUYS] = ENFOS_ARENA_CENTER[DOTA_TEAM_GOODGUYS] - arena_size,
	[DOTA_TEAM_BADGUYS] = ENFOS_ARENA_CENTER[DOTA_TEAM_GOODGUYS] - arena_size,
	["PVP_TEAM"] = ENFOS_ARENA_CENTER["PVP_TEAM"] - Vector(1856, 1344, 0),
	["PVP_SOLO"] = ENFOS_ARENA_CENTER["PVP_SOLO"] - Vector(1664, 1408, 0)
}


ENFOS_ARENA_BOUNDS_MAXS = {
	[DOTA_TEAM_GOODGUYS] = ENFOS_ARENA_CENTER[DOTA_TEAM_GOODGUYS] + arena_size,
	[DOTA_TEAM_BADGUYS] = ENFOS_ARENA_CENTER[DOTA_TEAM_GOODGUYS] + arena_size,
	["PVP_TEAM"] = ENFOS_ARENA_CENTER["PVP_TEAM"] + Vector(1856, 1344, 0),
	["PVP_SOLO"] = ENFOS_ARENA_CENTER["PVP_SOLO"] + Vector(1664, 1408, 0)
}
]]

Enfos.round_stats = require("game/5v5/round_stats")
Enfos.round_creeps = require("game/5v5/round_creeps")

require("game/5v5/enfosround")
require("game/5v5/enfosspawner")
require("game/5v5/enfospvp")
require("game/5v5/enfosdemon")
require("game/5v5/enfoswizard")
require("game/5v5/enfostreasury")

LinkLuaModifier("modifier_enfos_high_ground", "creatures/abilities/5v5/modifier_enfos_high_ground", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_shrine_cdr", "creatures/abilities/5v5/modifier_enfos_shrine_cdr", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_creep_stats", "creatures/abilities/5v5/modifier_enfos_creep_stats", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_portal", "creatures/abilities/5v5/modifier_enfos_portal_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_portal_thinker", "creatures/abilities/5v5/modifier_enfos_portal_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_creep_portal_thinker", "creatures/abilities/5v5/modifier_enfos_creep_portal_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_creep_portal_reached", "creatures/abilities/5v5/modifier_enfos_creep_portal_thinker", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enfos_creep_run", "creatures/abilities/5v5/modifier_enfos_creep_run", LUA_MODIFIER_MOTION_NONE)

function Enfos:Init()

	-- Enfo-specific settings
	GameRules:GetGameModeEntity():DisableClumpingBehaviorByDefault(true)
	GameRules:SetHeroRespawnEnabled(true)

	-- Creep tracking
	self.current_creeps = {}
	self.current_creeps[DOTA_TEAM_GOODGUYS] = {}
	self.current_creeps[DOTA_TEAM_BADGUYS] = {}

	self.enfos_entity_killed_listener = ListenToGameEvent("entity_killed", Dynamic_Wrap(Enfos, 'OnEntityKilled'), self)

	self.enemy_team = {}
	self.enemy_team[DOTA_TEAM_GOODGUYS] = DOTA_TEAM_BADGUYS
	self.enemy_team[DOTA_TEAM_BADGUYS] = DOTA_TEAM_GOODGUYS
	self.spent_enfos_spent_currency = { mana = {}, souls = {} }
	for player_id = 0, 24 do
		self.spent_enfos_spent_currency.mana[player_id] = 0
		self.spent_enfos_spent_currency.souls[player_id] = 0
	end

	-- Initialize submodules
	EnfosRound:InitializeRounds()
	EnfosSpawner:InitializeSpawnPoints()
	EnfosPVP:Init()
	EnfosTreasury:Init()
	EnfosDemon:Spawn()
	EnfosWizard:Spawn()
	AI_Enfos:Init()

	-- Spawn portals
	self.team_objectives = {}
	self.team_objectives[DOTA_TEAM_GOODGUYS] = Entities:FindByName(nil, "radiant_enemy_objective"):GetAbsOrigin()
	self.team_objectives[DOTA_TEAM_BADGUYS] = Entities:FindByName(nil, "dire_enemy_objective"):GetAbsOrigin()
	
	self:SpawnCreepObjectives()
	self:SpawnPortals()
	self:UpdateShrines()

	-- Keep track of team lives
	self.team_lives = {}
	self.team_lives[DOTA_TEAM_GOODGUYS] = ENFOS_STARTING_LIVES
	self.team_lives[DOTA_TEAM_BADGUYS] = ENFOS_STARTING_LIVES

	CustomNetTables:SetTableValue("game", "enfos_lives", {lives = self.team_lives})
	CustomNetTables:SetTableValue("game", "enfos_creeps_radiant", {count = self:GetCreepCount(DOTA_TEAM_GOODGUYS)})
	CustomNetTables:SetTableValue("game", "enfos_creeps_dire", {count = self:GetCreepCount(DOTA_TEAM_BADGUYS)})

	CustomGameEventManager:RegisterListener("team_panels:get_spent_enfos_currency", Dynamic_Wrap(Enfos, 'GetSpentEnfosCurrency'))

	EventDriver:Listen("GameMode:team_defeated", Enfos.OnTeamDefeated, Enfos)

	RevealArenaOf(DOTA_TEAM_GOODGUYS)
	RevealArenaOf(DOTA_TEAM_BADGUYS)
	RevealDuelArenas()
end

function Enfos:OnTeamDefeated(event)
	Timers:CreateTimer(1, function()
		for player_id = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
			if PlayerResource:GetTeam(player_id) == event.team then
				GameMode:TrueKill(player_id)
				
				local hero = PlayerResource:GetSelectedHeroEntity(player_id)
				
				if hero then
					hero:SetRespawnsDisabled(true)
					hero:SetTimeUntilRespawn(99999)
				end
			end
		end
	end)

	local team_creeps = table.clone(self.current_creeps[event.team])
	for _,creep in pairs(team_creeps) do
		creep:ForceKill(false)
	end
end

function RevealArenaOf(team, for_team) 
	if not for_team then for_team = team end

	AddFOWViewer(for_team, ENFOS_ARENA_CENTER[team] + Vector(0,3000,9999), 9999, 99999, false)
	AddFOWViewer(for_team, ENFOS_ARENA_CENTER[team] + Vector(0,-3000,9999), 9999, 99999, false)
end

function RevealDuelArenas()
	AddFOWViewer(DOTA_TEAM_GOODGUYS, ENFOS_ARENA_CENTER["PVP_TEAM"], 2500, 99999, false)
	AddFOWViewer(DOTA_TEAM_GOODGUYS, ENFOS_ARENA_CENTER["PVP_SOLO"], 2500, 99999, false)

	AddFOWViewer(DOTA_TEAM_BADGUYS, ENFOS_ARENA_CENTER["PVP_TEAM"], 2500, 99999, false)
	AddFOWViewer(DOTA_TEAM_BADGUYS, ENFOS_ARENA_CENTER["PVP_SOLO"], 2500, 99999, false)
end

function Enfos:StartGame()
	EnfosTreasury:Start()
	EnfosWizard:Start()
	EnfosPVP:Start()
end


function Enfos:UpdateShrines()
	local shrines = Entities:FindAllByClassname("npc_dota_healer")
	
	for _, shrine in pairs(shrines) do
		local old_ability = shrine:FindAbilityByName("filler_ability")
		if old_ability and not old_ability:IsNull() then old_ability:RemoveSelf() end
		local new_ability = shrine:AddAbility("enfos_shrine_aura")
		new_ability:SetLevel(1)
	end
end

function Enfos:SpawnCreepObjectives()
	local radiant_location = self.team_objectives[DOTA_TEAM_GOODGUYS]
	local dire_location = self.team_objectives[DOTA_TEAM_BADGUYS]

	local radiant_thinker = CreateUnitByName("npc_dota_thinker", radiant_location, false, nil, nil, DOTA_TEAM_NEUTRALS)
	local dire_thinker = CreateUnitByName("npc_dota_thinker", dire_location, false, nil, nil, DOTA_TEAM_NEUTRALS)

	radiant_thinker:AddNewModifier(radiant_thinker, nil, "modifier_enfos_creep_portal_thinker", {x = radiant_location.x, y = radiant_location.y, z = radiant_location.z})
	dire_thinker:AddNewModifier(dire_thinker, nil, "modifier_enfos_creep_portal_thinker", {x = dire_location.x, y = dire_location.y, z = dire_location.z})
end

function Enfos:SpawnPortals()
	self.portals = {}
	self.portals.radius = 128

	for i = 1, 4 do
		self.portals[i] = {}
		self.portals[i].entry = Entities:FindByName(nil, "portal_in_"..i):GetAbsOrigin()
		self.portals[i].exit = Entities:FindByName(nil, "portal_out_"..i):GetAbsOrigin()

		local portal_thinker_entry = CreateUnitByName("npc_dota_thinker", self.portals[i].entry, false, nil, nil, DOTA_TEAM_NEUTRALS)
		local portal_thinker_exit = CreateUnitByName("npc_dota_thinker", self.portals[i].exit, false, nil, nil, DOTA_TEAM_NEUTRALS)

		portal_thinker_entry:AddNewModifier(portal_thinker_entry, nil, "modifier_enfos_portal_thinker", {
			in_x = self.portals[i].entry.x, in_y = self.portals[i].entry.y, in_z = self.portals[i].entry.z,
			out_x = self.portals[i].exit.x, out_y = self.portals[i].exit.y, out_z = self.portals[i].exit.z, radius = self.portals.radius
		})
		portal_thinker_exit:AddNewModifier(portal_thinker_exit, nil, "modifier_enfos_portal_thinker", {
			in_x = self.portals[i].exit.x, in_y = self.portals[i].exit.y, in_z = self.portals[i].exit.z,
			out_x = self.portals[i].entry.x, out_y = self.portals[i].entry.y, out_z = self.portals[i].entry.z, radius = self.portals.radius
		})
	end
end

function Enfos:LoseLife(unit)
	if (not unit.spawner_team) then return end

	if GameMode:GetTeamState(unit.spawner_team) == TEAM_STATE_DEFEATED then return end

	local lives_lost = (unit.is_boss and ENFOS_BOSS_LIVES) or (unit.is_elite and ENFOS_ELITE_LIVES) or 1

	Enfos.team_lives[unit.spawner_team] = math.max(0, Enfos.team_lives[unit.spawner_team] - lives_lost)

	CustomNetTables:SetTableValue("game", "enfos_lives", {lives = Enfos.team_lives})

	if Enfos.team_lives[unit.spawner_team] <= 0 then
		Enfos:EndGameWithWinner(Enfos.enemy_team[unit.spawner_team])
	end
end

function Enfos:IsEnfosMode()
	return GetMapName() == "enfos"
end

function Enfos:GetCurrentRound()
	return Enfos.current_round
end

function Enfos:GetCurrentRoundNumber()
	if Enfos.current_round then
		return Enfos.current_round.round_number
	end

	return 0
end

function Enfos:GetCreepCount(team)
	return #Enfos.current_creeps[team]
end

function Enfos:UpdateCreepCount(team)
	CustomNetTables:SetTableValue("game", "enfos_creeps_radiant", {count = Enfos:GetCreepCount(DOTA_TEAM_GOODGUYS)})
	CustomNetTables:SetTableValue("game", "enfos_creeps_dire", {count = Enfos:GetCreepCount(DOTA_TEAM_BADGUYS)})
end

function Enfos:EndGameWithWinner(team)
	GameMode:TeamLose(Enfos.enemy_team[team])
end

-- Creep kill listener
function Enfos:OnEntityKilled(keys)
	local killed_unit = EntIndexToHScript(keys.entindex_killed)
	if killed_unit.spawner_team then

		-- Remove this unit from the current spawn table
		for creep_index, creep in pairs(Enfos.current_creeps[killed_unit.spawner_team]) do
			if creep == killed_unit then
				table.remove(Enfos.current_creeps[killed_unit.spawner_team], creep_index)
				Enfos:UpdateCreepCount(killed_unit.spawner_team)
				return
			end
		end
	end
end

function Enfos:IsPvpActive()
	return (GameMode:GetModeState() == GAME_STATE_ENFOS_PVP_SINGLE or GameMode:GetModeState() == GAME_STATE_ENFOS_PVP_TEAM)
end

function Enfos:IsSinglePvpActive()
	return GameMode:GetModeState() == GAME_STATE_ENFOS_PVP_SINGLE
end

function Enfos:IsGroupPvpActive()
	return GameMode:GetModeState() == GAME_STATE_ENFOS_PVP_TEAM
end

function Enfos:GetAllConnectedPlayerIDs()
	local connected_player_ids = {}

	for player_id = 0, 23 do
		if PlayerResource:IsValidPlayer(player_id) and (PlayerResource:GetConnectionState(player_id) == DOTA_CONNECTION_STATE_CONNECTED) then
			table.insert(connected_player_ids, player_id)
		end
	end

	return connected_player_ids
end

function Enfos:GetAllConnectedPlayers()
	local connected_players = {}
	for _, player_id in pairs(Enfos:GetAllConnectedPlayerIDs()) do
		if PlayerResource:GetPlayer(player_id) then table.insert(connected_players, PlayerResource:GetPlayer(player_id)) end
	end

	return connected_players
end

function Enfos:GetAllConnectedPlayerHeroes()
	local connected_heroes = {}
	for _, player_id in pairs(Enfos:GetAllConnectedPlayerIDs()) do
		if PlayerResource:GetSelectedHeroEntity(player_id) then table.insert(connected_heroes, PlayerResource:GetSelectedHeroEntity(player_id)) end
	end

	return connected_heroes
end

function Enfos:GetAllMainHeroes()
	local all_heroes = {}

	for player_id = 0, 23 do
		if PlayerResource:IsValidPlayer(player_id) and PlayerResource:GetSelectedHeroEntity(player_id) then
			table.insert(all_heroes, PlayerResource:GetSelectedHeroEntity(player_id))
		end
	end

	return all_heroes
end

function CDOTA_BaseNPC:GetEnfosArena()
	local unit_loc = self:GetAbsOrigin()

	if unit_loc.x < -4000 then
		return ENFOS_ARENA_RADIANT
	elseif unit_loc.x > 4000 then
		return ENFOS_ARENA_DIRE
	else
		return ENFOS_ARENA_PVP
	end
end

function Enfos:GetSpentEnfosCurrency(data)
	local player_id = data.PlayerID
	if not player_id then return end
	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "team_panels:update_spent_enfos_currency", {
		spent_currency_data = Enfos.spent_enfos_spent_currency
	})
end

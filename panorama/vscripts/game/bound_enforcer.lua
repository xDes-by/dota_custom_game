BoundEnforcer = BoundEnforcer or class({})


function BoundEnforcer:StartBoundsEnforcer()
	BoundEnforcer.playerBounds = {}

	BoundEnforcer.playerBounds["ffa"] = {}
	BoundEnforcer.playerBounds["ffa"].pve_inner = Vector(900, 900, 0) -- inner bounds of pve arena
	BoundEnforcer.playerBounds["ffa"].pvp_inner = Vector(950, 950, 0) -- inner bounds of pvp arena
	BoundEnforcer.playerBounds["ffa"].fountain = 1800

	BoundEnforcer.playerBounds["demo"] = {}
	BoundEnforcer.playerBounds["demo"].pve_inner = Vector(900, 900, 0) 
	BoundEnforcer.playerBounds["demo"].pvp_inner = Vector(950, 950, 0)
	BoundEnforcer.playerBounds["demo"].fountain = 1800

	BoundEnforcer.playerBounds["duos"] = {}
	BoundEnforcer.playerBounds["duos"].pve_inner = Vector(1150, 950, 0)
	BoundEnforcer.playerBounds["duos"].pvp_inner = Vector(1050, 1000, 0) 
	BoundEnforcer.playerBounds["duos"].fountain = 1800

	BoundEnforcer.map_bounds = BoundEnforcer.playerBounds[GetMapName()]

	Timers:CreateTimer(0, function()
		local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _, unit in pairs(units) do
			local team = unit:GetTeam()
			if team and unit:IsBoundsEnforced() then
				local is_tempest_double = unit:IsTempestDouble()
				local is_hero = unit:IsRealHero() and (not is_tempest_double)

				self:EnforceBounds(unit, team, is_hero, is_tempest_double)
			end
		end

		-- Frozen sigil is an exception since only this ward have flying movement
		for _, unit in pairs(Entities:FindAllByClassname("npc_dota_tusk_frozen_sigil")) do
			local team = unit:GetTeam()
			self:EnforceBounds(unit, team, false, false)
		end

		return 0.5
	end)
end

function BoundEnforcer:EnforceBounds(unit, team, is_hero, is_tempest_double)

	-- Creeps
	if team == DOTA_TEAM_NEUTRALS and unit.spawn_team and GameMode.arena_centers[unit.spawn_team] then
		local unit_loc = unit:GetAbsOrigin()
		local center = GameMode.arena_centers[unit.spawn_team]
		local bounds = BoundEnforcer.map_bounds.pve_inner

		if not IsPositionInRect2D(unit_loc, center, bounds) then
			FindClearSpaceForUnit(unit, ClosestPointInRect2D(unit_loc, center, bounds), true)
		end

		return
	end

	-- Heroes
	if is_hero then
		local unit_loc = unit:GetAbsOrigin()

		-- PVE
		if GameMode:IsTeamFightingCreeps(team) and GameMode.arena_centers[team] then
			
			local center = GameMode.arena_centers[team]
			local bounds = BoundEnforcer.map_bounds.pve_inner

			if not IsPositionInRect2D(unit_loc, center, bounds + 200) then
				FindClearSpaceForUnit(unit, ClosestPointInRect2D(unit_loc, center, bounds), true)
			end

			--DebugDrawBox(center, -bounds, bounds, 255, 0, 0, 32, 0.5)
			--DebugDrawBox(center, -(bounds+200), bounds+200, 0, 255, 0, 32, 0.5)

		-- PVP
		elseif GameMode:IsTeamDueling(team) and GameMode.pvp_center then

			local center = GameMode.pvp_center
			local bounds = BoundEnforcer.map_bounds.pvp_inner

			if not IsPositionInRect2D(unit_loc, center, bounds + 200) then
				FindClearSpaceForUnit(unit, ClosestPointInRect2D(unit_loc, center, bounds), true)
			end
			
			--local b = bounds + Vector(0,0,100)
			--DebugDrawBox(center, -bounds, b, 255, 0, 0, 32, 0.5)
			--DebugDrawBox(center, -(bounds+200), bounds+200, 0, 255, 0, 32, 0.5)

		-- Fountain
		elseif GameMode:IsTeamInFountain(team) and GameMode.fountain_center then
			local unit_distance = (unit_loc - GameMode.fountain_center):Length2D()

			if unit_distance > self.map_bounds.fountain then
				FindClearSpaceForUnit(unit, GameMode.fountain_center, true)
			end
		end

		return
	end

	-- Other units
	if unit.unit_state and not unit:HasModifier("modifier_tempest_double_hidden") then
		local unit_loc = unit:GetAbsOrigin()

		-- PVE
		if unit.unit_state == TEAM_STATE_FIGHTING_CREEPS and GameMode.arena_centers[team] then
			local center = GameMode.arena_centers[team]
			local bounds = BoundEnforcer.map_bounds.pve_inner

			if not IsPositionInRect2D(unit_loc, center, bounds + 200) then
				FindClearSpaceForUnit(unit, ClosestPointInRect2D(unit_loc, center, bounds), true)
			end

		-- PVP
		elseif unit.unit_state == TEAM_STATE_DUELING and GameMode.pvp_center then
			local center = GameMode.pvp_center
			local bounds = BoundEnforcer.map_bounds.pvp_inner

			if not IsPositionInRect2D(unit_loc, center, bounds + 200) then
				FindClearSpaceForUnit(unit, ClosestPointInRect2D(unit_loc, center, bounds), true)
			end
		end

		return
	end
end

function BoundEnforcer:StartEnfosBoundsEnforcer()
	BoundEnforcer.bounds = {}
	BoundEnforcer.bounds[DOTA_TEAM_GOODGUYS] = {}

	BoundEnforcer.bounds[DOTA_TEAM_GOODGUYS].center = Vector(-7168, -1344, 0)
	BoundEnforcer.bounds[DOTA_TEAM_GOODGUYS].size = Vector(2624, 5568, 0)

	BoundEnforcer.bounds[DOTA_TEAM_BADGUYS] = {}

	BoundEnforcer.bounds[DOTA_TEAM_BADGUYS].center = Vector(7168, -1344, 0)
	BoundEnforcer.bounds[DOTA_TEAM_BADGUYS].size = Vector(2624, 5568, 0)

	BoundEnforcer.bounds.group_pvp = {}

	BoundEnforcer.bounds.group_pvp.center = Vector(0, 1920, 0)
	BoundEnforcer.bounds.group_pvp.size = Vector(1856, 1344, 0)

	BoundEnforcer.bounds.single_pvp = {}

	BoundEnforcer.bounds.single_pvp.center = Vector(0, -4736, 0)
	BoundEnforcer.bounds.single_pvp.size = Vector(1664, 1408, 0)

	Timers:CreateTimer(0, function()
		local units = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false)
		for _, unit in pairs(units) do
			local team = unit:GetTeam()
			if team and unit:IsBoundsEnforced() then
				local is_tempest_double = unit:IsTempestDouble()
				local is_hero = unit:IsRealHero() and (not is_tempest_double)
				local unit_loc = unit:GetAbsOrigin()

				self:EnforceEnfosBounds(unit, unit_loc, team, is_hero, is_tempest_double)
			end
		end

		return 0.2
	end)
end

function BoundEnforcer:EnforceEnfosBounds(unit, location, team, is_hero, is_tempest_double)

	-- Creeps
	if team == DOTA_TEAM_NEUTRALS and unit.spawner_team then
		local bounds = BoundEnforcer.bounds[unit.spawner_team]

		if not IsPositionInRect2D(location, bounds.center, bounds.size) then
			FindClearSpaceForUnit(unit, ClosestPointInRect2D(location, bounds.center, bounds.size), true)
		end

		return
	end

	-- Heroes
	if is_hero then
		local bounds = BoundEnforcer.bounds[team]

		-- PVP case
		if unit:IsDueling() then bounds = (Enfos:IsGroupPvpActive() and BoundEnforcer.bounds.group_pvp) or BoundEnforcer.bounds.single_pvp end

		if not IsPositionInRect2D(location, bounds.center, bounds.size) then
			FindClearSpaceForUnit(unit, ClosestPointInRect2D(location, bounds.center, bounds.size), true)
		end

		return
	end

	-- Other units
	if unit.unit_state and not unit:HasModifier("modifier_tempest_double_hidden") then
		local bounds = BoundEnforcer.bounds[team]

		if unit.unit_state == PLAYER_STATE_ENFOS_SINGLE_PVP then
			bounds = (Enfos:IsGroupPvpActive() and BoundEnforcer.bounds.group_pvp) or BoundEnforcer.bounds.single_pvp
		end

		if not IsPositionInRect2D(location, bounds.center, bounds.size) then
			FindClearSpaceForUnit(unit, ClosestPointInRect2D(location, bounds.center, bounds.size), true)
		end

		return
	end
end

function BoundEnforcer:IsLocationInBounds(unit, location)
	if not unit or unit:IsNull() or not location then return false end
	local bounds = BoundEnforcer.bounds[unit:GetTeam()]
	if bounds and IsPositionInRect2D(location, bounds.center, bounds.size) then
		return true
	end
	return false
end
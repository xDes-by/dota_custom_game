if Camera == nil then
	print("[Camera] initialized Camera")
	Camera = {}
	Camera.__index = Camera
	DUEL_CAMERA_SPEED = 150
end	


function Camera:Init()
	RegisterCustomEventListener("options:creep_camera", function(data) Camera:SetCreepsCameraState(data) end)
	RegisterCustomEventListener("options:duel_camera", function(data) Camera:SetDuelCameraState(data) end)
	RegisterCustomEventListener("options:smooth_camera", function(data) Camera:SetCameraSmoothness(data) end)

	CustomGameEventManager:RegisterListener("Camera:spectate_player", function(entity_id, data) Camera:SelectSpectatedPlayer(entity_id, data) end)

	EventDriver:Listen("Round:round_started", Camera.OnRoundStarted, Camera)
	EventDriver:Listen("Round:round_ended", Camera.StopTracking, Camera)
	EventDriver:Listen("Spawner:all_creeps_killed", Camera.OnAllCreepsKilled, Camera)
	EventDriver:Listen("PvpManager:pvp_ended", Camera.OnPvpEnded, Camera)
	EventDriver:Listen("GameMode:team_defeated", Camera.OnTeamDefeated, Camera)

	Camera.camera_transition_time = 0.5
	Camera.camera_transition_delay = 0.3

	Camera.spectators = {}

	Camera.player_spectators = {}

	Camera.heroes = {}
	Camera.heroes_count = 0
	Camera.duel_spectators = {}
	Camera.creep_spectators = {}

	self.duel_dummy_info_target = Entities:FindByName(nil, "center_pvp")
	if self.duel_dummy_info_target then
		self.init_pos = self.duel_dummy_info_target:GetOrigin()
		local dummy = CreateUnitByName("npc_aura_dummy", self.init_pos, true, nil, nil, DOTA_TEAM_NEUTRALS)
		dummy:AddNewModifier(dummy, nil, "modifier_hidden_caster_dummy", {})
		dummy:SetMoveCapability(DOTA_UNIT_CAP_MOVE_FLY)
		dummy:AddNoDraw()
		dummy:SetBaseMoveSpeed(DUEL_CAMERA_SPEED)
		self.duel_dummy = dummy
	end
end


function Camera:GetCenterPosition()
	if self.heroes_count <= 0 then return self.init_pos end

	local center_pos = Vector(0, 0, 0)
	for _, hero in pairs(self.heroes) do
		if hero and not hero:IsNull() and hero:IsAlive() then
			local hero_position = hero:GetAbsOrigin()
			center_pos = center_pos + hero_position
		else
			self:RemoveHero(hero)
		end
	end

	return center_pos / self.heroes_count
end


function Camera:OnRoundStarted(data)
	if Enfos:IsEnfosMode() then return end
	self:TrackPositions()

	for _, player_id in pairs(PvpManager:GetAllPvpPlayers()) do
		self:AddHero(PlayerResource:GetSelectedHeroEntity(player_id))
	end

	-- Move the camera for still-connected dead players
	for i = 1, DOTA_MAX_PLAYERS do
		local player = EntIndexToHScript(i)

		if player then
			local team = player:GetTeam()

			if team == 1 or not GameMode:IsTeamAlive(team) then
				Timers:CreateTimer(0.3, function()
					if not IsValidEntity(player) then return end

					if player.spectate_player_id then
						Camera:Spectate(player)
					elseif team ~= 1 then
						Camera:IterateMovement(player, player:GetPlayerID())
					end
				end)
			end

		end
	end
end


function Camera:TrackPositions()
	self.duel_dummy:SetAbsOrigin(self.init_pos)

	local function _TrackTick()
		self.duel_dummy:MoveToPosition(self:GetCenterPosition())
		return 0.1
	end

	for index, player in pairs(self.duel_spectators) do
		if player and not player:IsNull() and PvpManager:IsPvpActive() then
			PlayerResource:SetCameraTarget(player:GetPlayerID(), self.duel_dummy)
		end
	end

	Timers:CreateTimer("position_tracker", {
		callback = _TrackTick
	})
end


function Camera:StopTracking()
	Timers:RemoveTimer("position_tracker")

	for index, player in pairs(self.duel_spectators) do
		if player and not player:IsNull() then
			PlayerResource:SetCameraTarget(player:GetPlayerID(), nil)
		end
	end

	self.duel_spectators = {}
	self.heroes = {}
	self.heroes_count = 0
end


function Camera:AddHero(hero)
	if not hero then return end
	self.heroes[hero:GetEntityIndex()] = hero
	self.heroes_count = self.heroes_count + 1
end


function Camera:RemoveHero(hero)
	if not hero or hero:IsNull() then return end
	local entindex = hero:GetEntityIndex()
	if self.heroes[entindex] then
		self.heroes[entindex] = nil
		self.heroes_count = self.heroes_count - 1

		if self.heroes_count <= 0 then
			self:StopTracking()
		end
	end
end


function Camera:AddSpectator(player)
	if not player or player:IsNull() then return end
	local hero = player:GetAssignedHero()
	self:SetCameraToPosition(player, Camera:GetCenterPosition())
	local player_id = hero:GetPlayerOwnerID()
	-- delaying table insertion to allow camera moving to center fast enough
	if PLAYER_OPTIONS_CAMERA_SMOOTHNESS_ENABLED[player_id] then
		Timers:CreateTimer(self.camera_transition_time, function()
			if hero and not hero:IsNull() and PvpManager:IsPvpActive() then
				PlayerResource:SetCameraTarget(player_id, self.duel_dummy)
				self.duel_spectators[hero:GetEntityIndex()] = player
			end
		end)
	-- pvp check is split since top one uses timer, and status may get invalid once it's actually executed
	elseif PvpManager:IsPvpActive() then  
		PlayerResource:SetCameraTarget(player_id, self.duel_dummy)
		self.duel_spectators[hero:GetEntityIndex()] = player
	end
end


function Camera:RemoveSpectator(hero)
	local entindex = hero:GetEntityIndex()
	if self.duel_spectators[entindex] then 
		self.duel_spectators[entindex] = nil
		PlayerResource:SetCameraTarget(hero:GetPlayerOwnerID(), nil)
		return true 
	end
	return false
end


function Camera:SetCameraToPosition(player, position, delay, move_duration)
	if not player or player:IsNull() then return end
	local player_id = player:GetPlayerID()
	-- disable default smoothness if setting is disabled
	if not move_duration then
		if not PLAYER_OPTIONS_CAMERA_SMOOTHNESS_ENABLED[player_id] then
			move_duration = -1
		else
			move_duration = Camera.camera_transition_time
		end
	end
	if not delay then
		PlayerResource:SetCameraTarget(player_id, nil)
		CustomGameEventManager:Send_ServerToPlayer(player, 'SetCameraLocation', {
			location = position, 
			move_duration = move_duration
		})
		return 
	end
	Timers:CreateTimer(delay, function()
		PlayerResource:SetCameraTarget(player_id, nil)
		CustomGameEventManager:Send_ServerToPlayer(player, 'SetCameraLocation', {
			location = position, 
			move_duration = move_duration
		})
	end)
end


function Camera:SetCameraToUnit(player, unit, delay, move_duration)
	if not player or player:IsNull() or not unit then return end
	local player_id = player:GetPlayerID()

	local function _CameraToUnit() 
		if move_duration then
			self:SetCameraToPosition(player, unit:GetOrigin(), nil, move_duration)
			Timers:CreateTimer(move_duration, function()
				PlayerResource:SetCameraTarget(player_id, unit)
			end)
		else
			PlayerResource:SetCameraTarget(player_id, unit)
		end
	end

	if not delay then
		_CameraToUnit()
		return
	end
	Timers:CreateTimer(delay, function()
		_CameraToUnit()
	end)
end


function Camera:SetCameraToOwnHeroPosition(player, delay, move_duration)
	if not player or player:IsNull() then return end
	local hero = player:GetAssignedHero()
	if not hero then return end
	-- creating another timer despite having one in SetCameraToPosition
	-- because otherwise hero position will be outdated
	-- leading to stupid errors
	if not delay then
		Camera:SetCameraToPosition(player, hero:GetOrigin(), nil, move_duration)
		return
	end
	Timers:CreateTimer(delay, function()
		Camera:SetCameraToPosition(player, hero:GetOrigin(), nil, move_duration)
	end)
end


function Camera:SetCamToRandomTeam(player_id, delay, move_duration)
	if not player_id then return end
	if not PLAYER_OPTIONS_CREEP_CAMERA_ENABLED[player_id] then return end
	PlayerResource:SetCameraTarget(player_id, nil)

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	local hero = player:GetAssignedHero()

	-- no camera movement if you fighting creeps!
	if GameMode:IsTeamFightingCreeps(player:GetTeamNumber()) then return end

	local alive_teams = {}
	for _, team_number in pairs(GameMode:GetAllAliveTeams()) do
		-- disable dead teams, finished teams, own team, and team currently spectated
		if GameMode:IsTeamFightingCreeps(team_number) and player:GetTeamNumber() ~= team_number then
			if Camera.spectators[player_id] then
				if Camera.spectators[player_id] ~= team_number then
					table.insert(alive_teams, team_number)
				end
			else
				table.insert(alive_teams, team_number)
			end
		end
	end

	if #alive_teams <= 0 then
		if hero and not hero:IsAlive() then 
			self:SetCameraToFountain(player, delay, move_duration)
			return 
		end
		self:SetCameraToOwnHeroPosition(player, delay, move_duration)
		Camera.spectators[player_id] = nil
		return
	end

	local cam_point = table.random(alive_teams)
	self:SetCameraToPosition(player, GameMode.arena_centers[cam_point], delay, move_duration)
	Camera.spectators[player_id] = cam_point
	return cam_point
end


function Camera:SetCameraToFountain(player, delay, move_duration)
	if not player or player:IsNull() then return end

	local fountain_point = GameMode.team_fountain_spawn_points[player:GetTeam()]
	if not fountain_point or not fountain_point[1] then return end

	self:SetCameraToPosition(player, fountain_point[1], delay, move_duration)
end


function Camera:SetCreepsCameraState(data)
	local player_id = data.PlayerID
	if not player_id then return end
	local state = toboolean(data.state)
	local update_hud = data.update_hud
	local player = PlayerResource:GetPlayer(player_id)
	if not player or player:IsNull() then return end
	local player_hero = player:GetAssignedHero()

	PLAYER_OPTIONS_CREEP_CAMERA_ENABLED[player_id] = state

	if update_hud then
		CustomGameEventManager:Send_ServerToPlayer(player, "options:update_checkboxes", {creeps=PLAYER_OPTIONS_CREEP_CAMERA_ENABLED[player_id]})
	end

	if not player_hero then return end

	--Round:SetCamToRandomTeam(player_id)
	if PLAYER_OPTIONS_CREEP_CAMERA_ENABLED[player_id] then
		if not GameMode:IsTeamFightingCreeps(player_hero:GetTeamNumber()) then
			self:SetCamToRandomTeam(player_id)
		end
	else
		if Camera.spectators[player_id] then
			Camera.spectators[player_id] = nil
		end
		if player_hero:IsAlive() then
			self:SetCameraToOwnHeroPosition(player, Camera.camera_transition_delay)
		else
			self:SetCameraToFountain(player, Camera.camera_transition_delay)
		end
	end
end 


function Camera:SetDuelCameraState(data)
	local player_id = data.PlayerID
	if not player_id then return end
	local state = toboolean(data.state)
	local update_hud = data.update_hud
	local player = PlayerResource:GetPlayer(player_id)
	if not player or player:IsNull() then return end
	local player_hero = player:GetAssignedHero()
	PLAYER_OPTIONS_DUEL_CAMERA_ENABLED[player_id] = state

	if update_hud then
		CustomGameEventManager:Send_ServerToPlayer(player, "options:update_checkboxes", {duel=PLAYER_OPTIONS_DUEL_CAMERA_ENABLED[player_id]})
	end

	if not player_hero then return end

	-- if setting is toggled off we need to remove tracking
	if PLAYER_OPTIONS_DUEL_CAMERA_ENABLED[player_id] then
		if PvpManager:IsPvpActive() and GameMode:IsPlayerInFountain(player_id) and self.heroes_count ~= 0 then
			Camera.spectators[player_id] = nil
			self:AddSpectator(player)
		end
	else
		-- if we have camera and hero was spectating duel
		if self:RemoveSpectator(player_hero) then
			PlayerResource:SetCameraTarget(player_id, nil)
			if PLAYER_OPTIONS_CREEP_CAMERA_ENABLED[player_id] and PvpManager:IsPvpActive() then
				self:SetCamToRandomTeam(player_id)
			else
				if player_hero:IsAlive() then
					self:SetCameraToOwnHeroPosition(player, Camera.camera_transition_delay)
				else
					self:SetCameraToFountain(player, Camera.camera_transition_delay)
				end
	        end
        end
	end
end


function Camera:SetCameraSmoothness(data)
	local player_id = data.PlayerID
	if not player_id then return end
	local state = toboolean(data.state)
	local update_hud = data.update_hud
	local player = PlayerResource:GetPlayer(player_id)
	if not player or player:IsNull() then return end
	PLAYER_OPTIONS_CAMERA_SMOOTHNESS_ENABLED[player_id] = state

	if update_hud then
		CustomGameEventManager:Send_ServerToPlayer(player, "options:update_checkboxes", {
			smooth_cam = PLAYER_OPTIONS_CAMERA_SMOOTHNESS_ENABLED[player_id]
		})
	end
end


function Camera:IterateMovement(player, player_id)
	if not player or player:IsNull() or not player_id then return false end
	if RoundManager:GetCurrentRound():IsPvpRound() then
		if PLAYER_OPTIONS_DUEL_CAMERA_ENABLED[player_id] and GameMode.pvp_center and Camera.heroes_count ~= 0 then
			Camera:AddSpectator(player)
			return
		-- what a shitshow
		elseif PLAYER_OPTIONS_CREEP_CAMERA_ENABLED[player_id] then
			Camera:SetCamToRandomTeam(player_id, Camera.camera_transition_delay)
			return
		end
	elseif PLAYER_OPTIONS_CREEP_CAMERA_ENABLED[player_id] then
		Camera:SetCamToRandomTeam(player_id, Camera.camera_transition_delay)
		return
	end

	self:SetCameraToFountain(player, Camera.camera_transition_delay)
end


function toboolean(value)
	if not value then return value end
	local val_type = type(value)
	if val_type == "boolean" then return value end
	if val_type == "number"	then return value ~= 0 end
	-- return true for anything we can't explicitly measure
	return true
end


-- A team was defeated, change camera focus to another arena
function Camera:OnTeamDefeated(data)
	local defeated_team = data.team

	for player, spectate_id in pairs(self.player_spectators) do
		if IsValidEntity(player) and PlayerResource:GetTeam(spectate_id) == defeated_team then 
			self:DisableSpectate(player)
			return
		end
	end

	-- Move the camera of anyone watching the defeated team
	for player_id, team in pairs(Camera.spectators) do
		if team == defeated_team then
			Camera:SetCamToRandomTeam(player_id)
		end
	end

	-- Move the camera of the defeated team's players
	for _, player_id in ipairs(GameMode.team_player_id_map[defeated_team]) do
		local player = PlayerResource:GetPlayer(player_id)
		if player then Camera:IterateMovement(player, player_id) end
	end
end


-- A team finished fighting creeps, change camera focus of spectators to another arena
function Camera:OnAllCreepsKilled(keys)
	if Enfos:IsEnfosMode() then return end

	for player_id, observed_team in pairs(Camera.spectators) do
		if observed_team and keys.team == observed_team and PlayerResource:GetTeam(player_id) ~= keys.team then
			Camera:SetCamToRandomTeam(player_id, Camera.camera_transition_delay)
		end
	end

	for player, spectate_id in pairs(self.player_spectators) do
		if IsValidEntity(player) and PlayerResource:GetTeam(spectate_id) == keys.team then 
			self:Spectate(player)
		end
	end

	local team = GameMode.team_player_id_map[keys.team]
	for _, player_id in pairs(team) do
		local player = PlayerResource:GetPlayer(player_id)
		if player and not player.spectate_player_id then
			Camera:IterateMovement(player, player_id)
		end
	end
end


-- The current duel ended
function Camera:OnPvpEnded(keys)
	if Enfos:IsEnfosMode() then return end

	self:StopTracking()

	for player, spectate_id in pairs(self.player_spectators) do
		local spectate_team = PlayerResource:GetTeam(spectate_id)
		if IsValidEntity(player) and (spectate_team == keys.winner_team or spectate_team == keys.loser_team) then 
			self:Spectate(player)
		end
	end

	for _, player_id in pairs(GameMode.all_players) do
		local player_team = PlayerResource:GetTeam(player_id)
		local player = PlayerResource:GetPlayer(player_id)

		if player and not player.spectate_player_id then
			if PLAYER_OPTIONS_CREEP_CAMERA_ENABLED[player_id] then
				Camera:SetCamToRandomTeam(player_id, Camera.camera_transition_delay)

			elseif PLAYER_OPTIONS_DUEL_CAMERA_ENABLED[player_id] and (player_team ~= keys.winner_team) and (player_team ~= keys.loser_team) 
			and (not GameMode:IsTeamFightingCreeps(player_team)) and GameMode:IsTeamAlive(player_team) then
				PlayerResource:SetCameraTarget(player_id, nil)
				Camera:SetCameraToOwnHeroPosition(player, Camera.camera_transition_delay)
			end
		end
	end
end

function Camera:Spectate(player)
	local spectate_team = PlayerResource:GetTeam(player.spectate_player_id)

	if GameMode:IsTeamAlive(spectate_team) then
		local team_state = GameMode:GetTeamState(spectate_team)
		local camera_target_pos 

		if team_state == TEAM_STATE_DUELING then
			camera_target_pos = self:GetCenterPosition()
		else
			local hero = PlayerResource:GetSelectedHeroEntity(player.spectate_player_id)
			camera_target_pos = hero:GetAbsOrigin()
		end

		if camera_target_pos then
			self:SetCameraToPosition(player, camera_target_pos, 0, -1)
		end

		return
	else
		Camera:DisableSpectate(player)
	end
end


function Camera:DisableSpectate(player)
	player.spectate_player_id = nil
	self.player_spectators[player] = nil

	CustomGameEventManager:Send_ServerToPlayer(player, "team_panels:set_spectate_player", { spectate_player_id = -1 })
end

function Camera:SelectSpectatedPlayer(entity_id, event)
	local player = EntIndexToHScript(entity_id)
	if not player then return end

	local team = player:GetTeam()
	if team ~= 1 and not GameMode:IsTeamDefeated(team) then return end

	local spectated_id = event.spectate_player_id
	local spectated_team = PlayerResource:GetTeam(spectated_id)
	if not GameMode:IsTeamAlive(spectated_team) then return end

	if player.spectate_player_id == spectated_id then
		self:DisableSpectate(player)
		return
	end

	player.spectate_player_id = spectated_id
	self.player_spectators[player] = spectated_id
	self.spectators[player:GetPlayerID()] = nil

	self:Spectate(player)

	CustomGameEventManager:Send_ServerToPlayer(player, "team_panels:set_spectate_player", { spectate_player_id = player.spectate_player_id })
end

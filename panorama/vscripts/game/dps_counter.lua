DPS_Counter = DPS_Counter or class({})


function DPS_Counter:Init()
	self.round_started_listener = EventDriver:Listen("Round:round_started", self.OnRoundStarted, self)
	self.round_ended_listener = EventDriver:Listen("Spawner:all_creeps_killed", self.OnRoundEndForTeam, self)
	self.team_lose_listener = EventDriver:Listen("GameMode:team_defeated", self.OnRoundEndForTeam, self)
	self.pvp_ended_listener = EventDriver:Listen("PvpManager:pvp_ended", self.OnDuelEndForTeam, self)
	self.current_damage_records = {}

	self.active_teams = {}

	if Enfos:IsEnfosMode() then
		self.update_timer = Timers:CreateTimer(5, function() return DPS_Counter:UpdateEnfos() end)
	else
		self.update_timer = Timers:CreateTimer(5, function() return DPS_Counter:Update() end)
	end
end

function DPS_Counter:Update()
	for team, values in pairs(self.current_damage_records) do
		if self.active_teams[team] and values and not PvpManager:IsPvpTeamThisRound(team) then
			CustomGameEventManager:Send_ServerToTeam(team, "DPS_Counter:update", values)
		end
	end
	return 3
end

function DPS_Counter:UpdateEnfos()
	local damage_table = DPS_Counter:GetCombinedDamageTable({winner_team = DOTA_TEAM_GOODGUYS, loser_team = DOTA_TEAM_BADGUYS})
	for team, values in pairs(self.current_damage_records) do
		if values then
			for player_id, _ in pairs(values) do
				local player = PlayerResource:GetPlayer(player_id)
				-- individual pvp checks cause enfos has 1v1 duels too
				if player and not player:IsNull() then
					CustomGameEventManager:Send_ServerToPlayer(player, "DPS_Counter:update", damage_table)
				end
			end
		end
	end
	return 3
end

function DPS_Counter:GetCombinedDamageTable(event)
	local winner_table = table.deepcopy(self.current_damage_records[event.winner_team] or {})
	local loser_table = table.deepcopy(self.current_damage_records[event.loser_team] or {})

	for p_id, vals in pairs(loser_table) do
		winner_table[p_id] = vals
	end

	return winner_table
end

function DPS_Counter:GetDamageInstanceName(inflictor, hero, unit)
	if inflictor and inflictor.GetAbilityName then
		return inflictor:GetAbilityName()
	else
		if hero ~= unit then 
			if unit:IsIllusion() then return "illusion" end
			return "summon" 
		else
			return "attack"
		end
	end
end

function DPS_Counter:RegisterDamageInstance(unit, damage, damage_type, inflictor)
	if not damage_type or damage_type < 1 or damage_type > 4 then return end
	local player_owner = unit:GetPlayerOwner()
	if not player_owner or player_owner:IsNull() then return end

	local player_id = player_owner:GetPlayerID()

	local hero = player_owner:GetAssignedHero()
	if not hero or hero:IsNull() then return end

	local team = hero:GetTeam()

	local inflictor_name = DPS_Counter:GetDamageInstanceName(inflictor, hero, unit)

	self.active_teams[team] = true
	if not self.current_damage_records[team] then self.current_damage_records[team] = {} end
	if not self.current_damage_records[team][player_id] then self.current_damage_records[team][player_id] = {} end

	local current_damage = self.current_damage_records[team][player_id][inflictor_name]
	if not current_damage then 
		self.current_damage_records[team][player_id][inflictor_name] = {
			damage_type = damage_type,
			damage = 0,
			count = 0,
		}
		current_damage = self.current_damage_records[team][player_id][inflictor_name]
	end

	current_damage.damage = current_damage.damage + damage
	current_damage.count = current_damage.count + 1
end


function DPS_Counter:OnRoundStarted(event)
	self.current_damage_records = {}
	CustomGameEventManager:Send_ServerToAllClients("DPS_Counter:round_started", event)
end


function DPS_Counter:OnRoundEndForTeam(event)
	local damage_table 
	if Enfos:IsEnfosMode() then
		damage_table = DPS_Counter:GetCombinedDamageTable({winner_team = DOTA_TEAM_GOODGUYS, loser_team = DOTA_TEAM_BADGUYS})
	else
		damage_table = self.current_damage_records[event.team] or {}
	end
	self.active_teams[event.team] = false
	CustomGameEventManager:Send_ServerToTeam(event.team, "DPS_Counter:round_ended", {
		damage_table = damage_table,
		end_time = GameRules:GetGameTime(),
	})
end


function DPS_Counter:OnDuelEndForTeam(event)
	local damage_table = DPS_Counter:GetCombinedDamageTable(event)

	self.active_teams[event.winner_team] = false
	self.active_teams[event.loser_team] = false
	
	CustomGameEventManager:Send_ServerToTeam(event.winner_team, "DPS_Counter:pvp_ended", {
		damage_table = damage_table,
		end_time = GameRules:GetGameTime()
	})
	
	CustomGameEventManager:Send_ServerToTeam(event.loser_team, "DPS_Counter:pvp_ended", {
		damage_table = damage_table,
		end_time = GameRules:GetGameTime()
	})
end

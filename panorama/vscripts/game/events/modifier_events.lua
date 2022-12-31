-- Listens for certain in-game events, and then fires associated modifier functions.
-- Only works for the main heroes of players in non-eliminated teams (can be expanded if useful/needed).

if ModifierEventListener == nil then ModifierEventListener = class({}) end

function ModifierEventListener:Init()
	EventDriver:Listen("Round:round_preparation_started", ModifierEventListener.OnRoundPreparationStarted, ModifierEventListener)
	EventDriver:Listen("Round:round_started", ModifierEventListener.OnRoundStart, ModifierEventListener)
	EventDriver:Listen("Spawner:all_creeps_killed", ModifierEventListener.OnRoundEndForTeam, ModifierEventListener)

	EventDriver:Listen("PvpManager:pvp_countdown_ended", ModifierEventListener.OnPvpStart, ModifierEventListener)
	EventDriver:Listen("PvpManager:pvp_ended", ModifierEventListener.OnPvpEndedForDuelists, ModifierEventListener)

	EventDriver:Listen("BetManager:won_bet", ModifierEventListener.OnBetWon, ModifierEventListener)
	EventDriver:Listen("BetManager:lost_bet", ModifierEventListener.OnBetLost, ModifierEventListener)
end

function ModifierEventListener:OnRoundPreparationStarted(keys)
	for _, team in pairs(GameMode:GetAllAliveTeams()) do
		for _, player_id in pairs(GameMode.team_player_id_map[team]) do
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero and (not hero:IsNull()) then
				for _, modifier in pairs(hero:FindAllModifiers()) do
					if modifier.OnRoundPreparationStarted then modifier:OnRoundPreparationStarted(keys) end
				end
			end
		end
	end
end

function ModifierEventListener:OnRoundStart(keys)
	for _, team in pairs(GameMode:GetAllAliveTeams()) do
		for _, player_id in pairs(GameMode.team_player_id_map[team]) do
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero and (not hero:IsNull()) then
				for _, modifier in pairs(hero:FindAllModifiers()) do
					if modifier.OnRoundStart then modifier:OnRoundStart(keys) end
				end
			end
		end
	end
end

function ModifierEventListener:OnRoundEndForTeam(keys)
	for _, player_id in pairs(GameMode.team_player_id_map[keys.team]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero and (not hero:IsNull()) then
			for _, modifier in pairs(hero:FindAllModifiers()) do
				if modifier.OnRoundEndForTeam then modifier:OnRoundEndForTeam(keys) end
			end
		end
	end
end

function ModifierEventListener:OnPvpStart(keys)
	if Enfos:IsEnfosMode() then
		if Enfos:IsGroupPvpActive() then
			for _, hero in pairs(Enfos:GetAllMainHeroes()) do
				if hero and (not hero:IsNull()) then
					for _, modifier in pairs(hero:FindAllModifiers()) do
						if modifier.OnPvpStart then modifier:OnPvpStart(keys) end
					end
				end
			end
		else
			for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
				for _, hero in pairs(EnfosPVP.dueling_heroes[team]) do
					if hero and (not hero:IsNull()) then
						for _, modifier in pairs(hero:FindAllModifiers()) do
							if modifier.OnPvpStart then modifier:OnPvpStart(keys) end
						end
					end
				end
			end
		end
	else
		for _, team in pairs(GameMode:GetAllAliveTeams()) do
			for _, player_id in pairs(GameMode.team_player_id_map[team]) do
				local hero = PlayerResource:GetSelectedHeroEntity(player_id)
				if hero and (not hero:IsNull()) then
					for _, modifier in pairs(hero:FindAllModifiers()) do
						if modifier.OnPvpStart then modifier:OnPvpStart(keys) end
					end
				end
			end
		end
	end
end

function ModifierEventListener:OnPvpEndedForDuelists(keys)
	for _, team in pairs(keys) do
		for _, player_id in pairs(GameMode.team_player_id_map[team]) do
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero and (not hero:IsNull()) then
				for _, modifier in pairs(hero:FindAllModifiers()) do
					if modifier.OnPvpEndedForDuelists then modifier:OnPvpEndedForDuelists(keys) end
				end
			end
		end
	end
end

function ModifierEventListener:OnBetWon(keys)
	local hero = PlayerResource:GetSelectedHeroEntity(keys.player_id)
	if hero and (not hero:IsNull()) then
		for _, modifier in pairs(hero:FindAllModifiers()) do
			if modifier.OnBetWon then modifier:OnBetWon(keys) end
		end
	end
end

function ModifierEventListener:OnBetLost(keys)
	local hero = PlayerResource:GetSelectedHeroEntity(keys.player_id)
	if hero and (not hero:IsNull()) then
		for _, modifier in pairs(hero:FindAllModifiers()) do
			if modifier.OnBetLost then modifier:OnBetLost(keys) end
		end
	end
end

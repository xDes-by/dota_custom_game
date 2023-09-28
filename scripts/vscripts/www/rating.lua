if rating == nil then
    _G.rating = class({})
end

function rating:init()
	
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( rating, 'OnGameRulesStateChange'), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap(rating, 'OnPlayerReconnected'), self)
	ListenToGameEvent( "player_connect_full", Dynamic_Wrap( rating, "PlayerConnectFull"), self)
	CustomGameEventManager:RegisterListener("pickRatingLua", Dynamic_Wrap( rating, 'pickRatingLua' ))
	CustomGameEventManager:RegisterListener("pickInit", Dynamic_Wrap( rating, 'pickInit' ))
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( rating, "OnEntityKilled"), self)
	rating.reliable = 0
	rating.wave_name = ""
	rating.wave_count = 0
	rating.wave_need = 0
end

function rating:pickInit(t)
	if not RATING['rating'] then return end
	CustomGameEventManager:Send_ServerToAllClients( "pickRating", RATING )
end

function rating:OnEntityKilled(keys)
	
	local killedUnit = EntIndexToHScript( keys.entindex_killed )
    local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
	if rating.wave_need > rating.wave_count then
		if rating.wave_name == name or "comandir_" .. rating.wave_name == name then
			rating.wave_count = rating.wave_count + 1
		end
		SendPlayerNotification:WaveMessage(rating.wave_need, rating.wave_count)
	end
end

function rating:OnGameRulesStateChange()
	-- if GameRules:State_Get() == DOTA_GAMERULES_STATE_HERO_SELECTION then
	-- 	Timers:CreateTimer(2, function()
	-- 		if RATING then
	-- 			CustomGameEventManager:Send_ServerToAllClients( "initRating", RATING )
	-- 		else
	-- 			print("============================")
	-- 			print("ERROR: _G.RATING not exist")
	-- 			print("RATING INIT FAILED")
	-- 			print("============================")
	-- 		end
	-- 	end)
	-- CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "pickRating", RATING )
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		-- _G.kill_invoker = false
		Timers:CreateTimer(2, function()
			if RATING then
				CustomGameEventManager:Send_ServerToAllClients( "initRating", RATING )
			else
				print("============================")
				print("ERROR: _G.RATING not exist")
				print("RATING INIT FAILED")
				print("============================")
			end
		end)
	elseif GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		--CustomGameEventManager:Send_ServerToAllClients( "updateRatingCouter", {a = rating_wave,b = mega_boss_bonus,  c = rat} )
		Timers:CreateTimer(1, function()
		
			mmr = ((math.floor(rat / 5)) * 2 ) * diff_wave.rating_scale 
			doom = mega_boss_bonus * diff_wave.rating_scale
			nad = 0
			
			if rat >= 75 then 
			nad = mmr - (30 * diff_wave.rating_scale)
			mmr = 30 * diff_wave.rating_scale 
			end
			
			CustomGameEventManager:Send_ServerToAllClients( "updateRatingCouter", {a = mmr, b = nad, c = doom} )
			if _G.kill_invoker == true then return nil end
			return 10
		end)
	end
end


function rating:PlayerConnectFull(keys)
	
end


function rating:OnPlayerReconnected(keys)
	Timers:CreateTimer(2, function()
		if RATING then
			if GameRules:State_Get() >= DOTA_GAMERULES_STATE_PRE_GAME then
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "initRating", RATING )
				sInv:UpdateInventory(keys.PlayerID)
			else
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer( keys.PlayerID ), "pickRating", RATING )
			end
		else
			print("============================")
			print("ERROR: _G.RATING not exist")
			print("RATING INIT FAILED")
			print("============================")
		end
	end)
end


function rating:showNoti(from, to)
	local event_data = 
	{
		from = from
	}
	CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(to), "Noti", event_data) 
end

rating:init()


if Quests == nil then
    _G.Quests = class({})
end


function Quests:init()
	ListenToGameEvent( 'npc_spawned', Dynamic_Wrap( Quests, 'OnNPCSpawned'), self)
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( Quests, 'OnGameRulesStateChange'), self)
	ListenToGameEvent( "player_connect_full", Dynamic_Wrap( Quests, "PlayerConnectFull"), self)
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( Quests, "OnEntityKilled"), self)
	ListenToGameEvent( "dota_hero_inventory_item_change", Dynamic_Wrap( Quests, "OnItemDrop"), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap( Quests, 'OnPlayerReconnected'), self)
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( Quests, "OnItemPickUp"), self)
	ListenToGameEvent( "dota_rune_activated_server", Dynamic_Wrap( Quests, "OnRunePickup"), self)
	
	CustomGameEventManager:RegisterListener("acceptButton", Dynamic_Wrap(Quests, 'acceptButton'))
	CustomGameEventManager:RegisterListener("selectItem", Dynamic_Wrap(Quests, 'selectItem'))
	CustomGameEventManager:RegisterListener("minimapEvent", Dynamic_Wrap(Quests, 'minimapEvent'))
	CustomGameEventManager:RegisterListener("auto_quest_toggle", Dynamic_Wrap(Quests, 'auto_quest_toggle'))
	--GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(Quests, 'OnDamageDealt'), self)
    Quests.questTabel = LoadKeyValues("scripts/kv/quests.txt")
	-- print("Quests.questTabel", Quests.questTabel)
	Quests:FillTable()
	Quests:linkmod('modifier_quest')
	Quests:linkmod('modifier_quest_aura')
	Quests.pointName = "quest_line_"
    Quests.npcName = "npc_"
	Quests.npcMaxNumber = 33
	Quests.npcArray = {}
	Quests.unitsKillList = {}
	Quests.dropListArray = {}
	Quests.damageMake = {}
	Quests.damageTaik = {}
	Quests.has_quest_main = "particles/voskl_gold.vpcf"
	Quests.complite_quest_main = "particles/vopros_gold.vpcf"
	Quests.has_quest_bonus = "particles/voskl_blue.vpcf"
	Quests.complite_quest_bonus = "particles/vopros_blue.vpcf"
	Quests.auto = {}
	Quests.midLine = {9,11,12,13,14,15,16,17,18}
	Quests.midLine2 = {10, 20, 25}
	Quests.trialPeriodCount = {}
end

function Quests:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		--print("OnGameRulesStateChange")
		Timers:CreateTimer(2, function() 
			Quests:createNPC()
			Quests:AutoQuestToggleInit()
		end)
		
		
	end
end

function Quests:PlayerConnectFull()
	
end

function Quests:OnRunePickup(t)
	Quests:UpdateCounter("bonus", 1, 1, t.PlayerID)
end

function Quests:OnPlayerReconnected(keys)
	local index_name = {}
	for i = 1, Quests.npcMaxNumber do
		index_name[i] = {
			name = Quests.npcArray[i]["name"],
			index = Quests.npcArray[i]["unit"]:entindex()
		}
	end

	Timers:CreateTimer(1, function()
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(keys.PlayerID), "npcInfo", {
			list = index_name,
			mode = diff_wave.rating_scale
		})
		CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(keys.PlayerID), "shortInit", {})
		
		local steamID = PlayerResource:GetSteamAccountID(keys.PlayerID)
		local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
		CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
	end)
end

function Quests:FillTable()

	base  = {}
    options = {}
	reward = {}
	abs = {}
	kill = {}
	item = {}
	custom = {}
	giveItem = {}


	for k1, v1 in pairs(Quests.questTabel) do
		for k2, v2 in pairs(Quests.questTabel[k1]) do
			b = #base+1
			base[b] = {}
			base[b].type = k1
			base[b].number = k2
			if v2['unlock'] or v2['options'] then
				o = #options+1
				options[o] = {}
				if v2['unlock'] then
					options[o]['unlock'] = v2['unlock']
					base[b].unlock = o
				end
				if v2['options'] then
					options[o]['options'] = v2['options']
					base[b].options = o
				end
			end
			if v2['reward'] then
				r = #reward+1
				base[b].reward = r
				reward[r] = {}
				if v2['reward']['gold'] then
					base[b].gold = r
					reward[r]['gold'] = v2['reward']['gold']
				end
				if v2['reward']['experience'] then
					base[b].experience = r
					reward[r]['experience'] = v2['reward']['experience']
				end
				if v2['reward']['items'] then
					base[b].items = r
					reward[r]['items'] = v2['reward']['items']
				end
				if v2['reward']['ChoosItems'] then
					base[b].ChoosItems = r
					reward[r]['ChoosItems'] = v2['reward']['ChoosItems']
				end
			end
			for k3,v3 in pairs(Quests.questTabel[k1][k2]['tasks']) do
				base[b][k3] = {}

				if v3['abs'] then
					base[b].abs = #abs+1
					abs[#abs+1] = v3['abs']
				end
				if v3['kill'] and v3['kill']['units'] then
					base[b][k3].kill = #kill+1
					kill[#kill+1] = v3['kill']['units']
				end
				if v3['item'] and v3['item']['items'] then
					base[b][k3].item = #item+1
					item[#item+1] = v3['item']['items']
				end
				if v3['custom'] then
					base[b][k3].custom = #custom+1
					custom[#custom+1] = v3['custom']
				end
				if v3['giveItem'] then
					base[b][k3].giveItem = #giveItem+1
					giveItem[#giveItem+1] = v3['giveItem']
				end
			end
		end
    end
	CustomNetTables:SetTableValue("quests", 'base', base)
	CustomNetTables:SetTableValue("quests", 'options', options)
	CustomNetTables:SetTableValue("quests", 'reward', reward)
	CustomNetTables:SetTableValue("quests", 'abs', abs)
	CustomNetTables:SetTableValue("quests", 'kill', kill)
	CustomNetTables:SetTableValue("quests", 'item', item)
	CustomNetTables:SetTableValue("quests", 'custom', custom)
	CustomNetTables:SetTableValue("quests", 'giveItem', giveItem)
end

function Quests:UpdateCounter(type, number, task, id, kol)
	local n = 1
	if kol and kol > 1 then
		n = kol
	end
    local steamID = PlayerResource:GetSteamAccountID(id)
    local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
    if player_info and player_info[tostring(steamID)][tostring(type)] and
    player_info[tostring(steamID)][tostring(type)][tostring(number)] and
    player_info[tostring(steamID)][tostring(type)][tostring(number)]["active"] == 1 and
    player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)] and
    player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["active"] == 1 and
    tonumber(player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["have"]) < tonumber(player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["HowMuch"]) 
    then
		if player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["have"] + n < player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["HowMuch"] then
        	player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["have"] = player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["have"] + n
			CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
		else
			player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["have"] = player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["HowMuch"]
			CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
			if Quests.auto[id] then
				Quests:AutoComplete({
					pid = id,
					type = type,
					number = number,
					task = task,
				})
			else
				Quests:updateParticle()
			end
		end
    end
	
end

function Quests:OnNPCSpawned(t)

	local npc = EntIndexToHScript(t.entindex)

	if npc:IsRealHero() and npc.bPlayerInit == nil then
		local playerID = npc:GetPlayerID()



		local connectState = PlayerResource:GetConnectionState(playerID)	
		if connectState == DOTA_CONNECTION_STATE_ABANDONED or connectState == DOTA_CONNECTION_STATE_FAILED or connectState == DOTA_CONNECTION_STATE_UNKNOWN then
			return
		end



		local steamID = PlayerResource:GetSteamAccountID(playerID)
		local player_info = {}
		local quests = Quests.questTabel
		npc.bPlayerInit = true
		player_info[tostring(steamID)] = {
			main = {},
			bonus = {},
			exchanger = {}
		}
		for _,main in pairs ({'main', 'bonus'}) do
			for k1,v1 in pairs(quests[main]) do
				player_info[tostring(steamID)][main][tostring(k1)] = {}
				player_info[tostring(steamID)][main][tostring(k1)]["tasks"] = {}
				player_info[tostring(steamID)][main][tostring(k1)]["complete"] = false
				player_info[tostring(steamID)][main][tostring(k1)]["available"] = false
				player_info[tostring(steamID)][main][tostring(k1)]["selectedItem"] = false
				player_info[tostring(steamID)][main][tostring(k1)]["active"] = false
				player_info[tostring(steamID)][main][tostring(k1)]["renewable"] = false
				player_info[tostring(steamID)][main][tostring(k1)]["close_all_after_end"] = false
				player_info[tostring(steamID)][main][tostring(k1)]["only_for_one"] = false
				player_info[tostring(steamID)][main][tostring(k1)]["lock_item_select"] = false
				player_info[tostring(steamID)][main][tostring(k1)]["experience"] = RandomInt(tonumber(quests[main][tostring(k1)]["reward"]["experience"]["min"]),tonumber(quests[main][tostring(k1)]["reward"]["experience"]["max"]))
				player_info[tostring(steamID)][main][tostring(k1)]["gold"] = RandomInt(tonumber(quests[main][tostring(k1)]["reward"]["gold"]["min"]),tonumber(quests[main][tostring(k1)]["reward"]["gold"]["max"]))
				if quests[main][tostring(k1)]["reward"]["talentExperience"] then
					local talentExperience = tonumber(quests[main][tostring(k1)]["reward"]["talentExperience"])
					if diff_wave.rating_scale == 0 then talentExperience = talentExperience * 0.5 end
					if diff_wave.rating_scale == 1 then talentExperience = talentExperience * 1 end
					if diff_wave.rating_scale == 2 then talentExperience = talentExperience * 1.25 end
					if diff_wave.rating_scale == 3 then talentExperience = talentExperience * 1.50 end
					if diff_wave.rating_scale == 4 then talentExperience = talentExperience * 1.75 end
					player_info[tostring(steamID)][main][tostring(k1)]["talentExperience"] = math.modf(talentExperience)
				else
					player_info[tostring(steamID)][main][tostring(k1)]["talentExperience"] = 0
				end
				player_info[tostring(steamID)][main][tostring(k1)]["UnitName"] = quests[main][tostring(k1)]["UnitName"]
				if v1['options'] then
					if v1['options']['renewable'] then
						player_info[tostring(steamID)][main][tostring(k1)]["renewable"] = v1['options']['renewable']
					end
					if v1['options']['close_all_after_end'] then
						player_info[tostring(steamID)][main][tostring(k1)]["close_all_after_end"] = v1['options']['close_all_after_end']
					end
					if v1['options']['only_for_one'] then
						player_info[tostring(steamID)][main][tostring(k1)]["only_for_one"] = v1['options']['only_for_one']
					end
					if v1['options']['available'] then
						player_info[tostring(steamID)][main][tostring(k1)]["available"] = v1['options']['available']
					end
					if v1['options']['lock_item_select'] then
						player_info[tostring(steamID)][main][tostring(k1)]["lock_item_select"] = v1['options']['lock_item_select']
					end
				end
				for k2,v2 in pairs(quests[main][tostring(k1)]["tasks"]) do
					player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)] = {}
					player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["have"] = 0
					player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["complete"] = false
					player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["active"] = false
					player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["UnitName"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["UnitName"]
					player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["Drop"] = false
					--print(main,k1,k2)
					--print(quests[main][tostring(k1)]["tasks"][tostring(k2)]["Drop"])
					
					
					
					if quests[main][tostring(k1)]["tasks"][tostring(k2)]["item"] and quests[main][tostring(k1)]["tasks"][tostring(k2)]["item"]["use_type"] == "random" then
						--local n =  RandomInt(1,)
						tab = quests[main][tostring(k1)]["tasks"][tostring(k2)]["item"]["items"]
						local i = 1
						while tab[tostring(i)] do
							i = i + 1
						end
						i = i - 1
						local n =  RandomInt(1, i)
						

						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["item"] = true
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["TextName"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["item"]["items"][tostring(n)]["TextName"]
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["DotaName"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["item"]["items"][tostring(n)]["DotaName"]
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["NotTakeAway"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["item"]["items"][tostring(n)]["NotTakeAway"] or 0
						--print("player_info1", player_info[tostring(steamID)]["main"][tostring(k1)]["tasks"][tostring(k2)]["DotaName"])
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["HowMuch"] = RandomInt(tonumber(quests[main][tostring(k1)]["tasks"][tostring(k2)]["item"]["items"][tostring(n)]["min"]), tonumber(quests[main][tostring(k1)]["tasks"][tostring(k2)]["item"]["items"][tostring(n)]["max"]))
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["Desc"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["item"]["items"][tostring(n)]["Desc"]
						--print("player_info2", player_info[tostring(steamID)]["main"][tostring(k1)]["tasks"][tostring(k2)]["HowMuch"])
						local name = player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["DotaName"]
						if Quests.dropListArray[name] == nil then
							Quests.dropListArray[name] = {}
							Quests.dropListArray[name].active = false
							for i = 0, PlayerResource:GetPlayerCount() do
								if PlayerResource:IsValidPlayer(i) then
									Quests.dropListArray[name][i] = {}
								end
							end
						end
					elseif quests[main][tostring(k1)]["tasks"][tostring(k2)]["kill"] and quests[main][tostring(k1)]["tasks"][tostring(k2)]["kill"]["use_type"] == "random"then
						tab = quests[main][tostring(k1)]["tasks"][tostring(k2)]["kill"]["units"]
						local i = 1
						while tab[tostring(i)] do
							i = i + 1
						end
						i = i - 1
						local n =  RandomInt(1, i)
						--print("carr", n)
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["carr"] = n
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["TextName"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["kill"]["units"][tostring(n)]["TextName"]
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["Desc"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["kill"]["units"][tostring(n)]["Desc"]
						--print("player_info1", player_info[tostring(steamID)]["main"][tostring(k1)]["tasks"][tostring(k2)]["DotaName"])
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["HowMuch"] = RandomInt(tonumber(quests[main][tostring(k1)]["tasks"][tostring(k2)]["kill"]["units"][tostring(n)]["min"]), tonumber(quests[main][tostring(k1)]["tasks"][tostring(k2)]["kill"]["units"][tostring(n)]["max"]))
						for _,value in pairs(quests[main][tostring(k1)]["tasks"][tostring(k2)]["kill"]["units"]) do
							local n = 1
							while value[tostring(n)] do
								local name = value[tostring(n)]
								if Quests.unitsKillList[name] == nil then
									Quests.unitsKillList[name] = {}
									Quests.unitsKillList[name].active = false
									for i = 0, PlayerResource:GetPlayerCount() do
										if PlayerResource:IsValidPlayer(i) then
											Quests.unitsKillList[name][i] = {}
										end
									end
								end
								n = n + 1
							end
						end
						
					elseif quests[main][tostring(k1)]["tasks"][tostring(k2)]["custom"] then
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["HowMuch"] = RandomInt(tonumber(quests[main][tostring(k1)]["tasks"][tostring(k2)]["custom"]["min"]), tonumber(quests[main][tostring(k1)]["tasks"][tostring(k2)]["custom"]["max"]))
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["TextName"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["custom"]["TextName"]
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["Desc"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["custom"]["Desc"]
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["type"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["custom"]["type"]
						player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["point"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["custom"]["point"]
					end
				end
			end
		end
		player_info[tostring(steamID)]["main"]["1"]["available"] = true
		
		for k1,v1 in pairs(quests['exchanger']) do
			player_info[tostring(steamID)]["exchanger"][tostring(k1)] = {}
			player_info[tostring(steamID)]["exchanger"][tostring(k1)]["available"] = 1
			if v1['options'] and v1['options']['available'] then
				player_info[tostring(steamID)]["exchanger"][tostring(k1)]["available"] = v1['options']['available']
			end
			player_info[tostring(steamID)]["exchanger"][tostring(k1)]["selectedItem"] = false
			player_info[tostring(steamID)]["exchanger"][tostring(k1)]["UnitName"] = v1['UnitName']
			
		end
        CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
	end

end

function Quests:updateParticle(n)
	local PlayerCount = PlayerResource:GetPlayerCount()
	local nPlayerID = 0
	if n then
		nPlayerID = n
		PlayerCount = n+1
	end
	for nPlayerID = 0, PlayerCount-1 do
		local steamID = PlayerResource:GetSteamAccountID(nPlayerID)
		local connectState = PlayerResource:GetConnectionState(nPlayerID)	
		if connectState ~= DOTA_CONNECTION_STATE_ABANDONED and connectState ~= DOTA_CONNECTION_STATE_FAILED and connectState ~= DOTA_CONNECTION_STATE_UNKNOWN and PlayerResource:IsValidPlayer(nPlayerID) then
			local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
			local key

			local k1 = 1
			if player_info then
				while player_info[tostring(steamID)]['main'][tostring(k1)] do
					local v1 = player_info[tostring(steamID)]['main'][tostring(k1)]
					--print("k1=", k1)
					if v1["available"] == 0 and v1["active"] == 0 and v1["complete"] == 0 then
						break
					end
					key = Quests:searchNpc(v1["UnitName"])
					unit = Entities:FindByName( nil, v1["UnitName"])
					if v1["complete"] == 1 and Quests.npcArray[key]['particle'][nPlayerID] ~= false then
						Quests:deliteParticle(key, nPlayerID, "main", 10)
					end
					-- if Quests.npcArray[key]['particle'][nPlayerID] ~= false then
					-- 	Quests:deliteParticle(key, nPlayerID, "main", 10)
					-- end
					--print("updateParticle_2")
					if v1["available"] == 1 and v1["active"] == 0 then
						if Quests.npcArray[key]['particle'][nPlayerID] ~= false then
							Quests:deliteParticle(key, nPlayerID, "main", 11)
						end
						--print("updateParticle_4")
						Quests:addParticle(Quests.has_quest_main, v1["UnitName"], key, nPlayerID, 12, "main")

					elseif Quests.npcArray[key]['particle'][nPlayerID] ~= false then
						Quests:deliteParticle(key, nPlayerID, "main", 13)
					end
					for k2,v2 in pairs(v1['tasks']) do
						key = Quests:searchNpc(v2["UnitName"])
						if Quests.npcArray[key]['particle'][nPlayerID] ~= false then
							Quests:deliteParticle(key, nPlayerID, "main", 14)
						end
						if v2['HowMuch'] == v2['have'] and v2['complete'] == 0 then
							if Quests.npcArray[key]['particle'][nPlayerID] == false and v2['complete'] == 0 then
								if Quests.npcArray[key]['particle'][nPlayerID] ~= false then
									Quests:deliteParticle(key, nPlayerID, "main", 15)
								end
								--print("updateParticle_3")
								if v1['tasks'][tostring(k2+1)] == nil then
									Quests:addParticle(Quests.complite_quest_main, v2["UnitName"], key, nPlayerID, 16, "main")
								else
									Quests:addParticle(Quests.has_quest_main, v2["UnitName"], key, nPlayerID, 17, "main")
								end
							end
						elseif v2['HowMuch'] ~= v2['have'] and v2['active'] == 1 and Quests.npcArray[key]['particle'][nPlayerID] ~= false then
							Quests:deliteParticle(key, nPlayerID, "main", 18)
						end
					end
					k1 = k1 + 1
				end

				local npc = {}
				local k1 = 1
				while player_info[tostring(steamID)]['bonus'][tostring(k1)] do
					local v1 = player_info[tostring(steamID)]['bonus'][tostring(k1)]
					key = Quests:searchNpc(v1["UnitName"])
					unit = Entities:FindByName( nil, v1["UnitName"])
					if v1["complete"] == 1 and Quests.npcArray[key]['particle'][nPlayerID] ~= false then
						Quests:deliteParticle(key, nPlayerID, "bonus", 1)
					end
					if npc[v1["UnitName"]] == nil or npc[v1["UnitName"]][1] + npc[v1["UnitName"]][2] == 0 then
						npc[v1["UnitName"]] = {
							[1] = tonumber(v1["available"]), 
							[2] = tonumber(v1["active"])
						}
					end
					if v1["available"] == 1 and v1["active"] == 0 then
						if Quests.npcArray[key]['particle'][nPlayerID] ~= false then
							Quests:deliteParticle(key, nPlayerID, "bonus", 2)
						end
						Quests:addParticle(Quests.has_quest_bonus, v1["UnitName"], key, nPlayerID, 3, "bonus")
					elseif v1["available"] == 0 and v1["active"] == 1 and Quests.npcArray[key]['particle'][nPlayerID] ~= false then
						Quests:deliteParticle(key, nPlayerID, "bonus", 4)
					elseif npc[v1["UnitName"]][1] + npc[v1["UnitName"]][2] == 0 and Quests.npcArray[key]['particle'][nPlayerID] ~= false then
						Quests:deliteParticle(key, nPlayerID, "bonus", 0)
					end
					for k2,v2 in pairs(v1['tasks']) do
						key = Quests:searchNpc(v2["UnitName"])
						if v2['complete'] == 1 and Quests.npcArray[key]['particle'][nPlayerID] ~= false then
							Quests:deliteParticle(key, nPlayerID, "bonus", 5)
						end
						if v2['HowMuch'] == v2['have'] and v2['complete'] == 0 then
							if Quests.npcArray[key]['particle'][nPlayerID] == false and v2['complete'] == 0 then
								if Quests.npcArray[key]['particle'][nPlayerID] ~= false then
									Quests:deliteParticle(key, nPlayerID, "bonus", 6)
								end
								if v1['tasks'][tostring(k2+1)] == nil then
									Quests:addParticle(Quests.complite_quest_bonus, v2["UnitName"], key, nPlayerID, 7, "bonus")
								else
									Quests:addParticle(Quests.has_quest_bonus, v2["UnitName"], key, nPlayerID, 8, "bonus")
								end
							end
						elseif v2['HowMuch'] ~= v2['have'] and v2['active'] == 1 and Quests.npcArray[key]['particle'][nPlayerID] ~= false then
							Quests:deliteParticle(key, nPlayerID, "bonus", 9)
						end
					end
					k1 = k1 + 1
				end

				for k1,v1 in pairs(player_info[tostring(steamID)]['exchanger']) do
					key = Quests:searchNpc(v1["UnitName"])
					unit = Entities:FindByName( nil, v1["UnitName"])
					if v1["available"] == 1 then
						if Quests.npcArray[key]['particle'][nPlayerID] ~= false then
							Quests:deliteParticle(key, nPlayerID, "main")
						end
						Quests:addParticle(Quests.has_quest_bonus, v1["UnitName"], key, nPlayerID)
					end
				end
			end
		end
	end
end

function Quests:searchNpc(name)
	for k,v in pairs(Quests.npcArray) do
		if v['name'] == name then
			return k
		end
	end
end


function Quests:deliteParticle(key, nPlayerID, t, n)
	local unit = Quests.npcArray[key]["unit"]
	if t == "bonus" and (unit.ParticleInfo[nPlayerID] == Quests.complite_quest_main or unit.ParticleInfo[nPlayerID] == Quests.has_quest_main) then return end
	ParticleManager:DestroyParticle( Quests.npcArray[key]['particle'][nPlayerID], false )
	ParticleManager:ReleaseParticleIndex( Quests.npcArray[key]['particle'][nPlayerID] )
	Quests.npcArray[key]['particle'][nPlayerID] = false
	
	
	unit.ParticleInfo[nPlayerID] = nil
end

function Quests:addParticle(url, name, key, nPlayerID, n, t)
	local unit = Quests.npcArray[key]["unit"]
	if t == "bonus" and (unit.ParticleInfo[nPlayerID] == Quests.complite_quest_main or unit.ParticleInfo[nPlayerID] == Quests.has_quest_main) then 
		return
	end
	unit.ParticleInfo[nPlayerID] = url
	local npcParticle = ParticleManager:CreateParticleForPlayer( url, PATTACH_OVERHEAD_FOLLOW, unit ,PlayerResource:GetPlayer(nPlayerID))
	ParticleManager:SetParticleControlEnt( npcParticle, PATTACH_OVERHEAD_FOLLOW, unit, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", unit:GetAbsOrigin(), true )
	Quests.npcArray[key]['particle'][nPlayerID] = npcParticle
end

function Quests:createNPC()
	
	--local blacksmith = CreateUnitByName("blacksmith", Entities:FindByName(nil,"blacksmith"):GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
    --blacksmith:SetAngles(0,300,0)
    --blacksmith:AddNewModifier(blacksmith,nil,"modifier_shopkeeper",{})
	--blacksmith:SetUnitName(tostring(Quests.npcName .. i))
--	local blacksmith2 = CreateUnitByName("Smithy_1", Vector(-404, -10435, 640), false, nil, nil, DOTA_TEAM_GOODGUYS)
--	local blacksmith3 = CreateUnitByName("Smithy_2", Vector(-10975, 2231, 256), false, nil, nil, DOTA_TEAM_GOODGUYS)
--	blacksmith2:AddNewModifier(blacksmith2,nil,"modifier_quest",{})
--	blacksmith3:AddNewModifier(blacksmith3,nil,"modifier_quest",{})
	

	for i = 1, Quests.npcMaxNumber do
		local blacksmith = CreateUnitByName("blacksmith", Entities:FindByName(nil, Quests.pointName .. i):GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
		--blacksmith:SetUnitName(tostring(Quests.npcName .. i))
		----print(blacksmith:GetUnitName())
		--unit:SetAngles(0,300,0)
    	blacksmith:AddNewModifier(blacksmith,nil,"modifier_quest",{})
		blacksmith.ParticleInfo = {}
		--unit:SetUnitName(tostring(Quests.npcName .. i))

		
		
		
		--local unit = Entities:FindByName( nil, Quests.npcName .. i)
		
		--local blacksmith = CreateUnitByName("blacksmith" , Entities:FindByName( nil, Quests.npcName .. i):GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)

		--blacksmith:SetAngles(0,300,0)
		--[[
		unit:SetUnitName(tostring(Quests.npcName .. i))
		--print(unit:GetUnitName())
		unit:AddNewModifier(unit,nil,"modifier_quest",{})
		----print(Entities:FindByName( nil, blacksmith))
		]]
		--local particleLeader = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_has_quest.vpcf", PATTACH_OVERHEAD_FOLLOW, unit )
		--local particleLeader = ParticleManager:CreateParticle( "particles/quest/marker_complite_quest_bonus.vpcf", PATTACH_OVERHEAD_FOLLOW, unit )
		--local particleLeader = ParticleManager:CreateParticleForPlayer( "particles/quest/marker_complite_quest_bonus.vpcf", PATTACH_OVERHEAD_FOLLOW, unit ,PlayerResource:GetPlayer(0))
		--ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, unit, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", unit:GetAbsOrigin(), true )
		
		--ParticleManager:SetParticleControl(particleLeader, 0, Vector(Point.x+200 , Point.y+200, Point.z+200))
		--[[
		Timers:CreateTimer(2, function() 
			ParticleManager:DestroyParticle( particleLeader, false )
			ParticleManager:ReleaseParticleIndex( particleLeader )
		end)
		]]
		--local spawnLocation2 = unit:GetAbsOrigin()
		--local hero = PlayerResource:GetPlayer(0)
		--hero = hero:GetAssignedHero()
		----print('hero_2:',hero)
        --MinimapEvent(DOTA_TEAM_GOODGUYS, hero:GetAssignedHero(), spawnLocation2.x, spawnLocation2.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 60)
		local quest = {}
		quest['name'] = Quests.npcName .. i 
		quest['unit'] = blacksmith
		quest['particle'] = {}
		for nPlayerID = 0, 4 do
			quest['particle'][nPlayerID] = false
		end
		table.insert(Quests.npcArray, quest)
	end
	
	--CustomGameEventManager:Send_ServerToAllClients( "load_npc", quests_array)
	local index_name = {}
	for i = 1, Quests.npcMaxNumber do
		index_name[i] = {
			name = Quests.npcArray[i]["name"],
			index = Quests.npcArray[i]["unit"]:entindex()
		}
	end
	--print(index_name[1]["name"])
	CustomGameEventManager:Send_ServerToAllClients( "npcInfo", {
		list = index_name,
		mode = diff_wave.rating_scale
	})
	
	Timers:CreateTimer(2, function() Quests:updateParticle()  end)
end




function Quests:linkmod(string)
    LinkLuaModifier(string, "modifiers/"..string, LUA_MODIFIER_MOTION_NONE)
end

function Quests:minimapEvent(t)
	Quests:updateMinimap(t.pid, {t.type,t.number,t.task})
end

function Quests:AutoQuestToggleInit()
	for i = 1, PlayerResource:GetPlayerCount() do
		local subscribe = false 
		if RATING["rating"][i]["patron"] and RATING["rating"][i]["patron"] == 1 then
			subscribe = true
		end
		if PlayerResource:IsValidPlayer(i-1) and RATING["rating"][i] and RATING["rating"][i]['auto_quest_trial'] ~= nil then
			Quests.trialPeriodCount[i-1] = RATING["rating"][i]['auto_quest_trial']
			if subscribe and RATING["rating"][i]['auto_quest'] and RATING["rating"][i]['auto_quest'] == 1 then
				Quests.auto[i-1] = true
			else
				Quests.auto[i-1] = false
			end
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(i-1),"change_auto_quest_toggle_state",{
				toggle_state = Quests.auto[i-1], 
				count = Quests.trialPeriodCount[i-1],
				subscribe = subscribe,
			})
		end
	end
end

function Quests:auto_quest_toggle(t)
	local subscribe = false 
	if RATING["rating"][t.PlayerID+1]["patron"] and RATING["rating"][t.PlayerID+1]["patron"] == 1 then
		subscribe = true
	end
	if subscribe == false and Quests.trialPeriodCount[t.PlayerID] > 0 then
		Quests.trialPeriodCount[t.PlayerID] = RATING["rating"][t.PlayerID+1]['auto_quest_trial'] - 1
		Quests.auto[t.PlayerID] = t.toggle_state == 1
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID),"change_auto_quest_toggle_state",{
			toggle_state = Quests.auto[t.PlayerID], 
			count = Quests.trialPeriodCount[t.PlayerID],
			subscribe = subscribe,
		})
	elseif subscribe == false then
		if t.toggle_state == 1 then
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID),"change_auto_quest_toggle_state",{
				toggle_state = false, 
				count = Quests.trialPeriodCount[t.PlayerID],
				subscribe = subscribe,
			})
		end
	elseif subscribe == true then
		Quests.auto[t.PlayerID] = t.toggle_state == 1
		DataBase:AutoQuestToggle(t)
	end
end

function Quests:AutoComplete(t)
	t.task = t.task + 1
	t.number = tonumber(t.number)
	Quests:acceptButton(t)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.pid),"QuestEmitSound",{})
end

function Quests:selectItem(t)
	local steamID = PlayerResource:GetSteamAccountID(t.pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['selectedItem'] = t.itemname
	CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
end

function Quests:acceptButton(t)
	local steamID = PlayerResource:GetSteamAccountID(t.pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	local sound = false
	if t.type == 'exchanger' then
		sound = Quests:findExchangerItem(t.pid, t.number)
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.pid),"ActivateShop",{name = t.name, index = t.index, sound = sound})
		return
	end
	if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['complete'] == 1 then
		Timers:CreateTimer(0, function() CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.pid),"open_quest_window",{index = t.index, sound = sound})  end)
		return
	elseif player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['active'] == 0 then
		--1
		if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['available'] == 0 then
			Timers:CreateTimer(0, function() CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.pid),"open_quest_window",{index = t.index, sound = sound})  end)
			return
		end
		player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['active'] = 1
		player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['available'] = 0
		player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)]['active'] = 1
		if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]["only_for_one"] == 1 then
			for i = 0, PlayerResource:GetPlayerCount()-1 do
				if PlayerResource:IsValidPlayer(i) then
					local sID = PlayerResource:GetSteamAccountID(i)
					local player_info_local = CustomNetTables:GetTableValue("player_info", tostring(sID))
					player_info_local[tostring(sID)][tostring(t.type)][tostring(t.number)]['available'] = 0
					CustomNetTables:SetTableValue("player_info",  tostring(sID), player_info_local)
				end
			end
		end
		if t.type == "bonus" and t.number == 2 and t.task == 1 then
			for _,n in ipairs({"raid_boss","raid_boss2","raid_boss3","raid_boss4"}) do
				if Entities:FindByName(nil, n) == nil then
					player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)]['have'] = player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)]['have'] + 1
				end
			end
		end
	elseif player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)] then
		if tonumber(player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)]['have']) < tonumber(player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)]['HowMuch']) then
			Timers:CreateTimer(0, function() CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.pid),"open_quest_window",{index = t.index, sound = sound})  end)
			return
		end
		-- 2 .... last -1
		player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)]['complete'] = 1
		player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)]['active'] = 0
		player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)]['active'] = 1
		
	elseif player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)] == nil then
		if t.type == 'bonus' and tonumber(t.number) == Quests.midLine[2] and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['selectedItem'] == 0 then
			return
		end
		if tonumber(player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)]['have']) < tonumber(player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)]['HowMuch']) then
			Timers:CreateTimer(0, function() CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.pid),"open_quest_window",{index = t.index, sound = sound})  end)
			return
		end
		--give revard
		player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)]['complete'] = 1
		player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)]['active'] = 0
		player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['complete'] = 1
		if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number+1)] ~= nil and t.type == 'main' then
			player_info[tostring(steamID)][tostring(t.type)][tostring(t.number+1)]['available'] = 1
		end
		if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['selectedItem'] ~= 0 then
			Quests.giveSelectedItem(t.type, t.number, t.task, t.pid)
		end
		Quests:giveReward(t.type, t.number, t.task, t.pid)
		if t.type == 'bonus' and t.number == Quests.midLine[2] and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['selectedItem'] ~= 0 then
			local selectedItem = player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]["selectedItem"]
			player_info[tostring(steamID)][tostring(t.type)][tostring(12)]["selectedItem"] = selectedItem
			player_info[tostring(steamID)][tostring(t.type)][tostring(13)]["selectedItem"] = selectedItem
			player_info[tostring(steamID)][tostring(t.type)][tostring(14)]["selectedItem"] = selectedItem
			player_info[tostring(steamID)][tostring(t.type)][tostring(15)]["selectedItem"] = selectedItem
			player_info[tostring(steamID)][tostring(t.type)][tostring(16)]["selectedItem"] = selectedItem
			player_info[tostring(steamID)][tostring(t.type)][tostring(17)]["selectedItem"] = selectedItem
			player_info[tostring(steamID)][tostring(t.type)][tostring(18)]["selectedItem"] = selectedItem
		end
		if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]["close_all_after_end"] == 1 then
			for i = 0, PlayerResource:GetPlayerCount()-1 do
				if PlayerResource:IsValidPlayer(i) then
					local sID = PlayerResource:GetSteamAccountID(i)
					local player_info_local = CustomNetTables:GetTableValue("player_info", tostring(sID))
					if player_info_local then
						player_info_local[tostring(sID)][tostring(t.type)][tostring(t.number)]['complete'] = 1
						player_info_local[tostring(sID)][tostring(t.type)][tostring(t.number)]['available'] = 0
						CustomNetTables:SetTableValue("player_info",  tostring(sID), player_info_local)
					end
				end
			end
		end
		sound = true
	end
	CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
	
	if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]["renewable"] == 1
	and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)] == nil then
		Quests:renewableQuest(t.type, t.number, t.task, t.pid)
	end
	if Quests.questTabel[tostring(t.type)][tostring(t.number)]['unlock']
	and Quests.questTabel[tostring(t.type)][tostring(t.number)]['unlock']["1"]
	and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)] == nil then
		Quests:unlockQuest(Quests.questTabel[tostring(t.type)][tostring(t.number)]['unlock'], t.pid)
	end
	
	if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)] then
		Quests:updateMinimap(t.pid, {t.type,t.number,t.task})
	end
	Quests:updateKillList()
	Quests:createDropList()
	if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)] and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)]["NotTakeAway"] == 0 then
		Quests:deliteItem(t.type, t.number, t.task, t.pid)
	end
	Quests:giveQuestItem(t.type, t.number, t.task, t.pid)
	Timers:CreateTimer(0, function() CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.pid),"open_quest_window",{index = t.index, sound = sound})  end)
	Quests:basically_complete(t.type, t.number, t.task, t.pid)
	Quests:updateParticle()
	if Quests.auto[t.pid] == true and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['complete'] == 1 and player_info[tostring(steamID)][t.type][tostring(t.number+1)] ~= nil then
		if t.type == 'main' then
			t.number = t.number + 1
			t.task = 1
			Quests:acceptButton(t)
		elseif t.type == 'bonus' and table.has_value(Quests.midLine, tonumber(t.number) ) then
			local pos = table.findkey(Quests.midLine, tonumber(t.number))
			if pos < #Quests.midLine then
				t.number = Quests.midLine[pos+1]
				t.task = 1
				Quests:acceptButton(t)
			end
		elseif t.type == 'bonus' and table.has_value(Quests.midLine2, tonumber(t.number) ) then
			local pos = table.findkey(Quests.midLine2, tonumber(t.number))
			if pos < #Quests.midLine2 then
				t.number = Quests.midLine2[pos+1]
				t.task = 1
				Quests:acceptButton(t)
			end
		end
	end
	
end

function Quests:updateTaikAndMaik(pid)
	Quests.damageMake = {}
	Quests.damageTaik = {}
	for i = 0, PlayerResource:GetPlayerCount() do
		if PlayerResource:IsValidPlayer(i) then
			local steamID = PlayerResource:GetSteamAccountID(i)
			local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
			for k1,v1 in pairs(player_info[tostring(steamID)]) do
				for  k2,v2 in pairs(player_info[tostring(steamID)][k1]) do
					if v2['active'] == 1 then
						for k3,v3 in pairs(player_info[tostring(steamID)][k1][k2]['tasks']) do
							local TextName = nil
							if Quests.questTabel[k1][k2]['tasks'][k3]['custom'] then
								TextName = Quests.questTabel[k1][k2]['tasks'][k3]['custom']['TextName']
							end
							
							if v3['active'] == 1 and TextName and TextName == 'quest_tank_damage' then
								table.insert(Quests.damageMake, {pid, k1, k2, k3})
							elseif v3['active'] == 1 and TextName and TextName == 'quest_make_damage' then
								table.insert(Quests.damageTaik, {pid, k1, k2, k3})
							end
						end
					end
				end
			end
		end
	end
end

function Quests:createDropList()

	for key,value in pairs(Quests.dropListArray) do
		Quests.dropListArray[key].active = false
		for i = 0, PlayerResource:GetPlayerCount() do
			if PlayerResource:IsValidPlayer(i) then
				Quests.dropListArray[key][i] = {}
			end
		end
	end
	for i = 0, PlayerResource:GetPlayerCount() do
		if PlayerResource:IsValidPlayer(i) then
			local steamID = PlayerResource:GetSteamAccountID(i)
			local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
			if player_info then
				for k1,v1 in pairs(player_info[tostring(steamID)]) do
					for  k2,v2 in pairs(player_info[tostring(steamID)][k1]) do
						if v2['active'] == 1 then
							for k3,v3 in pairs(player_info[tostring(steamID)][k1][k2]['tasks']) do
								if v3['active'] == 1 and v3['DotaName'] then
									local name = v3['DotaName']
									Quests.dropListArray[name].active = true
									table.insert(Quests.dropListArray[name][i], {k1, k2, k3})
								end
							end
						end
					end
				end
			end
		end
	end
end

function Quests:updateKillList()
	--print('updateKillList')
	for key,value in pairs(Quests.unitsKillList) do
		Quests.unitsKillList[key].active = false
		for i = 0, PlayerResource:GetPlayerCount() do
			if PlayerResource:IsValidPlayer(i) then
				Quests.unitsKillList[key][i] = {}
			end
		end
	end
	--print('cleart table')
	--DeepPrintTable(Quests.unitsKillList)
	for k1,v1 in pairs(Quests.questTabel) do
		if k1 ~= 'exchanger' then
			for k2,v2 in pairs(v1) do
				for k3,v3 in pairs(v2['tasks']) do
					local kill = v3['kill']
					--print(k1,k2,k3)
					--DeepPrintTable(kill)
					if kill then
						-- сбор имен
						if kill["use_type"] == "random" then
							for i = 0, PlayerResource:GetPlayerCount() do
								if PlayerResource:IsValidPlayer(i) then
									local steamID = PlayerResource:GetSteamAccountID(i)
									local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
									if player_info then
										local n = player_info[tostring(steamID)][tostring(k1)][tostring(k2)]["tasks"][tostring(k3)]["carr"]
										local j = 1
										while kill["units"][tostring(n)][tostring(j)] do
											local name = kill["units"][tostring(n)][tostring(j)]
											--print(name)
											if player_info[tostring(steamID)][tostring(k1)][tostring(k2)]["tasks"][tostring(k3)]["active"] == 1 then
												--print('valide')
												Quests.unitsKillList[name].active = true
												table.insert(Quests.unitsKillList[name][i], {k1, k2, k3})
											end
											j = j + 1
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	--DeepPrintTable(Quests.unitsKillList)
end

function Quests:updateDrop(type, number, task, pid)
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	local arr = player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['Drop']
	--print('Quests:updateDrop2')
	--print(arr)
	if arr ~= 0 then
		local list = Quests.DropArray
		--print('Quests:updateDrop')
		Quests.AddDropArray[tostring(player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['Drop'].item)] = player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['Drop']
		--DeepPrintTable(Quests.AddDropArray)
		GameMode:newDropList(Quests.AddDropArray)
	end
end

function Quests:basically_complete(type, number, task, pid)
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	if player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task+1)] 
	and player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]["type"] == "npc"
	then
		player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['complete'] = 1
		player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['active'] = 0
		player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task+1)]['active'] = 1
	end
	CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
end

function Quests:findExchangerItem(pid, number)
	local hero = PlayerResource:GetSelectedHeroEntity( pid )
	local ItemName = Quests.questTabel['exchanger'][tostring(number)]['exchange']['DotaName']
	local HowMuch = Quests.questTabel['exchanger'][tostring(number)]['exchange']['HowMuch']
	local Key = hero:FindItemInInventory( ItemName )
	if Key == nil then
		return false
	end 
	local n = Key:GetCurrentCharges()
	if Key ~= nil and HowMuch == 1 and n == 0 then
		Quests:giveReward('exchanger', number, 0, pid)
	end
	while n >= HowMuch do
		n = n - HowMuch
		Quests:giveReward('exchanger', number, 0, pid)
	end

	if n < 0 then
		return false
	else
		hero:RemoveItem(Key)
		if n == 0 then
			return true
		end 
		hero:AddItemByName(ItemName)
		Key = hero:FindItemInInventory( ItemName )
		Key:SetCurrentCharges(n)
		return true
	end

end

function Quests:unlockQuest(unlock, pid)
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	for k1,v1 in pairs(unlock) do
		player_info[tostring(steamID)][tostring(v1["type"])][tostring(v1["number"])]['available'] = 1
	end
	CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
	Quests:updateParticle()
end

function Quests:renewableQuest(type, number, task, pid)
	Quests:updateParticle()
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	player_info[tostring(steamID)][tostring(type)][tostring(number)]['active'] = 0
	player_info[tostring(steamID)][tostring(type)][tostring(number)]['complete'] = 0
	player_info[tostring(steamID)][tostring(type)][tostring(number)]['available'] = 1
	player_info[tostring(steamID)][tostring(type)][tostring(number)]['selectedItem'] = 0
	for k1,v1 in pairs(player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks']) do
		player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][k1]['complete'] = 0
		player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][k1]['active'] = 0
		player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][k1]['have'] = 0
	end
	CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
end

function Quests:giveQuestItem(type, number, task, pid)
	if Quests.questTabel[tostring(type)][tostring(number)]['tasks'][tostring(task)]
	and	Quests.questTabel[tostring(type)][tostring(number)]['tasks'][tostring(task)]['giveItem'] then
		local quantity = 1
		if Quests.questTabel[tostring(type)][tostring(number)]['tasks'][tostring(task)]['giveItem']['quantity'] then
			quantity = tonumber(Quests.questTabel[tostring(type)][tostring(number)]['tasks'][tostring(task)]['giveItem']['quantity'])
		end
		Quests.giveItem(pid, Quests.questTabel[tostring(type)][tostring(number)]['tasks'][tostring(task)]['giveItem']['DotaName'], quantity)
	end
end

function Quests:giveReward(type, number, task, pid)
	local hero = PlayerResource:GetSelectedHeroEntity( pid )
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	
	if Quests.questTabel[tostring(type)][tostring(number)]['reward']['items'] then
		for k,v in pairs(Quests.questTabel[tostring(type)][tostring(number)]['reward']['items']) do
			local item = v['DotaName']
			local to = 1
			if v['quantity'] then
				to = tonumber(v['quantity'])
			end 
			Quests.giveItem(pid, item, to)
		end
	end
	local bonusGold = tonumber(player_info[tostring(steamID)][tostring(type)][tostring(number)]['gold'])
	local bonusExperience = tonumber(player_info[tostring(steamID)][tostring(type)][tostring(number)]['experience'])
	hero:ModifyGoldFiltered(bonusGold, true, 0)
	-- local totalgold = hero:GetGold() + bonusGold
	-- hero:SetGold(0 , false) 
	-- hero:SetGold(totalgold , false) 
	-- herogold:addGold(pid,bonusGold)
	hero:AddExperience(bonusExperience, 0, true, true)
	-- local bonusTalant = 0
	-- if diff_wave.rating_scale == 1 then 
	-- 	bonusTalant = 15
	-- elseif diff_wave.rating_scale == 2 then
	-- 	bonusTalant = 20
	-- elseif diff_wave.rating_scale == 3 then 
	-- 	bonusTalant = 25
	-- elseif diff_wave.rating_scale == 4 then 
	-- 	bonusTalant = 30
	-- end
	if player_info[tostring(steamID)][tostring(type)][tostring(number)]['talentExperience'] then
		talants:giveExperienceFromQuest(pid, tonumber(player_info[tostring(steamID)][tostring(type)][tostring(number)]['talentExperience']))
	end
	
	--print('give revard')
end

function Quests.giveSelectedItem(type, number, task, pid)
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	local itemName = player_info[tostring(steamID)][tostring(type)][tostring(number)]['selectedItem']
	for k,v in pairs(Quests.questTabel[tostring(type)][tostring(number)]['reward']['ChoosItems']) do
		local quantity = 1
		if v['quantity'] then
			quantity = tonumber(v['quantity'])
		end
		if v['DotaName'] == itemName then
			Quests.giveItem(pid, itemName, quantity)
		end
	end
end



function Quests.giveItem(id, itemName, n)
	-- print('giveItem')
	local hero = PlayerResource:GetSelectedHeroEntity( id )
	for i = 1, n do
		if itemName == 'item_dragon_soul' or itemName == 'item_dragon_soul_2' or itemName == 'item_dragon_soul_3' then
			sInv:AddSoul(itemName, id)
		else
			hero:AddItemByName(itemName)
		end
	end
end

function Quests:deliteItem(type, number, task, pid)
	local hero = PlayerResource:GetSelectedHeroEntity( pid )
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	if task > 1 and player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task-1)]["DotaName"] then
		
		local DotaName = player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task-1)]["DotaName"]
		local HowMuch = tonumber(player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task-1)]["HowMuch"])
		local n = 0
		if DotaName == "item_key" then
			local hRelay = Entities:FindByName( nil, "donate_cementry" )
            hRelay:Trigger(nil,nil)
		end
		for i = 0, 8 do
			local item = hero:GetItemInSlot( i ) 
			if item ~= nil then 
			   if item:GetName() == DotaName then
					if item:GetCurrentCharges() <= 1 then
						n = n + 1
						hero:RemoveItem(item)
					else
						n = n + item:GetCurrentCharges()
						hero:RemoveItem(item)
						if n > HowMuch then
							--hero:AddItemByName(item)
							--item:SetCurrentCharges( n - HowMuch )
							return true
						elseif n == HowMuch then
							return true
						end
					end
					if n >= HowMuch then
						return true
					end
			   end
			end
		end
	else 
		return false
	end
end

LinkLuaModifier( "modifier_easy", "abilities/difficult/easy", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_normal", "abilities/difficult/normal", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_hard", "abilities/difficult/hard", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ultra", "abilities/difficult/ultra", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_insane", "abilities/difficult/insane", LUA_MODIFIER_MOTION_NONE )

function Quests:OnEntityKilled( keys )
	--DeepPrintTable(Quests.unitsKillList)
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
	for _,n in ipairs({"raid_boss","raid_boss2","raid_boss3","raid_boss4"}) do
		if name == n then
			for i = 0, PlayerResource:GetPlayerCount()-1 do
				if PlayerResource:IsValidPlayer(i) then
					Quests:UpdateCounter("bonus", 2, 1, i)
				end
			end
		end
	end
	
	if (name == "dust_creep_2" or name == "dust_creep_4" or name == "dust_creep_6") and killerEntity:IsRealHero() then
		if Quests:isActive("bonus", 21, 1, killerEntity:GetPlayerID()) then
			if RandomInt(1, 100) <= 10 then
				local unit = CreateUnitByName("npc_quest_dragon", killedUnit:GetOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS)
				b1 = 0
				while b1 < 6 do
					add_item = items_level_5[RandomInt(1,#items_level_5)]
					while not unit:HasItemInInventory(add_item) do
						b1 = b1 + 1
						unit:AddItemByName(add_item)
					end
				end
				if diff_wave.wavedef == "Easy" then
					unit:AddNewModifier(unit, nil, "modifier_easy", {})
				end
				if diff_wave.wavedef == "Normal" then
					unit:AddNewModifier(unit, nil, "modifier_normal", {})
				end
				if diff_wave.wavedef == "Hard" then
					unit:AddNewModifier(unit, nil, "modifier_hard", {})
				end	
				if diff_wave.wavedef == "Ultra" then
					unit:AddNewModifier(unit, nil, "modifier_ultra", {})
				end	
				if diff_wave.wavedef == "Insane" then
					unit:AddNewModifier(unit, nil, "modifier_insane", {})
				end		
			end
		end
	end
	if (Quests.unitsKillList[name] ~= nil and Quests.unitsKillList[name].active == true) or
	(Quests.unitsKillList['any_creep'] ~= nil and Quests.unitsKillList['any_creep'].active == true)
	then
		
		local heroes = FindUnitsInRadius(killerEntity:GetTeamNumber(), killedUnit:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_CREEP_HERO + DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_ANY_ORDER, false )
		local t = false
		local k = 1
		while heroes[k] do
			if heroes[k] == killerEntity then
				t = true
				break
			end
			k = k + 1
		end
		if t == false then
			heroes[#heroes+1] = killerEntity
		end
		for i = 1, #heroes do
			if heroes[i]:IsRealHero() then
				local playerID = heroes[i]:GetPlayerID()
				local steamID = PlayerResource:GetSteamAccountID(playerID)
				local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
				local player_info_changed = false
				if player_info and heroes[i]:IsAlive() then
					if Quests.unitsKillList[name] then 
						for k,v in pairs(Quests.unitsKillList[name][playerID]) do
							local type = v[1]
							local number = v[2]
							local task = v[3]
							if player_info_changed then
								player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
							end
							if player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['have'] < player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['HowMuch'] then
								player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['have'] = player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['have'] + 1
								player_info_changed = true
								CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
								if player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['have'] == player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['HowMuch'] then
									print("Quests.auto:",Quests.auto[playerID])
									if Quests.auto[playerID] then
										Quests:AutoComplete({
											pid = playerID,
											type = type,
											number = number,
											task = task,
										})
									else
										Quests:updateParticle()
										Quests:updateMinimap(playerID, {type,number,task})
									end
								end
							end
						end
					end
					if Quests.unitsKillList['any_creep'] ~= nil and Quests.unitsKillList['any_creep'].active == true then
						for k,v in pairs(Quests.unitsKillList['any_creep'][playerID]) do
							if player_info_changed then
								player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
							end
							local type = v[1]
							local number = v[2]
							local task = v[3]
							if player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['have'] < player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['HowMuch'] then
								player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['have'] = player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['have'] + 1
								CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
								if player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['have'] == player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['HowMuch'] then
									if Quests.auto[playerID] then
										Quests:AutoComplete({
											pid = playerID,
											type = type,
											number = number,
											task = task,
										})
									else
										Quests:updateParticle()
										Quests:updateMinimap(playerID, {type,number,task})
									end
									
									
								end
							end
						end
					end
				end
			end
		end
	end
end

function Quests:updateMinimap(n, array)
	local steamID = PlayerResource:GetSteamAccountID(n)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	local hero = PlayerResource:GetPlayer(n)
	local playerID = hero:GetPlayerID()
    local heros = PlayerResource:GetSelectedHeroEntity(playerID )
	--DeepPrintTable(player_info[tostring(steamID)])
	if array == nil then
		for k1,v1 in pairs(player_info[tostring(steamID)]) do
			for k2,v2 in pairs(v1) do			
				if v2['active'] == 1 then
					for k3,v3 in pairs(v2['tasks']) do
						if v3['active'] == 1 then
							if v3['have'] < v3['HowMuch'] then
								if Quests.questTabel[k1][k2]['tasks'][k3]['abs'] then
									heros:SetTeam(DOTA_TEAM_BADGUYS)
									for k,v in pairs(Quests.questTabel[k1][k2]['tasks'][k3]['abs']) do
										Timers:CreateTimer(k-1, function()
											local x = v['x']
											local y = v['y']
											MinimapEvent(DOTA_TEAM_GOODGUYS, hero:GetAssignedHero(), x, y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 3)
										end)
									end
									heros:SetTeam(DOTA_TEAM_GOODGUYS)
								end
							elseif v3['have'] == v3['HowMuch'] then
								local key = Quests:searchNpc(v3['UnitName'])
								local npc = Quests.npcArray[key]["unit"]:GetAbsOrigin()
								heros:SetTeam(DOTA_TEAM_BADGUYS)
								MinimapEvent(DOTA_TEAM_GOODGUYS, hero:GetAssignedHero(), npc.x, npc.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5)
								heros:SetTeam(DOTA_TEAM_GOODGUYS)
							end
						end
					end
				end
			end
		end
	else
		if player_info[tostring(steamID)][tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['have'] < player_info[tostring(steamID)][tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['HowMuch'] then
			if Quests.questTabel[tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['abs'] then
				heros:SetTeam(DOTA_TEAM_BADGUYS)
				for k,v in pairs(Quests.questTabel[tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['abs']) do
					Timers:CreateTimer(k-1, function()
						--print(x,y)
						local x = v['x']
						local y = v['y']
						MinimapEvent(DOTA_TEAM_GOODGUYS, hero:GetAssignedHero(), x, y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 3)
					end)
				end
				heros:SetTeam(DOTA_TEAM_GOODGUYS)
			end
		elseif player_info[tostring(steamID)][tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['have'] == player_info[tostring(steamID)][tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['HowMuch'] then
			local key = Quests:searchNpc(player_info[tostring(steamID)][tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['UnitName'])
			local npc = Quests.npcArray[key]["unit"]:GetAbsOrigin()
			heros:SetTeam(DOTA_TEAM_BADGUYS)
			--print("updateMinimap_4")
			MinimapEvent(DOTA_TEAM_GOODGUYS, hero:GetAssignedHero(), npc.x, npc.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5)
			heros:SetTeam(DOTA_TEAM_GOODGUYS)			
		end
	end
end

function Quests:OnItemDrop(t)
	Quests:updateItems(t.player_id)
end

function Quests:OnItemPickUp(t)
	Quests:updateItems(t.PlayerID)
end

function Quests:updateItems(id)
	
	if not id then return end
	-- print('update items post if ')
	--DeepPrintTable(Quests.dropListArray)
	local someQuestComplite = false
	local steamID = PlayerResource:GetSteamAccountID(id)
	local hero = PlayerResource:GetSelectedHeroEntity( id )
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	-- DeepPrintTable(Quests.questTabel)
	if player_info then
		for k1,v1 in pairs(Quests.questTabel) do
			if k1 ~= 'exchanger' then
				for k2,v2 in pairs(v1) do
					for k3,v3 in pairs(v2['tasks']) do
						if v3['item'] then
							local ItemName = player_info[tostring(steamID)][k1][k2]['tasks'][k3]['DotaName']
							-- print("ItemName ", ItemName)
							--local have = player_info[tostring(steamID)][k1][k2]['tasks'][k3]['have']
							local have = 0
							local Key = hero:FindItemInInventory( ItemName )
							local HowMuch = player_info[tostring(steamID)][k1][k2]['tasks'][k3]['HowMuch']
							if player_info[tostring(steamID)][k1][k2]['tasks'][k3]['active'] == 1 then
								if Key == nil then
									have = 0
								else
									for i = 0, 8 do
										local item = hero:GetItemInSlot( i )
										-- print('check slot ', i, ' item ', item)
										if item ~= nil then 
											if item:GetName() == "item_key" then
												local hRelay = Entities:FindByName( nil, "donate_cementry" )
												hRelay:Trigger(nil,nil)
											end
											-- print('item name ', item:GetName(), ' Charges ', item:GetCurrentCharges())
											if item:GetName() == ItemName then
												if item:GetCurrentCharges() <= 1 then
													have = have + 1
												else
													have = have + item:GetCurrentCharges()
												end
											end
										end
										--local item = hero:GetItemInSlot(i)
										
										--local slot = GetItemSlot(hero, i)
										--item = GetItemSlot(hero, 0)
										--print(item:GetAbilityName())
									end
								end
								-- print("have ",have)
								if have ~= player_info[tostring(steamID)][k1][k2]['tasks'][k3]['have'] then
									if have == 0 then	
										player_info[tostring(steamID)][k1][k2]['tasks'][k3]['have'] = 0
									elseif have <= HowMuch then
										player_info[tostring(steamID)][k1][k2]['tasks'][k3]['have'] = have
									else
										player_info[tostring(steamID)][k1][k2]['tasks'][k3]['have'] = HowMuch
									end
									CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
									Quests:updateParticle()
									if player_info[tostring(steamID)][k1][k2]['tasks'][k3]['have'] == player_info[tostring(steamID)][k1][k2]['tasks'][k3]['HowMuch'] then
										Quests:updateMinimap(id, {k1,k2,k3})
										if Quests.auto[id] then
											Quests:AutoComplete({
												pid = id,
												type = k1,
												number = k2,
												task = k3,
											})
										end
									end
								end
							end
							
						end
					end
				end
			end
		end
	end
end

function Quests:isActive(type, number, task, id)

	local steamID = PlayerResource:GetSteamAccountID(id)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	if player_info and player_info[tostring(steamID)] and player_info[tostring(steamID)][type] and player_info[tostring(steamID)][type][tostring(number)] and player_info[tostring(steamID)][type][tostring(number)]['tasks'] and player_info[tostring(steamID)][type][tostring(number)]['tasks'][tostring(task)] and player_info[tostring(steamID)][type][tostring(number)]['tasks'][tostring(task)]['active'] == 1 then
		return true
	end
	return false
end

function Quests:SearchInTable(tab,arg)
	for key, value in pairs(tab) do
		if value == arg then
			return key
		end
	end
	return false
end



Quests:init()

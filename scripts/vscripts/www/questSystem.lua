

if QuestSystem == nil then
    _G.QuestSystem = class({})
end


function QuestSystem:init()
	ListenToGameEvent( 'npc_spawned', Dynamic_Wrap( QuestSystem, 'OnNPCSpawned'), self)
	ListenToGameEvent( 'game_rules_state_change', Dynamic_Wrap( QuestSystem, 'OnGameRulesStateChange'), self)
	ListenToGameEvent( "player_connect_full", Dynamic_Wrap( QuestSystem, "PlayerConnectFull"), self)
	ListenToGameEvent( "entity_killed", Dynamic_Wrap( QuestSystem, "OnEntityKilled"), self)
	ListenToGameEvent( "dota_hero_inventory_item_change", Dynamic_Wrap( QuestSystem, "OnItemDrop"), self)
	ListenToGameEvent("player_reconnected", Dynamic_Wrap( QuestSystem, 'OnPlayerReconnected'), self)
	ListenToGameEvent( "dota_item_picked_up", Dynamic_Wrap( QuestSystem, "OnItemPickUp"), self)
	ListenToGameEvent( "dota_rune_activated_server", Dynamic_Wrap( QuestSystem, "OnRunePickup"), self)
	
	CustomGameEventManager:RegisterListener("acceptButton", Dynamic_Wrap(QuestSystem, 'acceptButton'))
	CustomGameEventManager:RegisterListener("selectItem", Dynamic_Wrap(QuestSystem, 'selectItem'))
	CustomGameEventManager:RegisterListener("minimapEvent", Dynamic_Wrap(QuestSystem, 'minimapEvent'))
	CustomGameEventManager:RegisterListener("auto_quest_toggle", Dynamic_Wrap(QuestSystem, 'auto_quest_toggle'))
	--GameRules:GetGameModeEntity():SetDamageFilter(Dynamic_Wrap(QuestSystem, 'OnDamageDealt'), self)
    QuestSystem.questTabel = LoadKeyValues("scripts/kv/quests.txt")
	-- print("QuestSystem.questTabel", QuestSystem.questTabel)
	QuestSystem:FillTable()
	QuestSystem:linkmod('modifier_quest')
	QuestSystem:linkmod('modifier_quest_aura')
	QuestSystem.pointName = "quest_line_"
    QuestSystem.npcName = "npc_"
	QuestSystem.npcMaxNumber = 33
	QuestSystem.npcArray = {}
	QuestSystem.unitsKillList = {}
	QuestSystem.dropListArray = {}
	QuestSystem.damageMake = {}
	QuestSystem.damageTaik = {}
	QuestSystem.has_quest_main = "particles/voskl_gold.vpcf"
	QuestSystem.complite_quest_main = "particles/vopros_gold.vpcf"
	QuestSystem.has_quest_bonus = "particles/voskl_blue.vpcf"
	QuestSystem.complite_quest_bonus = "particles/vopros_blue.vpcf"
	QuestSystem.auto = {}
	QuestSystem.midLine = {9,11,12,13,14,15,16,17,18}
	QuestSystem.midLine2 = {10, 20, 25}
	QuestSystem.trialPeriodCount = {}
end

function QuestSystem:OnGameRulesStateChange()
	if GameRules:State_Get() == DOTA_GAMERULES_STATE_PRE_GAME then
		--print("OnGameRulesStateChange")
		Timers:CreateTimer(2, function() 
			QuestSystem:createNPC()
			QuestSystem:AutoQuestToggleInit()
		end)
		
		
	end
end

function QuestSystem:PlayerConnectFull()
	
end

function QuestSystem:OnRunePickup(t)
	-- QuestSystem:UpdateCounter("bonus", 1, 1, t.PlayerID)
end

function QuestSystem:OnPlayerReconnected(keys)
	local index_name = {}
	for i = 1, QuestSystem.npcMaxNumber do
		index_name[i] = {
			name = QuestSystem.npcArray[i]["name"],
			index = QuestSystem.npcArray[i]["unit"]:entindex()
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

function QuestSystem:FillTable()

	base  = {}
    options = {}
	reward = {}
	abs = {}
	kill = {}
	item = {}
	custom = {}
	giveItem = {}


	for k1, v1 in pairs(QuestSystem.questTabel) do
		for k2, v2 in pairs(QuestSystem.questTabel[k1]) do
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
			for k3,v3 in pairs(QuestSystem.questTabel[k1][k2]['tasks']) do
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
	CustomNetTables:SetTableValue("QuestSystem", 'base', base)
	CustomNetTables:SetTableValue("QuestSystem", 'options', options)
	CustomNetTables:SetTableValue("QuestSystem", 'reward', reward)
	CustomNetTables:SetTableValue("QuestSystem", 'abs', abs)
	CustomNetTables:SetTableValue("QuestSystem", 'kill', kill)
	CustomNetTables:SetTableValue("QuestSystem", 'item', item)
	CustomNetTables:SetTableValue("QuestSystem", 'custom', custom)
	CustomNetTables:SetTableValue("QuestSystem", 'giveItem', giveItem)
end

function QuestSystem:UpdateCounter(type, number, task, id, kol)
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
			if tonumber(player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["have"]) < tonumber(player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["HowMuch"]) then
				CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(id), "PlayCompletionSound", {})
			end
			player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["have"] = player_info[tostring(steamID)][tostring(type)][tostring(number)]["tasks"][tostring(task)]["HowMuch"]
			CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
			if QuestSystem.auto[id] then
				QuestSystem:AutoComplete({
					pid = id,
					type = type,
					number = number,
					task = task,
				})
			else
				QuestSystem:updateParticle()
			end
		end
    end
	
end

function QuestSystem:OnNPCSpawned(t)

	local npc = EntIndexToHScript(t.entindex)

	if npc:IsRealHero() and npc.bPlayerInit == nil then
		local playerID = npc:GetPlayerID()



		local connectState = PlayerResource:GetConnectionState(playerID)	
		if connectState == DOTA_CONNECTION_STATE_ABANDONED or connectState == DOTA_CONNECTION_STATE_FAILED or connectState == DOTA_CONNECTION_STATE_UNKNOWN then
			return
		end



		local steamID = PlayerResource:GetSteamAccountID(playerID)
		local player_info = {}
		local quests = QuestSystem.questTabel
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
					local talentExperience = tonumber(quests[main][tostring(k1)]["reward"]["talentExperience"]) * diff_wave.talent_scale
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
					player_info[tostring(steamID)][main][tostring(k1)]["tasks"][tostring(k2)]["mapoverlay"] = quests[main][tostring(k1)]["tasks"][tostring(k2)]["mapoverlay"]
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
						if QuestSystem.dropListArray[name] == nil then
							QuestSystem.dropListArray[name] = {}
							QuestSystem.dropListArray[name].active = false
							for i = 0, PlayerResource:GetPlayerCount() do
								if PlayerResource:IsValidPlayer(i) then
									QuestSystem.dropListArray[name][i] = {}
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
								if QuestSystem.unitsKillList[name] == nil then
									QuestSystem.unitsKillList[name] = {}
									QuestSystem.unitsKillList[name].active = false
									for i = 0, PlayerResource:GetPlayerCount() do
										if PlayerResource:IsValidPlayer(i) then
											QuestSystem.unitsKillList[name][i] = {}
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

function QuestSystem:updateParticle(n)
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
					key = QuestSystem:searchNpc(v1["UnitName"])
					unit = Entities:FindByName( nil, v1["UnitName"])
					if v1["complete"] == 1 and QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
						QuestSystem:deliteParticle(key, nPlayerID, "main", 10)
					end
					-- if QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
					-- 	QuestSystem:deliteParticle(key, nPlayerID, "main", 10)
					-- end
					--print("updateParticle_2")
					if v1["available"] == 1 and v1["active"] == 0 then
						if QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
							QuestSystem:deliteParticle(key, nPlayerID, "main", 11)
						end
						--print("updateParticle_4")
						QuestSystem:addParticle(QuestSystem.has_quest_main, v1["UnitName"], key, nPlayerID, 12, "main")

					elseif QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
						QuestSystem:deliteParticle(key, nPlayerID, "main", 13)
					end
					for k2,v2 in pairs(v1['tasks']) do
						key = QuestSystem:searchNpc(v2["UnitName"])
						if QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
							QuestSystem:deliteParticle(key, nPlayerID, "main", 14)
						end
						if v2['HowMuch'] == v2['have'] and v2['complete'] == 0 then
							if QuestSystem.npcArray[key]['particle'][nPlayerID] == false and v2['complete'] == 0 then
								if QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
									QuestSystem:deliteParticle(key, nPlayerID, "main", 15)
								end
								--print("updateParticle_3")
								if v1['tasks'][tostring(k2+1)] == nil then
									QuestSystem:addParticle(QuestSystem.complite_quest_main, v2["UnitName"], key, nPlayerID, 16, "main")
								else
									QuestSystem:addParticle(QuestSystem.has_quest_main, v2["UnitName"], key, nPlayerID, 17, "main")
								end
							end
						elseif v2['HowMuch'] ~= v2['have'] and v2['active'] == 1 and QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
							QuestSystem:deliteParticle(key, nPlayerID, "main", 18)
						end
					end
					k1 = k1 + 1
				end

				local npc = {}
				local k1 = 1
				while player_info[tostring(steamID)]['bonus'][tostring(k1)] do
					local v1 = player_info[tostring(steamID)]['bonus'][tostring(k1)]
					key = QuestSystem:searchNpc(v1["UnitName"])
					unit = Entities:FindByName( nil, v1["UnitName"])
					if v1["complete"] == 1 and QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
						QuestSystem:deliteParticle(key, nPlayerID, "bonus", 1)
					end
					if npc[v1["UnitName"]] == nil or npc[v1["UnitName"]][1] + npc[v1["UnitName"]][2] == 0 then
						npc[v1["UnitName"]] = {
							[1] = tonumber(v1["available"]), 
							[2] = tonumber(v1["active"])
						}
					end
					if v1["available"] == 1 and v1["active"] == 0 then
						if QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
							QuestSystem:deliteParticle(key, nPlayerID, "bonus", 2)
						end
						QuestSystem:addParticle(QuestSystem.has_quest_bonus, v1["UnitName"], key, nPlayerID, 3, "bonus")
					elseif v1["available"] == 0 and v1["active"] == 1 and QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
						QuestSystem:deliteParticle(key, nPlayerID, "bonus", 4)
					elseif npc[v1["UnitName"]][1] + npc[v1["UnitName"]][2] == 0 and QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
						QuestSystem:deliteParticle(key, nPlayerID, "bonus", 0)
					end
					for k2,v2 in pairs(v1['tasks']) do
						key = QuestSystem:searchNpc(v2["UnitName"])
						if v2['complete'] == 1 and QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
							QuestSystem:deliteParticle(key, nPlayerID, "bonus", 5)
						end
						if v2['HowMuch'] == v2['have'] and v2['complete'] == 0 then
							if QuestSystem.npcArray[key]['particle'][nPlayerID] == false and v2['complete'] == 0 then
								if QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
									QuestSystem:deliteParticle(key, nPlayerID, "bonus", 6)
								end
								if v1['tasks'][tostring(k2+1)] == nil then
									QuestSystem:addParticle(QuestSystem.complite_quest_bonus, v2["UnitName"], key, nPlayerID, 7, "bonus")
								else
									QuestSystem:addParticle(QuestSystem.has_quest_bonus, v2["UnitName"], key, nPlayerID, 8, "bonus")
								end
							end
						elseif v2['HowMuch'] ~= v2['have'] and v2['active'] == 1 and QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
							QuestSystem:deliteParticle(key, nPlayerID, "bonus", 9)
						end
					end
					k1 = k1 + 1
				end

				for k1,v1 in pairs(player_info[tostring(steamID)]['exchanger']) do
					key = QuestSystem:searchNpc(v1["UnitName"])
					unit = Entities:FindByName( nil, v1["UnitName"])
					if v1["available"] == 1 then
						if QuestSystem.npcArray[key]['particle'][nPlayerID] ~= false then
							QuestSystem:deliteParticle(key, nPlayerID, "main")
						end
						QuestSystem:addParticle(QuestSystem.has_quest_bonus, v1["UnitName"], key, nPlayerID)
					end
				end
			end
		end
	end
end

function QuestSystem:searchNpc(name)
	for k,v in pairs(QuestSystem.npcArray) do
		if v['name'] == name then
			return k
		end
	end
end


function QuestSystem:deliteParticle(key, nPlayerID, t, n)
	local unit = QuestSystem.npcArray[key]["unit"]
	if t == "bonus" and (unit.ParticleInfo[nPlayerID] == QuestSystem.complite_quest_main or unit.ParticleInfo[nPlayerID] == QuestSystem.has_quest_main) then return end
	ParticleManager:DestroyParticle( QuestSystem.npcArray[key]['particle'][nPlayerID], false )
	ParticleManager:ReleaseParticleIndex( QuestSystem.npcArray[key]['particle'][nPlayerID] )
	QuestSystem.npcArray[key]['particle'][nPlayerID] = false
	
	
	unit.ParticleInfo[nPlayerID] = nil
end

function QuestSystem:addParticle(url, name, key, nPlayerID, n, t)
	local unit = QuestSystem.npcArray[key]["unit"]
	if t == "bonus" and (unit.ParticleInfo[nPlayerID] == QuestSystem.complite_quest_main or unit.ParticleInfo[nPlayerID] == QuestSystem.has_quest_main) then 
		return
	end
	unit.ParticleInfo[nPlayerID] = url
	local npcParticle = ParticleManager:CreateParticleForPlayer( url, PATTACH_OVERHEAD_FOLLOW, unit ,PlayerResource:GetPlayer(nPlayerID))
	ParticleManager:SetParticleControlEnt( npcParticle, PATTACH_OVERHEAD_FOLLOW, unit, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", unit:GetAbsOrigin(), true )
	QuestSystem.npcArray[key]['particle'][nPlayerID] = npcParticle
end

function QuestSystem:createNPC()
	for i = 1, QuestSystem.npcMaxNumber do
		local point = Entities:FindByName(nil, QuestSystem.pointName .. i)
		if not point then
			print(QuestSystem.pointName .. i)
		else
			local blacksmith = CreateUnitByName("blacksmith", point:GetAbsOrigin(), false, nil, nil, DOTA_TEAM_GOODGUYS)
			blacksmith:AddNewModifier(blacksmith,nil,"modifier_quest",{})
			blacksmith.ParticleInfo = {}
			local quest = {}
			quest['name'] = QuestSystem.npcName .. i 
			quest['unit'] = blacksmith
			quest['particle'] = {}
			for nPlayerID = 0, 4 do
				quest['particle'][nPlayerID] = false
			end
			table.insert(QuestSystem.npcArray, quest)
		end
	end
	local index_name = {}
	for i = 1, QuestSystem.npcMaxNumber do
		index_name[i] = {
			name = QuestSystem.npcArray[i]["name"],
			index = QuestSystem.npcArray[i]["unit"]:entindex()
		}
	end
	CustomGameEventManager:Send_ServerToAllClients( "npcInfo", {
		list = index_name,
		mode = diff_wave.rating_scale
	})
	Timers:CreateTimer(0.5, function() QuestSystem:updateParticle()  end)
end




function QuestSystem:linkmod(string)
    LinkLuaModifier(string, "modifiers/"..string, LUA_MODIFIER_MOTION_NONE)
end

function QuestSystem:minimapEvent(t)
	QuestSystem:updateMinimap(t.pid, {t.type,t.number,t.task})
end

function QuestSystem:AutoQuestToggleInit()
	for i = 0, PlayerResource:GetPlayerCount()-1 do
		local subscribe = false 
		if RATING["rating"][i]["patron"] and RATING["rating"][i]["patron"] == 1 then
			subscribe = true
		end
		if PlayerResource:IsValidPlayer(i) and RATING["rating"][i] and Shop.pShop[i]['auto_quest_trial'] ~= nil then
			QuestSystem.trialPeriodCount[i] = Shop.pShop[i]['auto_quest_trial']
			if subscribe and Quests.settings[i].quest_auto_submit and Quests.settings[i].quest_auto_submit == 1 then
				QuestSystem.auto[i] = true
			else
				QuestSystem.auto[i] = false
			end
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(i),"change_auto_quest_toggle_state",{
				toggle_state = QuestSystem.auto[i], 
				count = QuestSystem.trialPeriodCount[i],
				subscribe = subscribe,
			})
		end
	end
end

function QuestSystem:auto_quest_toggle(t)
	local subscribe = false 
	if RATING["rating"][t.PlayerID]["patron"] and RATING["rating"][t.PlayerID]["patron"] == 1 then
		subscribe = true
	end
	print(QuestSystem.trialPeriodCount[t.PlayerID])
	if subscribe == false and QuestSystem.trialPeriodCount[t.PlayerID] > 0 then
		QuestSystem.trialPeriodCount[t.PlayerID] = QuestSystem.trialPeriodCount[t.PlayerID] - 1
		QuestSystem.auto[t.PlayerID] = t.toggle_state == 1
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID),"change_auto_quest_toggle_state",{
			toggle_state = QuestSystem.auto[t.PlayerID], 
			count = QuestSystem.trialPeriodCount[t.PlayerID],
			subscribe = subscribe,
		})
	elseif subscribe == false then
		if t.toggle_state == 1 then
			CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.PlayerID),"change_auto_quest_toggle_state",{
				toggle_state = false, 
				count = QuestSystem.trialPeriodCount[t.PlayerID],
				subscribe = subscribe,
			})
		end
	elseif subscribe == true then
		QuestSystem.auto[t.PlayerID] = t.toggle_state == 1
		DataBase:Send(DataBase.link.SettingsSetAutoQuest, "GET", {
			checked = QuestSystem.auto[t.PlayerID],
		}, t.PlayerID, true, nil)
	end
end

function QuestSystem:AutoComplete(t)
	t.task = t.task + 1
	t.number = tonumber(t.number)
	QuestSystem:acceptButton(t)
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.pid),"QuestEmitSound",{})
end

function QuestSystem:selectItem(t)
	local steamID = PlayerResource:GetSteamAccountID(t.pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['selectedItem'] = t.itemname
	CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
end

function QuestSystem:acceptButton(t)
	local steamID = PlayerResource:GetSteamAccountID(t.pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	local sound = false
	if t.type == 'exchanger' then
		sound = QuestSystem:findExchangerItem(t.pid, t.number)
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
		if t.type == 'bonus' and tonumber(t.number) == QuestSystem.midLine[2] and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['selectedItem'] == 0 then
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
			QuestSystem.giveSelectedItem(t.type, t.number, t.task, t.pid)
		end
		QuestSystem:giveReward(t.type, t.number, t.task, t.pid)
		if t.type == 'bonus' and t.number == QuestSystem.midLine[2] and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['selectedItem'] ~= 0 then
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
		if t.type == "main" and t.number == 18 then
			Quests:UpdateCounter("daily", t.pid, 42)
		end
		if t.type == "bonus" and t.number == 18 then
			Quests:UpdateCounter("daily", t.pid, 43)
		end
	end
	CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
	
	if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]["renewable"] == 1
	and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)] == nil then
		QuestSystem:renewableQuest(t.type, t.number, t.task, t.pid)
	end
	if QuestSystem.questTabel[tostring(t.type)][tostring(t.number)]['unlock']
	and QuestSystem.questTabel[tostring(t.type)][tostring(t.number)]['unlock']["1"]
	and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)] == nil then
		QuestSystem:unlockQuest(QuestSystem.questTabel[tostring(t.type)][tostring(t.number)]['unlock'], t.pid)
	end
	
	if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task)] then
		QuestSystem:updateMinimap(t.pid, {t.type,t.number,t.task})
	end
	QuestSystem:updateKillList()
	QuestSystem:createDropList()
	if player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)] and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['tasks'][tostring(t.task-1)]["NotTakeAway"] == 0 then
		QuestSystem:deliteItem(t.type, t.number, t.task, t.pid)
	end
	QuestSystem:giveQuestItem(t.type, t.number, t.task, t.pid)
	Timers:CreateTimer(0, function() CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(t.pid),"open_quest_window",{index = t.index, sound = sound})  end)
	QuestSystem:basically_complete(t.type, t.number, t.task, t.pid)
	QuestSystem:updateParticle()
	if QuestSystem.auto[t.pid] == true and player_info[tostring(steamID)][tostring(t.type)][tostring(t.number)]['complete'] == 1 and player_info[tostring(steamID)][t.type][tostring(t.number+1)] ~= nil then
		if t.type == 'main' then
			t.number = t.number + 1
			t.task = 1
			QuestSystem:acceptButton(t)
		elseif t.type == 'bonus' and table.has_value(QuestSystem.midLine, tonumber(t.number) ) then
			local pos = table.findkey(QuestSystem.midLine, tonumber(t.number))
			if pos < #QuestSystem.midLine then
				t.number = QuestSystem.midLine[pos+1]
				t.task = 1
				QuestSystem:acceptButton(t)
			end
		elseif t.type == 'bonus' and table.has_value(QuestSystem.midLine2, tonumber(t.number) ) then
			local pos = table.findkey(QuestSystem.midLine2, tonumber(t.number))
			if pos < #QuestSystem.midLine2 then
				t.number = QuestSystem.midLine2[pos+1]
				t.task = 1
				QuestSystem:acceptButton(t)
			end
		end
	end
	
end

function QuestSystem:updateTaikAndMaik(pid)
	QuestSystem.damageMake = {}
	QuestSystem.damageTaik = {}
	for i = 0, PlayerResource:GetPlayerCount() do
		if PlayerResource:IsValidPlayer(i) then
			local steamID = PlayerResource:GetSteamAccountID(i)
			local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
			for k1,v1 in pairs(player_info[tostring(steamID)]) do
				for  k2,v2 in pairs(player_info[tostring(steamID)][k1]) do
					if v2['active'] == 1 then
						for k3,v3 in pairs(player_info[tostring(steamID)][k1][k2]['tasks']) do
							local TextName = nil
							if QuestSystem.questTabel[k1][k2]['tasks'][k3]['custom'] then
								TextName = QuestSystem.questTabel[k1][k2]['tasks'][k3]['custom']['TextName']
							end
							
							if v3['active'] == 1 and TextName and TextName == 'quest_tank_damage' then
								table.insert(QuestSystem.damageMake, {pid, k1, k2, k3})
							elseif v3['active'] == 1 and TextName and TextName == 'quest_make_damage' then
								table.insert(QuestSystem.damageTaik, {pid, k1, k2, k3})
							end
						end
					end
				end
			end
		end
	end
end

function QuestSystem:createDropList()

	for key,value in pairs(QuestSystem.dropListArray) do
		QuestSystem.dropListArray[key].active = false
		for i = 0, PlayerResource:GetPlayerCount() do
			if PlayerResource:IsValidPlayer(i) then
				QuestSystem.dropListArray[key][i] = {}
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
									QuestSystem.dropListArray[name].active = true
									table.insert(QuestSystem.dropListArray[name][i], {k1, k2, k3})
								end
							end
						end
					end
				end
			end
		end
	end
end

function QuestSystem:updateKillList()
	--print('updateKillList')
	for key,value in pairs(QuestSystem.unitsKillList) do
		QuestSystem.unitsKillList[key].active = false
		for i = 0, PlayerResource:GetPlayerCount() do
			if PlayerResource:IsValidPlayer(i) then
				QuestSystem.unitsKillList[key][i] = {}
			end
		end
	end
	--print('cleart table')
	--DeepPrintTable(QuestSystem.unitsKillList)
	for k1,v1 in pairs(QuestSystem.questTabel) do
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
												QuestSystem.unitsKillList[name].active = true
												table.insert(QuestSystem.unitsKillList[name][i], {k1, k2, k3})
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
	--DeepPrintTable(QuestSystem.unitsKillList)
end

function QuestSystem:updateDrop(type, number, task, pid)
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	local arr = player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['Drop']
	--print('QuestSystem:updateDrop2')
	--print(arr)
	if arr ~= 0 then
		local list = QuestSystem.DropArray
		--print('QuestSystem:updateDrop')
		QuestSystem.AddDropArray[tostring(player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['Drop'].item)] = player_info[tostring(steamID)][tostring(type)][tostring(number)]['tasks'][tostring(task)]['Drop']
		--DeepPrintTable(QuestSystem.AddDropArray)
		GameMode:newDropList(QuestSystem.AddDropArray)
	end
end

function QuestSystem:basically_complete(type, number, task, pid)
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

function QuestSystem:findExchangerItem(pid, number)
	local hero = PlayerResource:GetSelectedHeroEntity( pid )
	local ItemName = QuestSystem.questTabel['exchanger'][tostring(number)]['exchange']['DotaName']
	local HowMuch = QuestSystem.questTabel['exchanger'][tostring(number)]['exchange']['HowMuch']
	local Key = hero:FindItemInInventory( ItemName )
	if Key == nil then
		return false
	end 
	local n = Key:GetCurrentCharges()
	if Key ~= nil and HowMuch == 1 and n == 0 then
		QuestSystem:giveReward('exchanger', number, 0, pid)
	end
	while n >= HowMuch do
		n = n - HowMuch
		QuestSystem:giveReward('exchanger', number, 0, pid)
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

function QuestSystem:unlockQuest(unlock, pid)
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	for k1,v1 in pairs(unlock) do
		player_info[tostring(steamID)][tostring(v1["type"])][tostring(v1["number"])]['available'] = 1
	end
	CustomNetTables:SetTableValue("player_info",  tostring(steamID), player_info)
	QuestSystem:updateParticle()
end

function QuestSystem:renewableQuest(type, number, task, pid)
	QuestSystem:updateParticle()
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

function QuestSystem:giveQuestItem(type, number, task, pid)
	if QuestSystem.questTabel[tostring(type)][tostring(number)]['tasks'][tostring(task)]
	and	QuestSystem.questTabel[tostring(type)][tostring(number)]['tasks'][tostring(task)]['giveItem'] then
		local quantity = 1
		if QuestSystem.questTabel[tostring(type)][tostring(number)]['tasks'][tostring(task)]['giveItem']['quantity'] then
			quantity = tonumber(QuestSystem.questTabel[tostring(type)][tostring(number)]['tasks'][tostring(task)]['giveItem']['quantity'])
		end
		QuestSystem.giveItem(pid, QuestSystem.questTabel[tostring(type)][tostring(number)]['tasks'][tostring(task)]['giveItem']['DotaName'], quantity)
	end
end

function QuestSystem:giveReward(type, number, task, pid)
	local hero = PlayerResource:GetSelectedHeroEntity( pid )
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	
	if QuestSystem.questTabel[tostring(type)][tostring(number)]['reward']['items'] then
		for k,v in pairs(QuestSystem.questTabel[tostring(type)][tostring(number)]['reward']['items']) do
			local item = v['DotaName']
			local to = 1
			if v['quantity'] then
				to = tonumber(v['quantity'])
			end 
			QuestSystem.giveItem(pid, item, to)
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
		local experience = tonumber(player_info[tostring(steamID)][tostring(type)][tostring(number)]['talentExperience'])
		Talents:AddExperience(pid, experience, true)
		if Talents:IsPatron(pid) then
			Talents:AddExperienceDonate(pid, experience, true)
		end
	end
	
	--print('give revard')
end

function QuestSystem.giveSelectedItem(type, number, task, pid)
	local steamID = PlayerResource:GetSteamAccountID(pid)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	local itemName = player_info[tostring(steamID)][tostring(type)][tostring(number)]['selectedItem']
	for k,v in pairs(QuestSystem.questTabel[tostring(type)][tostring(number)]['reward']['ChoosItems']) do
		local quantity = 1
		if v['quantity'] then
			quantity = tonumber(v['quantity'])
		end
		if v['DotaName'] == itemName then
			QuestSystem.giveItem(pid, itemName, quantity)
		end
	end
end



function QuestSystem.giveItem(id, itemName, n)
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

function QuestSystem:deliteItem(type, number, task, pid)
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

function QuestSystem:OnEntityKilled( keys )
	--DeepPrintTable(QuestSystem.unitsKillList)
    local killedUnit = EntIndexToHScript( keys.entindex_killed )
    local killerEntity = EntIndexToHScript( keys.entindex_attacker )
	local name = killedUnit:GetUnitName()
	for _,n in ipairs({"raid_boss","raid_boss2","raid_boss3","raid_boss4"}) do
		if name == n then
			for i = 0, PlayerResource:GetPlayerCount()-1 do
				if PlayerResource:IsValidPlayer(i) then
					QuestSystem:UpdateCounter("bonus", 2, 1, i)
				end
			end
		end
	end
	
	if (name == "dust_creep_2" or name == "dust_creep_4" or name == "dust_creep_6") and killerEntity:IsRealHero() then
		if QuestSystem:isActive("bonus", 21, 1, killerEntity:GetPlayerID()) then
			if RandomInt(1, 100) <= 10 then
				local unit = CreateUnitByName("npc_quest_dragon", killedUnit:GetOrigin(), false, nil, nil, DOTA_TEAM_BADGUYS)
				b1 = 0
				while b1 < 6 do
					add_item = avaliable_creeps_items[RandomInt(1,#avaliable_creeps_items)]
					while not unit:HasItemInInventory(add_item) do
						b1 = b1 + 1
						unit:AddItemByName(add_item):SetLevel(5)
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
				if diff_wave.wavedef == "Impossible" then
					unit:AddNewModifier(unit, nil, "modifier_impossible", {})
					new_abil_passive = abiility_passive[RandomInt(1,#abiility_passive)]
					unit:AddAbility(new_abil_passive):SetLevel(4)
				end	
			end
		end
	end
	if (QuestSystem.unitsKillList[name] ~= nil and QuestSystem.unitsKillList[name].active == true) or
	(QuestSystem.unitsKillList['any_creep'] ~= nil and QuestSystem.unitsKillList['any_creep'].active == true)
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
					if QuestSystem.unitsKillList[name] then 
						for k,v in pairs(QuestSystem.unitsKillList[name][playerID]) do
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
									CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "PlayCompletionSound", {})
									if QuestSystem.auto[playerID] then
										QuestSystem:AutoComplete({
											pid = playerID,
											type = type,
											number = number,
											task = task,
										})
									else
										QuestSystem:updateParticle()
										QuestSystem:updateMinimap(playerID, {type,number,task})
									end
								end
							end
						end
					end
					if QuestSystem.unitsKillList['any_creep'] ~= nil and QuestSystem.unitsKillList['any_creep'].active == true then
						for k,v in pairs(QuestSystem.unitsKillList['any_creep'][playerID]) do
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
									CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(playerID), "PlayCompletionSound", {})
									if QuestSystem.auto[playerID] then
										QuestSystem:AutoComplete({
											pid = playerID,
											type = type,
											number = number,
											task = task,
										})
									else
										QuestSystem:updateParticle()
										QuestSystem:updateMinimap(playerID, {type,number,task})
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

function QuestSystem:updateMinimap(n, array)
	-- local steamID = PlayerResource:GetSteamAccountID(n)
	-- local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	-- local hero = PlayerResource:GetPlayer(n)
	-- local playerID = hero:GetPlayerID()
    -- local heros = PlayerResource:GetSelectedHeroEntity(playerID )
	-- if array == nil then
	-- 	for k1,v1 in pairs(player_info[tostring(steamID)]) do
	-- 		for k2,v2 in pairs(v1) do			
	-- 			if v2['active'] == 1 then
	-- 				for k3,v3 in pairs(v2['tasks']) do
	-- 					if v3['active'] == 1 then
	-- 						if v3['have'] < v3['HowMuch'] then
	-- 							if QuestSystem.questTabel[k1][k2]['tasks'][k3]['abs'] then
	-- 								heros:SetTeam(DOTA_TEAM_BADGUYS)
	-- 								for k,v in pairs(QuestSystem.questTabel[k1][k2]['tasks'][k3]['abs']) do
	-- 									Timers:CreateTimer(k-1, function()
	-- 										local x = v['x']
	-- 										local y = v['y']
	-- 										MinimapEvent(DOTA_TEAM_GOODGUYS, hero:GetAssignedHero(), x, y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 3)
	-- 									end)
	-- 								end
	-- 								heros:SetTeam(DOTA_TEAM_GOODGUYS)
	-- 							end
	-- 						elseif v3['have'] == v3['HowMuch'] then
	-- 							local key = QuestSystem:searchNpc(v3['UnitName'])
	-- 							local npc = QuestSystem.npcArray[key]["unit"]:GetAbsOrigin()
	-- 							heros:SetTeam(DOTA_TEAM_BADGUYS)
	-- 							MinimapEvent(DOTA_TEAM_GOODGUYS, hero:GetAssignedHero(), npc.x, npc.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5)
	-- 							heros:SetTeam(DOTA_TEAM_GOODGUYS)
	-- 						end
	-- 					end
	-- 				end
	-- 			end
	-- 		end
	-- 	end
	-- else
	-- 	if player_info[tostring(steamID)][tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['have'] < player_info[tostring(steamID)][tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['HowMuch'] then
	-- 		if QuestSystem.questTabel[tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['abs'] then
	-- 			heros:SetTeam(DOTA_TEAM_BADGUYS)
	-- 			for k,v in pairs(QuestSystem.questTabel[tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['abs']) do
	-- 				Timers:CreateTimer(k-1, function()
	-- 					--print(x,y)
	-- 					local x = v['x']
	-- 					local y = v['y']
	-- 					MinimapEvent(DOTA_TEAM_GOODGUYS, hero:GetAssignedHero(), x, y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 3)
	-- 				end)
	-- 			end
	-- 			heros:SetTeam(DOTA_TEAM_GOODGUYS)
	-- 		end
	-- 	elseif player_info[tostring(steamID)][tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['have'] == player_info[tostring(steamID)][tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['HowMuch'] then
	-- 		local key = QuestSystem:searchNpc(player_info[tostring(steamID)][tostring(array[1])][tostring(array[2])]['tasks'][tostring(array[3])]['UnitName'])
	-- 		local npc = QuestSystem.npcArray[key]["unit"]:GetAbsOrigin()
	-- 		heros:SetTeam(DOTA_TEAM_BADGUYS)
	-- 		--print("updateMinimap_4")
	-- 		MinimapEvent(DOTA_TEAM_GOODGUYS, hero:GetAssignedHero(), npc.x, npc.y, DOTA_MINIMAP_EVENT_HINT_LOCATION, 5)
	-- 		heros:SetTeam(DOTA_TEAM_GOODGUYS)			
	-- 	end
	-- end
end

function QuestSystem:OnItemDrop(t)
	QuestSystem:updateItems(t.player_id)
end

function QuestSystem:OnItemPickUp(t)
	QuestSystem:updateItems(t.PlayerID)
end

function QuestSystem:updateItems(id)
	
	if not id then return end
	-- print('update items post if ')
	--DeepPrintTable(QuestSystem.dropListArray)
	local someQuestComplite = false
	local steamID = PlayerResource:GetSteamAccountID(id)
	local hero = PlayerResource:GetSelectedHeroEntity( id )
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	-- DeepPrintTable(QuestSystem.questTabel)
	if player_info then
		for k1,v1 in pairs(QuestSystem.questTabel) do
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
									QuestSystem:updateParticle()
									if player_info[tostring(steamID)][k1][k2]['tasks'][k3]['have'] == player_info[tostring(steamID)][k1][k2]['tasks'][k3]['HowMuch'] then
										CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(id), "PlayCompletionSound", {})
										QuestSystem:updateMinimap(id, {k1,k2,k3})
										if QuestSystem.auto[id] then
											QuestSystem:AutoComplete({
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

function QuestSystem:isActive(type, number, task, id)

	local steamID = PlayerResource:GetSteamAccountID(id)
	local player_info = CustomNetTables:GetTableValue("player_info", tostring(steamID))
	if player_info and player_info[tostring(steamID)] and player_info[tostring(steamID)][type] and player_info[tostring(steamID)][type][tostring(number)] and player_info[tostring(steamID)][type][tostring(number)]['tasks'] and player_info[tostring(steamID)][type][tostring(number)]['tasks'][tostring(task)] and player_info[tostring(steamID)][type][tostring(number)]['tasks'][tostring(task)]['active'] == 1 then
		return true
	end
	return false
end

function QuestSystem:SearchInTable(tab,arg)
	for key, value in pairs(tab) do
		if value == arg then
			return key
		end
	end
	return false
end



QuestSystem:init()

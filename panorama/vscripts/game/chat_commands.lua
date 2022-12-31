ChatCommands = ChatCommands or class({})


function ChatCommands:Init()
	RegisterGameEventListener("player_chat", function(event)
		ChatCommands:OnPlayerChat(event)
	end)
end


function ChatCommands:OnPlayerChat(event)
	if not event.playerid then return end

	event.player = PlayerResource:GetPlayer( event.playerid )
	if not event.player then return end

	event.hero = event.player:GetAssignedHero()
	if not event.hero then return end

	event.player_id = event.hero:GetPlayerID()

	local command_source = string.trim(string.lower(event.text))
	if command_source:sub(0,1) ~= "-" then return end
	-- removing `-`
	command_source = command_source:sub(2)

	local arguments = string.split(command_source)
	local command_name = table.remove(arguments, 1)

	if ChatCommands[command_name] then
		ErrorTracking.Try(ChatCommands[command_name], ChatCommands, arguments, event)
	end

	ErrorTracking.Try(ChatCommands.GeneralProcessing, ChatCommands, command_name, arguments, event)
end


ChatCommands:Init()


-- Chat commands that rely on knowing command name go here
function ChatCommands:GeneralProcessing(command_name, arguments, event)
	if not command_name then return end
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end

	if HeroBuilder.ability_hero_map[command_name] then
		HeroBuilder:AddAbility(event.player_id, command_name, nil, true)
	end
	
	if string.find(command_name, "item_") == 1 then
		local new_item = event.hero:AddItemByName(command_name)
		if not new_item then return end
		new_item:SetSellable(true)
	end

	if RoundManager.round_data and RoundManager.round_data[command_name] and (not Enfos:IsEnfosMode()) and GameMode:HasGameStarted() then
		RoundManager:DebugMoveToRound({round_name = command_name})
	end
end

function ChatCommands:innate(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end

	local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)

	for _,unit in pairs(units) do
		HeroBuilder:LearnInnate(unit:GetPlayerID(), arguments[1])
	end
end

function ChatCommands:suicide(arguments, event)
	if GameMode:HasGameStarted() and GameMode.is_solo_pve_game and event.hero then
		GameMode:TeamLose(event.hero:GetTeam())
	end
end

function ChatCommands:pause(arguments, event)
	if GameMode:HasGameStarted() and (GameMode.is_solo_pve_game or Supporters:IsDeveloper(event.player_id)) and event.hero then
		PauseGame(not GameRules:IsGamePaused())
	end
end

function ChatCommands:events(arguments, event)
	for event_name, callbacks in pairs(EventDriver.serverside_events) do
		print(event_name, "=", #callbacks)
		for i = 1, #callbacks do
			if callbacks[i][1] then
				local callback_info = debug.getinfo(callbacks[i][1])
				local traceback_line = callback_info.short_src .. ":" .. callback_info.linedefined
				print("|\t", traceback_line)
			end
		end
		print("------------------")
	end
end


function ChatCommands:help(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end

	local help_list = {
		["-help"] = "Shows this list",
		["-redraw"] = "Opens the reroll ability menu",
		["-<ability_name>"] = "Gives you an ability eg. -dazzle_bad_juju",
		["-<item_name>"] = "Gives you an item eg. -item_blink",
		["-mastery <mastery_name> <mastery_level>"] = "Applies a mastery buff to your hero",
		["-innate <innate_name>"] = "Gives all heroes on the map the innate. eg. -innate innate_cascading_arcana",
		["-hero <hero_name>"] = "Changes your hero, BUGGY eg. -tinker",
		["-round <number>"] = "Starts a certain round",
		["-repeat_round <number>"] = "Causes the next <number> rounds to use the same wave as this one",
		["-curse <number>"] = "Gives you X number of curse stacks, buggy with UI",
		["-con"] = "Prints connection state",
		["-li"] = "Prints current items",
		["-lm"] = "Lists all modifiers on this hero",
		["-la <true/false>"] = "Lists all abilities on this hero, '-la true' for more detail",
		["-rg"] = "Report gold",
		["-uh"] = "Unhide abilities",
		["-rr"] = "Reloads scripts, VERY BUGGY",
		["-allup <number>"] = "Gives all bots X experience",
		["-refresh"] = "Refreshes ability charges",
		["-position"] = "Prints hero position",
		["-options"] = "Change options to default",
		["-debug_stats"] = "Prints info on timers, entities, creatures and frame time (ideal is 0.033333335071802)",
		["-endgame"] = "Immediately ends the current game with your team as the winner",
	}
		
	for name, description in pairs(help_list) do
		print(name, description)
	end
end


function ChatCommands:bullet_hell(arguments, event)
	if not (Supporters:IsDeveloper(event.player_id) or IsInToolsMode()) then return end
	
	local barrage_data = {
		type = "player_say",
		playerId = event.player_id,
		content = "We're no strangers to love. You know the rules, and so do I. Inside we both know what's been going on. We know the game and we're gonna play it.",
	}

	local duration = tonumber(arguments[1]) * 4

	Timers:CreateTimer(0, function()
		Barrage:FireBullet(barrage_data)
		
		if duration >= 0 then
			duration = duration - 1
			return 0.25
		end
	end)
end

function ChatCommands:kv(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) then return end
	
	local abilities_kv = LoadKeyValues("scripts/npc/npc_abilities_list.txt")

	WebApi:Send("match/send_kv", {
		kv = abilities_kv
	})
end

function ChatCommands:glory(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) or not arguments[1] then return end

	if Battlepass:GetSteamId(event.player_id) then
		BP_Inventory:AddGlory({
			steamId = Battlepass:GetSteamId(event.player_id),
			glory = tonumber(arguments[1]),
		})
	end
end


function ChatCommands:round(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end

	if not arguments[1] then return end

	local round_number = string.match(arguments[1], "%d+")
	if not round_number then return end

	if not GameMode:HasGameStarted() then return end

	RoundManager:DebugMoveToRound({round_number = round_number})
end


function ChatCommands:repeat_round(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end
	if not arguments[1] then return end

	local repeat_amount = string.match(arguments[1], "%d+")
	if not repeat_amount then return end

	local current_round = RoundManager:GetCurrentRoundNumber()
	local current_round_name = RoundManager:GetCurrentRoundName()
	for round = (current_round + 1), (current_round + repeat_amount) do
		RoundManager.round_list[round] = current_round_name
	end
end


function ChatCommands:lm(arguments, event)
	ListModifiers(event.hero)
end


function ChatCommands:la(arguments, event)
	if arguments[1] and arguments[1] == "true" then
		Util:ListAbilities(event.hero)
	else
		ListAbilities(event.hero)
	end
end


function ChatCommands:curse(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end
	if not arguments[1] then return end

	local arg = math.floor(tonumber(arguments[1]))
	local curse_modifier = event.hero:FindModifierByName("modifier_loser_curse")
	
	if arg == 0 then
		curse_modifier:Destroy()
		CustomGameEventManager:Send_ServerToAllClients("player_debuff_loser", { playerId = event.player_id, loserCount = 0, decrement = true})
		return
	end
	
	if not curse_modifier then
		curse_modifier = event.hero:AddNewModifier(event.hero, nil, "modifier_loser_curse", {})
	end
	if curse_modifier then
		curse_modifier:SetStackCount(arg)
	end
	CustomGameEventManager:Send_ServerToAllClients("player_debuff_loser", { playerId = event.player_id, loserCount = curse_modifier:GetStackCount()})
end


function ChatCommands:hero(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end
	if not arguments[1] then return end

	local hero_name = "npc_dota_hero_" .. arguments[1]
	local level = event.hero:GetLevel()

	event.hero = PlayerResource:ReplaceHeroWith(event.player_id, hero_name,  event.hero:GetGold(), 0)
	HeroBuilder:InitPlayerHero(event.hero, false, true)

	for _ = 0, level do event.hero:HeroLevelUp(false) end

	if HeroBuilder.talent_enablers[hero_name] then 
		event.hero:AddNewModifier(event.hero, nil, HeroBuilder.talent_enablers[hero_name], {}) 
	end
end


function ChatCommands:allup(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end
	if not arguments[1] then return end

	local arg = tonumber(arguments[1])

	for player_id = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
		if PlayerResource:IsValidPlayer( player_id ) then
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			if hero then
				hero:AddExperience(arg, 0, true, true)
			end
		end
	end
end


function ChatCommands:redraw(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end

	HeroBuilder:ShowRandomAbilitySelection(event.player_id)
end


function ChatCommands:refresh(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end
	
	AbilityCharges:RefreshCharges(event.hero, true)
end


function ChatCommands:position(arguments, event)
	print("[DEBUG] position:", event.hero:GetAbsOrigin())
end


function ChatCommands:rr(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end

	SendToServerConsole('script_reload')
end


function ChatCommands:timescale(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end
	if not arguments[1] then return end

	local value = tonumber(arguments[1])
	if value < 1 then value = 1 end -- if arg < 1 server freezes
	Convars:SetInt("host_timescale", value)
end


function ChatCommands:li(arguments, event)
	DeepPrintTable(HeroBuilder:GetPlayerItems(event.player_id))
end


function ChatCommands:debug_stats(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end

	local text = "DEBUG:\nTimers count: %s\nEntity count: %s\n\tnpc_dota_creature: %s\nServer frame time: %s"
	text = text:format(
		table.count(Timers.timers),
		#(Entities:FindAllInSphere(Vector(0, 0, 0), 10000) or {}) or 0,
		#(Entities:FindAllByClassname("npc_dota_creature") or {}) or 0,
		FrameTime()
	)
	CustomGameEventManager:Send_ServerToAllClients("server_print", {message = text})
end


function ChatCommands:endgame(arguments, event)
	if not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end
	
	local your_team = event.hero:GetTeam()
	for _, team in pairs(GameMode:GetAllAliveTeams()) do
		if team ~= your_team then GameMode:TeamLose(team) end
	end
	GameMode:TeamLose(your_team)
	return
end

function ChatCommands:party(arguments, event)
	if PartyMode.party_mode_enabled then return end -- remove if you want a million parties
	if not Supporters:IsPartier(event.player_id) and not Supporters:IsDeveloper(event.player_id) and not GameRules:IsCheatMode() then return end
	if not arguments[1] then return end

	if arguments[1] == "help" then
		local commands_list = {
			["-party help"] = "Shows this list",
			["-party ip"] = "Enables the Infinite Paragons party mode: allows players to buy as many books of paragon as they want",
			["-party hs"] = "Gives every player 75k gold and 40 levels",
			["-party dcs <number>"] = "Enables the Damage Casts Spells party mode",
			["-party fastdeath"] = "Enables fast death: +1 aegis to everyone, sudden death starts at round 20",
			["-party megadeath"] = "Enables mega death: +2 aegis to everyone, sudden death starts at round 1",
			["-party hardcore"] = "Enables hardcore mode: no one has aegis, sudden death starts at round 1",
		}

		for name, description in pairs(commands_list) do
			print(name, description)
		end
		return
	end

	if arguments[1] == "ip" then
		PartyMode:InfiniteParagon()
		PartyMode.party_mode_enabled = true
	end

	if arguments[1] == "hs" --[[ and arguments[2] and arguments[3] ]] then
		local gold = arguments[2] or 75000
		local levels = arguments[3] or 40
		
		PartyMode:HeadStart(gold, levels)
		PartyMode.party_mode_enabled = true
	end

	if arguments[1] == "dcs" and arguments[2] then
		local chance = tonumber(arguments[2])
		PartyMode:DamageCastsSpells(chance)
		PartyMode.party_mode_enabled = true
	end

	if arguments[1] == "fastdeath" then
		PartyMode:Fastdeath()
	end

	if arguments[1] == "megadeath" then
		PartyMode:Megadeath()
	end

	if arguments[1] == "hardcore" then
		PartyMode:Hardcore()
	end
end

function ChatCommands:test(arguments, event)
	if not IsInToolsMode() then return end

	local hero = PlayerResource:GetSelectedHeroEntity(1)
	
	SwapAbilities:ProposeSwap({ 
		PlayerID = 1, 
		own = hero:GetAbilityByIndex(0):entindex(),
		other = event.hero:GetAbilityByIndex(0):entindex(),
	})
end


function ChatCommands:ai(arguments, event)
	if not IsInToolsMode() then return end
	AI_Core:PrintAbilities()
end


function ChatCommands:ai2(arguments, event)
	if not IsInToolsMode() then return end
	for player_id, controller in pairs(AI_Core.bots) do
		controller.fully_abandoned = true
	end
end

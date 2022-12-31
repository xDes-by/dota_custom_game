AI_Responses = AI_Responses or class({})


function AI_Responses:Init()
	EventDriver:Listen("PvpManager:pvp_ended", AI_Responses.OnPVPEnded, AI_Responses)
	EventDriver:Listen("Spawner:all_creeps_killed", AI_Responses.OnAllCreepsKilled, AI_Responses)

	RESPONSE_COOLDOWN = 60

	-- response cannot be triggered often (to avoid it being annoying and spammy)
	AI_Responses.response_cooldowns = {}
end


function AI_Responses:TriggerResponse(player_id, response_type, response_index_override)
	if AI_Responses.response_cooldowns[player_id] then
		print("[AI Responses] bot response is on cooldown for", player_id)
		return
	end

	local responses_pool = AI_Responses[response_type] 

	if not responses_pool then
		print("[AI_Responses] warning: unrecognized response type", response_type)
		return
	end

	local response
	if response_index_override then
		response = responses_pool[response_index_override]
		if not response then return end
	else
		response, _ = table.random(responses_pool)
	end

	if type(response) == "table" then
		local value = 0
		if response.random_range_int then 
			value = RandomInt(response.random_range_int[1], response.random_range_int[2]) 
		end
		response = string.format(response.quote, value)
	end

	AI_Responses.response_cooldowns[player_id] = Timers:CreateTimer(RESPONSE_COOLDOWN, function()
		AI_Responses.response_cooldowns[player_id] = nil
	end)

	CustomChat:MessageToAll("<font color='#B40404'>[BOT]</font> " .. response, player_id)

	return true
end


function AI_Responses:OnPVPEnded(event)
	print("[AI_Responses] pvp ended", event.winner_team, event.loser_team)
	local bots_by_team = {}

	-- split bots into teams, use tables to pick random bot from winner and loser teams
	-- to avoid quote spam reliably

	for player_id, controller in pairs(AI_Core.bots or {}) do
		local team = PlayerResource:GetTeam(player_id)
		bots_by_team[team] = bots_by_team[team] or {}
		table.insert(bots_by_team[team], player_id)
	end

	if bots_by_team[event.winner_team] then
		-- only select bots with no cooldown on response
		local player_id = table.random_with_condition(
			bots_by_team[event.winner_team], 
			function(t, k, v)
				return AI_Responses.response_cooldowns[v] == nil
			end
		)
		if player_id then
			AI_Responses:TriggerResponse(player_id, "duel_won")
		end
	end

	if bots_by_team[event.loser_team] then
		local player_id = table.random_with_condition(
			bots_by_team[event.loser_team],
			function(t, k, v)
				return AI_Responses.response_cooldowns[v] == nil
			end
		)
		if player_id then
			AI_Responses:TriggerResponse(player_id, "duel_lost")
		end
	end
end


function AI_Responses:OnAllCreepsKilled(event)
	for player_id, _ in pairs(AI_Core.bots or {}) do
		local team = PlayerResource:GetTeam(player_id)
		
		-- inlining is not that readable, but convenient
		-- scan all bots and trigger round finished response for passed position and team
		-- stopping as soon as response is triggered (in case there's many bots in team, it will respect cooldown)
		if team == event.team and AI_Responses:TriggerResponse(player_id, "round_finished", event.position) then
			return
		end
	end
end


------------------------------------------------------------------------------------------------------
---------------------------------------- RESPONSE RULES ----------------------------------------------
------------------------------------------------------------------------------------------------------
AI_Responses.duel_won = {
	"ez",
	"uwu",
	"Thou hast made a valiant effort",
	"Doin a bamboozle fren.",
	"Are you even trying?",
	"Behold, the great and powerful, my magnificent and almighty nemisis!",
	"May your souls reconstitute themselves so you may try again.",
	"Well, you fought well. Pretty well, obviously not good enough. Next time.",
	"Aah, you fought well. I mean.. Pretty well, obviously not good enough. Maybe next time.",
	"You've all died? Unbelievable! Well... Totally believable, actually, probable in fact.",
	{
		quote = "We estimated probability of your win to be lower then %d%%",
		random_range_int = {5, 30}
	},
}


AI_Responses.duel_lost = {
	{
		quote = "so laggy, can they fix the game? literally %d fps",
		random_range_int = {10, 20},
	},
	{ 
		quote = "%d ping wtf",
		random_range_int = {300, 1200},
	},
	"balanced game kekw",
	"Tactical feed",
	"You are truly better than me!",
	"Maybe we can have a rematch?",
	"You are persistent, I'll give you that.",
	"Treasure for the stalwart. You've earned it.",
	"Noooooo! Oh well."
}

-- NOTE: quotes here are placed in the order of round finishing placement
-- (i.e. first quote is played on bot finishing round first)
AI_Responses.round_finished = {
	{
		-- percent is doubled to escape it (so it is showed instead of being replaced)
		quote = "We estimate probability of winning to be above %d%%",
		random_range_int = {85, 95}
	},
	{
		quote = "We estimate probability of winning to be above %d%%",
		random_range_int = {75, 85}
	},
	{
		quote = "We estimate probability of winning to be above %d%%",
		random_range_int = {60, 75}
	},
}


AI_Responses:Init()

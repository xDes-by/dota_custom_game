Feedback = Feedback or {}

FEEDBACK_COOLDOWN = 30

function Feedback:Init()
	RegisterCustomEventListener("feedback:send_feedback", function(event)
		self:GetFeedbackFromPlayer(event)
	end)
	RegisterCustomEventListener("feedback:check_cooldown", function(event)
		self:CheckCooldown(event)
	end)
	self.feedback_cooldowns = {}
end

function Feedback:GetFeedbackFromPlayer(event)
	local player_id = event.PlayerID
	if not player_id then return end

	local last_fb_time = self.feedback_cooldowns[player_id]
	local is_cooldown = last_fb_time and ((GameRules:GetGameTime() - last_fb_time) < FEEDBACK_COOLDOWN) or false
	if is_cooldown then return end

	self.feedback_cooldowns[player_id] = GameRules:GetGameTime()
	Timers:CreateTimer(FEEDBACK_COOLDOWN, function()
		CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "feedback:update_cooldown", {
			cooldown = 0
		})
	end)

	local steam_id = Battlepass:GetSteamId(player_id)
	if not steam_id then return end

	WebApi:Send(
		"match/suggestion",
		{
			steamId = steam_id,
			content = event.text
		},
		function(data)
			print("Successfully send suggestion")
		end,
		function(e)
			print("error while sending suggestion: ", e)
		end
	)
end

function Feedback:CheckCooldown(event)
	local player_id = event.PlayerID
	if not player_id then return end
	
	local last_fb_time = self.feedback_cooldowns[player_id]
	local is_cooldown = last_fb_time and ((GameRules:GetGameTime() - last_fb_time) < FEEDBACK_COOLDOWN) or false
	
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "feedback:update_cooldown", {
		cooldown = is_cooldown
	})
end

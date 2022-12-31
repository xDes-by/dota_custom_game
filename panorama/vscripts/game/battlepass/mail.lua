Mail = Mail or class({})


function Mail:Init()
	self.mails = {}
	self.last_refreshes = {}
	for player_id = 0, 24 do
		self.mails[player_id] = {}
	end

	RegisterCustomEventListener("mail:claim", self.Claim, self)
	RegisterCustomEventListener("mail:delete", self.Delete, self)

	RegisterCustomEventListener("mail:refresh_mails", function(event) self:RefreshMails(event.PlayerID) end)
	RegisterCustomEventListener("mail:get_mails", function(event) self:UpdateMailsForPlayer(event.PlayerID) end)
end 


function Mail:RefreshMails(player_id)
	if not player_id then return end

	local steam_id = Battlepass:GetSteamId(player_id)
	if not steam_id then return end

	local cooldown = self.last_refreshes[player_id]
	local game_time = GameRules:GetGameTime()

	if cooldown and (game_time - cooldown) < 60 then return end

	self.last_refreshes[player_id] = game_time

	WebApi:Send(
		"mail/get",
		{
			steamId = steam_id,
		},
		function(data)
			self:SetMails(player_id, data)
			self:UpdateMailsForPlayer(player_id)
			print("Successfully refreshed mail")
		end,
		function(e)
			print("error while refreshed mails: ", e)
		end
	)
end


function Mail:GetReward(player_id, mail_id)
	if not player_id then return end
	if not mail_id or not self.mails[player_id] or not self.mails[player_id][mail_id] then return end
	
	local attachments = self.mails[player_id][mail_id].attachments
	return {
		glory = attachments.glory or nil,
		fortune = attachments.fortune or nil,
		items = attachments.items or nil,
	}
end


function Mail:Claim(data)
	local player_id = data.PlayerID
	if not player_id then return end
	
	local mail_id = data.mail_id
	if not mail_id or not self.mails[player_id] or not self.mails[player_id][mail_id] then return end

	local steam_id = Battlepass:GetSteamId(player_id)
	if not steam_id then return end

	WebApi:Send(
		"mail/claim",
		{ 
			steamId = steam_id,
			mailId = mail_id
		},
		function(response)
			self.mails[player_id][mail_id].claimed = true
			local rewards = Mail:GetReward(player_id, mail_id)
			if not rewards then return end

			if rewards.glory then
				BP_PlayerProgress:AddGlory(player_id, rewards.glory)
			end
			if rewards.fortune then
				BP_PlayerProgress:AddFortune(player_id, rewards.fortune)
			end
			if rewards.items then
				for _, item_name in pairs(rewards.items) do
					BP_Inventory:AddItemLocal(item_name, steam_id, 1)
				end
			end
			BP_PlayerProgress:UpdatePlayerInfo(player_id)
			print("Successfully claimed mail")
		end,
		function(e)
			print("error while claimed mail: ", e)
		end
	)
end


function Mail:Delete(data)
	local player_id = data.PlayerID
	if not player_id then print("delete exit 1") return end

	local mail_id = data.mail_id	
	if not mail_id or not self.mails[player_id] or not self.mails[player_id][mail_id] or not self.mails[player_id][mail_id].claimed then print("delete exit 2") return end

	local steam_id = Battlepass:GetSteamId(player_id)
	if not steam_id then print("delete exit 3") return end

	WebApi:Send(
		"mail/delete",
		{
			steamId = steam_id,
			mailId = mail_id
		},
		function()
			self.mails[player_id][mail_id] = nil
			print("Successfully deleted mail")
		end,
		function(e)
			print("error while deleted mail: ", e)
		end
	)
end


function Mail:AddMail(player_id, mail)
	local attachments = mail.attachments
	self.mails[player_id][tostring(mail.id)] = {
		text_content = mail.textContent,
		claimed = mail.isRead,
		source = mail.source,
		created_date = mail.createdAt,
		topic = mail.topic or "Letter",
		attachments = attachments or {},
		items = attachments and attachments.items or {},
	}
end


function Mail:SetMails(player_id, mails)
	if not self.mails[player_id] then return end
	for _, mail in pairs(mails) do
		Mail:AddMail(player_id, mail)
	end
end


function Mail:UpdateMailsForPlayer(player_id)
	if not player_id then return end

	if not self.mails[player_id] then return end
	
	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end
	
	CustomGameEventManager:Send_ServerToPlayer(player, "mail:update_mails", self.mails[player_id])
end


MatchEvents.event_handlers.mail_incoming = function(data)
	print("[WebMail] mail received from match event")
	DeepPrintTable(data)

	local player_id = GetPlayerIdBySteamId(data.mail.targetSteamId)
	print("mail player id", player_id)
	if not player_id or not PlayerResource:IsValidPlayerID(player_id) then print("invalid player id") return end

	local player = PlayerResource:GetPlayer(player_id)
	if not player or player:IsNull() then print("invalid player") return end

	Mail:AddMail(player_id, data.mail)

	Mail:UpdateMailsForPlayer(player_id)
	Toasts:NewForPlayer(player_id, "mail_incoming", data.mail)
end

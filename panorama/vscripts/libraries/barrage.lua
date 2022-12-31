if Barrage == nil then Barrage = class({}) end

function Barrage:Init()
    ListenToGameEvent("player_chat", Dynamic_Wrap(Barrage, "OnPlayerSay"), self)   
end

Barrage.team_chat_disabled = {
    ["duos"] = true,
    ["enfos"] = true,
}


--Listening to player chatting
function Barrage:OnPlayerSay(keys)
    local szText = string.trim(keys.text)
	
	if szText:sub(0,1) == '-' then return end
	
    local map_name = GetMapName()
    if self.team_chat_disabled[map_name] then
        if keys.teamonly == 1 then return end
    end
    if (not keys.playerid) or (keys.playerid < 0) then return end
    local hPlayer = PlayerResource:GetPlayer(keys.playerid)
    local hHero = hPlayer and hPlayer:GetAssignedHero()
    if not hHero then return end

    local vData = {}
    vData.type = "player_say"
    vData.playerId = keys.playerid
    vData.content = szText
    self:FireBullet(vData)
end


--Send a barrage
function Barrage:FireBullet(vData)
     CustomGameEventManager:Send_ServerToAllClients("FireBullet",vData);
end


function Barrage:SetBarrageChatEnabled(data)
    if not data.PlayerID then return end
    local player = PlayerResource:GetPlayer(data.PlayerID)
    PLAYER_OPTIONS_BARRAGE_CHAT_ENABLED[data.PlayerID] = toboolean(data.state)
    CustomGameEventManager:Send_ServerToPlayer(player, "options:barrage_chat_lines", {state=data.state})
    if data.update_hud then
        CustomGameEventManager:Send_ServerToPlayer(player, "options:update_checkboxes", {barrage_chat=data.state})
    end
end


function Barrage:SetBarrageOpacity(data)
    if not data.PlayerID then return end
    local player = PlayerResource:GetPlayer(data.PlayerID)

	-- discard update if new value isn't different from present
	if data.state and PLAYER_OPTIONS_BARRAGE_OPACITY[data.PlayerID] then
		if math.abs(PLAYER_OPTIONS_BARRAGE_OPACITY[data.PlayerID] - (math.round(data.state * 100.0) / 100.0)) < 0.01 then
			return
		end
	end

    if not data.state then data.state = 1 end

    PLAYER_OPTIONS_BARRAGE_OPACITY[data.PlayerID] = math.round(data.state * 100.0) / 100.0

    CustomGameEventManager:Send_ServerToPlayer(player, "options:barrage_opacity", {state = data.state})

    if data.update_hud then
        CustomGameEventManager:Send_ServerToPlayer(player, "options:update_checkboxes", {barrage_opacity=data.state})
    end

	PlayerOptions:SavePlayerOptionsState(data.PlayerID)
end


Barrage:Init()

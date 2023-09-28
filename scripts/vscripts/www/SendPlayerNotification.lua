if SendPlayerNotification == nil then
    _G.SendPlayerNotification = class({})
end

function SendPlayerNotification:init()

end

function SendPlayerNotification:TutorialMessage(PlayerID, message)
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(PlayerID), "TutorialMessage", { message = message, })
end

function SendPlayerNotification:WaveMessage(need, count)
    CustomGameEventManager:Send_ServerToAllClients( "updateWaveCounter", {need = need, count = count} )
end

SendPlayerNotification:init()
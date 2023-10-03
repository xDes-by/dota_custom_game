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

function SendPlayerNotification:AddCoinsAlert(pid, value)
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "ReceivingCoinsAlert", { value = value, })
end

function SendPlayerNotification:AddRPAlert(pid, value)
    CustomGameEventManager:Send_ServerToPlayer( PlayerResource:GetPlayer(pid), "ReceivingRPAlert", { value = value, })
end

SendPlayerNotification:init()
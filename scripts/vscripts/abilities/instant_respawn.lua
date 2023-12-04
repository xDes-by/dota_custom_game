instant_respawn = class({})

function instant_respawn:OnOwnerDied()
    Timers:CreateTimer(0.03,function()
        self:GetCaster():RespawnUnit()
    end)
end
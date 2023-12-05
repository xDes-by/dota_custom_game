instant_respawn = class({})

function instant_respawn:Spawn()
    self.spawn_pos = self:GetCaster():GetAbsOrigin()
end

function instant_respawn:OnOwnerDied()
    Timers:CreateTimer(0.4,function()
        self:GetCaster():RespawnUnit()
        self:GetCaster():SetAbsOrigin(self.spawn_pos)
    end)
end
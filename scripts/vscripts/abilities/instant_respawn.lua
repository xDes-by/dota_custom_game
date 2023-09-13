instant_respawn = class({})

function instant_respawn:OnOwnerDied()
    self:GetCaster():RespawnUnit()
end
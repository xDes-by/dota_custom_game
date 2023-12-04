modifier_custom_vision = class({})

function modifier_custom_vision:IsHidden()
    return false
end

function modifier_custom_vision:IsDebuff()
    return true
end

function modifier_custom_vision:IsPurgable()
    return false
end

function modifier_custom_vision:OnCreated()
    if not IsServer() then return end
    self:StartIntervalThink(0.2)
    self:OnIntervalThink()
end

function modifier_custom_vision:OnIntervalThink()
    AddFOWViewer(DOTA_TEAM_GOODGUYS, self:GetParent():GetAbsOrigin(), 300, 0.2, false)
end
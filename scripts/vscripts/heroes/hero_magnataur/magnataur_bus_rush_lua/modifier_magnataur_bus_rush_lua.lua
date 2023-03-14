modifier_magnataur_bus_rush_lua = {}

function modifier_magnataur_bus_rush_lua:OnCreated(kv)
    self.unit = self:GetAbility().unit
    self:StartIntervalThink(0.2)
end

function modifier_magnataur_bus_rush_lua:OnDestroy()
    UTIL_Remove(self.unit)
end

function modifier_magnataur_bus_rush_lua:OnIntervalThink()
	if not IsServer() then return end
    if not self.unit:HasModifier("modifier_magnataur_skewer_lua") then
        self:Destroy()
    end
end
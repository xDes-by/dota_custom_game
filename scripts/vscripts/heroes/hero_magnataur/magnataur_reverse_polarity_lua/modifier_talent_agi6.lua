modifier_talent_agi6 = {}

function modifier_talent_agi6:OnCreated(kv)
    self.chance = kv.chance
    self.perc_crit = kv.perc_crit
end

function modifier_talent_agi6:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE, -- свойство, отвечающее за критический удар
    }
    return funcs
end

function modifier_talent_agi6:GetModifierPreAttack_CriticalStrike()
    if self.chance >= RandomInt(1, 100) then
        return self.perc_crit -- критический удар будет наносить вдвое больше урона
    end
end
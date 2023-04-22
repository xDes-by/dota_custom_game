modifier_magnataur_talent_agi6 = {}

function modifier_magnataur_talent_agi6:OnCreated(kv)
    self.chance = kv.chance
    self.perc_crit = kv.perc_crit
end

function modifier_magnataur_talent_agi6:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE, -- свойство, отвечающее за критический удар
        MODIFIER_PROPERTY_TOOLTIP,
        MODIFIER_PROPERTY_TOOLTIP2,
    }
    return funcs
end

function modifier_magnataur_talent_agi6:GetModifierPreAttack_CriticalStrike()
    if 80 >= RandomInt(1, 100) then
        return self.perc_crit -- критический удар будет наносить вдвое больше урона
    end
end
function modifier_magnataur_talent_agi6:OnTooltip()
	return 80
end
function modifier_magnataur_talent_agi6:OnTooltip2()
	return 200
end
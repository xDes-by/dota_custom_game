modifier_talent_str6 = {}

function modifier_talent_str6:OnCreated()
    self.hp_regen_perc = self:GetAbility():GetLevel()
end

function modifier_talent_str6:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE_UNIQUE,
    }
    return funcs
end

function modifier_talent_str6:GetModifierHealthRegenPercentageUnique(params)
    return self.hp_regen_perc
end
require("libraries/table")
modifier_gold_bank = class({})

function modifier_gold_bank:RemoveOnDeath()
    return false
end

function modifier_gold_bank:IsHidden()
    if self:GetStackCount() > 0 then 
        return false
    end
    return true
end

function modifier_gold_bank:GetTexture()
    return "alchemist_goblins_greed"
end

function modifier_gold_bank:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end

function modifier_gold_bank:OnTooltip()
    return self:GetStackCount()
end

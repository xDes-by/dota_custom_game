modifier_chc_stalling = class({})

function modifier_chc_stalling:IsHidden() return self:GetStackCount() == 0 end
function modifier_chc_stalling:IsPurgable() return false end
function modifier_chc_stalling:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_stalling:GetTexture()
	return "alchemist_goblins_greed"
end

function modifier_chc_stalling:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_chc_stalling:OnIntervalThink()
	self:SetStackCount(math.min(self:GetStackCount() + ROUND_MANAGER_STALLING_DETER_GOLD_REDUCTION, 100))
end

function modifier_chc_stalling:OnTooltip()
	return self:GetStackCount()
end
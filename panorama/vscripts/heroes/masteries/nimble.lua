modifier_chc_mastery_nimble = class({})

function modifier_chc_mastery_nimble:IsHidden() return true end
function modifier_chc_mastery_nimble:IsDebuff() return false end
function modifier_chc_mastery_nimble:IsPurgable() return false end
function modifier_chc_mastery_nimble:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_nimble:GetTexture() return "masteries/nimble" end

function modifier_chc_mastery_nimble:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
end

function modifier_chc_mastery_nimble:GetModifierBonusStats_Agility()
	return self.base_stat + self.level_stat * (self:GetParent():GetLevel() or 0)
end



modifier_chc_mastery_nimble_1 = class(modifier_chc_mastery_nimble)
modifier_chc_mastery_nimble_2 = class(modifier_chc_mastery_nimble)
modifier_chc_mastery_nimble_3 = class(modifier_chc_mastery_nimble)

function modifier_chc_mastery_nimble_1:OnCreated(keys)
	self.base_stat = 5
	self.level_stat = 0.3

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_chc_mastery_nimble_2:OnCreated(keys)
	self.base_stat = 10
	self.level_stat = 0.6

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_chc_mastery_nimble_3:OnCreated(keys)
	self.base_stat = 20
	self.level_stat = 1.2

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

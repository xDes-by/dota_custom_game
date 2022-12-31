modifier_chc_mastery_champion = class({})

function modifier_chc_mastery_champion:IsHidden() return true end
function modifier_chc_mastery_champion:IsDebuff() return false end
function modifier_chc_mastery_champion:IsPurgable() return false end
function modifier_chc_mastery_champion:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_champion:GetTexture() return "masteries/champion" end

function modifier_chc_mastery_champion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_chc_mastery_champion:GetModifierBonusStats_Strength()
	return self.base_stat + self.level_stat * (self:GetParent():GetLevel() or 0)
end

function modifier_chc_mastery_champion:GetModifierBonusStats_Agility()
	return self.base_stat + self.level_stat * (self:GetParent():GetLevel() or 0)
end

function modifier_chc_mastery_champion:GetModifierBonusStats_Intellect()
	return self.base_stat + self.level_stat * (self:GetParent():GetLevel() or 0)
end



modifier_chc_mastery_champion_1 = class(modifier_chc_mastery_champion)
modifier_chc_mastery_champion_2 = class(modifier_chc_mastery_champion)
modifier_chc_mastery_champion_3 = class(modifier_chc_mastery_champion)

function modifier_chc_mastery_champion_1:OnCreated(keys)
	self.base_stat = 3
	self.level_stat = 0.1

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_chc_mastery_champion_2:OnCreated(keys)
	self.base_stat = 6
	self.level_stat = 0.2

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_chc_mastery_champion_3:OnCreated(keys)
	self.base_stat = 12
	self.level_stat = 0.4

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

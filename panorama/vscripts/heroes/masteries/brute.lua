modifier_chc_mastery_brute = class({})

function modifier_chc_mastery_brute:IsHidden() return true end
function modifier_chc_mastery_brute:IsDebuff() return false end
function modifier_chc_mastery_brute:IsPurgable() return false end
function modifier_chc_mastery_brute:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_brute:GetTexture() return "masteries/brute" end

function modifier_chc_mastery_brute:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end

function modifier_chc_mastery_brute:GetModifierBonusStats_Strength()
	return self.base_stat + self.level_stat * (self:GetParent():GetLevel() or 0)
end



modifier_chc_mastery_brute_1 = class(modifier_chc_mastery_brute)
modifier_chc_mastery_brute_2 = class(modifier_chc_mastery_brute)
modifier_chc_mastery_brute_3 = class(modifier_chc_mastery_brute)

function modifier_chc_mastery_brute_1:OnCreated(keys)
	self.base_stat = 7
	self.level_stat = 0.3

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_chc_mastery_brute_2:OnCreated(keys)
	self.base_stat = 14
	self.level_stat = 0.6

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_chc_mastery_brute_3:OnCreated(keys)
	self.base_stat = 28
	self.level_stat = 1.2

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

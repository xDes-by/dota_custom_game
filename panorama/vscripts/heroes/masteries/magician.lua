modifier_chc_mastery_magician = class({})

function modifier_chc_mastery_magician:IsHidden() return true end
function modifier_chc_mastery_magician:IsDebuff() return false end
function modifier_chc_mastery_magician:IsPurgable() return false end
function modifier_chc_mastery_magician:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_magician:GetTexture() return "masteries/magician" end

function modifier_chc_mastery_magician:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_chc_mastery_magician:GetModifierBonusStats_Intellect()
	return self.base_stat + self.level_stat * (self:GetParent():GetLevel() or 0)
end



modifier_chc_mastery_magician_1 = class(modifier_chc_mastery_magician)
modifier_chc_mastery_magician_2 = class(modifier_chc_mastery_magician)
modifier_chc_mastery_magician_3 = class(modifier_chc_mastery_magician)

function modifier_chc_mastery_magician_1:OnCreated(keys)
	self.base_stat = 10
	self.level_stat = 0.4

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_chc_mastery_magician_2:OnCreated(keys)
	self.base_stat = 20
	self.level_stat = 0.8

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_chc_mastery_magician_3:OnCreated(keys)
	self.base_stat = 40
	self.level_stat = 1.6

	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

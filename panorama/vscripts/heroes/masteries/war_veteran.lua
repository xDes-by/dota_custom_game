modifier_chc_mastery_war_veteran = class({})

function modifier_chc_mastery_war_veteran:IsHidden() return true end
function modifier_chc_mastery_war_veteran:IsDebuff() return false end
function modifier_chc_mastery_war_veteran:IsPurgable() return false end
function modifier_chc_mastery_war_veteran:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_war_veteran:GetTexture() return "masteries/war_veteran" end

function modifier_chc_mastery_war_veteran:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_chc_mastery_war_veteran:GetModifierTotalDamageOutgoing_Percentage()
	return ((not self:GetParent():IsDueling()) and self.bonus_damage) or 0
end



modifier_chc_mastery_war_veteran_1 = class(modifier_chc_mastery_war_veteran)
modifier_chc_mastery_war_veteran_2 = class(modifier_chc_mastery_war_veteran)
modifier_chc_mastery_war_veteran_3 = class(modifier_chc_mastery_war_veteran)

function modifier_chc_mastery_war_veteran_1:OnCreated(keys)
	self.bonus_damage = 15
end

function modifier_chc_mastery_war_veteran_2:OnCreated(keys)
	self.bonus_damage = 30
end

function modifier_chc_mastery_war_veteran_3:OnCreated(keys)
	self.bonus_damage = 60
end

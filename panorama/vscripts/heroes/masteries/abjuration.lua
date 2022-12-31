modifier_chc_mastery_abjuration = class({})

function modifier_chc_mastery_abjuration:IsHidden() return true end
function modifier_chc_mastery_abjuration:IsDebuff() return false end
function modifier_chc_mastery_abjuration:IsPurgable() return false end
function modifier_chc_mastery_abjuration:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_abjuration:GetTexture() return "masteries/abjuration" end

function modifier_chc_mastery_abjuration:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_chc_mastery_abjuration:GetModifierMagicalResistanceBonus()
	return self.bonus_mr or 0
end

function modifier_chc_mastery_abjuration:GetModifierStatusResistanceStacking()
	return self.bonus_status_resist or 0
end



modifier_chc_mastery_abjuration_1 = class(modifier_chc_mastery_abjuration)
modifier_chc_mastery_abjuration_2 = class(modifier_chc_mastery_abjuration)
modifier_chc_mastery_abjuration_3 = class(modifier_chc_mastery_abjuration)

function modifier_chc_mastery_abjuration_1:OnCreated(keys)
	self.bonus_mr = 14
	self.bonus_status_resist = 14
end

function modifier_chc_mastery_abjuration_2:OnCreated(keys)
	self.bonus_mr = 25
	self.bonus_status_resist = 25
end

function modifier_chc_mastery_abjuration_3:OnCreated(keys)
	self.bonus_mr = 40
	self.bonus_status_resist = 40
end

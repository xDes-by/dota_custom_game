modifier_chc_mastery_celerity = class({})

function modifier_chc_mastery_celerity:IsHidden() return true end
function modifier_chc_mastery_celerity:IsDebuff() return false end
function modifier_chc_mastery_celerity:IsPurgable() return false end
function modifier_chc_mastery_celerity:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_celerity:GetTexture() return "masteries/celerity" end

function modifier_chc_mastery_celerity:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_chc_mastery_celerity:GetModifierAttackSpeedBonus_Constant()
	return self.level_as * (self:GetParent():GetLevel() or 0)
end



modifier_chc_mastery_celerity_1 = class(modifier_chc_mastery_celerity)
modifier_chc_mastery_celerity_2 = class(modifier_chc_mastery_celerity)
modifier_chc_mastery_celerity_3 = class(modifier_chc_mastery_celerity)

function modifier_chc_mastery_celerity_1:OnCreated(keys)
	self.level_as = 1.5
end

function modifier_chc_mastery_celerity_2:OnCreated(keys)
	self.level_as = 3.0
end

function modifier_chc_mastery_celerity_3:OnCreated(keys)
	self.level_as = 6.0
end

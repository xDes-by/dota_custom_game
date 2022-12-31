modifier_chc_mastery_manafication = class({})

function modifier_chc_mastery_manafication:IsHidden() return true end
function modifier_chc_mastery_manafication:IsDebuff() return false end
function modifier_chc_mastery_manafication:IsPurgable() return false end
function modifier_chc_mastery_manafication:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_manafication:GetTexture() return "masteries/manafication" end

function modifier_chc_mastery_manafication:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
	}
end

function modifier_chc_mastery_manafication:GetModifierConstantManaRegen()
	return self.base_regen or 0
end

function modifier_chc_mastery_manafication:GetModifierTotalPercentageManaRegen()
	return self.percent_regen or 0
end

function modifier_chc_mastery_manafication:GetModifierPercentageManacostStacking()
	return self.manacost_reduction or 0
end



modifier_chc_mastery_manafication_1 = class(modifier_chc_mastery_manafication)
modifier_chc_mastery_manafication_2 = class(modifier_chc_mastery_manafication)
modifier_chc_mastery_manafication_3 = class(modifier_chc_mastery_manafication)

function modifier_chc_mastery_manafication_1:OnCreated(keys)
	self.manacost_reduction = 20
	self.base_regen = 5
	self.percent_regen = 0.75
end

function modifier_chc_mastery_manafication_2:OnCreated(keys)
	self.manacost_reduction = 33
	self.base_regen = 10
	self.percent_regen = 1.5
end

function modifier_chc_mastery_manafication_3:OnCreated(keys)
	self.manacost_reduction = 50
	self.base_regen = 20
	self.percent_regen = 3.0
end

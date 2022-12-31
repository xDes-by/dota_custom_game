modifier_chc_mastery_regeneration = class({})

function modifier_chc_mastery_regeneration:IsHidden() return true end
function modifier_chc_mastery_regeneration:IsDebuff() return false end
function modifier_chc_mastery_regeneration:IsPurgable() return false end
function modifier_chc_mastery_regeneration:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_regeneration:GetTexture() return "masteries/regeneration" end

function modifier_chc_mastery_regeneration:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_chc_mastery_regeneration:GetModifierConstantHealthRegen()
	return self.base_regen or 0
end

function modifier_chc_mastery_regeneration:GetModifierHealthRegenPercentage()
	return self.percent_regen or 0
end



modifier_chc_mastery_regeneration_1 = class(modifier_chc_mastery_regeneration)
modifier_chc_mastery_regeneration_2 = class(modifier_chc_mastery_regeneration)
modifier_chc_mastery_regeneration_3 = class(modifier_chc_mastery_regeneration)

function modifier_chc_mastery_regeneration_1:OnCreated(keys)
	self.base_regen = 2
	self.percent_regen = 1.0
end

function modifier_chc_mastery_regeneration_2:OnCreated(keys)
	self.base_regen = 4
	self.percent_regen = 2.0
end

function modifier_chc_mastery_regeneration_3:OnCreated(keys)
	self.base_regen = 8
	self.percent_regen = 4.0
end

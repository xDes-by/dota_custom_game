innate_healer = class({})

LinkLuaModifier("modifier_innate_healer", "heroes/innates/healer", LUA_MODIFIER_MOTION_NONE)

function innate_healer:GetIntrinsicModifierName()
	return "modifier_innate_healer"
end

modifier_innate_healer = class({})

function modifier_innate_healer:IsHidden() return true end
function modifier_innate_healer:IsDebuff() return false end
function modifier_innate_healer:IsPurgable() return false end
function modifier_innate_healer:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_healer:OnCreated()
	self:OnRefresh()
end

function modifier_innate_healer:OnRefresh()
	self.bonus_heal = self:GetAbility():GetSpecialValueFor("bonus_heal")
	self.percent_heal = self:GetAbility():GetSpecialValueFor("percent_heal")
end

function modifier_innate_healer:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEAL_AMPLIFY_PERCENTAGE_SOURCE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end

function modifier_innate_healer:GetModifierHealAmplify_PercentageSource()
	return self.bonus_heal or 0
end

function modifier_innate_healer:GetModifierHPRegenAmplify_Percentage()
	return self.bonus_heal or 0
end

function modifier_innate_healer:GetModifierHealthRegenPercentage()
	return self.percent_heal or 0
end

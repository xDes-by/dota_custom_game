innate_frenzy = class({})

LinkLuaModifier("modifier_innate_frenzy", "heroes/innates/frenzy", LUA_MODIFIER_MOTION_NONE)

function innate_frenzy:GetIntrinsicModifierName()
	return "modifier_innate_frenzy"
end

modifier_innate_frenzy = class({})

function modifier_innate_frenzy:IsHidden() return true end
function modifier_innate_frenzy:IsDebuff() return false end
function modifier_innate_frenzy:IsPurgable() return false end
function modifier_innate_frenzy:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_frenzy:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifier_innate_frenzy:OnCreated()
	self.multiplier = self:GetAbility():GetLevelSpecialValueFor("bonus_attack_speed", 1)
	self.attack_speed_bonus = self:GetParent():GetAttackSpeed() * self.multiplier
	self:StartIntervalThink(1)
end

function modifier_innate_frenzy:OnIntervalThink()
	self.attack_speed_bonus = (self:GetParent():GetAttackSpeed() - self.attack_speed_bonus * 0.01) * self.multiplier
end

function modifier_innate_frenzy:GetModifierAttackSpeedBonus_Constant()
	return self.attack_speed_bonus
end

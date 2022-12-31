innate_brute = class({})

LinkLuaModifier("modifier_innate_brute", "heroes/innates/brute", LUA_MODIFIER_MOTION_NONE)

function innate_brute:GetIntrinsicModifierName()
	return "modifier_innate_brute"
end





modifier_innate_brute = class({})

function modifier_innate_brute:IsHidden() return true end
function modifier_innate_brute:IsDebuff() return false end
function modifier_innate_brute:IsPurgable() return false end
function modifier_innate_brute:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_brute:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_brute:OnRefresh(keys)
	local ability = self:GetAbility()
	local parent = self:GetParent()

	if (not ability) or (not parent) or (parent:IsNull() or ability:IsNull()) then return end

	self.base_str = ability:GetSpecialValueFor("base_str") or 0
	self.level_str = ability:GetSpecialValueFor("level_str") or 0
	self.pct_health_as_bonus_dmg = 0.01 * ability:GetSpecialValueFor("pct_health_as_bonus_dmg") or 0

	if IsClient() then return end

	parent:SetPrimaryAttribute(DOTA_ATTRIBUTE_STRENGTH)
end

function modifier_innate_brute:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_innate_brute:GetModifierBonusStats_Strength()
	return self.base_str + self.level_str * (self:GetParent():GetLevel() or 0)
end

function modifier_innate_brute:GetModifierPreAttack_BonusDamage()
	local parent = self:GetParent()
	local current_health = 0.01 * parent:GetHealthPercent() * parent:GetMaxHealth()

	return current_health * self.pct_health_as_bonus_dmg
end

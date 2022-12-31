innate_gambler = class({})

LinkLuaModifier("modifier_innate_gambler", "heroes/innates/gambler", LUA_MODIFIER_MOTION_NONE)

function innate_gambler:GetIntrinsicModifierName()
	return "modifier_innate_gambler"
end

modifier_innate_gambler = class({})

function modifier_innate_gambler:IsHidden() return true end
function modifier_innate_gambler:IsDebuff() return false end
function modifier_innate_gambler:IsPurgable() return false end
function modifier_innate_gambler:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_gambler:OnCreated(keys)
	if IsClient() then return end

	self:OnRefresh(keys)
end

function modifier_innate_gambler:OnRefresh(keys)
	if IsClient() then return end

	self.bonus_gold = self:GetAbility():GetSpecialValueFor("bonus_gold")
end

function modifier_innate_gambler:GetModifierBetGoldAmplification()
	return self.bonus_gold or 0
end

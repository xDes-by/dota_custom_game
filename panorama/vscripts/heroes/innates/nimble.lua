innate_nimble = class({})

LinkLuaModifier("modifier_innate_nimble", "heroes/innates/nimble", LUA_MODIFIER_MOTION_NONE)

function innate_nimble:GetIntrinsicModifierName()
	return "modifier_innate_nimble"
end





modifier_innate_nimble = class({})

function modifier_innate_nimble:IsHidden() return true end
function modifier_innate_nimble:IsDebuff() return false end
function modifier_innate_nimble:IsPurgable() return false end
function modifier_innate_nimble:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_nimble:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_nimble:OnRefresh(keys)
	local ability = self:GetAbility()
	local parent = self:GetParent()

	if (not ability) or (not parent) or (parent:IsNull() or ability:IsNull()) then return end

	self.base_agi = ability:GetSpecialValueFor("base_agi") or 0
	self.level_agi = ability:GetSpecialValueFor("level_agi") or 0

	if IsClient() then return end

	parent:SetPrimaryAttribute(DOTA_ATTRIBUTE_AGILITY)
end

function modifier_innate_nimble:DeclareFunctions()
	return { MODIFIER_PROPERTY_STATS_AGILITY_BONUS }
end

function modifier_innate_nimble:GetModifierBonusStats_Agility()
	return self.base_agi + self.level_agi * (self:GetParent():GetLevel() or 0)
end

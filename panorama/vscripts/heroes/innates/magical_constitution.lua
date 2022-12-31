innate_magical_constitution = class({})

LinkLuaModifier("modifier_innate_magical_constitution", "heroes/innates/magical_constitution", LUA_MODIFIER_MOTION_NONE)

function innate_magical_constitution:GetIntrinsicModifierName()
	return "modifier_innate_magical_constitution"
end

function innate_magical_constitution:OnInventoryContentsChanged()
	local caster = self:GetCaster()
	if not caster or caster:IsNull() then return end
	if not IsServer() then return end
	caster:CalculateStatBonus(true)
end

modifier_innate_magical_constitution = class({})

function modifier_innate_magical_constitution:IsHidden() return true end
function modifier_innate_magical_constitution:IsDebuff() return false end
function modifier_innate_magical_constitution:IsPurgable() return false end
function modifier_innate_magical_constitution:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_magical_constitution:OnCreated()
	self:OnRefresh()
end

function modifier_innate_magical_constitution:OnRefresh()
	self.mana_health_ratio = 0.01 * self:GetAbility():GetSpecialValueFor("mana_health_ratio")
end

function modifier_innate_magical_constitution:DeclareFunctions()
	return { MODIFIER_PROPERTY_HEALTH_BONUS }
end

function modifier_innate_magical_constitution:GetModifierHealthBonus()
	return self:GetParent():GetMaxMana() * (self.mana_health_ratio or 0)
end

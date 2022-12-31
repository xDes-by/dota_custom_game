innate_duelist = class({})

LinkLuaModifier("modifier_innate_duelist", "heroes/innates/duelist", LUA_MODIFIER_MOTION_NONE)

function innate_duelist:GetIntrinsicModifierName()
	return "modifier_innate_duelist"
end





modifier_innate_duelist = class({})

function modifier_innate_duelist:IsHidden() return not self:GetParent():IsDueling() end
function modifier_innate_duelist:IsDebuff() return false end
function modifier_innate_duelist:IsPurgable() return false end
function modifier_innate_duelist:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_duelist:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_duelist:OnRefresh(keys)
	local ability = self:GetAbility()
	if (not ability) or ability:IsNull() then return end

	self.duel_bonus_outgoing_damage = ability:GetSpecialValueFor("duel_bonus_outgoing_damage") or 0
	self.duel_damage_resistance = (-1) * ability:GetSpecialValueFor("duel_damage_resistance") or 0
	self.bonus_gold = ability:GetSpecialValueFor("bonus_gold") or 0
end

function modifier_innate_duelist:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_innate_duelist:GetModifierTotalDamageOutgoing_Percentage()
	return (self:GetParent():IsDueling() and self.duel_bonus_outgoing_damage) or 0
end

function modifier_innate_duelist:GetModifierIncomingDamage_Percentage()
	return (self:GetParent():IsDueling() and self.duel_damage_resistance) or 0
end

function modifier_innate_duelist:GetModifierDuelGoldAmplification()
	return self.bonus_gold or 0
end

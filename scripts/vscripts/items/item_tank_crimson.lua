item_tank_crimson = item_tank_crimson or class({})

LinkLuaModifier("modifier_item_tank_crimson", "items/item_tank_crimson", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_tank_crimson_effect", "items/item_tank_crimson", LUA_MODIFIER_MOTION_NONE)

function item_tank_crimson:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "mid_items/mage_" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/mage_" .. level
	end
end

function item_tank_crimson:GetIntrinsicModifierName()
	return "modifier_item_tank_crimson"
end

modifier_item_tank_crimson = class({})

function modifier_item_tank_crimson:IsHidden()
	return true
end

function modifier_item_tank_crimson:IsPurgable()
	return false
end

function modifier_item_tank_crimson:OnCreated()
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.spell_amp = self:GetAbility():GetSpecialValueFor("spell_amp")
	self.mana_regen = self:GetAbility():GetSpecialValueFor("mana_regen")
	self.aura_radius = self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_item_tank_crimson:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE
	}
end

function modifier_item_tank_crimson:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_tank_crimson:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_tank_crimson:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

function modifier_item_tank_crimson:GetModifierSpellAmplify_Percentage()
	return self.spell_amp
end

function modifier_item_tank_crimson:GetModifierTotalPercentageManaRegen()
	return self.mana_regen
end

-- Aura template
function modifier_item_tank_crimson:IsAura()
	return true
end

function modifier_item_tank_crimson:GetModifierAura()
	return "modifier_item_tank_crimson_effect"
end

function modifier_item_tank_crimson:GetAuraRadius()
	return self.aura_radius
end

function modifier_item_tank_crimson:GetAuraDuration()
	return 0.5
end

function modifier_item_tank_crimson:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_tank_crimson:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_tank_crimson:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

---------------------------------------------------------

modifier_item_tank_crimson_effect = class({})

function modifier_item_tank_crimson_effect:IsHidden()
	return false
end

function modifier_item_tank_crimson_effect:IsDebuff()
	return true
end

function modifier_item_tank_crimson_effect:IsPurgable()
	return false
end

function modifier_item_tank_crimson_effect:RemoveOnDeath()
	return true
end

function modifier_item_tank_crimson_effect:OnCreated()
	self.mag_res_reduse = self:GetAbility():GetSpecialValueFor("mag_res_reduse")
end

function modifier_item_tank_crimson_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_item_tank_crimson_effect:GetModifierMagicalResistanceBonus()
	return self.mag_res_reduse * (-1)
end

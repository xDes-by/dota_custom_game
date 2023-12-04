item_tank_hell = item_tank_hell or class({})

LinkLuaModifier("modifier_item_tank_hell", "items/item_tank_hell", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_tank_hell_effect", "items/item_tank_hell", LUA_MODIFIER_MOTION_NONE)

function item_tank_hell:GetAbilityTextureName()
	local level = self:GetLevel()
	if self:GetSecondaryCharges() == 0 then
		return "mid_items/lance" .. level
	else
		return "gem" .. self:GetSecondaryCharges() .. "/lance" .. level
	end
end

function item_tank_hell:GetIntrinsicModifierName()
	return "modifier_item_tank_hell"
end

modifier_item_tank_hell = class({})
--Classifications template
function modifier_item_tank_hell:IsHidden()
	return true
end

function modifier_item_tank_hell:IsPurgable()
	return false
end

function modifier_item_tank_hell:RemoveOnDeath()
	return false
end

function modifier_item_tank_hell:OnCreated()
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
	self.lifesteal_amp = self:GetAbility():GetSpecialValueFor("lifesteal_amp")
	self.magic_resist = self:GetAbility():GetSpecialValueFor("magic_resist")
	self.health_bonus = self:GetAbility():GetSpecialValueFor("health_bonus")
	self.damage_persent = self:GetAbility():GetSpecialValueFor("damage_persent") * 0.01
	self:StartIntervalThink(1)
	self:OnIntervalThink()
end

function modifier_item_tank_hell:OnRefresh()
	self:OnCreated()
end

function modifier_item_tank_hell:OnIntervalThink()
	self:GetAbility().damage = self.damage_persent * self:GetCaster():GetMaxHealth()
end

function modifier_item_tank_hell:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_HEALTH_BONUS,
	}
end

function modifier_item_tank_hell:GetModifierBonusStats_Strength()
	return self.bonus_all_stats
end

function modifier_item_tank_hell:GetModifierBonusStats_Agility()
	return self.bonus_all_stats
end

function modifier_item_tank_hell:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats
end

function modifier_item_tank_hell:GetModifierSpellLifestealRegenAmplify_Percentage()
	return self.lifesteal_amp
end

function modifier_item_tank_hell:GetModifierHPRegenAmplify_Percentage()
	return self.lifesteal_amp
end

function modifier_item_tank_hell:GetModifierMagicalResistanceBonus()
	return self.magic_resist
end

function modifier_item_tank_hell:GetModifierHealthBonus()
	return self.health_bonus
end

function modifier_item_tank_hell:IsAura()
	return true
end

function modifier_item_tank_hell:GetModifierAura()
	return "modifier_item_tank_hell_effect"
end

function modifier_item_tank_hell:GetAuraRadius()
	return 500
end

function modifier_item_tank_hell:GetAuraDuration()
	return 0.5
end

function modifier_item_tank_hell:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_item_tank_hell:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_item_tank_hell:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

modifier_item_tank_hell_effect = class({})

function modifier_item_tank_hell_effect:IsHidden()
	return true
end

function modifier_item_tank_hell_effect:IsDebuff()
	return true
end

function modifier_item_tank_hell_effect:RemoveOnDeath()
	return true
end

function modifier_item_tank_hell_effect:OnCreated()
	self.miss_persent = self:GetAbility():GetSpecialValueFor("miss_persent")
	if IsClient() then
		return
	end
	self:StartIntervalThink(1)
end

function modifier_item_tank_hell_effect:OnIntervalThink()
	ApplyDamage({victim = self:GetParent(),
	damage = self:GetAbility().damage,
	damage_type = DAMAGE_TYPE_MAGICAL,
	damage_flags = DOTA_DAMAGE_FLAG_NONE,
	attacker = self:GetCaster(),
	ability = self:GetAbility()})
end

function modifier_item_tank_hell_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MISS_PERCENTAGE
	}
end

function modifier_item_tank_hell_effect:GetModifierMiss_Percentage()
	return self.miss_persent
end
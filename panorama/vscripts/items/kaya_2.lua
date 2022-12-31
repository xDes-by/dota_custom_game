item_kaya_2 = class({})

function item_kaya_2:GetIntrinsicModifierName()
	return "modifier_item_sky_staff"
end

LinkLuaModifier("modifier_item_sky_staff", "items/kaya_2", LUA_MODIFIER_MOTION_NONE)

modifier_item_sky_staff = class({})

function modifier_item_sky_staff:IsHidden() return true end
function modifier_item_sky_staff:IsDebuff() return false end
function modifier_item_sky_staff:IsPurgable() return false end
function modifier_item_sky_staff:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_sky_staff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_MP_REGEN_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_LIFESTEAL_AMPLIFY_PERCENTAGE,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE_UNIQUE
	}
end

function modifier_item_sky_staff:OnCreated()
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self:OnRefresh()
end

function modifier_item_sky_staff:OnRefresh()
	if (not self.ability) or self.ability:IsNull() then return end

	self.bonus_int = self.ability:GetSpecialValueFor("bonus_intellect")
	self.mana_regen_multiplier = self.ability:GetSpecialValueFor("mana_regen_multiplier")
	self.spell_lifesteal_amp = self.ability:GetSpecialValueFor("spell_lifesteal_amp")
	self.creep_spell_amp = self.ability:GetSpecialValueFor("creep_spell_amp")
	self.duel_spell_amp = self.ability:GetSpecialValueFor("duel_spell_amp")
	
	if IsServer() and self.parent and (not self.parent:IsNull()) and self.parent.CalculateStatBonus then self.parent:CalculateStatBonus(false) end
end

function modifier_item_sky_staff:GetModifierBonusStats_Intellect()
	return self.bonus_int or 0
end

function modifier_item_sky_staff:GetModifierMPRegenAmplify_Percentage()
	return self.mana_regen_multiplier or 0
end

function modifier_item_sky_staff:GetModifierSpellLifestealRegenAmplify_Percentage()
	return self.spell_lifesteal_amp or 0
end

function modifier_item_sky_staff:GetModifierSpellAmplify_PercentageUnique()
	if (not self.parent) or (self.parent:IsNull()) then return end
	if not self.parent.GetIntellect then return 0 end -- Bear exlusion
	
	if self.parent:HasModifier("modifier_hero_dueling") then
		return self.duel_spell_amp * self.parent:GetIntellect()
	else
		return self.creep_spell_amp * self.parent:GetIntellect()
	end
end

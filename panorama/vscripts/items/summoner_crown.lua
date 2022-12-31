item_summoner_crown = class({})
item_summoner_crown_2 = item_summoner_crown
item_summoner_crown_3 = item_summoner_crown

function item_summoner_crown:GetIntrinsicModifierName()
	return "modifier_item_summoner_crown"
end

LinkLuaModifier("modifier_item_summoner_crown", "items/summoner_crown", LUA_MODIFIER_MOTION_NONE)

modifier_item_summoner_crown = class({})

function modifier_item_summoner_crown:IsDebuff() return false end
function modifier_item_summoner_crown:IsHidden() return true end
function modifier_item_summoner_crown:IsPurgable() return false end
function modifier_item_summoner_crown:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_item_summoner_crown:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
	}
end

function modifier_item_summoner_crown:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_item_summoner_crown:OnRefresh(keys)
	self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")

	if IsServer() then
		if self:GetParent() and self:GetParent().CalculateStatBonus then
			self:GetParent():CalculateStatBonus(false)
		end
	end
end

function modifier_item_summoner_crown:GetModifierBonusStats_Strength()
	return self.bonus_all_stats or 0
end

function modifier_item_summoner_crown:GetModifierBonusStats_Agility()
	return self.bonus_all_stats or 0
end

function modifier_item_summoner_crown:GetModifierBonusStats_Intellect()
	return self.bonus_all_stats or 0
end

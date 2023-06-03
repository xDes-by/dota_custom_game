LinkLuaModifier( "modifier_item_quest_blue_stone", "items/blue_stone", LUA_MODIFIER_MOTION_NONE )
item_quest_blue_stone = class({})

function item_quest_blue_stone:GetIntrinsicModifierName()
	return "modifier_item_quest_blue_stone"
end
function item_quest_blue_stone:IsPermanent()
    return true
end

function item_quest_blue_stone:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT
end
modifier_item_quest_blue_stone = class({})

function modifier_item_quest_blue_stone:IsHidden()
	return true
end

function modifier_item_quest_blue_stone:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
end

function modifier_item_quest_blue_stone:GetModifierBonusStats_Strength()
	return self:GetAbility():GetSpecialValueFor("bonus_attributes") * self:GetAbility():GetCurrentCharges()
end

function modifier_item_quest_blue_stone:GetModifierBonusStats_Agility()
	return self:GetAbility():GetSpecialValueFor("bonus_attributes") * self:GetAbility():GetCurrentCharges()
end

function modifier_item_quest_blue_stone:GetModifierBonusStats_Intellect()
	return self:GetAbility():GetSpecialValueFor("bonus_attributes") * self:GetAbility():GetCurrentCharges()
end
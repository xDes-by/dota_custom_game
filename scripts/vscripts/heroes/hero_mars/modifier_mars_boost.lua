modifier_mars_boost = class({})

function modifier_mars_boost:IsHidden()
	return true
end

function modifier_mars_boost:IsPurgable()
	return false
end

function modifier_mars_boost:OnCreated( kv )
str_bonus = self:GetCaster():GetStrength()*0.1
end

function modifier_mars_boost:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		
	}
	return funcs
end

function modifier_mars_boost:GetModifierBonusStats_Strength(keys)
return str_bonus
end

function modifier_mars_boost:GetModifierMoveSpeedBonus_Constant(keys)
return 50
end
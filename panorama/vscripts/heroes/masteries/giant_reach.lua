modifier_chc_mastery_giant_reach = class({})

function modifier_chc_mastery_giant_reach:IsHidden() return true end
function modifier_chc_mastery_giant_reach:IsDebuff() return false end
function modifier_chc_mastery_giant_reach:IsPurgable() return false end
function modifier_chc_mastery_giant_reach:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_giant_reach:GetTexture() return "masteries/giant_reach" end

function modifier_chc_mastery_giant_reach:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_PROPERTY_CAST_RANGE_BONUS_STACKING
	}
end

function modifier_chc_mastery_giant_reach:GetModifierAttackRangeBonus()
	return (self:GetParent():IsRangedAttacker() and self.ranged_bonus) or self.melee_bonus
end

function modifier_chc_mastery_giant_reach:GetModifierCastRangeBonusStacking()
	return self.cast_bonus
end



modifier_chc_mastery_giant_reach_1 = class(modifier_chc_mastery_giant_reach)
modifier_chc_mastery_giant_reach_2 = class(modifier_chc_mastery_giant_reach)
modifier_chc_mastery_giant_reach_3 = class(modifier_chc_mastery_giant_reach)

function modifier_chc_mastery_giant_reach_1:OnCreated(keys)
	self.melee_bonus = 100
	self.ranged_bonus = 100
	self.cast_bonus = 100
end

function modifier_chc_mastery_giant_reach_2:OnCreated(keys)
	self.melee_bonus = 200
	self.ranged_bonus = 200
	self.cast_bonus = 200
end

function modifier_chc_mastery_giant_reach_3:OnCreated(keys)
	self.melee_bonus = 400
	self.ranged_bonus = 400
	self.cast_bonus = 400
end

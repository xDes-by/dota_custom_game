innate_giant_strikes = class({})

LinkLuaModifier("modifier_innate_giant_strikes", "heroes/innates/giant_strikes", LUA_MODIFIER_MOTION_NONE)

function innate_giant_strikes:GetIntrinsicModifierName()
	return "modifier_innate_giant_strikes"
end

modifier_innate_giant_strikes = class({})

function modifier_innate_giant_strikes:IsHidden() return true end
function modifier_innate_giant_strikes:IsDebuff() return false end
function modifier_innate_giant_strikes:IsPurgable() return false end
function modifier_innate_giant_strikes:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_giant_strikes:OnCreated(keys)
	self:OnRefresh(keys)
end

function modifier_innate_giant_strikes:OnRefresh()
	self.parent = self:GetParent()
	self.locked_attack_speed = self:GetAbility():GetSpecialValueFor("locked_attack_speed")
	self.bat_mult = self.locked_attack_speed * 0.01
end

function modifier_innate_giant_strikes:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_FIXED_ATTACK_RATE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_innate_giant_strikes:GetModifierFixedAttackRate()
	return self.parent:GetBaseAttackTime() / self.bat_mult
end

function modifier_innate_giant_strikes:GetModifierDamageOutgoing_Percentage()
	local attack_speed = self.parent:GetIncreasedAttackSpeed() + 1
	local bonus_damage = self.locked_attack_speed - attack_speed * 100

	-- GetIncreasedAttackSpeed dont take into account attack speed percentage reduction 
	-- and other functions capped by attack speed limit, so we reduce value here manually
	if self.parent:HasModifier("modifier_tiny_grow") then
		bonus_damage = bonus_damage * 0.7
	end

	return math.max(-bonus_damage, 0)
end

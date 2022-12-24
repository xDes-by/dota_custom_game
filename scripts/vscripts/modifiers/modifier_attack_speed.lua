modifier_attack_speed = class({})

function modifier_attack_speed:IsHidden()
	return true
end

function modifier_attack_speed:IsPurgable()
	return false
end

function modifier_attack_speed:RemoveOnDeath()
	return false
end


function modifier_attack_speed:DeclareFunctions()
	return {MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT}
end

function modifier_attack_speed:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount() * 3
end
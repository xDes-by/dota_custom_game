modifier_benchmark_power = class({})

function modifier_benchmark_power:IsHidden() return true end
function modifier_benchmark_power:IsDebuff() return false end
function modifier_benchmark_power:IsPurgable() return false end
function modifier_benchmark_power:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_benchmark_power:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end

function modifier_benchmark_power:GetModifierPreAttack_BonusDamage()
	return 100000
end

function modifier_benchmark_power:GetModifierAttackSpeedBonus_Constant()
	return 10000
end

function modifier_benchmark_power:GetModifierIncomingDamage_Percentage()
	return -100
end

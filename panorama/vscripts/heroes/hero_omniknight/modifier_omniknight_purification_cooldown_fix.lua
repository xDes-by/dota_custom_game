modifier_omniknight_purification_cooldown_fix = class({})

function modifier_omniknight_purification_cooldown_fix:IsHidden()
	return true
end

function modifier_omniknight_purification_cooldown_fix:IsPermanent()
	return true
end

function modifier_omniknight_purification_cooldown_fix:IsPurgable()
	return false
end

function modifier_omniknight_purification_cooldown_fix:RemoveOnDeath()
	return false
end

function modifier_omniknight_purification_cooldown_fix:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
	}
end

function modifier_omniknight_purification_cooldown_fix:GetModifierCooldownReduction_Constant(keys)
	local ability = keys.ability
	if ability and ability:GetAbilityName() == "frostivus2018_omniknight_purification" then
		return ability:GetCaster():FindTalentValue("special_bonus_unique_omniknight_6")
	end
end

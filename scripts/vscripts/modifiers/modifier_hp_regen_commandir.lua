modifier_hp_regen_commandir = class({})

function modifier_hp_regen_commandir:IsHidden()
	return true
end

function modifier_hp_regen_commandir:IsPurgable()
	return false
end

function modifier_hp_regen_commandir:RemoveOnDeath()
	return false
end

function modifier_hp_regen_commandir:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
end

function modifier_hp_regen_commandir:GetModifierHealthRegenPercentage()
	return 0.5
end

modifier_hp_regen_creep = class({})

function modifier_hp_regen_creep:IsHidden()
	return true
end

function modifier_hp_regen_creep:IsPurgable()
	return false
end

function modifier_hp_regen_creep:RemoveOnDeath()
	return false
end

function modifier_hp_regen_creep:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
end

function modifier_hp_regen_creep:GetModifierHealthRegenPercentage()
	return 0.75
end

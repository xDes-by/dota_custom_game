modifier_hp_regen_boss = class({})

function modifier_hp_regen_boss:IsHidden()
	return true
end

function modifier_hp_regen_boss:IsPurgable()
	return false
end

function modifier_hp_regen_boss:RemoveOnDeath()
	return false
end

function modifier_hp_regen_boss:DeclareFunctions()
	return {MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE}
end

function modifier_hp_regen_boss:GetModifierHealthRegenPercentage()
	if self:GetParent():GetUnitName() == "npc_boss_plague_squirrel" then
		return 0.025
	end
	return 0.25
end

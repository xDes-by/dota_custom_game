modifier_tempest_double_illusion_permanent = class({})

function modifier_tempest_double_illusion_permanent:IsHidden() return true end
function modifier_tempest_double_illusion_permanent:IsPurgable() return false end
function modifier_tempest_double_illusion_permanent:RemoveOnDeath() return false end

function modifier_tempest_double_illusion_permanent:StatusEffectPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA 
end

function modifier_tempest_double_illusion_permanent:GetEffectName()
	return "particles/units/heroes/hero_arc_warden/arc_warden_tempest_buff.vpcf"
end

function modifier_tempest_double_illusion_permanent:GetStatusEffect()
	return "particles/status_fx/status_effect_arc_warden_tempest.vpcf"
end

function modifier_tempest_double_illusion_permanent:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TEMPEST_DOUBLE
	}
end

function modifier_tempest_double_illusion_permanent:GetModifierTempestDouble()
	return 1
end
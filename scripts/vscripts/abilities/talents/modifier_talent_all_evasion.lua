modifier_talent_all_evasion = class({})

function modifier_talent_all_evasion:IsHidden()
	return true
end

function modifier_talent_all_evasion:IsPurgable()
	return false
end

function modifier_talent_all_evasion:RemoveOnDeath()
	return false
end

function modifier_talent_all_evasion:OnCreated()
	self.value = {10, 15, 20, 25, 30, 35}
	self:SetStackCount(1)
	self.parent = self:GetParent()
end

function modifier_talent_all_evasion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_talent_all_evasion:GetModifierIncomingDamage_Percentage()
	if RollPercentage(self.value[self:GetStackCount()]) then
		local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, self.parent)
		ParticleManager:SetParticleControl(backtrack_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(backtrack_fx)
		return -100
	end
end
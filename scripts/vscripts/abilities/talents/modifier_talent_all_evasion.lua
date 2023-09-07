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
modifier_talent_all_evasion.value = {10, 15, 20, 25, 30, 35}
function modifier_talent_all_evasion:OnCreated()
	self.caster = self:GetCaster()
	self.max_chance = self.value[self:GetStackCount()]
end

function modifier_talent_all_evasion:OnRefresh()
	self.max_chance = self.value[self:GetStackCount()]
end

function modifier_talent_all_evasion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_talent_all_evasion:GetModifierIncomingDamage_Percentage()
	if RandomInt(1,100) <= self.max_chance then
		local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, self.caster)
		ParticleManager:SetParticleControl(backtrack_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(backtrack_fx)
		return -100
	end
end
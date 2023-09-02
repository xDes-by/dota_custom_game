all_evasion = class({})
LinkLuaModifier( "modifier_all_evasion", "abilities/talents/all_evasion", LUA_MODIFIER_MOTION_NONE )

function all_evasion:GetIntrinsicModifierName()
	return "modifier_all_evasion"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_all_evasion = class({})

function modifier_all_evasion:IsHidden()
	return true
end

function modifier_all_evasion:IsPurgable()
	return false
end

function modifier_all_evasion:RemoveOnDeath()
	return false
end

function modifier_all_evasion:OnCreated()
	self.caster = self:GetCaster()
	self.max_chance = self:GetAbility():GetSpecialValueFor("all_evasion")
end

function modifier_all_evasion:OnRefresh()
	self.max_chance = self:GetAbility():GetSpecialValueFor("all_evasion")
end

function modifier_all_evasion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_all_evasion:GetModifierIncomingDamage_Percentage()
	if RandomInt(1,100) <= self.max_chance then
		local backtrack_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_backtrack.vpcf", PATTACH_ABSORIGIN, self.caster)
		ParticleManager:SetParticleControl(backtrack_fx, 0, caster:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(backtrack_fx)
		return -100
	end
end
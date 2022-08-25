modifier_effect_14 = class({})

function modifier_effect_14:IsHidden()
	return true
end

function modifier_effect_14:IsPurgable()
	return false
end

function modifier_effect_14:IsPermanent()
	return true
end

function modifier_effect_14:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "particles/econ/events/ti9/mjollnir_shield_ti9.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self.caster:GetAbsOrigin(), true )
end

function modifier_effect_14:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end

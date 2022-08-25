modifier_effect_10 = class({})

function modifier_effect_10:IsHidden()
	return true
end

function modifier_effect_10:IsPurgable()
	return false
end

function modifier_effect_10:IsPermanent()
	return true
end

function modifier_effect_10:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "particles/econ/events/ti10/mjollnir_shield_ti10.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self.caster:GetAbsOrigin(), true )
end

function modifier_effect_10:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end


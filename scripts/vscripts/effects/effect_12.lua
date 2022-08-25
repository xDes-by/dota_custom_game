modifier_effect_12 = class({})

function modifier_effect_12:IsHidden()
	return true
end

function modifier_effect_12:IsPurgable()
	return false
end

function modifier_effect_12:IsPermanent()
	return true
end

function modifier_effect_12:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "particles/econ/events/ti8/ti8_hero_effect.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self.caster:GetAbsOrigin(), true )
end

function modifier_effect_12:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end


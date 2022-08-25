modifier_effect_15 = class({})

function modifier_effect_15:IsHidden()
	return true
end

function modifier_effect_15:IsPurgable()
	return false
end

function modifier_effect_15:IsPermanent()
	return true
end

function modifier_effect_15:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "particles/econ/events/winter_major_2016/radiant_fountain_regen_wm_lvl3.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self.caster:GetAbsOrigin(), true )
end

function modifier_effect_15:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end


modifier_effect_21 = class({})

function modifier_effect_21:IsHidden()
	return true
end

function modifier_effect_21:IsPurgable()
	return false
end

function modifier_effect_21:IsPermanent()
	return true
end

function modifier_effect_21:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "particles/econ/items/skywrath_mage/skywrath_ti9_immortal_back/skywrath_mage_ti9_golden_ambient_wings.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self.caster:GetAbsOrigin(), true )
end

function modifier_effect_21:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end

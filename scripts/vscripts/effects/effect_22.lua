modifier_effect_22 = class({})

function modifier_effect_22:IsHidden()
	return true
end

function modifier_effect_22:IsPurgable()
	return false
end

function modifier_effect_22:IsPermanent()
	return true
end

function modifier_effect_22:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "particles/econ/items/skywrath_mage/manticore/wings_of_the_manticore_golden_ambientfx.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self.caster:GetAbsOrigin(), true )
end

function modifier_effect_22:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end

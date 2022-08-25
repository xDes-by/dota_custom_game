modifier_effect_23 = class({})

function modifier_effect_23:IsHidden()
	return true
end

function modifier_effect_23:IsPurgable()
	return false
end

function modifier_effect_23:IsPermanent()
	return true
end

function modifier_effect_23:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "particles/units/heroes/hero_skywrath_mage/skywrath_mage_ancient_seal_debuff_rune.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self.caster:GetAbsOrigin(), true )
end

function modifier_effect_23:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end

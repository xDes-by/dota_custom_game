modifier_following_effect_1 = class({})

function modifier_following_effect_1:IsHidden()
	return true
end

function modifier_following_effect_1:IsPurgable()
	return false
end

function modifier_following_effect_1:IsPermanent()
	return true
end

function modifier_following_effect_1:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticle( "models/heroes/phantom_assassin_persona/debut/particles/pa_env_lanterns/pa_env_lanterns.vpcf", PATTACH_POINT_FOLLOW, self.caster )
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self.caster:GetAbsOrigin(), true )
end

function modifier_following_effect_1:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end

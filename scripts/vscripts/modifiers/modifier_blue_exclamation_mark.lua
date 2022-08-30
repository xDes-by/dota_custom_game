modifier_blue_exclamation_mark = class({})

function modifier_blue_exclamation_mark:IsHidden()
	return true
end

function modifier_blue_exclamation_mark:IsPurgable()
	return false
end

function modifier_blue_exclamation_mark:IsPermanent()
	return true
end

function modifier_blue_exclamation_mark:OnCreated( kv )
	self.caster = self:GetCaster()
	self.particleLeader = ParticleManager:CreateParticleForPlayer( "particles/voskl_gold.vpcf", PATTACH_POINT_FOLLOW, self.caster, PlayerResource:GetPlayer(kv.PlayerID))
	ParticleManager:SetParticleControlEnt( self.particleLeader, PATTACH_OVERHEAD_FOLLOW, self.caster, PATTACH_OVERHEAD_FOLLOW, "PATTACH_OVERHEAD_FOLLOW", self.caster:GetAbsOrigin(), true )
end

function modifier_blue_exclamation_mark:OnDestroy( kv )
	ParticleManager:DestroyParticle(self.particleLeader, true)
    ParticleManager:ReleaseParticleIndex(self.particleLeader)
end


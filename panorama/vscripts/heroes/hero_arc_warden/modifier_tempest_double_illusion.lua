modifier_tempest_double_illusion = class({})

function modifier_tempest_double_illusion:IsHidden() return false end
function modifier_tempest_double_illusion:IsPurgable() return false end

function modifier_tempest_double_illusion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION, -- GetUnitLifetimeFraction
	}
end

function modifier_tempest_double_illusion:GetUnitLifetimeFraction( params )
	return ( ( self:GetDieTime() - GameRules:GetGameTime() ) / self:GetDuration() )
end

function modifier_tempest_double_illusion:OnDestroy()
	if not IsServer() then return end
	local parent = self:GetParent()

	parent:ForceKill(false)

	local particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_arc_warden/arc_warden_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
	ParticleManager:SetParticleControlEnt(particle, 0, parent, PATTACH_ABSORIGIN_FOLLOW, "attach_hitloc", parent:GetAbsOrigin(), true)

	Timers:CreateTimer("arc_dying_sequence_" .. tostring(parent:GetEntityIndex()), {
		endTime = 3,
		callback = function()
			ParticleManager:DestroyParticle(particle, true)
			ParticleManager:ReleaseParticleIndex(particle)

			parent:AddEffects(EF_NODRAW)
			parent:SetAbsOrigin(Vector(-8000, -8000, -8000))
		end
	})
end


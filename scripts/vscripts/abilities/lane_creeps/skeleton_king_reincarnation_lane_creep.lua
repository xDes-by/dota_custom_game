skeleton_king_reincarnation_lane_creep = class({})

LinkLuaModifier( "modifier_skeleton_king_reincarnation_lane_creep","abilities/lane_creeps/skeleton_king_reincarnation_lane_creep", LUA_MODIFIER_MOTION_NONE )

function skeleton_king_reincarnation_lane_creep:GetIntrinsicModifierName()
    return "modifier_skeleton_king_reincarnation_lane_creep"
end

function skeleton_king_reincarnation_lane_creep:OnOwnerDied()
end

-----------------------------------------------------------------------------

modifier_skeleton_king_reincarnation_lane_creep = class({})

function modifier_skeleton_king_reincarnation_lane_creep:IsHidden()
	return false
end

function modifier_skeleton_king_reincarnation_lane_creep:GetTexture()
	return "item_aegis"
end

function modifier_skeleton_king_reincarnation_lane_creep:IsPermanent()
	return true
end

function modifier_skeleton_king_reincarnation_lane_creep:IsPurgable()
	return false
end


function modifier_skeleton_king_reincarnation_lane_creep:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_skeleton_king_reincarnation_lane_creep:ReincarnateTime()
	return self.reincarnate_time
end

function modifier_skeleton_king_reincarnation_lane_creep:OnDeath(keys)
	if IsServer() then
	   if keys.unit == self:GetParent() and self:GetAbility():IsFullyCastable() then
			self:GetAbility():StartCooldown(99999)
			self:PlayEffects()
			local hCaster = self:GetParent()
			local hAbility = self:GetAbility()
			local flReincarnateTime = self.reincarnate_time
			Timers:CreateTimer({ endTime = 3, callback = function()
				hCaster:RespawnUnit()
			end})
		end
	end
end

function modifier_skeleton_king_reincarnation_lane_creep:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_skeletonking/wraith_king_reincarnate.vpcf"
	local sound_cast = "Hero_SkeletonKing.Reincarnate"
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.reincarnate_time, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end
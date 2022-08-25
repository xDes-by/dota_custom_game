mars_bulwark_lane_creep = class({})

LinkLuaModifier( "modifier_mars_bulwark_lane_creep","abilities/lane_creeps/mars_bulwark_lane_creep", LUA_MODIFIER_MOTION_NONE )

function mars_bulwark_lane_creep:GetIntrinsicModifierName()
    return "modifier_mars_bulwark_lane_creep"
end

modifier_mars_bulwark_lane_creep = class({})

function modifier_mars_bulwark_lane_creep:IsHidden()
    return false
end

function modifier_mars_bulwark_lane_creep:IsDebuff()
    return false
end

function modifier_mars_bulwark_lane_creep:IsPurgable()
    return false
end

function modifier_mars_bulwark_lane_creep:OnCreated()
    self.reduction_front = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction" )
	self.reduction_side = self:GetAbility():GetSpecialValueFor( "physical_damage_reduction_side" )
	self.angle_front = 140
	self.angle_side = 240
end

function modifier_mars_bulwark_lane_creep:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
    }
end

function modifier_mars_bulwark_lane_creep:GetModifierPhysical_ConstantBlock( params )
	if RandomInt(1,100) < 50 then
		if params.inflictor then return 0 end
		if params.target:PassivesDisabled() then return 0 end
		local parent = params.target
		local attacker = params.attacker
		local reduction = 0

		-- Check target position
		local facing_direction = parent:GetAnglesAsVector().y
		local attacker_vector = (attacker:GetOrigin() - parent:GetOrigin())
		local attacker_direction = VectorToAngles( attacker_vector ).y
		local angle_diff = math.abs( AngleDiff( facing_direction, attacker_direction ) )

		-- calculate damage reduction
		if angle_diff < self.angle_front then
			reduction = self.reduction_front
			self:PlayEffects( true, attacker_vector )

		elseif angle_diff < self.angle_side then
			reduction = self.reduction_side
			self:PlayEffects( false, attacker_vector )
		end

		return reduction*params.damage/100
	end
end

function modifier_mars_bulwark_lane_creep:PlayEffects( front )
	local particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars.vpcf"
	local sound_cast = "Hero_Mars.Shield.Block"
	if not front then
		particle_cast = "particles/units/heroes/hero_mars/mars_shield_of_mars_small.vpcf"
		sound_cast = "Hero_Mars.Shield.BlockSmall"
	end
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:ReleaseParticleIndex( effect_cast )
	EmitSoundOn( sound_cast, self:GetParent() )
end
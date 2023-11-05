modifier_jakiro_dual_breath_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_jakiro_dual_breath_lua:IsHidden()
	return true
end

function modifier_jakiro_dual_breath_lua:IsDebuff()
	return false
end

function modifier_jakiro_dual_breath_lua:IsStunDebuff()
	return false
end

function modifier_jakiro_dual_breath_lua:IsPurgable()
	return false
end

function modifier_jakiro_dual_breath_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE 
end

function modifier_jakiro_dual_breath_lua:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_jakiro_dual_breath_lua:OnCreated( kv )
	if not IsServer() then return end
	local caster = self:GetCaster()
	-- calculate direction
	self.direction = Vector( kv.x, kv.y, 0 )
	self.direction.z = 0
	self.direction = self.direction:Normalized()
	self.speed = self:GetSpecialValueFor( "speed_fire" )
	self:GetAbility():IceBreath(self.direction.x, self.direction.y)
	-- play effects
	local sound_cast = "Hero_Jakiro.DualBreath.Cast"
	EmitSoundOn( sound_cast, self:GetCaster() )
end

function modifier_jakiro_dual_breath_lua:OnRefresh( kv )
	
end

function modifier_jakiro_dual_breath_lua:OnRemoved()
	if not IsServer() then return end

	-- launch fire projectile
	self:GetAbility():FireBreath(self.direction.x, self.direction.y)

	-- play effects
	self:PlayEffects()
end

function modifier_jakiro_dual_breath_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_jakiro_dual_breath_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire_launch_2.vpcf"

	local caster = self:GetCaster()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControl( effect_cast, 0, caster:GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, self.direction * self.speed )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		9,
		caster,
		PATTACH_ABSORIGIN_FOLLOW,
		"attach_attack1",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
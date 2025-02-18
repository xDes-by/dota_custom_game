sniper_shrapnel_lua = class({})
LinkLuaModifier( "modifier_sniper_shrapnel_lua", "heroes/hero_sniper/sniper_shrapnel_lua/modifier_sniper_shrapnel_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_sniper_shrapnel_lua_thinker", "heroes/hero_sniper/sniper_shrapnel_lua/modifier_sniper_shrapnel_lua_thinker", LUA_MODIFIER_MOTION_NONE )


function sniper_shrapnel_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function sniper_shrapnel_lua:GetCooldown(level)
	local caster = self:GetCaster()
	return self.BaseClass.GetCooldown( self, level )
end

function sniper_shrapnel_lua:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function sniper_shrapnel_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	-- logic
	CreateModifierThinker(
		caster,
		self,
		"modifier_sniper_shrapnel_lua_thinker",
		{},
		point,
		caster:GetTeamNumber(),
		false
	)

	-- effects
	self:PlayEffects( point )
end

--------------------------------------------------------------------------------
function sniper_shrapnel_lua:PlayEffects( point )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_sniper/sniper_shrapnel_launch.vpcf"
	local sound_cast = "Hero_Sniper.ShrapnelShoot"

	-- Get Data
	local height = 2000

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_attack1",
		self:GetCaster():GetOrigin(), -- unknown
		false -- unknown, true
	)
	ParticleManager:SetParticleControl( effect_cast, 1, point + Vector( 0, 0, height ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetCaster() )
end



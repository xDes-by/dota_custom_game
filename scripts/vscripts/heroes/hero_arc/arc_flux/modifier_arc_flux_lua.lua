modifier_arc_flux_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_arc_flux_lua:IsHidden()
	return false
end

function modifier_arc_flux_lua:IsDebuff()
	return false
end

function modifier_arc_flux_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_arc_flux_lua:OnCreated( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	if not IsServer() then return end
	local caster = self:GetCaster()

	self:PlayEffects()
end

function modifier_arc_flux_lua:OnRefresh( kv )
	-- references
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )	
end

function modifier_arc_flux_lua:OnRemoved()
end

function modifier_arc_flux_lua:OnDestroy()

end

function modifier_arc_flux_lua:IsAura()
	return true
end

function modifier_arc_flux_lua:GetModifierAura()
	return "modifier_arc_flux_lua_debuff"
end

function modifier_arc_flux_lua:GetAuraRadius()
	return self.radius
end

function modifier_arc_flux_lua:GetAuraDuration()
	return 0.5
end

function modifier_arc_flux_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_arc_flux_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_arc_flux_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_arc_flux_lua:GetAuraEntityReject( hEntity )
	if IsServer() then
		
	end

	return false
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_arc_flux_lua:PlayEffects()
	-- Get Resources
	local particle_cast1 = "particles/units/heroes/hero_siren/naga_siren_siren_song_cast.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_siren/naga_siren_song_aura.vpcf"
	local sound_cast = "Hero_ArcWarden.Flux.Cast"

	-- Get Data
	local caster = self:GetCaster()

	-- Create Particle 1
	local effect_cast = ParticleManager:CreateParticle( particle_cast1, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- create particle 2
	effect_cast = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, caster )
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		0,
		caster,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0,0,0), -- unknown
		true -- unknown, true
	)

	-- buff particle
	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, caster )
end
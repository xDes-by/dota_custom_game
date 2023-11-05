modifier_lina_firehell_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_lina_firehell_lua:IsHidden()
	return false
end

function modifier_lina_firehell_lua:IsDebuff()
	return not self.owner
end

function modifier_lina_firehell_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_lina_firehell_lua:OnCreated( kv )
	-- references
	local damage = self:GetAbility():GetSpecialValueFor( "base_damage_per_second" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.ms_bonus = self:GetAbility():GetSpecialValueFor( "bonus_movement_speed_pct" )
	self.manacost = self:GetAbility():GetManaCost(self:GetAbility():GetLevel() - 1)
	
	self:PlayEffects1()
	self.owner = kv.isProvidedByAura~=1
	if not IsServer() then return end
	self.interval = 0.3
	if self.owner then return end
	-- precache damage
	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage * self.interval,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self:GetAbility(),
	}

	-- Start interval
	self:StartIntervalThink( 0.2 )

	-- Play effects
	
end

function modifier_lina_firehell_lua:OnRemoved()
end

function modifier_lina_firehell_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_lina_firehell_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_lina_firehell_lua:GetModifierMoveSpeedBonus_Constant()
	return self.ms_bonus
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_lina_firehell_lua:OnIntervalThink()
	ApplyDamage( self.damageTable )
	self:PlayEffects2( self:GetParent() )
	self:StartIntervalThink( self.interval )
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_lina_firehell_lua:IsAura()
	return self.owner
end

function modifier_lina_firehell_lua:GetModifierAura()
	return "modifier_lina_firehell_lua"
end

function modifier_lina_firehell_lua:GetAuraRadius()
	return self.radius
end

function modifier_lina_firehell_lua:GetAuraDuration()
	return 0.5
end

function modifier_lina_firehell_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_lina_firehell_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_lina_firehell_lua:GetEffectName()
	return "particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_buff.vpcf"
end

function modifier_lina_firehell_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_lina_firehell_lua:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_scorched_earth.vpcf"
	local sound_cast = "Hero_DoomBringer.ScorchedEarthAura"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )

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
	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_lina_firehell_lua:PlayEffects2( target )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_doom_bringer/doom_bringer_scorched_earth_debuff.vpcf"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, target )
	ParticleManager:ReleaseParticleIndex( effect_cast )
end
boss_4_midnignt = class({})
LinkLuaModifier( "modifier_boss_4_midnignt_thinker", "abilities/bosses/line/boss_4/boss_4_midnignt", LUA_MODIFIER_MOTION_NONE )

function boss_4_midnignt:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function boss_4_midnignt:OnSpellStart()
	local caster = self:GetCaster()
	local point = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor("duration")

	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_boss_4_midnignt_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end

--------------------------------------------------------------------------------

modifier_boss_4_midnignt_thinker = class({})

function modifier_boss_4_midnignt_thinker:IsHidden()
	return true
end

function modifier_boss_4_midnignt_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage_percent" )
	local interval = 1

	if IsServer() then
		GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), self.radius, true )

		self.damageTable = {
			attacker = self:GetCaster(),
			damage_type = DAMAGE_TYPE_PURE,
			ability = self:GetAbility(), --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
		}

		self:StartIntervalThink( interval )
		self:PlayEffects()
	end
end

function modifier_boss_4_midnignt_thinker:OnDestroy()
	if IsServer() then
		UTIL_Remove( self:GetParent() )
	end
end

function modifier_boss_4_midnignt_thinker:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		-- apply damage
		self.damageTable.victim = enemy
		self.damageTable.damage = enemy:GetMaxHealth()*self.damage/100
		ApplyDamage( self.damageTable )
	end
end

function modifier_boss_4_midnignt_thinker:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_enigma/enigma_midnight_pulse.vpcf"
	self.sound_cast = "Hero_Enigma.Midnight_Pulse"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 0, 0 ) )
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

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
	EmitSoundOn( self.sound_cast, self:GetParent() )
end
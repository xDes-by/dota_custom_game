ability_crystal_boss_freezing_field = class({})

LinkLuaModifier( "modifier_ability_crystal_boss_freezing_field", "abilities/bosses/crystal/ability_crystal_boss_freezing_field", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_crystal_boss_freezing_field_effect", "abilities/bosses/crystal/ability_crystal_boss_freezing_field", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_crystal_boss_freezing_field_frost_bite", "abilities/bosses/crystal/ability_crystal_boss_freezing_field", LUA_MODIFIER_MOTION_NONE )

function ability_crystal_boss_freezing_field:OnSpellStart()
	local caster = self:GetCaster()
	self.modifier = caster:AddNewModifier(caster,self,"modifier_ability_crystal_boss_freezing_field",{ duration = self:GetChannelTime() })
end

function ability_crystal_boss_freezing_field:OnChannelFinish( bInterrupted )
	if self.modifier then
		self.modifier:Destroy()
		self.modifier = nil
	end
end

modifier_ability_crystal_boss_freezing_field = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ability_crystal_boss_freezing_field:IsHidden()
	return true
end

function modifier_ability_crystal_boss_freezing_field:IsDebuff()
	return false
end

function modifier_ability_crystal_boss_freezing_field:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Aura
function modifier_ability_crystal_boss_freezing_field:IsAura()
	return true
end

function modifier_ability_crystal_boss_freezing_field:GetModifierAura()
	return "modifier_ability_crystal_boss_freezing_field_effect"
end

function modifier_ability_crystal_boss_freezing_field:GetAuraRadius()
	return self.slow_radius
end

function modifier_ability_crystal_boss_freezing_field:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_crystal_boss_freezing_field:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_ability_crystal_boss_freezing_field:GetAuraDuration()
	return self.slow_duration
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_ability_crystal_boss_freezing_field:OnCreated( kv )
	-- references
	self.slow_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.slow_duration = self:GetAbility():GetSpecialValueFor( "slow_duration" )
	self.explosion_radius = self:GetAbility():GetSpecialValueFor( "explosion_radius" )
	self.explosion_interval = self:GetAbility():GetSpecialValueFor( "explosion_interval" )
	self.explosion_min_dist = self:GetAbility():GetSpecialValueFor( "explosion_min_dist" )
	self.explosion_max_dist = self:GetAbility():GetSpecialValueFor( "explosion_max_dist" )
	local explosion_damage = self:GetAbility():GetSpecialValueFor( "damage" )

	-- generate data
	self.quartal = -1

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = explosion_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()

		-- Play Effects
		self:PlayEffects1()
	end
end

function modifier_ability_crystal_boss_freezing_field:OnRefresh( kv )
	-- references
	self.slow_radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.explosion_radius = self:GetAbility():GetSpecialValueFor( "explosion_radius" )
	self.explosion_interval = self:GetAbility():GetSpecialValueFor( "explosion_interval" )
	self.explosion_min_dist = self:GetAbility():GetSpecialValueFor( "explosion_min_dist" )
	self.explosion_max_dist = self:GetAbility():GetSpecialValueFor( "explosion_max_dist" )
	local explosion_damage = self:GetAbility():GetSpecialValueFor( "damage" )

	-- generate data
	self.quartal = -1

	if IsServer() then
		-- precache damage
		self.damageTable = {
			-- victim = target,
			attacker = self:GetCaster(),
			damage = explosion_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.explosion_interval )
		self:OnIntervalThink()
	end
end

function modifier_ability_crystal_boss_freezing_field:OnDestroy( kv )
	if IsServer() then
		self:StartIntervalThink( -1 )
		self:StopEffects1()
	end
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ability_crystal_boss_freezing_field:OnIntervalThink()
	-- Set explosion quartal
	self.quartal = self.quartal+1
	if self.quartal>3 then self.quartal = 0 end

	-- determine explosion relative position
	local a = RandomInt(0,90) + self.quartal*90
	local r = RandomInt(self.explosion_min_dist,self.explosion_max_dist)
	local point = Vector( math.cos(a), math.sin(a), 0 ):Normalized() * r

	-- actual position
	point = self:GetCaster():GetOrigin() + point

	-- Explode at point
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		point,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.explosion_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	-- damage units
	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- Play effects
	self:PlayEffects2( point )
end

function modifier_ability_crystal_boss_freezing_field:CheckState()
    return {
        [MODIFIER_STATE_INVULNERABLE] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true
    }
end

--------------------------------------------------------------------------------
-- Effects
function modifier_ability_crystal_boss_freezing_field:PlayEffects1()
	local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_snow.vpcf"
	self.sound_cast = "hero_Crystal.freezingField.wind"

	-- Create Particle
	self.effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	-- self.effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetCaster() )
	ParticleManager:SetParticleControl( self.effect_cast, 1, Vector( self.slow_radius, self.slow_radius, 1 ) )
	self:AddParticle(
		self.effect_cast,
		false,
		false,
		-1,
		false,
		false
	)

	-- Play sound
	EmitSoundOn( self.sound_cast, self:GetCaster() )
end

function modifier_ability_crystal_boss_freezing_field:PlayEffects2( point )
	-- Play particles
	local particle_cast = "particles/units/heroes/hero_crystalmaiden/maiden_freezing_field_explosion.vpcf"

	-- Create particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, nil )
	-- local effect_cast = assert(loadfile("lua_abilities/rubick_spell_steal_lua/rubick_spell_steal_lua_arcana"))(self, particle_cast, PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( effect_cast, 0, point )

	-- Play sound
	local sound_cast = "hero_Crystal.freezingField.explosion"
	EmitSoundOnLocationWithCaster( point, sound_cast, self:GetCaster() )
end

function modifier_ability_crystal_boss_freezing_field:StopEffects1()
	StopSoundOn( self.sound_cast, self:GetCaster() )
end

modifier_ability_crystal_boss_freezing_field_effect = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ability_crystal_boss_freezing_field_effect:IsHidden()
	return false
end

function modifier_ability_crystal_boss_freezing_field_effect:IsDebuff()
	return true
end

function modifier_ability_crystal_boss_freezing_field_effect:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ability_crystal_boss_freezing_field_effect:OnCreated( kv )
	-- references
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )
    if not IsServer() then
        return
    end
    self:StartIntervalThink(2)
end

function modifier_ability_crystal_boss_freezing_field_effect:OnIntervalThink()
    self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_ability_crystal_boss_freezing_field_frost_bite", {duration = 1.5})
    self:StartIntervalThink(-1)
end

function modifier_ability_crystal_boss_freezing_field_effect:OnRefresh( kv )
	-- references
	self.ms_slow = self:GetAbility():GetSpecialValueFor( "movespeed_slow" )
	self.as_slow = self:GetAbility():GetSpecialValueFor( "attack_slow" )	
end

function modifier_ability_crystal_boss_freezing_field_effect:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_ability_crystal_boss_freezing_field_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}

	return funcs
end

function modifier_ability_crystal_boss_freezing_field_effect:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end

function modifier_ability_crystal_boss_freezing_field_effect:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ability_crystal_boss_freezing_field_effect:GetEffectName()
	return "particles/generic_gameplay/generic_slowed_cold.vpcf"
end

function modifier_ability_crystal_boss_freezing_field_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

modifier_ability_crystal_boss_freezing_field_frost_bite = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_ability_crystal_boss_freezing_field_frost_bite:IsHidden()
	return false
end

function modifier_ability_crystal_boss_freezing_field_frost_bite:IsDebuff()
	return true
end

function modifier_ability_crystal_boss_freezing_field_frost_bite:IsStunDebuff()
	return false
end

function modifier_ability_crystal_boss_freezing_field_frost_bite:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_ability_crystal_boss_freezing_field_frost_bite:OnCreated( kv )
	-- references
	local tick_damage = self:GetParent():GetLevel() * 20
	self.interval = 0.5

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- Play Effects
		self.sound_target = "hero_Crystal.frostbite"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_ability_crystal_boss_freezing_field_frost_bite:OnRefresh( kv )
	-- references
	local tick_damage = self:GetParent():GetLevel() * 20
	self.interval = 0.1

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = tick_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_NONE, --Optional.
			ability = self, --Optional.
		}

		-- Start interval
		self:StartIntervalThink( self.interval )
		self:OnIntervalThink()

		-- Play Effects
		self.sound_target = "hero_Crystal.frostbite"
		EmitSoundOn( self.sound_target, self:GetParent() )
	end
end

function modifier_ability_crystal_boss_freezing_field_frost_bite:OnDestroy()
	StopSoundOn( self.sound_target, self:GetParent() )
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_ability_crystal_boss_freezing_field_frost_bite:CheckState()
	local state = {
	[MODIFIER_STATE_DISARMED] = true,
	[MODIFIER_STATE_ROOTED] = true,
	[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_ability_crystal_boss_freezing_field_frost_bite:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_ability_crystal_boss_freezing_field_frost_bite:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_ability_crystal_boss_freezing_field_frost_bite:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
modifier_naga_siren_rip_tide_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_naga_siren_rip_tide_lua:IsHidden()
	return true
end

function modifier_naga_siren_rip_tide_lua:IsDebuff()
	return false
end

function modifier_naga_siren_rip_tide_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_naga_siren_rip_tide_lua:OnCreated( kv )
	
	self.caster = self:GetCaster()

	-- references
	self.chance = self:GetAbility():GetSpecialValueFor( "chance" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.duration = self:GetAbility():GetSpecialValueFor( "duration" )
	local damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end
	-- ability properties
	self:GetAbility()DamageType = self:GetAbility():GetAbilityDamageType()
	self:GetAbility()TargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self:GetAbility()TargetType = self:GetAbility():GetAbilityTargetType()
	self:GetAbility()TargetFlags = self:GetAbility():GetAbilityTargetFlags()

	-- precache damage
	self.damageTable = {
		-- victim = target,
		attacker = self:GetParent(),
		damage = damage,
		damage_type = self:GetAbility()DamageType,
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)
end

function modifier_naga_siren_rip_tide_lua:OnRefresh( kv )
	self:OnCreated( kv )
end

function modifier_naga_siren_rip_tide_lua:OnRemoved()
end

function modifier_naga_siren_rip_tide_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_naga_siren_rip_tide_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
	}

	return funcs
end

function modifier_naga_siren_rip_tide_lua:GetModifierProcAttack_Feedback( params )
	if not IsServer() then return end

	-- cancel if break
	if self:GetParent():PassivesDisabled() then return end

	-- roll chance
	local rand = RandomInt( 0,100 )
	if rand>=self.chance then return end

	-- find enemies
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)
	
	if self:GetCaster():FindAbilityByName("special_bonus_unique_naga_custom2"):IsTrained() then 
		self.duration = self:GetAbility():GetSpecialValueFor( "duration" ) + 2
	end

	for _,enemy in pairs(enemies) do
		-- apply debuff
		enemy:AddNewModifier(
			self.caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_naga_siren_rip_tide_lua_debuff", -- modifier name
			{ duration = self.duration } -- kv
		)

		-- damage
		self.damageTable.victim = enemy
		ApplyDamage( self.damageTable )
	end

	-- play effects
	self:PlayEffects()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_naga_siren_rip_tide_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_siren/naga_siren_riptide.vpcf"
	local sound_cast = "Hero_NagaSiren.Riptide.Cast"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:SetParticleControl( effect_cast, 3, Vector( self.radius, self.radius, self.radius ) )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_cast, self:GetParent() )
end
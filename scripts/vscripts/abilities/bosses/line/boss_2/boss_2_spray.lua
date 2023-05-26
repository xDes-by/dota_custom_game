boss_2_spray = class({})
LinkLuaModifier( "modifier_boss_2_spray", "abilities/bosses/line/boss_2/boss_2_spray", LUA_MODIFIER_MOTION_NONE )

function boss_2_spray:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function boss_2_spray:OnSpellStart()
	local point = self:GetCursorPosition()

	local duration = self:GetSpecialValueFor( "duration" )

	CreateModifierThinker(
		self:GetCaster(), -- player source
		self, -- ability source
		"modifier_boss_2_spray", -- modifier name
		{ duration = duration }, -- kv
		point,
		self:GetCaster():GetTeamNumber(),
		false
	)
end


------------------------------------------------------------------------------------------------

modifier_boss_2_spray = class({})

function modifier_boss_2_spray:IsHidden()
	return false
end

function modifier_boss_2_spray:IsDebuff()
	return true
end

function modifier_boss_2_spray:IsStunDebuff()
	return false
end

function modifier_boss_2_spray:IsPurgable()
	return false
end

function modifier_boss_2_spray:OnCreated( kv )
	local interval = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.armor = -self:GetAbility():GetSpecialValueFor( "armor_reduction" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )

	self.thinker = kv.isProvidedByAura~=1

	if not IsServer() then return end
	if not self.thinker then return end


	self.damageTable = {
		victim = target,
		attacker = self:GetCaster(),
		damage_type = DAMAGE_TYPE_PHYSICAL,
		ability = self:GetAbility(),
	}

	self:StartIntervalThink( interval )

	self.sound_cast = "Hero_Alchemist.AcidSpray.Damage"
	self:PlayEffects()
end

function modifier_boss_2_spray:OnRefresh( kv )
	
end

function modifier_boss_2_spray:OnRemoved()
end

function modifier_boss_2_spray:OnDestroy()
	if not IsServer() then return end
	if not self.thinker then return end

	UTIL_Remove( self:GetParent() )
end

function modifier_boss_2_spray:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_boss_2_spray:GetModifierPhysicalArmorBonus()
	return self.armor
end

function modifier_boss_2_spray:OnIntervalThink()
	local enemies = FindUnitsInRadius(
		self:GetParent():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	for _,enemy in pairs(enemies) do
		self.damageTable.victim = enemy
		self.damageTable.damage = enemy:GetMaxHealth()/100*self.damage
		
		ApplyDamage( self.damageTable )

		-- play effects
		EmitSoundOn( self.sound_cast, enemy )
	end
end

--------------------------------------------------------------------------------
-- Aura Effects
function modifier_boss_2_spray:IsAura()
	return self.thinker
end

function modifier_boss_2_spray:GetModifierAura()
	return "modifier_boss_2_spray"
end

function modifier_boss_2_spray:GetAuraRadius()
	return self.radius
end

function modifier_boss_2_spray:GetAuraDuration()
	return 0.5
end

function modifier_boss_2_spray:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_boss_2_spray:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_boss_2_spray:GetAuraSearchFlags()
	return 0
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_boss_2_spray:GetEffectName()
	return "particles/units/heroes/hero_alchemist/alchemist_acid_spray_debuff.vpcf"
end

function modifier_boss_2_spray:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_boss_2_spray:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_alchemist/alchemist_acid_spray.vpcf"
	local sound_cast = "Hero_Alchemist.AcidSpray"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	ParticleManager:SetParticleControl( effect_cast, 0, self:GetParent():GetOrigin() )
	ParticleManager:SetParticleControl( effect_cast, 1, Vector( self.radius, 1, 1 ) )

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
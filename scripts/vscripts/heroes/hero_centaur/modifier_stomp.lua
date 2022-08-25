modifier_stomp = class({})

function modifier_stomp:IsHidden()
	return false
end

function modifier_stomp:IsPurgable()
	return false
end

function modifier_stomp:OnCreated( kv )
	self.radius = 250

	self.interval = 0.5
	self.haste = 550

	if IsServer() then
		-- Apply Damage	 
		self.damageTable = {
			-- victim = target,
			attacker = self:GetParent(),
			damage = self:GetCaster():GetAgility(),
			damage_type = DAMAGE_TYPE_PHYSICAL,
		}
		self:StartIntervalThink( self.interval )

		self:PlayEffects1()
	end
end

function modifier_stomp:OnRefresh( kv )
end

function modifier_stomp:OnDestroy( kv )
end

function modifier_stomp:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE_MIN,
	}

	return funcs
end

function modifier_stomp:GetModifierMoveSpeed_AbsoluteMin()
	return self.haste
end

function modifier_stomp:CheckState()
	local state = {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end


function modifier_stomp:OnIntervalThink()
	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		self:GetCaster():GetTeamNumber(),	-- int, your team number
		self:GetParent():GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local target = nil
	for _,enemy in pairs(enemies) do
		target = enemy
	if target then
		-- Damage
		self.damageTable.victim = target
		ApplyDamage( self.damageTable )

		self:PlayEffects2( target )
	end
	end
end

function modifier_stomp:GetEffectName()
	return "particles/units/heroes/hero_centaur/centaur_stampede_overhead.vpcf"
end

function modifier_stomp:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end
function modifier_stomp:PlayEffects1()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_stampede.vpcf"
	local particle_cast2 = "particles/units/heroes/hero_centaur/centaur_stampede_haste.vpcf"
	local sound_cast = "Hero_Centaur.Stampede.Movement"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(
		effect_cast,
		false,
		false,
		-1,
		false,
		false
	)
	-- ParticleManager:ReleaseParticleIndex( effect_cast )

	local effect_cast2 = ParticleManager:CreateParticle( particle_cast2, PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
	self:AddParticle(
		effect_cast2,
		false,
		false,
		-1,
		false,
		false
	)

	EmitSoundOn( sound_cast, self:GetParent() )
end

function modifier_stomp:PlayEffects2( target )
	local sound_cast = "Hero_Centaur.Stampede.Stun"
	EmitSoundOn( sound_cast, target )
end
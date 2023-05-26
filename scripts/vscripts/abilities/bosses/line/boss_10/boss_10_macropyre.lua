LinkLuaModifier("modifier_boss_10_macropyre_thinker", "abilities/bosses/line/boss_10/boss_10_macropyre", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_boss_10_macropyre", "abilities/bosses/line/boss_10/boss_10_macropyre", LUA_MODIFIER_MOTION_NONE)

boss_10_macropyre = class({})

function boss_10_macropyre:OnSpellStart()
	local caster_pos = self:GetCaster():GetAbsOrigin()
	local line_pos = caster_pos + self:GetCaster():GetForwardVector() * 400
	local rotation_rate = 360 / 6
	for i = 1, 6 do
		line_pos = RotatePosition(caster_pos, QAngle(0, rotation_rate, 0), line_pos)
		self:createbolt(line_pos)
	end	
end

function boss_10_macropyre:createbolt(point)
	local caster = self:GetCaster()
	local dir = point - caster:GetOrigin()
	dir.z = 0
	dir = dir:Normalized()

	local duration = self:GetSpecialValueFor( "duration" )

	CreateModifierThinker(caster, self, "modifier_boss_10_macropyre_thinker",
		{
			duration = duration,
			x = dir.x,
			y = dir.y,
		},
		caster:GetOrigin(),
		caster:GetTeamNumber(),
		false)
	local sound_cast = "Hero_Jakiro.Macropyre.Cast"
	EmitSoundOn( sound_cast, caster )
end

----------------------------------------------------------------------------------

modifier_boss_10_macropyre_thinker = class({})

function modifier_boss_10_macropyre_thinker:IsHidden()
	return false
end

function modifier_boss_10_macropyre_thinker:IsDebuff()
	return false
end

function modifier_boss_10_macropyre_thinker:IsStunDebuff()
	return false
end

function modifier_boss_10_macropyre_thinker:IsPurgable()
	return false
end

function modifier_boss_10_macropyre_thinker:OnCreated( kv )
	self.caster = self:GetCaster()
	self.parent = self:GetParent()

	self.radius = 400
	self.duration = 5
	self.interval = 0.25
	self.range = self:GetAbility():GetCastRange( self.parent:GetAbsOrigin(), nil ) + self.caster:GetCastRangeBonus()
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )

	if not IsServer() then return end

	self.abilityDamageType = DAMAGE_TYPE_MAGICAL
	self.abilityTargetTeam = self:GetAbility():GetAbilityTargetTeam()
	self.abilityTargetType = self:GetAbility():GetAbilityTargetType()
	self.abilityTargetFlags = self:GetAbility():GetAbilityTargetFlags()

	-- calculate stuff
	local start_range = 234
	self.direction = Vector( kv.x, kv.y, 0 )
	self.startpoint = self.parent:GetOrigin() + self.direction * start_range
	self.endpoint = self.startpoint + self.direction * self.range

	local step = 0
	while step < self.range do
		local loc = self.startpoint + self.direction * step
		GridNav:DestroyTreesAroundPoint( loc, self.radius, true )

		step = step + self.radius
	end

	self:StartIntervalThink( self.interval )

	self:PlayEffects()
end

function modifier_boss_10_macropyre_thinker:OnRefresh( kv )
	
end

function modifier_boss_10_macropyre_thinker:OnRemoved()
end

function modifier_boss_10_macropyre_thinker:OnDestroy()
	if not IsServer() then return end
	UTIL_Remove( self:GetParent() )
end

function modifier_boss_10_macropyre_thinker:OnIntervalThink()
	local enemies = FindUnitsInLine(
		self.caster:GetTeamNumber(),	-- int, your team number
		self.startpoint,	-- point, center point
		self.endpoint,
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		self.abilityTargetTeam,	-- int, team filter
		self.abilityTargetType,	-- int, type filter
		self.abilityTargetFlags	-- int, flag filter
	)

	for _,enemy in pairs(enemies) do
		-- add modifier
		enemy:AddNewModifier(
			self.caster, -- player source
			self:GetAbility(), -- ability source
			"modifier_boss_10_macropyre", -- modifier name
			{
				duration = self.duration,
				interval = self.interval,
				damage = self.damage * self.interval,
				damage_type = self.abilityDamageType,
			} -- kv
		)
	end

end

function modifier_boss_10_macropyre_thinker:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf"
	local sound_cast = "hero_jakiro.macropyre"
	local duration = self:GetDuration()

	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_WORLDORIGIN, self.parent )
	ParticleManager:SetParticleControl( effect_cast, 0, self.startpoint )
	ParticleManager:SetParticleControl( effect_cast, 1, self.endpoint )
	ParticleManager:SetParticleControl( effect_cast, 2, Vector( duration, 0, 0 ) )

	self:AddParticle(
		effect_cast,
		false, -- bDestroyImmediately
		false, -- bStatusEffect
		-1, -- iPriority
		false, -- bHeroEffect
		false -- bOverheadEffect
	)

	-- Create Sound
	EmitSoundOn( sound_cast, self.parent )
end

--------------------------------------------------------------------

modifier_boss_10_macropyre = class({})

function modifier_boss_10_macropyre:IsHidden()
	return false
end

function modifier_boss_10_macropyre:IsDebuff()
	return true
end

function modifier_boss_10_macropyre:IsStunDebuff()
	return false
end

function modifier_boss_10_macropyre:IsPurgable()
	return false
end

function modifier_boss_10_macropyre:OnCreated( kv )
	if not IsServer() then return end
	local interval = kv.interval
	local damage = kv.damage
	local damage_type = kv.damage_type

	self.damageTable = {
		victim = self:GetParent(),
		attacker = self:GetCaster(),
		damage = damage,
		damage_type = damage_type,
		ability = self:GetAbility(), --Optional.
	}
	self:StartIntervalThink( interval )
end

function modifier_boss_10_macropyre:OnRefresh( kv )
	if not IsServer() then return end
	local damage = kv.damage
	local damage_type = kv.damage_type

	self.damageTable.damage = damage
	self.damageTable.damage_type = damage_type
end

function modifier_boss_10_macropyre:OnRemoved()
end

function modifier_boss_10_macropyre:OnDestroy()
end

function modifier_boss_10_macropyre:OnIntervalThink()
	ApplyDamage( self.damageTable )
end

function modifier_boss_10_macropyre:GetEffectName()
	return "particles/units/heroes/hero_jakiro/jakiro_liquid_fire_debuff.vpcf"
end

function modifier_boss_10_macropyre:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
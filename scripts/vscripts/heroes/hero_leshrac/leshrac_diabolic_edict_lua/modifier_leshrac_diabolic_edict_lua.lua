modifier_leshrac_diabolic_edict_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_leshrac_diabolic_edict_lua:IsHidden()
	return false
end

function modifier_leshrac_diabolic_edict_lua:IsDebuff()
	return false
end

function modifier_leshrac_diabolic_edict_lua:IsPurgable()
	return false
end

function modifier_leshrac_diabolic_edict_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_leshrac_diabolic_edict_lua:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_leshrac_diabolic_edict_lua:OnCreated( kv )
	if not IsServer() then return end
	-- references
	local explosion = self:GetAbility():GetSpecialValueFor( "num_explosions" )
	local duration = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	self.tower_bonus = self:GetAbility():GetSpecialValueFor( "tower_bonus" )/100 + 1
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi3")~=nil then
		if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi3"):GetLevel() > 0 then 
			self.damage = self:GetAbility():GetSpecialValueFor( "damage" ) + 22
		end
	end

	-- init data and precache
	local interval = duration/explosion
	self.parent = self:GetParent()
	self.damageTable = {
		-- victim = target,
		attacker = self:GetParent(),
		damage = self.damage,
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	-- ApplyDamage(damageTable)

	-- Start interval
	self:StartIntervalThink( interval )
	self:OnIntervalThink()

	-- play effects
	local sound_loop = "Hero_Leshrac.Diabolic_Edict_lp"
	EmitSoundOn( sound_loop, self.parent )
end

function modifier_leshrac_diabolic_edict_lua:OnRefresh( kv )
end

function modifier_leshrac_diabolic_edict_lua:OnRemoved()
end

function modifier_leshrac_diabolic_edict_lua:OnDestroy()
	if not IsServer() then return end
	local sound_loop = "Hero_Leshrac.Diabolic_Edict_lp"
	StopSoundOn( sound_loop, self.parent )
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_leshrac_diabolic_edict_lua:OnIntervalThink()
	if not self:GetCaster():IsAlive() then return end
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self.radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local count = 1
	if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi8") then
		count = 2
	end	
	local leshrac_pulse_nova_lua = self.parent:FindAbilityByName("leshrac_pulse_nova_lua")
	local npc_dota_hero_leshrac_agi13 = self.parent:FindAbilityByName("npc_dota_hero_leshrac_agi13")
	for i = 1, count do
		if enemies[i] then
			-- apply damage
			self.damageTable.victim = enemies[i]
			ApplyDamage( self.damageTable )
			self:PlayEffects( enemies[i] )
			if npc_dota_hero_leshrac_agi13 and leshrac_pulse_nova_lua and leshrac_pulse_nova_lua:GetLevel() > 0 then
				leshrac_pulse_nova_lua:Hit(enemies[i])
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_leshrac_diabolic_edict_lua:PlayEffects( unit )
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_leshrac/leshrac_diabolic_edict.vpcf"
	local sound_cast = "Hero_Leshrac.Diabolic_Edict"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.parent )

	if unit then
		ParticleManager:SetParticleControlEnt(
			effect_cast,
			1,
			unit,
			PATTACH_ABSORIGIN_FOLLOW,
			"attach_hitloc",
			Vector(0,0,0), -- unknown
			true -- unknown, true
		)
	else
		ParticleManager:SetParticleControl( effect_cast, 1, self.parent:GetOrigin() + RandomVector( RandomInt(0,self.radius) ) )
	end
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	if unit then
		EmitSoundOn( sound_cast, unit )
	end
end


modifier_leshrac_diabolic_edict_permanent_lua = modifier_leshrac_diabolic_edict_lua

function modifier_leshrac_diabolic_edict_permanent_lua:OnCreated( kv )
	if not IsServer() then return end
	-- init data and precache
	self.parent = self:GetParent()
	self.damageTable = {
		attacker = self:GetParent(),
		damage_type = self:GetAbility():GetAbilityDamageType(),
		ability = self:GetAbility(), --Optional.
	}
	self:OnIntervalThink()
	-- play effects
	local sound_loop = "Hero_Leshrac.Diabolic_Edict_lp"
	EmitSoundOn( sound_loop, self.parent )
end

function modifier_leshrac_diabolic_edict_permanent_lua:OnIntervalThink()
	-- find enemies
	local enemies = FindUnitsInRadius(
		self.parent:GetTeamNumber(),	-- int, your team number
		self.parent:GetOrigin(),	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		self:GetAbility():GetSpecialValueFor( "radius" ),	-- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY,	-- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,	-- int, type filter
		0,	-- int, flag filter
		0,	-- int, order filter
		false	-- bool, can grow cache
	)

	local count = 1
	if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi8") then
		count = 2
	end	
	local leshrac_pulse_nova_lua = self.parent:FindAbilityByName("leshrac_pulse_nova_lua")
	local npc_dota_hero_leshrac_agi13 = self.parent:FindAbilityByName("npc_dota_hero_leshrac_agi13")
	for i = 1, count do
		if enemies[i] then
			-- apply damage
			self.damageTable.victim = enemies[i]
			self.damageTable.damage = self:GetAbility():GetSpecialValueFor( "damage" )
			ApplyDamage( self.damageTable )
			self:PlayEffects( enemies[i] )
			if npc_dota_hero_leshrac_agi13 and leshrac_pulse_nova_lua and leshrac_pulse_nova_lua:GetLevel() > 0 then
				leshrac_pulse_nova_lua:Hit(enemies[i])
			end
		end
	end

	local explosion = self:GetAbility():GetSpecialValueFor( "num_explosions" )
	local duration = self:GetAbility():GetSpecialValueFor( "duration_tooltip" )
	self:StartIntervalThink( duration/explosion )
end
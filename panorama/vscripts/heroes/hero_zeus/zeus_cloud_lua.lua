LinkLuaModifier("modifier_zeus_cloud_lua", "heroes/hero_zeus/zeus_cloud_lua", LUA_MODIFIER_MOTION_NONE)

zeus_cloud_lua = zeus_cloud_lua or class({})

function zeus_cloud_lua:Spawn()
	if not IsServer() then return end
	self:SetLevel(1)
end

function zeus_cloud_lua:GetAOERadius()
	return self:GetSpecialValueFor("cloud_radius")
end

function zeus_cloud_lua:OnSpellStart()
	if not IsServer() then return end
	
	self.target_point 			= self:GetCursorPosition()
	local caster 				= self:GetCaster()
	local cloud_duration 		= self:GetSpecialValueFor("cloud_duration")

	EmitSoundOnLocationWithCaster(self.target_point, "Hero_Zuus.Cloud.Cast", caster)

	-- spawn the cloud
	self.zuus_nimbus_unit = CreateUnitByName("npc_dota_zeus_cloud", Vector(self.target_point.x, self.target_point.y, 450), false, caster, nil, caster:GetTeam())
	self.zuus_nimbus_unit:SetControllableByPlayer(caster:GetPlayerID(), true)
	self.zuus_nimbus_unit:SetOwner(caster)
	self.zuus_nimbus_unit:AddNewModifier(self.zuus_nimbus_unit, self, "modifier_phased", {})
	self.zuus_nimbus_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = cloud_duration})
	
	-- summons buff
	-- affects only spell damage as bonus per int
	-- hp and interval was decided as too imba
	self.zuus_nimbus_unit:AddAbility("summon_buff")		

	-- multicast
	-- affects damage, model scale and max hp
	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	local multicast = 1
	
	if multicast_modifier then
		multicast = multicast_modifier:GetMulticastFactor(self)
		multicast_modifier:PlayMulticastFX(multicast)
	end
	
	self.zuus_nimbus_unit:SetBaseMaxHealth(self.zuus_nimbus_unit:GetBaseMaxHealth() * multicast)
	self.zuus_nimbus_unit:SetHealth(self.zuus_nimbus_unit:GetBaseMaxHealth() * multicast)
	self.zuus_nimbus_unit:SetModelScale(1.0 + 0.25 * multicast)
	self.zuus_nimbus_unit:AddNewModifier(caster, self, "modifier_zeus_cloud_lua", {duration = cloud_duration, multicast = multicast})
end

modifier_zeus_cloud_lua = class({})
function modifier_zeus_cloud_lua:IsHidden() return true end

function modifier_zeus_cloud_lua:OnCreated(keys)
	if not IsServer() then return end

	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	self.cloud_radius = ability:GetSpecialValueFor("cloud_radius")
	self.true_sight_radius 	= ability:GetSpecialValueFor("true_sight_radius")
	self.sight_duration 		= ability:GetSpecialValueFor("sight_duration")
	self.stun_duration 		= ability:GetSpecialValueFor("stun_duration") + caster:FindTalentValue("special_bonus_unique_zeus_3") -- +0.4s stun duration
	self.nimbus_position = parent:GetAbsOrigin()
	self.cloud_bolt_interval 	= ability:GetSpecialValueFor("cloud_bolt_interval")
	self.z_pos = 450		-- nimbus offset from the ground
	self.damage = 125		-- default

	-- bolt damage
	local bolt_ability = caster:FindAbilityByName("zuus_lightning_bolt")
	if bolt_ability and bolt_ability:IsTrained() then
		-- affected by multicast and summon buff
		self.damage = bolt_ability:GetAbilityDamage() * keys.multicast
	end

	-- Create nimbus cloud particle
	self.zuus_nimbus_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zeus_cloud.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	-- Position of ground effect
	ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 0, Vector(self.nimbus_position.x, self.nimbus_position.y, self.z_pos))
	-- Radius of ground effect
	ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 1, Vector(self.cloud_radius, 0, 0))
	-- Position of cloud 
	ParticleManager:SetParticleControl(self.zuus_nimbus_particle, 2, Vector(self.nimbus_position.x, self.nimbus_position.y, self.nimbus_position.z + self.z_pos))	

	self.cloud_cast = false
	self:StartIntervalThink(FrameTime())
	
end

function modifier_zeus_cloud_lua:CastLightningBolt()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local parent = self:GetParent()
	local ability = self:GetAbility()

	if not caster or caster:IsNull() then return end
	if not parent or parent:IsNull() then return end
	if not ability or ability:IsNull() then return end

	-- Finds all heroes in the radius (the closest hero takes priority over the closest creep)
	local nearby_enemy_units = FindUnitsInRadius(
		caster:GetTeam(), 
		self.nimbus_position, 
		nil, 
		self.cloud_radius, 
		DOTA_UNIT_TARGET_TEAM_ENEMY, 
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NONE, 
		FIND_CLOSEST, 
		false
	)

	local target
	local closest = radius
	for i, unit in ipairs(nearby_enemy_units) do
		if not unit:IsMagicImmune() then 
			-- First unit is the closest
			target = unit
			break
		end
	end

	if not target or target:IsNull() then return end

	self.cloud_cast = true
	self.cloud_cast_time = GameRules:GetGameTime()
	local target_point = target:GetAbsOrigin()

	-- Renders the particle on the ground target
	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN, target)
	ParticleManager:SetParticleControl(particle, 0, target_point)
	ParticleManager:SetParticleControl(particle, 1, Vector(self.nimbus_position.x, self.nimbus_position.y, self.z_pos))
	ParticleManager:SetParticleControl(particle, 2, target_point)
	ParticleManager:ReleaseParticleIndex(particle)
	
	-- Target stuff
	target:EmitSound("Hero_Zuus.LightningBolt")
	target:AddNewModifier(caster, ability, "modifier_truesight", {duration = self.sight_duration})
	target:AddNewModifier(caster, ability, "modifier_stunned", {duration = self.stun_duration * (1 - target:GetStatusResistance())})

	-- Add dummy to provide us with truesight aura
	local dummy_unit = CreateUnitByName("npc_dummy_caster", Vector(target_point.x, target_point.y, 0), false, nil, nil, caster:GetTeam())
	dummy_unit:AddNewModifier(caster, ability, "modifier_zuus_lightningbolt_vision_thinker", {duration = self.sight_duration})
	dummy_unit:SetDayTimeVisionRange(self.true_sight_radius)
	dummy_unit:SetNightTimeVisionRange(self.true_sight_radius)

	dummy_unit:AddNewModifier(caster, ability, "modifier_hidden_caster_dummy", {})
	dummy_unit:AddNewModifier(caster, nil, "modifier_kill", {duration = self.sight_duration + 1})

	-- Damage
	local damage_table 			= {
		attacker 		= parent,		-- not caster so there is no blade mail reflect
		ability 		= ability,
		damage_type 	= ability:GetAbilityDamageType(),
		damage			= self.damage,
		victim 			= target,
	}
	ApplyDamage(damage_table)
		
end

function modifier_zeus_cloud_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end

function modifier_zeus_cloud_lua:CheckState()
	return {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true
	}
end

function modifier_zeus_cloud_lua:GetVisualZDelta()
	return 450
end

function modifier_zeus_cloud_lua:GetModifierAvoidDamage(params)
	local parent = self:GetParent()
	local health = parent:GetHealth()

	if params.damage_category == DOTA_DAMAGE_CATEGORY_SPELL then 
		return 1
	end

	local damage = 1
	if params.attacker:IsRealHero() then
		if not params.attacker:IsRangedAttacker() then
			damage = 4
		else
			damage = 2
		end
	end

	if health > damage then
		parent:SetHealth(health - damage)
	else
		parent:Kill(nil, params.attacker)
	end

	return 1
end

function modifier_zeus_cloud_lua:OnIntervalThink()
	if not self.cloud_cast then
		self:CastLightningBolt()
	else
		if GameRules:GetGameTime() >= self.cloud_cast_time + self.cloud_bolt_interval then
			self.cloud_cast = false
		end
	end
end

function modifier_zeus_cloud_lua:OnRemoved()
	if IsServer() then
		ParticleManager:DestroyParticle(self.zuus_nimbus_particle, false)
	end
end

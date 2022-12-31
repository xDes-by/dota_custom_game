modifier_void_spirit_aether_remnant_lua_thinker = class({})


function modifier_void_spirit_aether_remnant_lua_thinker:IsPurgable() return false end
function modifier_void_spirit_aether_remnant_lua_thinker:DestroyOnExpire() return true end

function modifier_void_spirit_aether_remnant_lua_thinker:IsAura() return self.truesight ~= nil end
function modifier_void_spirit_aether_remnant_lua_thinker:GetAuraRadius() return self.truesight end
function modifier_void_spirit_aether_remnant_lua_thinker:GetAuraSearchFlags() return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_void_spirit_aether_remnant_lua_thinker:GetAuraSearchTeam() return DOTA_UNIT_TARGET_TEAM_ENEMY end
function modifier_void_spirit_aether_remnant_lua_thinker:GetAuraSearchType() return DOTA_UNIT_TARGET_ALL end
function modifier_void_spirit_aether_remnant_lua_thinker:GetModifierAura() return "modifier_truesight" end

function modifier_void_spirit_aether_remnant_lua_thinker:OnCreated()
	if not IsServer() then return end

	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.caster = self.ability:GetCaster()

	self.radius = self.ability:GetSpecialValueFor("radius")
	self.activation_delay = self.ability:GetSpecialValueFor("activation_delay")
	self.impact_damage = self.ability:GetSpecialValueFor("impact_damage") + self.caster:FindTalentValue("special_bonus_unique_void_spirit_2")
	self.duration = self.ability:GetSpecialValueFor("duration")
	self.pull_duration = self.ability:GetSpecialValueFor("pull_duration")
	self.pull_destination = self.ability:GetSpecialValueFor("pull_destination")
	self.think_interval = self.ability:GetSpecialValueFor("think_interval")

	self.damage_table = {
		damage = self.impact_damage,
		attacker = self.caster,
		damage_type = self.ability:GetAbilityDamageType(),
		ability = self.ability,
	}

	self.origin = self.parent:GetAbsOrigin()
	self.direction = (self.origin - self.caster:GetAbsOrigin()):Normalized()
	self.known_enemies = {}

	self:SetDuration(self.duration, false)
	self:StartIntervalThink(self.think_interval)
	self:WatchEffect()

	local talent = self.caster:FindAbilityByName("special_bonus_unique_void_spirit_7")
	if talent and talent:IsTrained() then
		self.truesight = talent:GetSpecialValueFor("value")
	end
end


function modifier_void_spirit_aether_remnant_lua_thinker:OnIntervalThink()
	if not IsServer() then return end
	if not self.ability or self.ability:IsNull() then self:Destroy() end
	local enemies = FindUnitsInRadius(
		self.caster:GetTeamNumber(),
		self.origin,
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		0,
		0,
		false
	)
	if #enemies == 0 then return end

	local valid_target
	for _, enemy in pairs(enemies) do
		if enemy and not enemy:IsNull() and not self.known_enemies[enemy:GetEntityIndex()] then
			self.damage_table.victim = enemy
			ApplyDamage(self.damage_table)
			if enemy:IsAlive() then
				local modifier = enemy:AddNewModifier(
					self.caster, self.ability, "modifier_void_spirit_aether_remnant_lua_pull", {
						duration = self.pull_duration,
						pos_x = self.origin.x,
						pos_y = self.origin.y,
						pull = self.pull_destination,
					}
				)
				if modifier and not modifier:IsNull() then
					modifier.pull_source = self
					enemy:EmitSound("Hero_VoidSpirit.AetherRemnant.Target")
					self:TargetPullEffect(enemy)
					self.known_enemies[enemy:GetEntityIndex()] = 1
					valid_target = enemy
				end
			end
		end
	end

	if not valid_target or valid_target:IsNull() then return end
	self:PullEffect(valid_target)
end


function modifier_void_spirit_aether_remnant_lua_thinker:OnDestroy()
	if not IsServer() then return end

	ParticleManager:DestroyParticle( self.effect_cast, false )
	ParticleManager:ReleaseParticleIndex( self.effect_cast )

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_flash.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent )
	ParticleManager:SetParticleControl(effect_cast, 3, self.origin)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	self.parent:EmitSound("Hero_VoidSpirit.AetherRemnant.Destroy")
	self.parent:StopSound("Hero_VoidSpirit.AetherRemnant.Spawn_lp")

	if self.effect_aoe then
		ParticleManager:DestroyParticle( self.effect_aoe, false )
		ParticleManager:ReleaseParticleIndex( self.effect_aoe )
	end

	if self.current_primary_pull_target then
		self.current_primary_pull_target.void_spirit_pull_primary = nil
		self.current_primary_pull_target = nil
	end
end


function modifier_void_spirit_aether_remnant_lua_thinker:WatchEffect()
	local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_watch.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
	ParticleManager:SetParticleControl(effect_cast, 0, self.origin)
	ParticleManager:SetParticleControl(effect_cast, 1, self.origin + self.direction * 100)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		self:GetCaster(),
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0, 0, 0),
		true
	)
	ParticleManager:SetParticleControlForward(effect_cast, 0, self.direction)
	ParticleManager:SetParticleControlForward(effect_cast, 2, self.direction)
	self.effect_cast = effect_cast
	self.parent:EmitSound("Hero_VoidSpirit.AetherRemnant.Spawn_lp")

	if self.effect_aoe then
		ParticleManager:DestroyParticle(self.effect_aoe, false)
		ParticleManager:ReleaseParticleIndex(self.effect_aoe)
		self.effect_aoe = nil
	end

	local effect_aoe = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/dissimilate/void_spirit_dissimilate.vpcf", PATTACH_WORLDORIGIN, self.parent)
	ParticleManager:SetParticleControl(effect_aoe, 0, self.origin )
	ParticleManager:SetParticleControl(effect_aoe, 1, Vector(self.radius, 0, 1))
	ParticleManager:SetParticleControl(effect_aoe, 2, Vector(1, 0, 0))

	self.effect_aoe = effect_aoe
end


function modifier_void_spirit_aether_remnant_lua_thinker:PullEffect(target)
	if not target or target:IsNull() then return end

	if self.current_primary_pull_target then
		self.current_primary_pull_target.void_spirit_pull_primary = nil
		self.current_primary_pull_target = nil
	end

	ParticleManager:DestroyParticle(self.effect_cast, false)
	ParticleManager:ReleaseParticleIndex(self.effect_cast)

	local direction = self.origin - target:GetOrigin()
	direction.z = 0
	direction = direction:Normalized()

	local effect_cast = ParticleManager:CreateParticle( "particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pull.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl(effect_cast, 0, self.origin)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0, 0, 0), 
		true
	)
	ParticleManager:SetParticleControlForward(effect_cast, 2, direction)
	ParticleManager:SetParticleControl(effect_cast, 3, self.origin)

	target.void_spirit_pull_primary = effect_cast
	self.current_primary_pull_target = target

	self.effect_cast = effect_cast

	self.parent:EmitSound("Hero_VoidSpirit.AetherRemnant.Triggered")
end


function modifier_void_spirit_aether_remnant_lua_thinker:TargetPullEffect(target)
	if target.void_spirit_pull_effect then
		ParticleManager:DestroyParticle(target.void_spirit_pull_effect, false)
		ParticleManager:ReleaseParticleIndex(target.void_spirit_pull_effect)
	end

	local effect_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/aether_remnant/void_spirit_aether_remnant_pull_beam.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
	ParticleManager:SetParticleControl(effect_cast, 0, self.origin)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		1,
		self.parent,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0, 0, 0), 
		true
	)
	ParticleManager:SetParticleControlEnt(
		effect_cast,
		3,
		target,
		PATTACH_POINT_FOLLOW,
		"attach_hitloc",
		Vector(0, 0, 0), 
		true
	)
	target.void_spirit_pull_effect = effect_cast
end

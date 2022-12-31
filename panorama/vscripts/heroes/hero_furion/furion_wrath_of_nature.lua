LinkLuaModifier("modifier_furion_wrath_of_nature_thinker_lua", "heroes/hero_furion/furion_wrath_of_nature", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_wrath_of_nature_spawn", "heroes/hero_furion/furion_wrath_of_nature", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_furion_wrath_of_nature_damage", "heroes/hero_furion/furion_wrath_of_nature", LUA_MODIFIER_MOTION_NONE)

---@class furion_wrath_of_nature:CDOTA_Ability_Lua
furion_wrath_of_nature = class({})

function furion_wrath_of_nature:GetCooldown(level)
	if self:GetCaster():HasScepter() then 
		return self:GetSpecialValueFor("scepter_cooldown")
	end

	return self.BaseClass.GetCooldown(self, level)
end

function furion_wrath_of_nature:OnAbilityPhaseStart()
	local cast_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControlEnt(cast_particle, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(cast_particle)
	
	return true
end

function furion_wrath_of_nature:OnSpellStart()
	local caster = self:GetCaster()

	caster:EmitSound("Hero_Furion.WrathOfNature_Cast.Self")
	EmitSoundOnLocationWithCaster(self:GetCursorPosition(), "Hero_Furion.WrathOfNature_Cast", caster)

	self:SetRefCountsModifiers(true)
	
	-- Going to use a thinker to keep track of the bounced targets and general logic
	CreateModifierThinker(caster, self, "modifier_furion_wrath_of_nature_thinker_lua", {}, self:GetCursorPosition(), caster:GetTeamNumber(), false)
end



---@class modifier_furion_wrath_of_nature_thinker_lua:CDOTA_Modifier_Lua
modifier_furion_wrath_of_nature_thinker_lua	= class({})

function modifier_furion_wrath_of_nature_thinker_lua:NextTarget()
	local targets = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), self.position, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	
	for _, target in pairs(targets) do
		if not self.hit_enemies[target:entindex()] then
			return target
		end
	end
end

function modifier_furion_wrath_of_nature_thinker_lua:OnCreated()
	local ability = self:GetAbility()
	local caster = self:GetCaster()

	self.max_targets			= ability:GetSpecialValueFor("max_targets")
	self.damage					= ability:GetSpecialValueFor("damage") + caster:FindTalentValue("special_bonus_unique_furion_5")
	self.damage_percent_add		= ability:GetSpecialValueFor("damage_percent_add") * 0.01
	self.jump_delay				= ability:GetSpecialValueFor("jump_delay")
	self.kill_damage_duration	= ability:GetSpecialValueFor("kill_damage_duration")
	self.scepter_min_entangle_duration = ability:GetSpecialValueFor("scepter_min_entangle_duration")
	self.scepter_max_entangle_duration = ability:GetSpecialValueFor("scepter_max_entangle_duration")
	
	if not IsServer() then return end
	
	self.damage_type = ability:GetAbilityDamageType()
	self.hit_enemies = {}
	self.counter 	 = 0
	self.position	 = self:GetParent():GetAbsOrigin()
	self.target		 = self:GetParent()

	self.radius = ability:GetCastRange(self.position, nil)
	local cursor_target = ability:GetCursorTarget()

	if not cursor_target or cursor_target:TriggerSpellAbsorb(ability) then
		cursor_target = self:NextTarget()
	end
	
	if cursor_target then
		self:BounceTo(cursor_target)
	end
	
	self:StartIntervalThink(self.jump_delay)
end

function modifier_furion_wrath_of_nature_thinker_lua:OnIntervalThink()
	local ability = self:GetAbility()
	local caster = self:GetCaster()

	local target = self:NextTarget()

	if target then
		self:BounceTo(target)
	end
	
	-- No more valid targets
	if not target or self.counter >= self.max_targets then
		self:StartIntervalThink(-1)
		self:Destroy()
	end
end

function modifier_furion_wrath_of_nature_thinker_lua:BounceTo(enemy)
	local ability = self:GetAbility()
	local caster = self:GetCaster()

	self.counter = self.counter + 1
	self.hit_enemies[enemy:entindex()] = true

	local current_position = self.position
	local enemy_origin = enemy:GetAbsOrigin()
	
	self.position = enemy_origin

	local next_target = self:NextTarget()
	local next_origin = next_target and next_target:GetAbsOrigin() or enemy_origin

	local start_distance = math.min((current_position - enemy_origin):Length(), 200)
	local start_origin = enemy_origin + ( (current_position - enemy_origin):Normalized() * start_distance) + Vector(0,0,100)

	local end_distance = math.min((next_origin - enemy_origin):Length(), 200)
	local end_origin = enemy_origin + ( (next_origin - enemy_origin):Normalized() * end_distance) + Vector(0,0,100)
	
	self.wrath_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_furion/furion_wrath_of_nature.vpcf", PATTACH_CUSTOMORIGIN, enemy)
	ParticleManager:SetParticleControl(self.wrath_particle, 0, start_origin)
	ParticleManager:SetParticleControlEnt(self.wrath_particle, 1, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy_origin, true)
	ParticleManager:SetParticleControlEnt(self.wrath_particle, 2, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy_origin, true)
	ParticleManager:SetParticleControl(self.wrath_particle, 3, end_origin)
	ParticleManager:SetParticleControlEnt(self.wrath_particle, 4, enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", enemy_origin, true)
	ParticleManager:ReleaseParticleIndex(self.wrath_particle)
	
	if enemy:IsCreep() then
		enemy:EmitSound("Hero_Furion.WrathOfNature_Damage.Creep")
	else
		enemy:EmitSound("Hero_Furion.WrathOfNature_Damage")
	end
	
	if caster:HasScepter() then
		local duration = RemapValClamped(self.counter, 1, self.max_targets, self.scepter_min_entangle_duration, self.scepter_max_entangle_duration)
		enemy:AddNewModifier(caster, ability, "modifier_furion_sprout_entangle", {
			duration = duration * (1 - enemy:GetStatusResistance()),
		})
	end

	ApplyDamage({
		victim 			= enemy,
		damage 			= self.damage * ((1 + self.damage_percent_add) ^ self.counter),
		damage_type		= self.damage_type,
		damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
		attacker 		= caster,
		ability 		= ability
	})

	if not enemy:IsAlive() then
		local modifier = caster:AddNewModifier(caster, ability, "modifier_furion_wrath_of_nature_damage", { duration = self.kill_damage_duration })
		if modifier then
			modifier:AddIndependentStack(self.kill_damage_duration, nil, false)
		end
	end
end




modifier_furion_wrath_of_nature_damage		= class({})

function modifier_furion_wrath_of_nature_damage:OnCreated()
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("kill_damage")
end

function modifier_furion_wrath_of_nature_damage:DeclareFunctions()
	return {MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}
end

function modifier_furion_wrath_of_nature_damage:GetModifierPreAttack_BonusDamage()
	return self:GetStackCount() * self.damage_per_stack
end

warlock_upheaval_lua = class({})

LinkLuaModifier("modifier_warlock_upheaval_lua_thinker", "heroes/hero_warlock/warlock_upheaval_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_warlock_upheaval_lua_debuff", "heroes/hero_warlock/warlock_upheaval_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_warlock_upheaval_lua_buff", "heroes/hero_warlock/warlock_upheaval_lua", LUA_MODIFIER_MOTION_NONE)

function warlock_upheaval_lua:GetAOERadius()
	return self:GetSpecialValueFor("aoe")
end

function warlock_upheaval_lua:OnSpellStart()
	if not IsServer() then return end

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	CreateModifierThinker(
		caster,
		self,
		"modifier_warlock_upheaval_lua_thinker",
		{duration = duration},
		point,
		caster:GetTeamNumber(),
		false
	)
end



modifier_warlock_upheaval_lua_thinker = class({})

function modifier_warlock_upheaval_lua_thinker:OnCreated(keys)
	if not IsServer() then return end

	self.parent = self:GetParent()
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.team = self.caster:GetTeam()

	self.interval = self.ability:GetSpecialValueFor("think_interval")
	self.linger_duration = self.ability:GetSpecialValueFor("linger_duration")
	self.max_duration = self.ability:GetSpecialValueFor("duration")

	self.damage_tick = self.ability:GetSpecialValueFor("damage_tick_interval")
	self.damage_per_second = self.ability:GetSpecialValueFor("damage_per_second")
	self.max_damage = self.ability:GetSpecialValueFor("max_damage")

	self.acc = 0

	self.radius = self.ability:GetAOERadius()
	self.pos = self.parent:GetOrigin()

	self:StartIntervalThink(self.interval)
	self:PlayEffects()
end

function modifier_warlock_upheaval_lua_thinker:OnRemoved()
	local sound_cast = "Hero_Warlock.Upheaval"
	StopSoundOn(sound_cast, self.parent)
end

function modifier_warlock_upheaval_lua_thinker:OnIntervalThink()
	if not IsServer() then return end
	if not self or self:IsNull() then return end
	if not self.ability or self.ability:IsNull() then self:Destroy() return end

	self.acc = self.acc + self.interval

	if self.caster:HasTalent("special_bonus_unique_warlock_10") then
		self:_UpheavalTalentTick()
	else
		self:_UpheavalDefaultTick()
	end

	if self.acc >= self.damage_tick then
		self.acc = 0
	end
end


function modifier_warlock_upheaval_lua_thinker:__AddModifier(unit, modifier_name)
	local modifier = unit:AddNewModifier(self.caster, self.ability, modifier_name, {
		duration = self.linger_duration, 
	})

	if not modifier then return end

	local new_stacks = math.floor((self:GetElapsedTime() / self.linger_duration) * 100)
	if new_stacks > 100 then new_stacks = 100 end

	if new_stacks > modifier:GetStackCount() then
		modifier:SetStackCount(new_stacks)
	end

	if unit:GetTeam() ~= self.team and self.acc >= self.damage_tick then
		local damage = math.min(self:GetElapsedTime() * self.damage_per_second, self.max_damage)
		ApplyDamage({
			victim = unit,
			attacker = self.caster,
			ability = self.ability,
			damage = damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
		})
	end
end


function modifier_warlock_upheaval_lua_thinker:_UpheavalTalentTick()
	local units = FindUnitsInRadius(
		self.caster:GetTeam(),
		self.pos,	
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		0,
		false
	)
	for _, unit in pairs(units) do
		if unit and not unit:IsNull() then
			if unit:GetTeam() == self.team then
				self:__AddModifier(unit, "modifier_warlock_upheaval_lua_buff")
			else
				self:__AddModifier(unit, "modifier_warlock_upheaval_lua_debuff")
			end
		end
	end
end


function modifier_warlock_upheaval_lua_thinker:_UpheavalDefaultTick()
	local enemies = FindUnitsInRadius(
		self.caster:GetTeam(),
		self.pos,
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		0,
		false
	)
	for _, enemy in pairs(enemies) do
		if enemy and not enemy:IsNull() then
			self:__AddModifier(enemy, "modifier_warlock_upheaval_lua_debuff")
		end
	end
end


function modifier_warlock_upheaval_lua_thinker:PlayEffects()
	local particle_cast = "particles/units/heroes/hero_warlock/warlock_upheaval.vpcf"
	local sound_cast = "Hero_Warlock.Upheaval"

	local main_particle = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN, self.parent)
	ParticleManager:SetParticleControl(main_particle, 0, self.pos)
	ParticleManager:SetParticleControl(main_particle, 1, Vector(self.radius, 0, 0))

	self:AddParticle(main_particle, false, false, -1, false, false)

	EmitSoundOn(sound_cast, self.parent)
end



modifier_warlock_upheaval_lua_debuff = class({})

function modifier_warlock_upheaval_lua_debuff:IsHidden() return false end
function modifier_warlock_upheaval_lua_debuff:IsDebuff() return true end
function modifier_warlock_upheaval_lua_debuff:IsPurgable() return true end

function modifier_warlock_upheaval_lua_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
	return funcs
end

function modifier_warlock_upheaval_lua_debuff:OnCreated(keys)
	self.ability = self:GetAbility()
	if not self.ability or self.ability:IsNull() then return end

	self.max_move_slow = self.ability:GetSpecialValueFor("max_move_slow")
	self.max_attack_slow = self.ability:GetSpecialValueFor("max_attack_slow")
end


function modifier_warlock_upheaval_lua_debuff:OnStackCountChanged()
	local stacks = self:GetStackCount() / 100
	self.move_slow = -self.max_move_slow * stacks
	self.attack_slow = -self.max_attack_slow * stacks
end

function modifier_warlock_upheaval_lua_debuff:GetEffectName()
	if self:GetParent():IsHero() then
		return "particles/units/heroes/hero_warlock/warlock_upheaval_debuff.vpcf" 
	else
		return "particles/units/heroes/hero_warlock/warlock_upheaval_debuff_creep.vpcf"
	end
end

function modifier_warlock_upheaval_lua_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.move_slow
end

function modifier_warlock_upheaval_lua_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.attack_slow
end



modifier_warlock_upheaval_lua_buff = class({})

function modifier_warlock_upheaval_lua_buff:IsHidden() return false end
function modifier_warlock_upheaval_lua_buff:IsDebuff() return false end
function modifier_warlock_upheaval_lua_buff:IsPurgable() return true end

function modifier_warlock_upheaval_lua_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE,
	}
end

function modifier_warlock_upheaval_lua_buff:OnCreated(keys)
	self.ability = self:GetAbility()
	if not self.ability or self.ability:IsNull() then return end

	self.parent = self:GetParent()

	self.max_attack_speed = self.ability:GetSpecialValueFor("aspd_max")
end

function modifier_warlock_upheaval_lua_buff:GetEffectName()
	if self:GetParent():IsHero() then
		return "particles/units/heroes/hero_warlock/warlock_upheaval_debuff.vpcf" 
	else
		return "particles/units/heroes/hero_warlock/warlock_upheaval_debuff_creep.vpcf"
	end
end

function modifier_warlock_upheaval_lua_buff:GetModifierAttackSpeedPercentage()
	return self.max_attack_speed * (self:GetStackCount() / 100)
end

undying_decay_lua = class({})

LinkLuaModifier("modifier_undying_decay_lua_debuff", "heroes/hero_undying/undying_decay_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undying_decay_lua_debuff_counter", "heroes/hero_undying/undying_decay_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undying_decay_lua_buff", "heroes/hero_undying/undying_decay_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_undying_decay_lua_buff_counter", "heroes/hero_undying/undying_decay_lua", LUA_MODIFIER_MOTION_NONE)

function undying_decay_lua:GetAOERadius()
	local total_radius = self:GetSpecialValueFor("radius")
	return total_radius
end

function undying_decay_lua:GetCooldown(level)
	return self.BaseClass.GetCooldown(self, level) - self:GetCaster():FindTalentValue("special_bonus_unique_undying_2")
end

function undying_decay_lua:OnSpellStart()
	if IsClient() then return end

	local caster = self:GetCaster()
	local caster_loc = caster:GetAbsOrigin()
	local target_loc = self:GetCursorPosition()
	local has_scepter = caster:HasScepter()

	local decay_damage = self:GetSpecialValueFor("decay_damage") + caster:GetTalentValue("special_bonus_unique_undying_8")
	local radius = self:GetSpecialValueFor("radius")
	local str_steal_hero = (has_scepter and self:GetSpecialValueFor("str_steal_hero_scepter")) or self:GetSpecialValueFor("str_steal_hero")
	local str_steal_creep = (has_scepter and self:GetSpecialValueFor("str_steal_creep_scepter")) or self:GetSpecialValueFor("str_steal_creep")
	local decay_duration = self:GetSpecialValueFor("decay_duration")
	local creep_damage = 0.01 * self:GetSpecialValueFor("creep_damage_mult") * decay_damage

	-- Decay duration talent
	local duration_talent = caster:FindAbilityByName("special_bonus_unique_undying_4")
	if duration_talent then decay_duration = decay_duration + duration_talent:GetSpecialValueFor("value") end

	-- Cast effects
	caster:EmitSound("Hero_Undying.Decay.Cast")
	EmitSoundOnLocationWithCaster(target_loc, "Hero_Undying.Decay.Target", caster)

	local particle_cast = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_undying/undying_decay.vpcf", caster)
	local particle_enemy = ParticleManager:GetParticleReplacement("particles/units/heroes/hero_undying/undying_decay_strength_xfer.vpcf", caster)

	local cast_pfx = ParticleManager:CreateParticle(particle_cast, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(cast_pfx, 0, target_loc)
	ParticleManager:SetParticleControl(cast_pfx, 1, Vector(radius, radius, radius))
	ParticleManager:SetParticleControl(cast_pfx, 2, caster_loc)
	ParticleManager:ReleaseParticleIndex(cast_pfx)

	local targets = FindUnitsInRadius(caster:GetTeam(), target_loc, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, enemy in pairs(targets) do

		-- Target effects
		local enemy_loc = enemy:GetAbsOrigin()
		enemy:EmitSound("Hero_Undying.Decay.Transfer")

		local drain_pfx = ParticleManager:CreateParticle(particle_enemy, PATTACH_ABSORIGIN, enemy)
		ParticleManager:SetParticleControl(drain_pfx, 0, enemy_loc)
		ParticleManager:SetParticleControl(drain_pfx, 1, caster_loc)
		ParticleManager:SetParticleControl(drain_pfx, 2, enemy_loc)
		ParticleManager:ReleaseParticleIndex(drain_pfx)

		-- Strength steal
		if not enemy:IsIllusion() then
			if enemy:IsRealHero() then
				enemy:AddNewModifier(caster, self, "modifier_undying_decay_lua_debuff", {duration = decay_duration, str = str_steal_hero})
				caster:AddNewModifier(caster, self, "modifier_undying_decay_lua_buff", {duration = decay_duration, str = str_steal_hero})
			else
				caster:AddNewModifier(caster, self, "modifier_undying_decay_lua_buff", {duration = decay_duration, str = str_steal_creep})
			end
		end

		-- Damage
		if enemy:IsHero() then
			ApplyDamage({victim = enemy, attacker = caster, damage = decay_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
		else
			ApplyDamage({victim = enemy, attacker = caster, damage = creep_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
		end
	end
end



modifier_undying_decay_lua_debuff = class({})

function modifier_undying_decay_lua_debuff:IsHidden() return true end
function modifier_undying_decay_lua_debuff:IsDebuff() return true end
function modifier_undying_decay_lua_debuff:IsPurgable() return false end
function modifier_undying_decay_lua_debuff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_undying_decay_lua_debuff:OnCreated(keys)
	if IsClient() then return end

	self.str = (keys.str or 0)

	local current_health = self:GetParent():GetHealth()
	local counter_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_undying_decay_lua_debuff_counter", {duration = keys.duration})

	if counter_modifier then
		counter_modifier:SetStackCount(counter_modifier:GetStackCount() + self.str)
		self:GetParent():SetHealth(math.max(1, current_health - 20 * self.str))
	end
end

function modifier_undying_decay_lua_debuff:OnDestroy()
	if IsClient() then return end

	local counter_modifier = self:GetParent():FindModifierByName("modifier_undying_decay_lua_debuff_counter")
	if counter_modifier then
		counter_modifier:SetStackCount(counter_modifier:GetStackCount() - self.str)
	end
end



modifier_undying_decay_lua_debuff_counter = class({})

function modifier_undying_decay_lua_debuff_counter:IsHidden() return false end
function modifier_undying_decay_lua_debuff_counter:IsDebuff() return true end
function modifier_undying_decay_lua_debuff_counter:IsPurgable() return false end

function modifier_undying_decay_lua_debuff_counter:OnStackCountChanged()
	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_undying_decay_lua_debuff_counter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS
	}
end

function modifier_undying_decay_lua_debuff_counter:GetModifierBonusStats_Strength()
	return (-1) * self:GetStackCount()
end



modifier_undying_decay_lua_buff = class({})

function modifier_undying_decay_lua_buff:IsHidden() return true end
function modifier_undying_decay_lua_buff:IsDebuff() return false end
function modifier_undying_decay_lua_buff:IsPurgable() return false end
function modifier_undying_decay_lua_buff:GetAttributes() return MODIFIER_ATTRIBUTE_MULTIPLE end

function modifier_undying_decay_lua_buff:OnCreated(keys)
	if IsClient() then return end

	self.str = (keys.str or 0)

	local current_health = self:GetParent():GetHealth()
	local counter_modifier = self:GetParent():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_undying_decay_lua_buff_counter", {duration = keys.duration})

	if counter_modifier then
		counter_modifier:SetStackCount(counter_modifier:GetStackCount() + self.str)
		self:GetParent():SetHealth(math.max(1, current_health + 20 * self.str))
	end
end

function modifier_undying_decay_lua_buff:OnDestroy()
	if IsClient() then return end

	local counter_modifier = self:GetParent():FindModifierByName("modifier_undying_decay_lua_buff_counter")
	if counter_modifier then
		counter_modifier:SetStackCount(counter_modifier:GetStackCount() - self.str)
	end
end



modifier_undying_decay_lua_buff_counter = class({})

function modifier_undying_decay_lua_buff_counter:IsHidden() return false end
function modifier_undying_decay_lua_buff_counter:IsDebuff() return false end
function modifier_undying_decay_lua_buff_counter:IsPurgable() return false end

function modifier_undying_decay_lua_buff_counter:OnCreated(keys)
	local ability = self:GetAbility()
	if ability then
		self.str_scale_up = ability:GetSpecialValueFor("str_scale_up") or 0
	end
end

function modifier_undying_decay_lua_buff_counter:OnStackCountChanged()
	if IsServer() then self:GetParent():CalculateStatBonus(false) end
end

function modifier_undying_decay_lua_buff_counter:GetEffectName()
	return "particles/units/heroes/hero_undying/undying_decay_strength_buff.vpcf"
end

function modifier_undying_decay_lua_buff_counter:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_undying_decay_lua_buff_counter:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_MODEL_SCALE
	}
end

function modifier_undying_decay_lua_buff_counter:GetModifierBonusStats_Strength()
	return self:GetStackCount()
end

function modifier_undying_decay_lua_buff_counter:GetModifierModelScale()
	return min(50, self:GetStackCount() * self.str_scale_up)
end

---@class warlock_rain_of_chaos_lua:CDOTA_Ability_Lua
warlock_rain_of_chaos_lua = class({})

function warlock_rain_of_chaos_lua:GetAOERadius()
	return self:GetSpecialValueFor("aoe")
end

function warlock_rain_of_chaos_lua:OnAbilityPhaseStart()
	-- Ability properties
	local caster = self:GetCaster()
	local sound_precast = "Hero_Warlock.RainOfChaos_buildup"

	-- Play precast sound
	EmitSoundOn(sound_precast, caster)

	return true
end

function warlock_rain_of_chaos_lua:OnAbilityPhaseInterrupted()
	-- Ability properties
	local caster = self:GetCaster()
	local sound_precast = "Hero_Warlock.RainOfChaos_buildup"

	-- Stop precast sound
	StopSoundOn(sound_precast, caster)
end

function warlock_rain_of_chaos_lua:OnOwnerDied()
	if self:IsTrained() and self:GetCaster():HasTalent("special_bonus_unique_warlock_4") then
		self:SummonGolem(self:GetCaster():GetAbsOrigin(), 1, true)
	end
end

function warlock_rain_of_chaos_lua:OnSpellStart()
	local cursor_position = self:GetCursorPosition()
	local caster = self:GetCaster()

	local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
	local multicast = 1

	if multicast_modifier then
		multicast = multicast_modifier:GetMulticastFactor(self)
		multicast_modifier:PlayMulticastFX(multicast)
	end

	self:SummonGolem(cursor_position, multicast, false)

	if caster:HasScepter() then
		Timers:CreateTimer(0.4, function()
			self:SummonGolem(cursor_position, multicast, false)
		end)
	end
end

function warlock_rain_of_chaos_lua:GetSpecialValueForScepter(value_name)
	if self:GetCaster():HasScepter() then
		local value = self:GetSpecialValueFor(value_name .. "_scepter")

		if value ~= 0 then
			return value	
		end
	end

	return self:GetSpecialValueFor(value_name)
end

function warlock_rain_of_chaos_lua:SummonGolem(target_point, multicast_factor, is_death)
	local caster = self:GetCaster()

	local particle_start_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN, caster)
	ParticleManager:SetParticleControl(particle_start_fx, 0, target_point)
	ParticleManager:ReleaseParticleIndex(particle_start_fx)

	local effect_delay = 0.5
	
	if is_death then
		effect_delay = 0
	end

	local radius = self:GetSpecialValueFor("aoe")
	local level = self:GetLevel()

	Timers:CreateTimer(effect_delay, function()
		GridNav:DestroyTreesAroundPoint(target_point, radius, false)

		local particle_main_fx = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos.vpcf", PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_main_fx, 0, target_point)
		ParticleManager:SetParticleControl(particle_main_fx, 1, Vector(radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_main_fx)

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			target_point,
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
			FIND_ANY_ORDER,
			false)

		local stun_duration = self:GetSpecialValueFor("stun_duration")

		for _,enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, self, "modifier_stunned", {duration = enemy:ApplyStatusResistance(stun_duration)})
		end

		local unit_name = "npc_dota_warlock_golem"

		local health = self:GetSpecialValueForScepter("golem_hp")
		local damage = self:GetSpecialValueForScepter("golem_dmg")
		local bounty = self:GetSpecialValueForScepter("golem_gold_bounty")
		local armor = self:GetSpecialValueForScepter("golem_armor")
		local move_speed = self:GetSpecialValueForScepter("golem_movement_speed")
		local health_regen = self:GetSpecialValueForScepter("golem_health_regen")

		local damage_min = damage - 10
		local damage_max = damage + 10

		local unit = CreateUnitByName(unit_name, target_point, true, caster, caster, caster:GetTeam())
		unit:AddNewModifier(caster, self, "modifier_kill", {duration = self:GetSpecialValueFor("golem_duration")})
		unit:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)

		unit:SetBaseMaxHealth(health * multicast_factor)
		unit:SetBaseHealthRegen(health_regen)

		unit:SetBaseDamageMin(damage_min * multicast_factor)
		unit:SetBaseDamageMax(damage_max * multicast_factor)
		
		unit:SetPhysicalArmorBaseValue(armor)

		unit:SetBaseMoveSpeed(move_speed)

		unit:SetMinimumGoldBounty(bounty)
		unit:SetMaximumGoldBounty(bounty)

		unit:AddAbility("summon_buff")

		unit:AddNewModifier(caster, self, "modifier_warlock_rain_of_chaos_golem", nil)

		unit:FindAbilityByName("warlock_golem_flaming_fists"):SetLevel(level)
		unit:FindAbilityByName("warlock_golem_permanent_immolation"):SetLevel(level)

		local multicast_modifier = caster:FindModifierByName("modifier_multicast_lua")
		if multicast_factor > 1 and multicast_modifier then
			multicast_modifier:PlaySummonFX(unit, multicast_factor)
		end

		ResolveNPCPositions(unit:GetAbsOrigin(), 64)

	end)

end

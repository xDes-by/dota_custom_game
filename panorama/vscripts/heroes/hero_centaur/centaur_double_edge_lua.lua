centaur_double_edge_lua = class({})

LinkLuaModifier("modifier_centaur_double_edge_buff_lua", "heroes/hero_centaur/modifier_centaur_double_edge_buff_lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------
-- Ability Start
function centaur_double_edge_lua:OnSpellStart()
	-- Unit identifier
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	-- Cancel if linken
	if target:TriggerSpellAbsorb(self) then
		return
	end

	-- load data
	local radius = self:GetSpecialValueFor("radius")
	local max_stack_count = self:GetSpecialValueFor("shard_max_stacks")
	local str_multiplier = 0.01 * self:GetSpecialValueFor("strength_damage")

	-- Find Units in Radius
	local enemies = FindUnitsInRadius(
		caster:GetTeam(), -- int, your team number
		target:GetOrigin(), -- point, center point
		nil, -- handle, cacheUnit. (not known)
		radius, -- float, radius. or use FIND_UNITS_EVERYWHERE
		DOTA_UNIT_TARGET_TEAM_ENEMY, -- int, team filter
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, -- int, type filter
		DOTA_UNIT_TARGET_FLAG_NONE, -- int, flag filter
		0, -- int, order filter
		false    -- bool, can grow cache
	)

	-- Shard
	if caster and caster:HasShard() then

		-- Percentage Strength Bonus
		local previous_modifier = caster:FindModifierByName("modifier_centaur_double_edge_buff_lua")
		local previous_stacks
		if previous_modifier then
			previous_stacks = previous_modifier:GetStackCount()
		end

		caster:RemoveModifierByName("modifier_centaur_double_edge_buff_lua")
		local modifier_shard = caster:AddNewModifier(caster, self, "modifier_centaur_double_edge_buff_lua", {duration = self:GetSpecialValueFor("shard_str_duration")})
		
		if previous_stacks ~= nil then	-- Add previous stacks before any unit calculations
			modifier_shard:SetStackCount(previous_stacks)
		end

		-- Apply slow
		local shard_slow_duration = self:GetSpecialValueFor("shard_movement_slow_duration")
		for _, enemy in pairs(enemies) do
			enemy:AddNewModifier(caster, self, "modifier_centaur_doubleedge_slow", {duration = shard_slow_duration})

			if modifier_shard then
				if enemy:IsHero() then
					modifier_shard:SetStackCount(math.min(max_stack_count, modifier_shard:GetStackCount() + 3))
				else
					modifier_shard:SetStackCount(math.min(max_stack_count, modifier_shard:GetStackCount() + 1))
				end
			end
		end
	end

	-- Damage is calculated after the shard strength bonus is applied
	local damage = self:GetSpecialValueFor("edge_damage") + caster:GetStrength() * str_multiplier

	-- Precache damage
	local damageTable = {
		-- victim = target,
		attacker = caster,
		damage = damage,
		damage_type = self:GetAbilityDamageType(),
		ability = self, --Optional.
	}

	-- Apply aoe damage
	for _, enemy in pairs(enemies) do
		damageTable.victim = enemy
		ApplyDamage(damageTable)
	end

	-- Apply self-damage
	damageTable.victim = caster
	damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
	ApplyDamage(damageTable)

	-- Play effects
	self:PlayEffects(target)
end

function centaur_double_edge_lua:PlayEffects(target)
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_centaur/centaur_double_edge.vpcf"
	local sound_cast = "Hero_Centaur.DoubleEdge"

	-- Get Data
	local forward = (target:GetOrigin() - self:GetCaster():GetOrigin()):Normalized()

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle(particle_cast, PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControlEnt(
			effect_cast,
			0,
			self:GetCaster(),
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			self:GetCaster():GetOrigin(), -- unknown
			true -- unknown, true
	)
	ParticleManager:SetParticleControlEnt(
			effect_cast,
			1,
			target,
			PATTACH_POINT_FOLLOW,
			"attach_hitloc",
			target:GetOrigin(), -- unknown
			true -- unknown, true
	)
	ParticleManager:SetParticleControlForward(effect_cast, 2, forward)
	ParticleManager:SetParticleControlForward(effect_cast, 5, forward)
	ParticleManager:ReleaseParticleIndex(effect_cast)

	-- Create Sound
	EmitSoundOn(sound_cast, target)
end

local special_damage_effects = {
	alchemist_unstable_concoction_throw = function(attacker, target, ability, modified_damage)
		if not attacker or attacker:IsNull() then return end
		if not ability or ability:IsNull() then return end
		if not target or target:IsNull() then return end

		local radius = ability:GetSpecialValueFor("midair_explosion_radius")
		local min_duration = ability:GetSpecialValueFor("min_stun")
		local max_duration = ability:GetSpecialValueFor("max_stun")
		local max_damage = ability:GetSpecialValueFor("max_damage") + attacker:GetTalentValue("special_bonus_unique_alchemist_2")

		-- Calculate brew potency
		local target_armor = target:GetPhysicalArmorValue(false)
		local damage_before_amp = modified_damage / (1 + attacker:GetSpellAmplification(false))
		local damage_before_armor = damage_before_amp * (1 + 0.06 * math.abs(target_armor)) / (1 + 0.06 * (math.abs(target_armor) - target_armor))
		local brew_potency = damage_before_armor / max_damage
		local actual_duration = min_duration + brew_potency * (max_duration - min_duration)

		local enemies = FindUnitsInRadius(attacker:GetTeam(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			if enemy ~= target then
				ApplyDamage({attacker = attacker, victim = enemy, damage = damage_before_armor, damage_type = DAMAGE_TYPE_PHYSICAL})
				enemy:AddNewModifier(attacker, ability, "modifier_stunned", {duration = actual_duration})
			end
		end
	end,

	ancient_apparition_ice_blast = function(attacker, target, ability, actual_damage)
		if not attacker or attacker:IsNull() then return end
		if not ability or ability:IsNull() then return end
		if not target or target:IsNull() then return end

		local duration = ability:GetSpecialValueFor("frostbite_duration")
		local expected_dot_damage = (ability:GetSpecialValueFor("dot_damage") + 10) * (1 + attacker:GetSpellAmplification(false))

		-- Ability must also affect creeps.
		-- Tick damage also triggers this, using additional conditional to make it not repeat itself
		if target:IsCreep() and actual_damage > expected_dot_damage then
			target:AddNewModifier(attacker, ability, "modifier_ice_blast", {duration = duration})
		end
	end,
}

function Filters:DamageFilter(keys)
	local attacker 	= false
	local victim 	= false
	local inflictor = false

	if keys.entindex_attacker_const then
		attacker = EntIndexToHScript(keys.entindex_attacker_const)
	end

	if keys.entindex_victim_const then
		victim = EntIndexToHScript(keys.entindex_victim_const)
	end

	if keys.entindex_inflictor_const then
		inflictor = EntIndexToHScript(keys.entindex_inflictor_const)
	end

	if keys.damagetype_const == DAMAGE_TYPE_NONE then return true end

	if not attacker or attacker:IsNull() then return false end
	if not victim or victim:IsNull() then return false end

	-- Percentage-based ability exceptions
	if inflictor and inflictor.GetAbilityName then
		local ability_name = inflictor:GetAbilityName()

		-- Spellcraft mastery
		if attacker.spellcraft_multiplier and attacker ~= victim then
			keys.damage = keys.damage * attacker.spellcraft_multiplier
		end

		-- Special on-damage effects
		if special_damage_effects[ability_name] then
			special_damage_effects[ability_name](attacker, victim, inflictor, keys.damage)
		end
	end
	
	if victim:HasModifier("modifier_hero_refreshing") then return false end

	-- Prevents player-based damage except against units in the same arena
	if attacker.IsControllableByAnyPlayer and attacker:IsControllableByAnyPlayer() then

		-- All-damage crit abilities
		if attacker:GetTeam() ~= victim:GetTeam() then
			local damage_multiplier = 1.0
			
			if attacker:HasModifier("modifier_innate_assassin") then
				local ability = attacker:FindAbilityByName("innate_assassin")
				if ability and not ability:IsNull() and RollPercentage(ability:GetSpecialValueFor("crit_chance")) then
					damage_multiplier = damage_multiplier * ability:GetSpecialValueFor("crit_dmg") * 0.01
				end
			end

			if attacker:HasModifier("modifier_chc_mastery_luck_1") then
				local crit_modifier = attacker:FindModifierByName("modifier_chc_mastery_luck_1")
				if crit_modifier and crit_modifier.crit_chance and crit_modifier.crit_damage and RollPercentage(crit_modifier.crit_chance) then
					damage_multiplier = damage_multiplier * crit_modifier.crit_damage
				end
			end

			if attacker:HasModifier("modifier_chc_mastery_luck_2") then
				local crit_modifier = attacker:FindModifierByName("modifier_chc_mastery_luck_2")
				if crit_modifier and crit_modifier.crit_chance and crit_modifier.crit_damage and RollPercentage(crit_modifier.crit_chance) then
					damage_multiplier = damage_multiplier * crit_modifier.crit_damage
				end
			end

			if attacker:HasModifier("modifier_chc_mastery_luck_3") then
				local crit_modifier = attacker:FindModifierByName("modifier_chc_mastery_luck_3")
				if crit_modifier and crit_modifier.crit_chance and crit_modifier.crit_damage and RollPercentage(crit_modifier.crit_chance) then
					damage_multiplier = damage_multiplier * crit_modifier.crit_damage
				end
			end

			if damage_multiplier > 1 then
				keys.damage = keys.damage * damage_multiplier
				SendOverheadEventMessage(nil, OVERHEAD_ALERT_CRITICAL, victim, keys.damage, nil)
			end
		end
		DPS_Counter:RegisterDamageInstance(attacker, keys.damage, keys.damagetype_const, inflictor)
	end

	-- Nyx Assassin's Carapace vs Neutrals
	if victim:HasModifier("modifier_nyx_assassin_spiked_carapace") and attacker:GetTeamNumber() == DOTA_TEAM_NEUTRALS then
		local carapace_ability = victim:FindAbilityByName("nyx_assassin_spiked_carapace")
		local carapace_modifier = victim:FindModifierByName("modifier_nyx_assassin_spiked_carapace")
		carapace_modifier.units_hit = carapace_modifier.units_hit or {}

		-- If the unit wasn't hit by carapace yet
		if carapace_ability and not carapace_modifier.units_hit[attacker:entindex()] then
			carapace_modifier.units_hit[attacker:entindex()] = true

			local carapace_debuff = attacker:AddNewModifier(victim, carapace_ability, "modifier_stunned", {duration = carapace_ability:GetSpecialValueFor("stun_duration") + victim:GetTalentValue("special_bonus_unique_nyx_6")})

			if carapace_debuff then
				attacker:EmitSound("Hero_NyxAssassin.SpikedCarapace.Stun")

				local carapace_debuff_particles = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_spiked_carapace.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, attacker)
				ParticleManager:SetParticleControl(carapace_debuff_particles, 0, attacker:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(carapace_debuff_particles, 1, attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", attacker:GetAbsOrigin(), true)
				ParticleManager:SetParticleControl(carapace_debuff_particles, 2, Vector(1,0,0))
				carapace_debuff:AddParticle(carapace_debuff_particles, false, false, 0, false, false)

				ApplyDamage({
					victim = attacker,
					attacker = victim,
					damage = keys.damage,
					damage_type = keys.damagetype_const,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
					ability = carapace_ability,
				})
				return false
			end
		end
	end

	-- Damage stagger mastery
	if victim.stagger_amount and victim.stagger_duration and attacker ~= victim then
		victim:AddNewModifier(victim, nil, "modifier_chc_mastery_numb_stack", {damage = keys.damage * victim.stagger_amount, duration = victim.stagger_duration})

		keys.damage = keys.damage * (1 - victim.stagger_amount)
	end
	
	-- force kill anyone who touches bots and prevent damage taken, if it's neutral
	if GAME_OPTION_IMMORTAL_BOTS and victim.GetPlayerID and PlayerResource:IsFakeClient(victim:GetPlayerID()) and attacker:GetTeam() == DOTA_TEAM_NEUTRALS then
		attacker:ForceKill(false)
		return false
	end

	return true
end

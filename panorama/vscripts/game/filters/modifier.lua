local ignoreModifiers = require('game/5v5/enfos_globalmodifiers')

local special_modifier_effects = {
	modifier_lion_finger_of_death = function(parent)
		local parent_modifier = parent:FindModifierByName("modifier_lion_finger_of_death")
		if parent_modifier and (not parent:IsRealHero()) then 
			local caster = parent_modifier:GetCaster()
			local ability = parent_modifier:GetAbility()

			if caster and ability then
				parent:AddNewModifier(caster, ability, "modifier_lion_finger_of_death_creep_delay", {duration = ability:GetSpecialValueFor("grace_period")})
			end
		end

		return true
	end,

	modifier_filler_heal = function(parent)
		if parent:HasModifier("modifier_hero_fighting_pve") then
			parent:AddNewModifier(parent, nil, "modifier_enfos_shrine_cdr", {duration = 10})
		end
		if parent:HasModifier("modifier_hero_dueling") then
			return false
		end

		return true
	end,

	modifier_abyssal_underlord_atrophy_aura_effect = function(parent)
		local parent_modifier = parent:FindModifierByName("modifier_abyssal_underlord_atrophy_aura_effect")
		if parent_modifier then 
			local caster = parent_modifier:GetCaster()
			local ability = parent_modifier:GetAbility()

			if caster and ability then
				parent:AddNewModifier(caster, ability, "modifier_abyssal_underlord_atrophy_aura_effect_perma", {})
			end
		end

		return true
	end,

	modifier_pangolier_shield_crash_jump = function(parent)
		local parent_modifier = parent:FindModifierByName("modifier_pangolier_shield_crash_jump")
		if parent_modifier then 
			local caster = parent_modifier:GetCaster()
			local ability = parent_modifier:GetAbility()

			if caster and ability then
				parent:AddNewModifier(caster, ability, "modifier_pangolier_shield_crash_creep_check", {})
			end
		end

		return true
	end,

	modifier_abyssal_underlord_pit_of_malice_ensare = function(parent)
		local parent_modifier = parent:FindModifierByName("modifier_abyssal_underlord_pit_of_malice_ensare")
		if parent_modifier then 
			local caster = parent_modifier:GetCaster()
			local ability = parent_modifier:GetAbility()
			local debuff_duration = parent_modifier:GetDuration()

			if caster and ability then
				parent:AddNewModifier(caster, ability, "modifier_disarmed", {duration = debuff_duration})
			end
		end

		return true
	end,

	--[[
	modifier_rattletrap_battery_assault = function(parent)
		local parent_modifier = parent:FindModifierByName("modifier_rattletrap_battery_assault")
		if parent_modifier then 
			local caster = parent_modifier:GetCaster()
			local ability = parent_modifier:GetAbility()
			local duration = ability:GetSpecialValueFor("duration")

			if caster and ability then
				parent_modifier:Destroy()
				parent:AddNewModifier(caster, ability, "modifier_rattletrap_battery_assault_lua", {duration = duration})
			end
		end

		return true
	end
	]]

	modifier_faceless_void_time_walk = function(parent)
		local parent_modifier = parent:FindModifierByName("modifier_faceless_void_time_walk")
		if parent_modifier then 
			local caster = parent_modifier:GetCaster()
			local ability = parent_modifier:GetAbility()

			if caster and ability and caster:HasScepter() then
				caster:AddNewModifier(caster, ability, "modifier_faceless_void_time_walk_bash_check", {})
			end
		end

		return true
	end,

	modifier_legion_commander_duel = function(parent)
		local parent_modifier = parent:FindModifierByName("modifier_legion_commander_duel")
		if parent_modifier and not parent:IsHero() then -- Tracker modifier should only apply on dueled creeps
			local caster = parent_modifier:GetCaster()
			local ability = parent_modifier:GetAbility()
			local debuff_duration = parent_modifier:GetDuration()

			if caster and ability then
				parent:AddNewModifier(caster, ability, "modifier_legion_commander_duel_creep", {duration = debuff_duration})
			end
		end

		return true
	end,

	--Fix for Fiend's Grip Aghanim's Scepter
	modifier_bane_fiends_grip_illusion = function(parent)
		local illusion_mod = parent:FindModifierByName("modifier_illusion")
		if not illusion_mod then return end

		local original_hero = illusion_mod:GetCaster()
		if not original_hero then return end
		
		local ability = original_hero:FindAbilityByName("bane_fiends_grip")
		if not ability or ability:IsNull() then 
			if IsValidEntity(parent) then
				parent:RemoveSelf()
			end
			return
		end
		
		local target = ability:GetCursorTarget()
		if target then
			local level = ability:GetLevel()
			local illusion_ability = parent:FindAbilityByName("bane_fiends_grip") or parent:AddAbility("bane_fiends_grip")
			illusion_ability:SetLevel(level)
		end

		--Remove illusion 
		Timers:CreateTimer(21, function() 
			if IsValidEntity(parent) then
				parent:RemoveSelf()
			end
		end)
		return true
	end,

	modifier_shadow_demon_disruption = function(parent, caster, ability, duration)
		if not parent:IsHero() then
			parent:AddNewModifier(caster, ability, "modifier_shadow_demon_disruption_creep", { duration = duration })
		end

		return true

	end,

	modifier_slark_shadow_dance = function(parent)			-- without this shadow dance does not apply hp regen and movement speed bonus
		local parent_modifier = parent:FindModifierByName("modifier_slark_shadow_dance")
		if parent_modifier then 
			local caster = parent_modifier:GetCaster()
			local ability = parent_modifier:GetAbility()
			local duration = ability:GetSpecialValueFor("duration")

			if caster and ability then
				parent:AddNewModifier(caster, ability, "modifier_slark_depth_shroud", {duration = duration})
			end
		end

		return true
	end,
}

function Filters:ModifierFilter(keys)

	local caster
	local parent
	local ability

	local modifier_name = keys.name_const

	if modifier_name and modifier_name == "modifier_illusion" then return true end
	if modifier_name and modifier_name == "modifier_truesight" then return true end
	if modifier_name and modifier_name == "modifier_fountain_invulnerability" then return false end -- volvo things kekw
	
	if keys.entindex_caster_const then
		caster = EntIndexToHScript(keys.entindex_caster_const)
	end
	
	if keys.entindex_parent_const then
		parent = EntIndexToHScript(keys.entindex_parent_const)
	end

	if keys.entindex_ability_const then
		ability = EntIndexToHScript(keys.entindex_ability_const)
	end

	if parent and modifier_name and HeroBuilder.modifiers_reapply[modifier_name] then
		local modifier = parent:FindModifierByName(modifier_name)
		if modifier and not modifier:IsNull() then
			local duration = modifier:GetDuration()
			local ability = modifier:GetAbility()
			parent:RemoveModifierByName(modifier_name)
			parent:AddNewModifier(caster, ability, modifier_name .. "_lua", { duration = duration })
		end
	end

	if parent and modifier_name then
		if parent:IsRealHero() and not parent:IsTempestDouble() then
			if modifier_name == "modifier_item_ultimate_scepter" or modifier_name == "modifier_item_ultimate_scepter_consumed" then
				EventDriver:Dispatch("Hero:scepter_received", {
					hero = parent
				})
			end
			if modifier_name == "modifier_item_aghanims_shard" then
				EventDriver:Dispatch("Hero:shard_received", {
					hero = parent
				})
			end
		end
		if ATTACK_TYPE_MODIFIERS[modifier_name] then
			AttackCapabilityChanger:RegisterAttackCapabilityChanger(parent)
		end
		if special_modifier_effects[modifier_name] then
			local exit = special_modifier_effects[modifier_name](parent, caster, ability, keys.duration)
			if (not exit) then return false end
		end
	end

	-- Enemy-sourced modifiers
	if caster and parent and caster:GetTeam() ~= parent:GetTeam() then

		-- Enemies can't apply debuffs to heroes at fountain
		if GameMode:IsTeamInFountain(parent:GetTeam()) then return false end

		-- Prevents player-based modifiers from affecting enemies, except if they are in the same arena
		if caster:IsControllableByAnyPlayer() then
			if Enfos:IsEnfosMode() then
				if caster:GetEnfosArena() ~= parent:GetEnfosArena() and not ignoreModifiers[modifier_name] then return false end
			else
				if caster:GetRangeToUnit(parent) > 2900 then return false end
			end
		end
	end

	return true
end

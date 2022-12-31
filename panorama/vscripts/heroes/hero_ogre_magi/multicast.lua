ogre_magi_multicast_custom = {
	GetIntrinsicModifierName = function() return "modifier_multicast_lua" end,
}

if IsServer() then
	function ogre_magi_multicast_custom:OnSpellStart()
		local caster = self:GetCaster()
		if not caster:HasScepter() then return end

		local target = self:GetCursorTarget()
		local duration = self:GetSpecialValueFor("duration_ally_scepter")
		target:EmitSound("Hero_OgreMagi.Fireblast.x3")
		target:AddNewModifier(caster, self, "modifier_multicast_lua", { duration = duration })
	end
end

function ogre_magi_multicast_custom:GetBehaviorInt()
	if self:GetCaster():HasScepter() then
		return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
	else
		return DOTA_ABILITY_BEHAVIOR_PASSIVE
	end
end

function ogre_magi_multicast_custom:GetManaCost(...)
	return self:GetCaster():HasScepter() and self.BaseClass.GetManaCost(self, ...) or 0
end

function ogre_magi_multicast_custom:GetCastRange(...)
	return self:GetCaster():HasScepter() and self.BaseClass.GetCastRange(self, ...) or 0
end

function ogre_magi_multicast_custom:CastFilterResultTarget(target)
	if not IsServer() then return end
	local caster = self:GetCaster()
	if (caster and (caster == target)) or (target and target:HasAbility("ogre_magi_multicast_custom"))then
		return UF_FAIL_CUSTOM
	end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE, caster:GetTeamNumber())
end


function ogre_magi_multicast_custom:GetCustomCastErrorTarget(target)
	if self:GetCaster() == target then
		return "#dota_hud_error_cant_cast_on_self"
	end
	if target:FindAbilityByName("ogre_magi_multicast_custom") then
		return "#dota_hud_error_cant_cast_on_other"
	end
	return ""
end


LinkLuaModifier("modifier_multicast_lua", "heroes/hero_ogre_magi/multicast.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_multicast_grow", "heroes/hero_ogre_magi/modifier_multicast_grow.lua", LUA_MODIFIER_MOTION_NONE)

---@class modifier_multicast_lua:CDOTA_Modifier_Lua
modifier_multicast_lua = {
	IsPurgable = function() return false end,
	DeclareFunctions = function() return { MODIFIER_EVENT_ON_ABILITY_EXECUTED } end,
}

if IsServer() then

	function modifier_multicast_lua:GetMulticastFactor(castedAbility)
		local ability = self:GetAbility()
		local caster = self:GetParent()
		
		if caster:PassivesDisabled() then return 1 end
		
		local multiplier = IsUltimateAbility(castedAbility) and 0.5 or 1
		if RollPercentage(ability:GetSpecialValueFor("multicast_4_times") * multiplier) then
			return 4
		elseif RollPercentage(ability:GetSpecialValueFor("multicast_3_times") * multiplier) then
			return 3
		elseif RollPercentage(ability:GetSpecialValueFor("multicast_2_times") * multiplier) then
			return 2
		end
		return 1
	end

	function modifier_multicast_lua:PlayMulticastFX(factor)
		if factor <= 1 then return end

		local caster = self:GetParent()
		local x = 1

		local fx = ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf', PATTACH_OVERHEAD_FOLLOW, caster)
		local delay = 0.5

		Timers:CreateTimer(delay, function() 
			ParticleManager:DestroyParticle(fx, x ~= factor)
			if x < factor then
				x = x + 1
				fx = ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf', PATTACH_OVERHEAD_FOLLOW, caster)
				ParticleManager:SetParticleControl(fx, 1, Vector(x, 0, 0))
				caster:EmitSound('Hero_OgreMagi.Fireblast.x'.. x)
				return delay
			end
		end)
	end

	function modifier_multicast_lua:PlaySummonFX(summon, counter)
			local delay = 0.5 -- multicast delay
			local particle_name = "particles/units/heroes/hero_ursa/ursa_overpower_cast.vpcf"

			local modifier = summon:AddNewModifier(summon, nil, "modifier_multicast_grow", nil)
			if modifier and not modifier:IsNull() then
				modifier:SetStackCount(counter)
			end

			Timers:CreateTimer(delay, function()
				local pfx = ParticleManager:CreateParticle(particle_name, PATTACH_ABSORIGIN_FOLLOW, summon)
				ParticleManager:ReleaseParticleIndex(pfx)

				counter = counter - 1

				if counter > 1 then
					return delay
				end
			end)
	end

	function modifier_multicast_lua:OnAbilityExecuted(keys)
		local parent = self:GetParent()
		if parent ~= keys.unit then return end
		local castedAbility = keys.ability

		local caster = self:GetParent()
		local target = keys.target or castedAbility:GetCursorPosition()
		local ability = self:GetAbility()

		if not ability or ability:IsNull() then return end

		local ogreAbilities = {
			ogre_magi_bloodlust = true,
			ogre_magi_fireblast = true,
			ogre_magi_ignite = true,
			ogre_magi_unrefined_fireblast = true
		}

		if ogreAbilities[castedAbility:GetAbilityName()] then
			local mc = caster:AddAbility("ogre_magi_multicast")
			if not mc or mc:IsNull() then return end
			mc:SetHidden(true)
			mc:SetLevel(ability:GetLevel())
			Timers:NextTick(function() caster:RemoveAbility("ogre_magi_multicast") end)
			return
		end

		local multiplier = IsUltimateAbility(castedAbility) and 0.5 or 1
		local multicast = self:GetMulticastFactor(castedAbility)

		if multicast > 1 then
			-- multicast_count used for summon upgrade in summon_buff ability
			-- for MULTICAST_TYPE_SUMMON abilities PreformMulticast does nothing except x2/x3/x4 particle
			castedAbility.multicast_count = multicast
			PreformMulticast(caster, castedAbility, multicast, ability:GetSpecialValueFor("multicast_delay"), target)
		else
			castedAbility.multicast_count = nil
		end
	end

	local MULTICAST_TYPE_NONE = 0
	local MULTICAST_TYPE_SAME = 1 -- Fireblast
	local MULTICAST_TYPE_DIFFERENT = 2 -- Ignite
	local MULTICAST_TYPE_INSTANT = 3 -- Bloodlust
	local MULTICAST_TYPE_SUMMON = 4
	local MULTICAST_ABILITIES = {
		ogre_magi_bloodlust = MULTICAST_TYPE_NONE,
		ogre_magi_fireblast = MULTICAST_TYPE_NONE,
		ogre_magi_ignite = MULTICAST_TYPE_NONE,
		ogre_magi_unrefined_fireblast = MULTICAST_TYPE_NONE,
		ogre_magi_multicast_custom = MULTICAST_TYPE_NONE,

		-- Consumables or resource duplication
		item_ward_sentry = MULTICAST_TYPE_NONE,
		item_bottle = MULTICAST_TYPE_NONE,
		item_tango = MULTICAST_TYPE_NONE,
		item_clarity = MULTICAST_TYPE_NONE,
		item_flask = MULTICAST_TYPE_NONE,
		item_enchanted_mango = MULTICAST_TYPE_NONE,
		item_dust = MULTICAST_TYPE_NONE,
		item_relearn_book_lua = MULTICAST_TYPE_NONE,
		item_summon_book_lua = MULTICAST_TYPE_NONE,
		item_upgrade_book = MULTICAST_TYPE_NONE,
		item_upgrade_book_2 = MULTICAST_TYPE_NONE,
		item_mastery_book = MULTICAST_TYPE_NONE,
		item_mastery_scroll = MULTICAST_TYPE_NONE,
		item_enfos_exp_tome = MULTICAST_TYPE_NONE,
		item_enfos_exp_tome_2 = MULTICAST_TYPE_NONE,
		item_book_of_strength = MULTICAST_TYPE_NONE,
		item_book_of_strength_2 = MULTICAST_TYPE_NONE,
		item_book_of_agility = MULTICAST_TYPE_NONE,
		item_book_of_agility_2 = MULTICAST_TYPE_NONE,
		item_book_of_intelligence = MULTICAST_TYPE_NONE,
		item_book_of_intelligence_2 = MULTICAST_TYPE_NONE,
		item_smoke_of_deceit = MULTICAST_TYPE_NONE,
		item_random_gift = MULTICAST_TYPE_NONE,
		item_comeback_gift = MULTICAST_TYPE_NONE,
		item_pirate_hat = MULTICAST_TYPE_NONE,
		item_kaya_3 = MULTICAST_TYPE_NONE,
		item_moon_shard = MULTICAST_TYPE_NONE,
		item_ancient_janggo = MULTICAST_TYPE_NONE,
		broodmother_spin_web = MULTICAST_TYPE_NONE,

		-- Multicast is pointless or bad for the user
		item_blink = MULTICAST_TYPE_NONE,
		item_hand_of_midas = MULTICAST_TYPE_DIFFERENT,
		item_power_treads = MULTICAST_TYPE_NONE,
		item_vambrace = MULTICAST_TYPE_NONE,
		item_refresher = MULTICAST_TYPE_NONE,
		item_fallen_sky = MULTICAST_TYPE_NONE,
		item_force_staff = MULTICAST_TYPE_NONE,
		item_hurricane_pike = MULTICAST_TYPE_NONE,
		item_black_king_bar = MULTICAST_TYPE_NONE,
		item_fusion_rune = MULTICAST_TYPE_NONE,
		item_ex_machina = MULTICAST_TYPE_NONE,
		item_book_of_the_dead = MULTICAST_TYPE_NONE,
		item_arcane_blink = MULTICAST_TYPE_NONE,
		item_overwhelming_blink = MULTICAST_TYPE_NONE,
		item_swift_blink = MULTICAST_TYPE_NONE,
		item_teleports_behind_you = MULTICAST_TYPE_NONE,
		item_force_boots = MULTICAST_TYPE_NONE,
		item_force_field = MULTICAST_TYPE_NONE,
		item_seer_stone = MULTICAST_TYPE_NONE,
		item_stormcrafter = MULTICAST_TYPE_NONE,
		item_flicker = MULTICAST_TYPE_NONE,
		item_mask_of_madness = MULTICAST_TYPE_NONE,
		item_satanic = MULTICAST_TYPE_NONE,
		item_meteor_hammer = MULTICAST_TYPE_NONE,
		item_invis_sword = MULTICAST_TYPE_NONE,
		item_silver_edge = MULTICAST_TYPE_NONE,
		item_blade_mail = MULTICAST_TYPE_NONE,
		item_hood_of_defiance = MULTICAST_TYPE_NONE,
		item_eternal_shroud = MULTICAST_TYPE_NONE,
		item_pipe = MULTICAST_TYPE_NONE,
		item_crimson_guard = MULTICAST_TYPE_NONE,
		item_mekansm = MULTICAST_TYPE_NONE,
		item_veil_of_discord = MULTICAST_TYPE_NONE,
		item_ironwood_tree = MULTICAST_TYPE_NONE,
		item_quelling_blade = MULTICAST_TYPE_NONE,
		item_bfury = MULTICAST_TYPE_NONE,
		item_ghost = MULTICAST_TYPE_NONE,
		item_shadow_amulet = MULTICAST_TYPE_NONE,
		item_magic_stick = MULTICAST_TYPE_NONE,
		item_magic_wand = MULTICAST_TYPE_NONE,
		item_holy_locket = MULTICAST_TYPE_NONE,

		bid50 = MULTICAST_TYPE_NONE,
		bid250 = MULTICAST_TYPE_NONE,
        rattletrap_overclocking = MULTICAST_TYPE_NONE,
		wisp_tether = MULTICAST_TYPE_NONE,
		arc_warden_tempest_double_lua = MULTICAST_TYPE_NONE,
		earth_spirit_rolling_boulder = MULTICAST_TYPE_NONE,
		lifestealer_infest_lua = MULTICAST_TYPE_NONE,
		winter_wyvern_arctic_burn = MULTICAST_TYPE_NONE,
		tiny_tree_channel = MULTICAST_TYPE_NONE,
		ancient_apparition_ice_blast_release = MULTICAST_TYPE_NONE,
		naga_siren_song_of_the_siren = MULTICAST_TYPE_NONE,
		techies_suicide = MULTICAST_TYPE_NONE,
		drow_ranger_multishot = MULTICAST_TYPE_NONE,
		lone_druid_spirit_bear = MULTICAST_TYPE_NONE,
		alchemist_chemical_rage = MULTICAST_TYPE_NONE,
		riki_tricks_of_the_trade = MULTICAST_TYPE_NONE,
		rubick_null_field = MULTICAST_TYPE_NONE,
		leshrac_pulse_nova = MULTICAST_TYPE_NONE,
		tinker_rearm_lua = MULTICAST_TYPE_NONE,
		invoker_quas = MULTICAST_TYPE_NONE,
		invoker_wex = MULTICAST_TYPE_NONE,
		invoker_exort = MULTICAST_TYPE_NONE,
		invoker_invoke = MULTICAST_TYPE_NONE,
		timbersaw_chakram_lua = MULTICAST_TYPE_NONE,
		timbersaw_chakram_2_lua = MULTICAST_TYPE_NONE,
		timbersaw_chakram_lua_return = MULTICAST_TYPE_NONE,
		timbersaw_chakram_lua_2_return = MULTICAST_TYPE_NONE,
		alchemist_unstable_concoction = MULTICAST_TYPE_NONE,
		alchemist_unstable_concoction_throw = MULTICAST_TYPE_NONE,
		elder_titan_return_spirit_lua = MULTICAST_TYPE_NONE,
		elder_titan_move_spirit_lua = MULTICAST_TYPE_NONE,
		ember_spirit_sleight_of_fist = MULTICAST_TYPE_NONE,
		monkey_king_tree_dance = MULTICAST_TYPE_NONE,
		monkey_king_primal_spring = MULTICAST_TYPE_NONE,
		monkey_king_primal_spring_early = MULTICAST_TYPE_NONE,
		wisp_spirits = MULTICAST_TYPE_NONE,
		wisp_spirits_in = MULTICAST_TYPE_NONE,
		wisp_spirits_out = MULTICAST_TYPE_NONE,
		arc_warden_tempest_double = MULTICAST_TYPE_NONE,
		phoenix_sun_ray = MULTICAST_TYPE_NONE,
		phoenix_sun_ray_stop = MULTICAST_TYPE_NONE,
		phoenix_sun_ray_toggle_move = MULTICAST_TYPE_NONE,
		phoenix_fire_spirits = MULTICAST_TYPE_NONE,
		phoenix_launch_fire_spirit = MULTICAST_TYPE_NONE, 
		phoenix_icarus_dive = MULTICAST_TYPE_NONE, 
		phoenix_icarus_dive_stop = MULTICAST_TYPE_NONE,
		tusk_snowball = MULTICAST_TYPE_NONE,
		ancient_apparition_ice_blast = MULTICAST_TYPE_NONE,
		bane_nightmare = MULTICAST_TYPE_NONE,
		bane_nightmare_end = MULTICAST_TYPE_NONE,
		bane_fiends_grip = MULTICAST_TYPE_NONE,
		keeper_of_the_light_illuminate = MULTICAST_TYPE_NONE,
		keeper_of_the_light_illuminate_end = MULTICAST_TYPE_NONE,
		keeper_of_the_light_spirit_form_illuminate = MULTICAST_TYPE_NONE,
		keeper_of_the_light_spirit_form_illuminate_end = MULTICAST_TYPE_NONE,
		puck_phase_shift = MULTICAST_TYPE_NONE,
		puck_ethereal_jaunt = MULTICAST_TYPE_NONE,
		nyx_assassin_burrow = MULTICAST_TYPE_NONE,
		nyx_assassin_unburrow = MULTICAST_TYPE_NONE,
		templar_assassin_trap_teleport = MULTICAST_TYPE_NONE,
		morphling_waveform = MULTICAST_TYPE_NONE,
		faceless_void_time_walk = MULTICAST_TYPE_NONE,
		void_spirit_astral_step = MULTICAST_TYPE_NONE,
		antimage_blink = MULTICAST_TYPE_NONE,
		queenofpain_blink = MULTICAST_TYPE_NONE,
		slark_pounce = MULTICAST_TYPE_NONE,
		obsidian_destroyer_arcane_orb = MULTICAST_TYPE_NONE,
		storm_spirit_ball_lightning = MULTICAST_TYPE_NONE,
		brewmaster_drunken_brawler = MULTICAST_TYPE_NONE,
		snapfire_gobble_up_lua = MULTICAST_TYPE_NONE,
		snapfire_spit_creep_lua = MULTICAST_TYPE_NONE,
		enigma_midnight_pulse = MULTICAST_TYPE_NONE,

		-- Lag/bugs
		keeper_of_the_light_chakra_magic = MULTICAST_TYPE_NONE,
		clinkz_death_pact_lua = MULTICAST_TYPE_NONE,
		tiny_tree_grab_lua = MULTICAST_TYPE_NONE,
		monkey_king_wukongs_command_lua = MULTICAST_TYPE_NONE,
		undying_tombstone_lua = MULTICAST_TYPE_NONE,
		faceless_void_chronosphere = MULTICAST_TYPE_NONE,
		jakiro_macropyre = MULTICAST_TYPE_NONE,
		enigma_black_hole = MULTICAST_TYPE_NONE,
		kunkka_torrent_storm = MULTICAST_TYPE_NONE,
		frostivus2018_dark_willow_bedlam = MULTICAST_TYPE_NONE,
		hoodwink_sharpshooter_lua = MULTICAST_TYPE_NONE,
		witch_doctor_voodoo_switcheroo = MULTICAST_TYPE_NONE,
		shadow_shaman_shackles_lua = MULTICAST_TYPE_NONE,
		dawnbreaker_converge = MULTICAST_TYPE_NONE,
		dawnbreaker_solar_guardian = MULTICAST_TYPE_NONE,
		dawnbreaker_celestial_hammer = MULTICAST_TYPE_NONE,
		crystal_maiden_freezing_field = MULTICAST_TYPE_NONE,
		tusk_ice_shards = MULTICAST_TYPE_NONE,
		clinkz_strafe = MULTICAST_TYPE_NONE,
		rattletrap_hookshot = MULTICAST_TYPE_NONE,
		marci_grapple = MULTICAST_TYPE_NONE,
		ursa_earthshock = MULTICAST_TYPE_NONE,
		ursa_enrage = MULTICAST_TYPE_NONE,
		primal_beast_onslaught = MULTICAST_TYPE_NONE,

		-- Enfos Wizard
		enfos_wizard_rune_spawned = MULTICAST_TYPE_NONE,
		enfos_wizard_arcane_eye = MULTICAST_TYPE_NONE,
		enfos_wizard_mass_banishment = MULTICAST_TYPE_NONE,
		enfos_wizard_revivify = MULTICAST_TYPE_NONE,
		enfos_wizard_disjunction = MULTICAST_TYPE_NONE,
		enfos_wizard_adrenaline_rush = MULTICAST_TYPE_NONE,
		enfos_wizard_lethargy = MULTICAST_TYPE_NONE,
		enfos_wizard_death_sentence = MULTICAST_TYPE_NONE,
		enfos_wizard_meteor_swarm = MULTICAST_TYPE_NONE,
		enfos_wizard_upgrade_wizard = MULTICAST_TYPE_NONE,
		enfos_wizard_upgrade_wizard_2 = MULTICAST_TYPE_NONE,
		enfos_wizard_upgrade_treasury = MULTICAST_TYPE_NONE,
		enfos_wizard_upgrade_treasury_2 = MULTICAST_TYPE_NONE,
		enfos_wizard_sanctuary = MULTICAST_TYPE_NONE,
		enfos_wizard_plague_of_frogs = MULTICAST_TYPE_NONE,
		enfos_wizard_rain_of_riches = MULTICAST_TYPE_NONE,
		enfos_wizard_mass_enlightenment = MULTICAST_TYPE_NONE,
		enfos_wizard_celestial_stasis = MULTICAST_TYPE_NONE,

		item_enfos_gold_bag = MULTICAST_TYPE_NONE,
		item_enfos_gold_bag_2 = MULTICAST_TYPE_NONE,
		item_enfos_gold_bag_3 = MULTICAST_TYPE_NONE,
		item_enfos_gold_bag_4 = MULTICAST_TYPE_NONE,
		item_enfos_gold_bag_5 = MULTICAST_TYPE_NONE,
		item_enfos_gold_bag_6 = MULTICAST_TYPE_NONE,

		-- Multicast is OP
		terrorblade_reflection_lua = MULTICAST_TYPE_NONE,
		item_eye_of_midas = MULTICAST_TYPE_NONE,
		dazzle_good_juju = MULTICAST_TYPE_NONE,

		-- Other
		terrorblade_conjure_image = MULTICAST_TYPE_INSTANT,
		magnataur_empower = MULTICAST_TYPE_INSTANT,
		oracle_purifying_flames = MULTICAST_TYPE_SAME,
		vengefulspirit_magic_missile = MULTICAST_TYPE_SAME,
		tusk_walrus_kick = MULTICAST_TYPE_DIFFERENT,

		--All summon upgrages for this abilites doing in summon_buff modifier
		lycan_summon_wolves_lua = MULTICAST_TYPE_SUMMON,
		beastmaster_call_of_the_wild_boar = MULTICAST_TYPE_SUMMON,
		beastmaster_call_of_the_wild_hawk = MULTICAST_TYPE_SUMMON,
		invoker_forge_spirit_ad_lua = MULTICAST_TYPE_SUMMON,
		furion_force_of_nature = MULTICAST_TYPE_SUMMON,
		visage_summon_familiars = MULTICAST_TYPE_SUMMON,
		witch_doctor_death_ward = MULTICAST_TYPE_SUMMON,
		skeleton_king_vampiric_aura = MULTICAST_TYPE_SUMMON,
		item_demonicon = MULTICAST_TYPE_SUMMON,

		--Next abilities have custom multicast logic implemented in ability code
		enigma_demonic_conversion_lua = MULTICAST_TYPE_NONE,
		shadow_shaman_mass_serpent_ward_lua = MULTICAST_TYPE_NONE,
		venomancer_plague_ward_lua = MULTICAST_TYPE_NONE,
		venomancer_venomous_gale_lua = MULTICAST_TYPE_NONE,
		warlock_rain_of_chaos_lua = MULTICAST_TYPE_NONE,
		broodmother_spawn_spiderlings_lua = MULTICAST_TYPE_NONE,
		zeus_cloud_lua = MULTICAST_TYPE_NONE,
		item_wraith_pact_lua = MULTICAST_TYPE_NONE,
		abyssal_underlord_firestorm_lua = MULTICAST_TYPE_NONE,
		elder_titan_echo_stomp_lua = MULTICAST_TYPE_NONE,
		elder_titan_ancestral_spirit_lua = MULTICAST_TYPE_NONE,
	}

	local cast_target_filter = {}
	cast_target_filter["doom_bringer_doom"] = function(caster, ability, target)
		if target == caster or target:GetTeam() ~= caster:GetTeam() then return UF_SUCCESS end
	end

	function GetAbilityMulticastType(ability)
		local name = ability:GetAbilityName()
		if MULTICAST_ABILITIES[name] then return MULTICAST_ABILITIES[name] end
		if ability:IsToggle() then return MULTICAST_TYPE_NONE end
		if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_TOGGLE) then return MULTICAST_TYPE_NONE end
		if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_PASSIVE) then return MULTICAST_TYPE_NONE end
		return ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) and MULTICAST_TYPE_DIFFERENT or MULTICAST_TYPE_SAME
	end

	function PreformMulticast(caster, ability_cast, multicast, multicast_delay, target)
		local multicast_type = GetAbilityMulticastType(ability_cast)
		if multicast_type ~= MULTICAST_TYPE_NONE then
			local prt = ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf', PATTACH_OVERHEAD_FOLLOW, caster)
			local multicast_flag_data = GetMulticastFlags(caster, ability_cast, multicast_type)
			local channelData = {}
			caster:AddEndChannelListener(function(interrupted)
				channelData.endTime = GameRules:GetGameTime()
				channelData.channelFailed = interrupted
			end)
			if multicast_type == MULTICAST_TYPE_INSTANT then
				Timers:NextTick(function()
					ParticleManager:SetParticleControl(prt, 1, Vector(multicast, 0, 0))
					ParticleManager:ReleaseParticleIndex(prt)
					local multicast_casted_data = {}
					for i=2,multicast do
						CastMulticastedSpellInstantly(caster, ability_cast, target, multicast_flag_data, multicast_casted_data, 0, channelData)
					end
				end)
			else
				CastMulticastedSpell(caster, ability_cast, target, multicast-1, multicast_type, multicast_flag_data, { [target] = true }, multicast_delay, channelData, prt, 2)
			end
		end
	end

	function GetMulticastFlags(caster, ability, multicast_type)
		local rv = {}
		if multicast_type ~= MULTICAST_TYPE_SAME then
			local cast_range = ability:GetCastRange(caster:GetOrigin(), caster)
			local cast_range_bonus = caster:GetCastRangeBonus()
			rv.cast_range = cast_range + cast_range_bonus + caster:GetHullRadius()
			local abilityTarget = ability:GetAbilityTargetTeam()
			if abilityTarget == 0 then abilityTarget = DOTA_UNIT_TARGET_TEAM_ENEMY end
			rv.abilityTarget = abilityTarget
			local abilityTargetType = ability:GetAbilityTargetType()
			if abilityTargetType == 0 then abilityTargetType = DOTA_UNIT_TARGET_ALL
			elseif abilityTargetType == 2 and ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT) then abilityTargetType = 3 end
			rv.abilityTargetType = abilityTargetType
			rv.team = caster:GetTeam()
			rv.targetFlags = ability:GetAbilityTargetFlags()
		end
		return rv
	end

	function CastMulticastedSpellInstantly(caster, ability, target, multicast_flag_data, multicast_casted_data, delay, channelData)
		if not IsValidEntity(ability) then return end

		local candidates = FindUnitsInRadius(multicast_flag_data.team, caster:GetOrigin(), nil, multicast_flag_data.cast_range, multicast_flag_data.abilityTarget, multicast_flag_data.abilityTargetType, multicast_flag_data.targetFlags, FIND_ANY_ORDER, false)
		local ability_name = ability:GetAbilityName()
		
		if ability.CastFilterResultTarget then
			candidates = table.filter_array(candidates, function(unit)
				return ability:CastFilterResultTarget(unit) == UF_SUCCESS
			end)
		elseif cast_target_filter[ability_name] then
			candidates = table.filter_array(candidates, function(unit)
				return cast_target_filter[ability_name](caster, ability, unit) == UF_SUCCESS
			end)
		end

		local Tier1 = {} --heroes
		local Tier2 = {} --creeps and self
		local Tier3 = {} --already casted
		local Tier4 = {} --dead stuff

		local target_exceptions = {
			aghsfort_mars_bulwark_soldier = true,
			npc_dota_elder_titan_ancestral_spirit = true,
		}

		for k, v in pairs(candidates) do
			if caster:CanEntityBeSeenByMyTeam(v) and (not target_exceptions[v:GetUnitName()]) and (ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT) or (not ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT) and not v:IsUntargetable())) then
				if multicast_casted_data[v] then
					Tier3[#Tier3 + 1] = v
				elseif not v:IsAlive() then
					Tier4[#Tier4 + 1] = v
				elseif v:IsHero() and v ~= caster then
					Tier1[#Tier1 + 1] = v
				else
					Tier2[#Tier2 + 1] = v
				end
			end
		end
		local castTarget = Tier1[math.random(#Tier1)] or Tier2[math.random(#Tier2)] or Tier3[math.random(#Tier3)] or Tier4[math.random(#Tier4)]
		
		if castTarget then
			multicast_casted_data[castTarget] = true
			Util:CastAdditionalAbility(caster, ability, castTarget, delay, channelData)
		end

		return multicast_casted_data
	end

	function CastMulticastedSpell(caster, ability, target, multicasts, multicast_type, multicast_flag_data, multicast_casted_data, delay, channelData, prt, prtNumber)
		if multicasts >= 1 then
			Timers:CreateTimer(delay, function()
				if not IsValidEntity(ability) then return end

				ParticleManager:DestroyParticle(prt, true)
				ParticleManager:ReleaseParticleIndex(prt)
				prt = ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf', PATTACH_OVERHEAD_FOLLOW, caster)
				ParticleManager:SetParticleControl(prt, 1, Vector(prtNumber, 0, 0))
				if multicast_type == MULTICAST_TYPE_SAME then
					Util:CastAdditionalAbility(caster, ability, target, delay * (prtNumber - 1), channelData)
				elseif multicast_type ~= MULTICAST_TYPE_SUMMON then
					multicast_casted_data = CastMulticastedSpellInstantly(caster, ability, target, multicast_flag_data, multicast_casted_data, delay * (prtNumber - 1), channelData)
				end
				caster:EmitSound('Hero_OgreMagi.Fireblast.x'.. multicasts)
				if multicasts >= 2 then
					CastMulticastedSpell(caster, ability, target, multicasts - 1, multicast_type, multicast_flag_data, multicast_casted_data, delay, channelData, prt, prtNumber + 1)
				end
			end)
		else
			ParticleManager:DestroyParticle(prt, false)
			ParticleManager:ReleaseParticleIndex(prt)
		end
	end
end

function IsUltimateAbility(ability)
	return ability:GetAbilityType() == 1
end

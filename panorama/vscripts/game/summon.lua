if Summon == nil then Summon = class({}) end

SUMMON_DESTINATION_FOUNTAIN = 1
SUMMON_DESTINATION_PVE = 2
SUMMON_DESTINATION_PVP = 3

SUMMON_TELEPORTABLE_SUMMONS = {
	npc_dota_lone_druid_bear1 = true,
	npc_dota_lone_druid_bear2 = true,
	npc_dota_lone_druid_bear3 = true,
	npc_dota_lone_druid_bear4 = true,
	npc_dota_visage_familiar1 = true,
	npc_dota_visage_familiar2 = true,
	npc_dota_visage_familiar3 = true,
}

function Summon:Init()
	Summon.list = {
		npc_dota_techies_stasis_trap = true,
		npc_dota_techies_remote_mine = true,
		npc_dota_techies_land_mine = true,
		npc_dota_venomancer_plague_ward_1 = true,
		npc_dota_venomancer_plague_ward_2 = true,
		npc_dota_venomancer_plague_ward_3 = true,
		npc_dota_venomancer_plague_ward_4 = true,
		npc_dota_beastmaster_boar = true,
		npc_dota_warlock_golem_1 = true,
		npc_dota_warlock_golem_2 = true,
		npc_dota_warlock_golem_3 = true,
		npc_dota_warlock_golem_scepter_1 = true,
		npc_dota_warlock_golem_scepter_2 = true,
		npc_dota_warlock_golem_scepter_3 = true,
		npc_dota_shadow_shaman_ward_1 = true,
		npc_dota_shadow_shaman_ward_2 = true,
		npc_dota_shadow_shaman_ward_3 = true,
		npc_dota_witch_doctor_death_ward = true,
		npc_dota_visage_familiar1 = true,
		npc_dota_visage_familiar2 = true,
		npc_dota_visage_familiar3 = true,
		npc_dota_necronomicon_warrior_1 = true,
		npc_dota_necronomicon_warrior_2 = true,
		npc_dota_necronomicon_warrior_3 = true,
		npc_dota_necronomicon_archer_1 = true,
		npc_dota_necronomicon_archer_2 = true,
		npc_dota_necronomicon_archer_3 = true,
		npc_dota_lycan_wolf1 = true,
		npc_dota_lycan_wolf2 = true,
		npc_dota_lycan_wolf3 = true,
		npc_dota_lycan_wolf4 = true,
		npc_dota_broodmother_spiderling = true,
		npc_dota_broodmother_spiderite = true,
		npc_dota_lesser_eidolon = true,
		npc_dota_eidolon = true,
		npc_dota_greater_eidolon = true,
		npc_dota_dire_eidolon = true,
		npc_dota_furion_treant_1 = true,
		npc_dota_furion_treant_2 = true,
		npc_dota_furion_treant_3 = true,
		npc_dota_furion_treant_4 = true,
		npc_dota_furion_treant_large = true,
		npc_dota_rattletrap_cog = true,
		npc_dota_lone_druid_bear1 = true,
		npc_dota_lone_druid_bear2 = true,
		npc_dota_lone_druid_bear3 = true,
		npc_dota_lone_druid_bear4 = true,
		npc_dota_invoker_forged_spirit = true,
		npc_dota_brewmaster_storm_1 = true,
		npc_dota_brewmaster_storm_2 = true,
		npc_dota_brewmaster_storm_3 = true,
		npc_dota_brewmaster_fire_1 = true,
		npc_dota_brewmaster_fire_2 = true,
		npc_dota_brewmaster_fire_3 = true,
		npc_dota_brewmaster_earth_1 = true,
		npc_dota_brewmaster_earth_2 = true,
		npc_dota_brewmaster_earth_3 = true,
		npc_dota_brewmaster_void_1 = true,
		npc_dota_brewmaster_void_2 = true,
		npc_dota_brewmaster_void_3 = true,
		npc_dota_creature_tombstone_zombie = true,
		npc_dota_creature_tombstone_zombie_torso = true,
		npc_dota_templar_assassin_psionic_trap = true,
		npc_dota_zeus_cloud = true,
		npc_dota_tusk_frozen_sigil1 = true,
		npc_dota_tusk_frozen_sigil2 = true,
		npc_dota_tusk_frozen_sigil3 = true,
		npc_dota_tusk_frozen_sigil4 = true,
		npc_dota_unit_tombstone1 = true,
		npc_dota_unit_tombstone2 = true,
		npc_dota_unit_tombstone3 = true,
		npc_dota_unit_tombstone4 = true,
		npc_dota_juggernaut_healing_ward = true,
		npc_dota_pugna_nether_ward_1 = true,
		npc_dota_pugna_nether_ward_2 = true,
		npc_dota_pugna_nether_ward_3 = true,
		npc_dota_pugna_nether_ward_4 = true,
		npc_dota_pugna_ward_winter_2018 = true,
		npc_dota_observer_wards = true,
		npc_dota_item_wraith_pact_totem = true,
	}
end

function Summon:KillSummonedCreature(location)
	if not location then return end

	local summons = FindUnitsInRadius(DOTA_TEAM_NEUTRALS, location, nil, 2500, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
	for _, unit in ipairs(summons) do
		if unit and not unit:IsNull() and unit:IsAlive() and unit.GetUnitName and unit:GetUnitName() 
		and (unit:IsSummoned() or Summon.list[unit:GetUnitName()] or unit:IsIllusion() or unit:IsTempestDouble()) then
			if unit:IsTempestDouble() then
				ApplyDamage({victim = unit, attacker = unit, damage = unit:GetMaxHealth(), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL})
			else
				unit:ForceKill(false)
			end
		end
	end
end

function Summon:KillSummonedCreatureAsync(location)
	if not location then return end

	Timers:CreateTimer({ 
		endTime = 1, 
		callback = function()
			Summon:KillSummonedCreature(location)
		end
	})
end

function Summon:EnfosKillPvpSummons()
	Timers:CreateTimer(1, function()
		local units = FindUnitsInRadius(
			DOTA_TEAM_NEUTRALS, 
			Vector(0, 0, 0), 
			nil, 
			-1, 
			DOTA_UNIT_TARGET_TEAM_ENEMY, 
			DOTA_UNIT_TARGET_ALL, 
			DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 
			FIND_CLOSEST, 
			false
		)

		for _, unit in ipairs(units) do
			if unit and not unit:IsNull() and unit.GetUnitName and unit:IsAlive() and unit:GetEnfosArena() == ENFOS_ARENA_PVP 
			and unit:GetUnitName() and (unit:IsSummoned() or Summon.list[unit:GetUnitName()] or unit:IsIllusion() or unit:IsTempestDouble()) then
				if unit:IsTempestDouble() then
					ApplyDamage({victim = unit, attacker = unit, damage = unit:GetMaxHealth(), damage_type = DAMAGE_TYPE_PURE, damage_flags = DOTA_DAMAGE_FLAG_BYPASSES_BLOCK + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION + DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL})
				else
					unit:ForceKill(false)
				end
			end
		end
	end)
end

function Summon:TeleportSummonsToHero(hero, destination_type, arena_center)
	local target_location = hero:GetAbsOrigin()

	for _, summon in pairs(Util:FindAllOwnedUnits(hero:GetPlayerID())) do
		if SUMMON_TELEPORTABLE_SUMMONS[summon:GetUnitName()] then

			summon:RemoveModifierByName("modifier_creature_kick_motion")

			summon:AddNewModifier(hero, nil, "modifier_no_collision_custom", {duration = 2})

			if destination_type == SUMMON_DESTINATION_FOUNTAIN then
				summon:AddNewModifier(hero, nil, "modifier_summon_refreshing", {})
				FindClearSpaceForUnit(summon, target_location + RandomVector(150), false)
				summon.unit_state = TEAM_STATE_ON_BASE
			elseif destination_type == SUMMON_DESTINATION_PVE then
				summon:RemoveModifierByName("modifier_summon_refreshing")
				summon:RemoveModifierByName("modifier_innate_rend_tear")
				summon:RemoveModifierByName("modifier_innate_cascading_arcana_debuff")
				FindClearSpaceForUnit(summon, target_location + RandomVector(150), false)
				summon.unit_state = TEAM_STATE_FIGHTING_CREEPS
			elseif destination_type == SUMMON_DESTINATION_PVP then
				summon:RemoveModifierByName("modifier_summon_refreshing")
				summon:AddNewModifier(hero, nil, "modifier_summon_pre_duel_frozen", {duration = 3})
				FindClearSpaceForUnit(summon, target_location + Vector(0, 200, 0), false)
				summon.unit_state = Enfos:IsEnfosMode() and GameMode:GetPlayerState(hero:GetPlayerOwnerID()) or TEAM_STATE_DUELING
			end

			if arena_center then
				summon:FaceTowards(arena_center)
			else
				summon:FaceTowards(target_location)
			end
			summon:Heal(summon:GetMaxHealth(), nil)
			summon:Stop()
		end
	end
end

function Summon:KillAllForPlayer(player_id)
	for _, unit in pairs(Util:FindAllOwnedUnits(player_id)) do
		if unit:IsSummoned() or Summon.list[unit:GetUnitName()] or unit:IsIllusion() or unit:IsTempestDouble() then
			unit:ForceKill(false)
		end
	end
end

Summon:Init()

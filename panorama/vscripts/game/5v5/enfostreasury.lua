if EnfosTreasury == nil then EnfosTreasury = class({}) end

function EnfosTreasury:Init()

	self.treasury_speed_multiplier = {}
	self.treasury_speed_multiplier[0] = 1
	self.treasury_speed_multiplier[1] = 1.3
	self.treasury_speed_multiplier[2] = 1.75

	self.treasury_thresholds = {}
	self.treasury_thresholds[1] = 10
	self.treasury_thresholds[2] = 20
	self.treasury_thresholds[3] = 30
	self.treasury_thresholds[4] = 40
	self.treasury_thresholds[5] = 50
	self.treasury_thresholds[6] = 60

	self.treasury_models = {}
	self.treasury_models[1] = "models/courier/flopjaw/flopjaw.vmdl"
	self.treasury_models[2] = "models/courier/lockjaw/lockjaw.vmdl"
	self.treasury_models[3] = "models/courier/trapjaw/trapjaw.vmdl"

	self.treasury_platform_models = {}
	self.treasury_platform_models[0] = "models/heroes/pedestal/effigy_pedestal_dire.vmdl"
	self.treasury_platform_models[1] = "models/heroes/pedestal/effigy_pedestal_dire.vmdl"
	self.treasury_platform_models[2] = "models/heroes/pedestal/pedestal_1_small.vmdl"
	self.treasury_platform_models[3] = "models/heroes/pedestal/effigy_pedestal_ti5.vmdl"
	self.treasury_platform_models[4] = "models/heroes/phantom_assassin/arcana_pedestal.vmdl"
	self.treasury_platform_models[5] = "models/heroes/pedestal/effigy_pedestal_wm16.vmdl"
	self.treasury_platform_models[6] = "models/heroes/pedestal/mesh/effigy_pedestal_fm16_wood.vmdl"

	self.treasure_colors = {}
	self.treasure_colors[1] = Vector(255, 255, 255)
	self.treasure_colors[2] = Vector(0, 255, 0)
	self.treasure_colors[3] = Vector(0, 0, 255)
	self.treasure_colors[4] = Vector(125, 50, 175)
	self.treasure_colors[5] = Vector(255, 150, 0)
	self.treasure_colors[6] = Vector(255, 50, 50)

	self.treasury_item_list = {}

	self.treasury_item_list[1] = {
		"item_boots",
		"item_book_of_strength",
		"item_book_of_agility",
		"item_book_of_intelligence"
	}

	self.treasury_item_list[2] = {
		"item_ironwood_tree",
		"item_arcane_ring",
		"item_chipped_vest",
		"item_possessed_mask",
		"item_ring_of_aquila",
		"item_ceremonial_robe",
		"item_orb_of_destruction",
		"item_elven_tunic",
		"item_cloak_of_flames",
	}

	self.treasury_item_list[3] = {
		"item_fusion_rune",
		"item_refresher_shard",
		"item_vladmir",
		"item_hand_of_midas",
		"item_aeon_disk_lua",
		"item_sange_and_yasha",
		"item_yasha_and_kaya",
		"item_kaya_and_sange",
		"item_titan_sliver",
		"item_quickening_charm",
		"item_paladin_sword",
		"item_minotaur_horn",
		"item_timeless_relic",
		"item_trickster_cloak",
		"item_enfos_gold_bag_3"
	}

	self.treasury_item_list[4] = {
		"item_moon_shard",
		"item_guardian_greaves",
		"item_octarine_core",
		"item_ultimate_scepter",
		"item_refresher",
		"item_assault",
		"item_skadi",
		"item_spell_prism",
		"item_force_boots",
		"item_desolator_2",
		"item_ballista_lua",
		"item_pirate_hat",
		"item_cheese",
		"item_book_of_strength_2",
		"item_book_of_agility_2",
		"item_book_of_intelligence_2",
		"item_enfos_gold_bag_4"
	}

	self.treasury_item_list[5] = {
		"item_bloodthorn",
		"item_guardian_helmet",
		"item_luminance",
		"item_summoner_crown_3",
		"item_kaya_3",
		"item_ranged_cleave_2",
		"item_devastator",
		"item_apex",
		"item_fallen_sky",
		"item_demonicon",
		"item_mirror_shield",
		"item_giants_ring",
		"item_turbulent_sturmaz",
		"item_enfos_gold_bag_5"
	}

	self.treasury_item_list[6] = {
		"item_the_triumvirate",
		"item_teleports_behind_you",
		"item_diamondwood_tree",
		"item_robe_of_the_archmage",
		"item_crystal_tiara",
		"item_titan_soul",
		"item_desolator_3",
		"item_spell_fractal",
		"item_upgrade_book_2",
		"item_enfos_gold_bag_6",
		"item_colossus_ring",
	}

	self.treasury_levels = {}
	self.treasury_levels[DOTA_TEAM_GOODGUYS] = 0
	self.treasury_levels[DOTA_TEAM_BADGUYS] = 0

	self.treasury_states = {}
	self.treasury_states[DOTA_TEAM_GOODGUYS] = {voted = {}, state = false}
	self.treasury_states[DOTA_TEAM_BADGUYS] = {voted = {}, state = false}

	self.treasuries = {}
	self.treasuries[DOTA_TEAM_GOODGUYS] = {}

	table.insert(self.treasuries[DOTA_TEAM_GOODGUYS], {
		charge = 0,
		chest = CreateUnitByName("npc_enfos_treasury", Entities:FindByName(nil, "radiant_treasury_left_chest"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS),
		platforms = {
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "radiant_treasury_left_slot1"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS),
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "radiant_treasury_left_slot2"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS),
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "radiant_treasury_left_slot3"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
		},
		tiers = {0, 0, 0}
	})

	table.insert(self.treasuries[DOTA_TEAM_GOODGUYS], {
		charge = 0,
		chest = CreateUnitByName("npc_enfos_treasury", Entities:FindByName(nil, "radiant_treasury_right_chest"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS),
		platforms = {
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "radiant_treasury_right_slot1"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS),
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "radiant_treasury_right_slot2"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS),
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "radiant_treasury_right_slot3"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_GOODGUYS)
		},
		tiers = {0, 0, 0}
	})

	self.treasuries[DOTA_TEAM_BADGUYS] = {}

	table.insert(self.treasuries[DOTA_TEAM_BADGUYS], {
		charge = 0,
		chest = CreateUnitByName("npc_enfos_treasury", Entities:FindByName(nil, "dire_treasury_left_chest"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS),
		platforms = {
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "dire_treasury_left_slot1"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS),
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "dire_treasury_left_slot2"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS),
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "dire_treasury_left_slot3"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		},
		tiers = {0, 0, 0}
	})

	table.insert(self.treasuries[DOTA_TEAM_BADGUYS], {
		charge = 0,
		chest = CreateUnitByName("npc_enfos_treasury", Entities:FindByName(nil, "dire_treasury_right_chest"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS),
		platforms = {
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "dire_treasury_right_slot1"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS),
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "dire_treasury_right_slot2"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS),
			CreateUnitByName("npc_enfos_treasure_platform", Entities:FindByName(nil, "dire_treasury_right_slot3"):GetAbsOrigin(), true, nil, nil, DOTA_TEAM_BADGUYS)
		},
		tiers = {0, 0, 0}
	})

	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		EnfosTreasury:InitializeUnit(self.treasuries[team][1].chest, 240)
		EnfosTreasury:InitializeUnit(self.treasuries[team][2].chest, 300)

		for i = 1, 2 do
			for j = 1, 3 do
				EnfosTreasury:InitializeUnit(self.treasuries[team][i].platforms[j], 300)
			end
		end
	end

	CustomNetTables:SetTableValue("game", "enfos_treasuries", {self.treasuries})


	self.VOTES_REQUIRED = 3
	RegisterCustomEventListener("treasury:set_vote_state", function(data) EnfosTreasury:VoteOpen(data) end)
	RegisterCustomEventListener("treasury:request_vote_state", function(data) EnfosTreasury:SendVoteState(data) end)
	RegisterCustomEventListener("treasury:request_totem_info", function(data) EnfosTreasury:SendTotemInfo(data) end)
end

function EnfosTreasury:GetTreasuryLevel(team)
	return self.treasury_levels[team]
end

function EnfosTreasury:UpgradeTreasury(team)
	self.treasury_levels[team] = self.treasury_levels[team] + 1

	-- Update progress bars
	for _, treasury in pairs(self.treasuries[team]) do
		if ProgressBars:HasTimedProgressBar(treasury.chest) then
			ProgressBars:RemoveTimedProgressBar(treasury.chest)
		end

		if not EnfosTreasury:IsFull(treasury) then
			local current_slot = EnfosTreasury:GetLowestTierSlot(treasury)
			local next_tier = 1 + treasury.tiers[current_slot]

			ProgressBars:AddTimedProgressBar(
				treasury.chest,
				(self.treasury_thresholds[next_tier] - treasury.charge) / self.treasury_speed_multiplier[self.treasury_levels[team]],
				{reversedProgress = true, style="Treasury"}
			)
		end
	end

	EnfosWizard.data[team].treasury_level = self.treasury_levels[team]
	CustomNetTables:SetTableValue("game", "enfos_wizard_data", EnfosWizard.data)
end

function EnfosTreasury:RegisterTreasuryTooltipsForPlayer(player_id)
	local attempts = 0
	local treasury_index = 1
	Timers:CreateTimer(5, function()
		if PlayerResource:GetPlayer(player_id) then
			for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
				for _, treasury in pairs(self.treasuries[team]) do
					local chest_position = treasury.chest:GetAbsOrigin()

					CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "totems:register", {
						entindex = treasury.chest:GetEntityIndex(),
						position_x = chest_position.x,
						position_y = chest_position.y,
						position_z = chest_position.z,
						index = treasury_index,
						foreground_panel = "treasury",
						team = team,
					})

					treasury_index = treasury_index + 1
				end
			end
		elseif (attempts < DISCONNECTED_PLAYER_GIVE_UP_TIME) then
			attempts = attempts + 1
			return 1
		end
	end)
end

function EnfosTreasury:InitializeUnit(unit, yaw)
	if unit:FindAbilityByName("enfos_treasury") then
		unit:FindAbilityByName("enfos_treasury"):SetLevel(1)
	end

	if unit:FindAbilityByName("enfos_treasure_platform") then
		unit:FindAbilityByName("enfos_treasure_platform"):SetLevel(1)
	end

	unit:FaceTowards(unit:GetAbsOrigin() + RotatePosition(Vector(1, 0, 0), QAngle(0, yaw, 0), Vector(100, 0, 0)))
end

function EnfosTreasury:Start()
	self.enfos_item_pickup_listener = ListenToGameEvent("dota_item_picked_up", Dynamic_Wrap(EnfosTreasury, 'OnItemPickedUp'), self)

	Timers:CreateTimer(0, function()
		for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
			for _, treasury in pairs(self.treasuries[team]) do
				EnfosTreasury:Tick(treasury)
			end
		end
		return 1
	end)

	-- force-unlock treasuries
	Timers:CreateTimer(5 * 60, function()
		self.treasury_states[DOTA_TEAM_GOODGUYS].state = true
		self.treasury_states[DOTA_TEAM_BADGUYS].state = true

		CustomGameEventManager:Send_ServerToTeam(DOTA_TEAM_GOODGUYS, "treasury:unlocked", {team = DOTA_TEAM_GOODGUYS})
		CustomGameEventManager:Send_ServerToTeam(DOTA_TEAM_BADGUYS, "treasury:unlocked", {team = DOTA_TEAM_BADGUYS})
	end)
end

function EnfosTreasury:Tick(treasury)
	if EnfosTreasury:IsFull(treasury) then return end

	-- Keep charging up if not full
	local team = treasury.chest:GetTeam()
	local amount = EnfosTreasury.treasury_speed_multiplier[EnfosTreasury:GetTreasuryLevel(team)]
	EnfosTreasury:ModifyCharge(treasury, amount)

	local current_slot = EnfosTreasury:GetLowestTierSlot(treasury)
	local next_tier = 1 + treasury.tiers[current_slot]

	-- Create new progress bar if need be
	if (not ProgressBars:HasTimedProgressBar(treasury.chest)) then
		ProgressBars:AddTimedProgressBar(
			treasury.chest,
			(EnfosTreasury.treasury_thresholds[next_tier] - treasury.charge) / EnfosTreasury.treasury_speed_multiplier[EnfosTreasury:GetTreasuryLevel(team)],
			{reversedProgress = true, style="Treasury"}
		)
	end

	if treasury.charge >= EnfosTreasury.treasury_thresholds[next_tier] then
		EnfosTreasury:SpawnTreasure(treasury, current_slot, next_tier)
		EnfosTreasury:ModifyCharge(treasury, (-1) * EnfosTreasury.treasury_thresholds[next_tier])
	end
end

function EnfosTreasury:ModifyCharge(treasury, amount)
	treasury.charge = treasury.charge + amount
	CustomNetTables:SetTableValue("game", "enfos_treasuries", {EnfosTreasury.treasuries})
end

function EnfosTreasury:IsFull(treasury)
	return (treasury.tiers[1] >= 6 and treasury.tiers[2] >= 6 and treasury.tiers[3] >= 6)
end

function EnfosTreasury:GetLowestTierSlot(treasury)
	local lowest_tier_slot = 1
	for i = 2, 3 do
		if treasury.tiers[i] < treasury.tiers[lowest_tier_slot] then
			lowest_tier_slot = i
		end
	end

	return lowest_tier_slot
end

function EnfosTreasury:SpawnTreasure(treasury, slot, tier)

	-- Destroy any currently existing item
	if treasury.platforms[slot].item and (not treasury.platforms[slot].item:IsNull()) then
		
		local contained_item = treasury.platforms[slot].item:GetContainedItem()
		if contained_item then
			contained_item:Destroy()
		end
		
		treasury.platforms[slot].item:Destroy()
		treasury.platforms[slot].item = nil
	end

	-- Reset progress bar
	if ProgressBars:HasTimedProgressBar(treasury.chest) then
		ProgressBars:RemoveTimedProgressBar(treasury.chest)
	end

	-- Launch a random item to the platform
	local item_name = EnfosTreasury.treasury_item_list[tier][RandomInt(1, #EnfosTreasury.treasury_item_list[tier])]

	local item
	if IsNeutralItem(item_name) then
		local container = DropNeutralItemAtPositionForHero(item_name, treasury.chest:GetAbsOrigin(), treasury.platforms[slot], GetNeutralItemTier(item_name)-1, true)
		item = container:GetContainedItem()
		container:RemoveSelf()
	else
		item = CreateItem(item_name, nil, nil)
	end
	treasury.platforms[slot].item = CreateItemOnPositionForLaunch(treasury.chest:GetAbsOrigin(), item)
	item:LaunchLootInitialHeight(false, 100, 350, 0.9, treasury.platforms[slot]:GetAbsOrigin())
	item:SetPurchaseTime(0)

	item.treasury_item = true
	item:GetContainer().treasury_item = true

	treasury.chest:EmitSound("Enfos.TreasureLaunch")
	treasury.chest:StartGestureWithPlaybackRate(ACT_DOTA_IDLE_RARE, 2.0)

	Timers:CreateTimer(0.9, function()
		EnfosTreasury:UpdatePlatformTier(treasury, slot, tier)

		treasury.platforms[slot]:EmitSound("Enfos.TreasureImpactTier"..tier)

		local impact_pfx = ParticleManager:CreateParticle("particles/ui/ui_generic_treasure_impact.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(impact_pfx, 0, treasury.platforms[slot]:GetAbsOrigin())
		ParticleManager:SetParticleControl(impact_pfx, 1, treasury.platforms[slot]:GetAbsOrigin())
		ParticleManager:SetParticleControl(impact_pfx, 15, EnfosTreasury.treasure_colors[tier])
	end)
end

function EnfosTreasury:UpdatePlatformTier(treasury, slot, tier)
	local platform = treasury.platforms[slot]
	platform:SetModel(EnfosTreasury.treasury_platform_models[tier])
	platform:SetOriginalModel(EnfosTreasury.treasury_platform_models[tier])

	treasury.tiers[slot] = tier

	CustomNetTables:SetTableValue("game", "enfos_treasuries", {EnfosTreasury.treasuries})
end

function EnfosTreasury:OnItemPickedUp(keys)
	if (not keys.ItemEntityIndex) then return end

	-- Reset any newly-vacated platforms to tier 0
	for team = DOTA_TEAM_GOODGUYS, DOTA_TEAM_BADGUYS do
		for _, treasury in pairs(self.treasuries[team]) do
			for slot = 1, 3 do
				if treasury.platforms[slot].item and (not treasury.platforms[slot].item:IsNull()) then
					local contained_item = treasury.platforms[slot].item:GetContainedItem()
					if contained_item and (contained_item:GetEntityIndex() == keys.ItemEntityIndex) then
						treasury.platforms[slot].item = nil
						EnfosTreasury:UpdatePlatformTier(treasury, slot, 0)
						if ProgressBars:HasTimedProgressBar(treasury.chest) then ProgressBars:RemoveTimedProgressBar(treasury.chest) end
					end
				end
			end
		end
	end
end


function EnfosTreasury:VoteOpen(event)
	local player_id = event.PlayerID
	if not player_id then return end

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero or hero:IsNull() then return end

	local team = hero:GetTeam()
	-- self.treasury_states[DOTA_TEAM_GOODGUYS] = {voted = {}, state = false}
	if not self.treasury_states[team] then return end
	self.treasury_states[team].voted[player_id] = event.state == 1

	local votes_open = 0
	for player_id, state in pairs(self.treasury_states[team].voted) do
		if state then votes_open = votes_open + 1 end
	end

	if votes_open >= self.VOTES_REQUIRED then
		CustomGameEventManager:Send_ServerToTeam(team, "treasury:unlocked", {team = team})
		self.treasury_states[team].state = true
	end

	CustomGameEventManager:Send_ServerToTeam(team, "treasury:player_voted", {
		voter_player_id = player_id,
		voter_hero_name = hero:GetUnitName(),
		vote_state = event.state,
		votes_open = votes_open,
	})

	EventDriver:Dispatch("Enfos:Treasury:player_voted", {
		player_id = player_id,
		hero = hero,
		state = event.state == 1
	})
end


function EnfosTreasury:SendVoteState(event)
	local player_id = event.PlayerID
	if not player_id then return end

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	local team = PlayerResource:GetTeam(player_id)

	local votes_open = 0
	for player_id, state in pairs(self.treasury_states[team].voted) do
		if state then votes_open = votes_open + 1 end
	end

	CustomGameEventManager:Send_ServerToPlayer(player, "treasury:vote_state", {
		state = self.treasury_states[team].state,
		votes = self.treasury_states[team].voted or {},
		votes_required = self.VOTES_REQUIRED,
		votes_open = votes_open,
	})
end

function EnfosTreasury:SendTotemInfo(event)
	local player_id = event.PlayerID
	if not player_id then return end

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end

	self:RegisterTreasuryTooltipsForPlayer(player_id)
end

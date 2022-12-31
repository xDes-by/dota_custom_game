-- Links modifiers for each mastery

BP_Masteries = BP_Masteries or {}
MASTERY_LEVEL_MAX = 3
PRICE_FOR_RANDOM_MASTERY = 5
MAX_MASTERIES = 3

function BP_Masteries:Init()
	self.players_owned_masteries = {}
	self.players_favorite_masteries = {}
	self.players_masteries_count = {}
	self.players_current_masteries_count = {}
	for playerId = 0, 24 do
		self.players_owned_masteries[playerId] = {}
		self.players_favorite_masteries[playerId] = {}
		self.players_masteries_count[playerId] = TestMode:IsTestMode() and MAX_MASTERIES or 2
		self.players_current_masteries_count[playerId] = 0
	end
	BP_Masteries.scheduled_favourite_masteries_update = {}
	
	self.mastery_types = {
		"regeneration",
		"manafication",
		"champion",
		"brute",
		"nimble",
		"magician",
		"sprinter",
		"celerity",
		"colossus",
		"heavy_armor",
		"vampirism",
		"spell_vampirism",
		"cleave",
		"abjuration",
		"giant_reach",
		"spellcraft",
		"evasion",
		"might",
		"luck",
		"tenacity",
		"control",
		"revenge",
		"ferocity",
		"ascension",
		"glass_cannon",
		"acrobatics",
		"countermagic",
		"iron_body",
		"initiative",
		"speed_of_thought",
		"war_veteran",
		"warrior",
		"goldfinger",
		"crescendo",
		"numb",
		"quickdraw",
		"impatience",
		"summon_power",
	}

	self.cumulative_masteries = {
		revenge = true
	}

	-- Link mastery modifiers
	LinkLuaModifier("modifier_chc_mastery_initiative_buff", "heroes/masteries/initiative", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_chc_mastery_tenacity_cooldown", "heroes/masteries/tenacity", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_chc_mastery_numb_stack", "heroes/masteries/numb", LUA_MODIFIER_MOTION_NONE)

	for _, mastery_type in pairs(self.mastery_types) do
		LinkLuaModifier("modifier_chc_mastery_"..mastery_type, "heroes/masteries/"..mastery_type, LUA_MODIFIER_MOTION_NONE)
		for level = 1, MASTERY_LEVEL_MAX do
			LinkLuaModifier("modifier_chc_mastery_"..mastery_type.."_"..level, "heroes/masteries/"..mastery_type, LUA_MODIFIER_MOTION_NONE)
		end
	end
	
	CustomGameEventManager:RegisterListener("masteries:upgrade_random_mastery",function(_, keys)
		self:UpgradeRandomMastery(keys)
	end)
	CustomGameEventManager:RegisterListener("masteries:upgrade_mastery",function(_, keys)
		self:UpgradeMastery(keys)
	end)
	CustomGameEventManager:RegisterListener("masteries:player_equip_mastery",function(_, keys)
		self:PlayerEquipMastery(keys)
	end)
	CustomGameEventManager:RegisterListener("masteries:get_public_masteries",function(_, keys)
		self:UpdatePublicMasteriesForPlayer(keys.PlayerID)
	end)
	CustomGameEventManager:RegisterListener("masteries:client_request_masteries_count",function(_, keys)
		self:UpdateMaxCount_Client(keys.PlayerID)
	end)
	CustomGameEventManager:RegisterListener("masteries:set_favorite_masteries",function(_, keys)
		self:SetFavoriteMasteries(keys)
	end)
	CustomGameEventManager:RegisterListener("fortune:get_daily_bonus",function(_, keys)
		self:GetDailyBonus(keys.PlayerID)
	end)
	EventDriver:Listen("Round:round_preparation_started", BP_Masteries.CheckRoundForMasteriesApply, BP_Masteries)
	EventDriver:Listen("Round:round_ended", function(event)
		if event.round_number % 10 == 0 then
			BP_Masteries:SaveFavoriteMasteries()
		end
	end)
end


function BP_Masteries:SetFavoriteMasteries(event)
	local player_id = event.PlayerID
	if not player_id or not event.favorite_masteries then return end
	
	self.players_favorite_masteries[player_id] = {}
	for _, f_mastery in pairs(event.favorite_masteries) do 
		if self.players_owned_masteries[player_id] and self.players_owned_masteries[player_id][f_mastery] then
			self.players_favorite_masteries[player_id][f_mastery] = true
		end
	end
	if not event.b_skip_save then
		BP_Masteries.scheduled_favourite_masteries_update[player_id] = true
	end
end

function BP_Masteries:GetFavouriteMasteries(player_id, for_update)
	-- if we need masteries for update, return nothing if update wasn't scheduled (meaning no changes to favourite masteries)
	if for_update and not BP_Masteries.scheduled_favourite_masteries_update[player_id] then return {} end

	local masteries = {}
	for f_mastery_name, _ in pairs(self.players_favorite_masteries[player_id] or {}) do
		table.insert(masteries, f_mastery_name)
	end
	return masteries
end

function BP_Masteries:SaveFavoriteMasteries()
	if next(BP_Masteries.scheduled_favourite_masteries_update) == nil then return end

	local favorites_masteries_table = {}
	for player_id, _ in pairs(BP_Masteries.scheduled_favourite_masteries_update or {}) do
		local steam_id = Battlepass:GetSteamId(player_id)
		favorites_masteries_table[steam_id] = BP_Masteries:GetFavouriteMasteries(player_id)
	end

	WebApi:Send(
		"battlepass/set_favourite_masteries",
		{ players_favourite_masteries = favorites_masteries_table },
		function(data)
			print("[BP_Masteries] update complete")
		end,
		function(e)
			print("[BP_Masteries] error in favourite masteries update ", e)
		end
	)
	BP_Masteries.scheduled_favourite_masteries_update = {}
end


function BP_Masteries:UpdatePublicMasteriesForPlayer(player_id)
	if not player_id or type(player_id) ~= "number" then return end
	
	local public_masteries_data = {}
	for p_id = 0, 24 do
		if WearFunc[CHC_ITEM_TYPE_MASTERIES][p_id] then
			public_masteries_data[p_id] = {}
			for _, mastery_name in pairs(WearFunc[CHC_ITEM_TYPE_MASTERIES][p_id]) do
				table.insert(public_masteries_data[p_id], mastery_name)
			end
		end
	end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "masteries:update_public_masteries", {
		masteries = public_masteries_data;
	})
end

function BP_Masteries:UpdateEquippedMastery(playerId) 
	if not WearFunc[CHC_ITEM_TYPE_MASTERIES][playerId] then return end
	
	local public_masteries = {}
	local responceMasteryData = {}
	for index, masteryName in pairs(WearFunc[CHC_ITEM_TYPE_MASTERIES][playerId]) do
		local masteryLevel = BP_Masteries:GetMasteryLevel(playerId, masteryName)
		if masteryLevel > 0 then
			responceMasteryData[masteryName] = {
				mastery_level = masteryLevel,
				index = index,
			}
			table.insert(public_masteries, masteryName)
		end
	end
	local player = PlayerResource:GetPlayer(playerId)
	
	--Send bot mastery info to player in Demo mode, since player can control bot and equip masteries
	if TestMode:IsTestMode() and PlayerResource:IsFakeClient(playerId) then
		local host_player = PlayerResource:GetPlayer(0)
		if host_player then
			CustomGameEventManager:Send_ServerToAllClients("masteries:equip_mastery_bot", {
				masteries = responceMasteryData;
				maxCount = self.players_masteries_count[playerId],
				player_id = playerId
			})
		end
	end
	
	CustomGameEventManager:Send_ServerToPlayer(player, "masteries:equip_mastery", {
		masteries = responceMasteryData;
		maxCount = self.players_masteries_count[playerId]
	})
	
	if self:IsPreEquipTime() then return end

	CustomGameEventManager:Send_ServerToAllClients("masteries:update_public_masteries", {
		masteries = {[playerId] = public_masteries};
	})
end

function BP_Masteries:PlayerEquipMastery(data)
	local playerId = data.PlayerID
	if not playerId then return end

	if self:IsPreEquipTime() and self:IsMasteryEquipped(playerId, data.masteryName) then
		WearFunc:TakeOffItemInCategory(playerId, CHC_ITEM_TYPE_MASTERIES, data.masteryName)
	else
		WearFunc:EquipItemInCategory(playerId, CHC_ITEM_TYPE_MASTERIES, data.masteryName)
	end
end

function BP_Masteries:_UpgradeMasteryPull(playerId, tier)
	if tier > MASTERY_LEVEL_MAX then return end
	local pullTier = {}
	local counter = 0
	for _, masteryName in pairs(self.mastery_types) do
		if BP_Inventory.item_definitions[masteryName].tiers[tier - 1] then
			pullTier[counter] = masteryName
			counter = counter + 1
		end
	end
	for id, tryName in pairs(pullTier) do
		if self.players_owned_masteries[playerId][tryName] and self.players_owned_masteries[playerId][tryName][tier] then
			pullTier[id] = nil
			counter = counter - 1
		end
	end
	if counter > 0 then
		return {name = table.random(pullTier), tier = tier}
	else
		return BP_Masteries:_UpgradeMasteryPull(playerId, tier + 1)
	end
end

function BP_Masteries:GetMasteryLevel(playerId, masteryName)
	if GameMode:IsTournamentMode() then return MASTERY_LEVEL_MAX end

	local tier = 0
	local masteryData = self.players_owned_masteries[playerId][masteryName]
	if masteryData then
		for _tier, _ in pairs(masteryData) do
			if _tier > tier then tier = _tier end
		end
	end
	return tier
end

function BP_Masteries:UpdateMasteriesForPlayer(playerId, newMastery)
	if not self.players_owned_masteries[playerId] then return end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerId), "masteries:update_masteries", {
		masteries = self.players_owned_masteries[playerId],
		favorite_masteries = self.players_favorite_masteries[playerId],
		newMastery = newMastery,
	})
end

function BP_Masteries:UpdateMasteryForPlayer(playerId, masteryName, tier, cost)
	BP_Masteries:UpdateFortune(playerId)

	BP_Masteries:UpgradeMasteryBackend({
		steamId = Battlepass:GetSteamId(playerId),
		masteryName = masteryName,
		masteryLevel = tier,
		fortuneCost = cost
	}, tier == 1)

	local hero = PlayerResource:GetSelectedHeroEntity(playerId)

	local equipped_masteries = WearFunc[CHC_ITEM_TYPE_MASTERIES][playerId]
	if equipped_masteries and table.contains(equipped_masteries, masteryName) and not BP_Masteries:IsPreEquipTime() then --if mastery equipped remove old and apply new tier modifier
		BP_Masteries:TakeOffMastery(hero, masteryName)
		BP_Masteries:EquipMastery(hero, masteryName, tier)
	end
end

function BP_Masteries:UpgradeRandomMastery(data)
	local playerId = data.PlayerID
	local newMasteryData = self:_UpgradeMasteryPull(playerId, 1)
	if newMasteryData then
		local oldFotune = BP_PlayerProgress:GetFortune(playerId)
		if not oldFotune or oldFotune < PRICE_FOR_RANDOM_MASTERY then return end
		
		if not self.players_owned_masteries[playerId][newMasteryData.name] then 
			self.players_owned_masteries[playerId][newMasteryData.name] = {}
		end
		self.players_owned_masteries[playerId][newMasteryData.name][newMasteryData.tier] = true
		BP_PlayerProgress:SetFortune(playerId, oldFotune - PRICE_FOR_RANDOM_MASTERY)
		BP_Masteries:UpdateMasteryForPlayer(playerId, newMasteryData.name, newMasteryData.tier, PRICE_FOR_RANDOM_MASTERY)
	else
		print("PLAYER OWNED ALL PERKS")
	end
end

function BP_Masteries:UpgradeMastery(data)
	local playerId = data.PlayerID
	if not table.contains(self.mastery_types, data.name) then return end
	local currentLevel = self:GetMasteryLevel(playerId, data.name)
	if MASTERY_LEVEL_MAX + 1 <= currentLevel or currentLevel == 0 then return end
	if not BP_Inventory.item_definitions[data.name].tiers[currentLevel] then return end
	
	local cost = tonumber(BP_Inventory.item_definitions[data.name].tiers[currentLevel].price)
	local oldFotune = BP_PlayerProgress:GetFortune(playerId)
	
	if not oldFotune or oldFotune < cost then return end
	
	self.players_owned_masteries[playerId][data.name][currentLevel + 1] = true
	BP_PlayerProgress:SetFortune(playerId, oldFotune - cost)
	BP_Masteries:UpdateMasteryForPlayer(playerId, data.name, currentLevel + 1, cost)
end

function BP_Masteries:UpdateFortune(playerId)
	local playerFortune = BP_PlayerProgress:GetFortune(playerId)
	if not playerFortune then return end
	CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerId), "masteries:update_fortune", { fortune = playerFortune })
end

function BP_Masteries:TakeOffMastery(hero, mastery)
	if not mastery then return end
	for level = 1, MASTERY_LEVEL_MAX do
		hero:RemoveModifierByName("modifier_chc_mastery_"..mastery.."_"..level)
	end

	if hero.masteries_to_apply then
		hero.masteries_to_apply[mastery] = nil
	end
end

function BP_Masteries:CheckRoundForMasteriesApply(event)
	if event.round_number == 4 then
		local equipped_masteries = WearFunc[CHC_ITEM_TYPE_MASTERIES]
		for player_id = 0, 23 do
			local hero = PlayerResource:GetSelectedHeroEntity(player_id)
			local player_masteries = equipped_masteries[player_id]
			if player_masteries then
				for _, mastery in pairs(player_masteries) do
					self:EquipMastery(hero, mastery, BP_Masteries:GetMasteryLevel(player_id, mastery))
				end
				BP_Masteries:UpdateEquippedMastery(player_id)
			end
		end
	end
end

function BP_Masteries:EquipMastery(hero, mastery, level)
	if hero:IsAlive() then
		self:ApplyMastery(hero, mastery, level)
	else -- if hero dead wait to respawn to apply modifiers
		hero.masteries_to_apply = hero.masteries_to_apply or {}
		hero.masteries_to_apply[mastery] = level

		Timers:CreateTimer(0, function()
			if IsValidEntity(hero) and hero.masteries_to_apply and next(hero.masteries_to_apply) then
				if hero:IsAlive() then
					for mastery_name, mastery_level in pairs(hero.masteries_to_apply) do
						self:ApplyMastery(hero, mastery_name, mastery_level)
					end
					hero.masteries_to_apply = {}
				else
					return 0
				end
			end
		end)
	end
end

function BP_Masteries:ApplyMastery(hero, mastery, level)
	if self.cumulative_masteries[mastery] then
		for cumulative_level = 1, level do
			hero:AddNewModifier(hero, nil, "modifier_chc_mastery_"..mastery.."_"..cumulative_level, {})
		end
	else
		hero:AddNewModifier(hero, nil, "modifier_chc_mastery_"..mastery.."_"..level, {})
	end
end

function BP_Masteries:SetMasteriesForPlayer(playerId, data)
	if TestMode:IsTestMode() then return end
	local result = {}
	for _, masteryData in pairs(data) do
		local masteryName = masteryData.masteryName
		if masteryName and BP_Inventory.item_definitions[masteryName] then
			if not result[masteryData.masteryName] then
				result[masteryData.masteryName] = {}
			end
			result[masteryData.masteryName][masteryData.masteryLevel] = masteryData.expirationDate and masteryData.expirationDate or true
		end
	end
	self.players_owned_masteries[playerId] = result
end

function BP_Masteries:UpgradeMasteryBackend(responseData, isPermanentMastery)
	WebApi:Send(
		isPermanentMastery and "battlepass/unlock_mastery" or "battlepass/upgrade_mastery",
		responseData,
		function(data)
			local playerId = Battlepass.playerid_map[responseData.steamId]
			if data.masteries then
				BP_Masteries:SetMasteriesForPlayer(playerId, data.masteries)
			end
			if data.fortune then
				BP_PlayerProgress:SetFortune(playerId, data.fortune)
				self:UpdateFortune(playerId)
			end
			BP_Masteries:UpdateMasteriesForPlayer(playerId, responseData.masteryName)
			print("Successfully upgraded masteries for player")
		end,
		function(e)
			print("error while upgrade masteries for player: ", e)
		end
	)
end

function BP_Masteries:ChangeMaxCount(player_id, inc_value)
	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end
	
	local old_max = self.players_masteries_count[player_id]
	if not old_max then return end

	self.players_masteries_count[player_id] = old_max + inc_value
	self:UpdateMaxCount_Client(player_id)
end

function BP_Masteries:UpdateMaxCount_Client(playerId)
	if not playerId then return end
	local player = PlayerResource:GetPlayer(playerId)
	if not player then return end
	
	CustomGameEventManager:Send_ServerToPlayer(player, "masteries:update_masteries_count", {
		count = self.players_masteries_count[playerId],
		current_round = (GetMapName() == "enfos" and Enfos:GetCurrentRound() and Enfos:GetCurrentRound().round_number) or RoundManager:GetCurrentRoundNumber()
	})
end

function BP_Masteries:GetDailyBonus(player_id)
	if not player_id then return end
	local player = PlayerResource:GetPlayer(player_id)
	if not player then return end
	
	local steam_id = Battlepass:GetSteamId(player_id)
	if not steam_id then return end
	
	local earned_fortune = BP_PlayerProgress:GetEarnedFortuneToday(player_id)
	
	if earned_fortune and earned_fortune > 0 then return end
	
	WebApi:Send(
		"match/redeem_daily_fortune",
		{ 
			steamId = steam_id 
		},
		function()
			if BP_PlayerProgress.players[steam_id] and BP_PlayerProgress.players[steam_id].earned_fortune then
				BP_PlayerProgress.players[steam_id].earned_fortune = earned_fortune + 1

				BP_PlayerProgress:SetFortune(player_id, (BP_PlayerProgress:GetFortune(player_id) or 0) + 1)
				BP_Masteries:UpdateFortune(player_id)
				BP_PlayerProgress:UpdatePlayerInfo(player_id)
			end
			print("Successfully got daily bonus")
		end,
		function(e)
			print("error while got daily bonus: ", e)
		end
	)
end

function BP_Masteries:IsPreEquipTime()
	local current_round_number = GetMapName() == "enfos" and Enfos:GetCurrentRoundNumber() or RoundManager:GetCurrentRoundNumber()
	return current_round_number < 4
end

function BP_Masteries:IsMasteryEquipped(player_id, mastery_name)
	if not WearFunc[CHC_ITEM_TYPE_MASTERIES] then return false end
	if not WearFunc[CHC_ITEM_TYPE_MASTERIES][player_id] then return false end

	return table.contains(WearFunc[CHC_ITEM_TYPE_MASTERIES][player_id], mastery_name)
end

function BP_Masteries:CanBeRetrained(mastery_name)
	local item_def = BP_Inventory.item_definitions[mastery_name]

	if item_def and item_def.CanBeRetrained then
		return item_def.CanBeRetrained == 1
	end

	return true
end

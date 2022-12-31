AI_Core = AI_Core or class({})
-- this module mainly serves as a proxy for events to not spam subscriptions

function AI_Core:Init()
	self.listeners = {
		["BetManager:confirmed_bet"] = "MakeBet",
		["Spawner:all_creeps_killed"] = "PickNeutralItem",
		["Round:round_started"] = "PickAbility",
		["Round:round_preparation_started"] = "OnRoundPrepare",
		["PvpManager:new_pvp_match_decided"] = "MakeBetSentient",
		["PvpManager:pvp_countdown_ended"] = "OnPvpCountdownEnded",
		["Enfos:Treasury:player_voted"] = "OnEnfosTreasuryVoted",
	}

	for event_name, callback_name in pairs(self.listeners) do
		self[callback_name] = EventDriver:Listen(event_name, function(_, data) self:Propagate(callback_name, data) end, self)
	end

	self.bots = {}
	self.used_player_ids = {}
	self.bots_per_team = {}
end


function AI_Core:_next_player_id()
	for i = 0, 24 do
		if not PlayerResource:IsValidPlayer(i) and not self.used_player_ids[i] then
			self.used_player_ids[i] = true
			return i 
		end
	end
	return -1
end


function AI_Core:AddBots(desired_count, on_created_callback)
	local current_count = 0
	for _, team in pairs(GameMode.team_list) do
		for i = 1, GameRules:GetCustomGameTeamMaxPlayers(team) do
			local player_id = PlayerResource:GetNthPlayerIDOnTeam(team, i)
			if player_id == -1 then
				local assumed_player_id = AI_Core:_next_player_id()
				if assumed_player_id == -1 then return end
				local random_heroes_pool = HeroBuilder.hero_tables[assumed_player_id]
				table.remove_item(random_heroes_pool, "npc_dota_hero_monkey_king") -- crashes when selected by bot
				if random_heroes_pool then
					local hero_name = table.random(random_heroes_pool) 
					PrecacheUnitByNameAsync(
						hero_name,
						function()
							local new_hero = GameRules:AddBotPlayerWithEntityScript(hero_name, "Bot " .. assumed_player_id, team, "", true)
							local player = new_hero:GetPlayerOwner()
							local player_id = new_hero:GetPlayerOwnerID()

							player:SetSelectedHero(hero_name)
							player:SetAssignedHeroEntity(new_hero)
							if on_created_callback then
								ErrorTracking.Try(on_created_callback, new_hero)
							end
						end,
						nil
					)
				end
				current_count = current_count + 1
				
				if desired_count then
					if current_count >= desired_count then return true end
				end
			end
		end
	end

	return current_count > 0
end


function AI_Core:Register(player_id, modifier_contoller)
	print("[AI Core] new bot takes over player at", player_id)
	self.bots[player_id] = modifier_contoller

	if not self.bots_per_team[modifier_contoller.team] then self.bots_per_team[modifier_contoller.team] = {} end
	self.bots_per_team[modifier_contoller.team][player_id] = modifier_contoller
end


function AI_Core:Unregister(player_id)
	print("[AI Core] destroying bot at", player_id)
	self.bots[player_id] = nil

	self.bots_per_team[PlayerResource:GetTeam(player_id)][player_id] = nil
end


function AI_Core:Propagate(call_name, data)
	for player_id, controller in pairs(self.bots) do
		if controller and not controller:IsNull() then
			controller[call_name](controller, data)
		end
	end
end


function AI_Core:GetTeamNetworth(team_number)
	local networth = 0
	for _, player_id in pairs(GameMode.team_player_id_map[team_number]) do
		local hero = PlayerResource:GetSelectedHeroEntity(player_id)
		if hero and not hero:IsNull() then
			networth = networth + hero:GetNetworthCHC()
		end
	end
	return networth
end


function AI_Core:BuyAndUseItem(hero, item_name, cost)
	local item = hero:AddItemByName(item_name)
	hero:SpendGold(cost, DOTA_ModifyGold_PurchaseItem)
	Timers:CreateTimer(0, function()
		if not hero or hero:IsNull() then return end
		if not item or item:IsNull() then return end
		hero:SetCursorCastTarget(hero)
		item:OnSpellStart()
	end)
end


function AI_Core:PrintAbilities()
	for player_id, controller in pairs(self.bots) do
		print("[AI Core] abilities of", controller.hero_name)
		for i=0, controller.parent:GetAbilityCount() - 1 do
			local ability = controller.parent:GetAbilityByIndex(i)
			if ability and not ability:IsNull() then
				print(i, ability:GetAbilityName())
			else
				print(i, "empty")
			end
		end
	end
end


function AI_Core:GetEnfosSpawnPoint(player_id, team)
	local round = RoundManager:GetCurrentRound()
	if not round then return end
	if not round.spawners then return end

	local spawners = round.spawners[team]
	if not spawners then return end

	local spawn_points = spawners.spawn_points[team]
	if not spawn_points then return end

	-- either at 1 or 2 index (since lua is 1-indexed)
	local desired_spawn_point_position = spawn_points[player_id % 2 + 1].position
	return desired_spawn_point_position
end

-- DOTA_ABILITY_BEHAVIOR_NO_TARGET
function AI_Core:InferAOERadius(ability, ability_name)
	if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT) then return 0 end
	if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_PASSIVE) then return 0 end

	local base_radius_special = ability:GetSpecialValueFor("radius")
	if base_radius_special and base_radius_special > 0 then return base_radius_special end

	if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_NO_TARGET) then
		local area_of_effect_special = ability:GetSpecialValueFor("area_of_effect")
		if area_of_effect_special and area_of_effect_special > 0 then return area_of_effect_special end

		local aoe_special = ability:GetSpecialValueFor("aoe")
		if aoe_special and aoe_special > 0 then return aoe_special end
	end

	return 0
end

AI_Core:Init()

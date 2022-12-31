modifier_auto_attack = class({})

function modifier_auto_attack:IsHidden() return true end
function modifier_auto_attack:IsPurgable() return false end
function modifier_auto_attack:RemoveOnDeath() return false end

function modifier_auto_attack:GetEffectName()
	return "particles/custom/ai_ring.vpcf"
end

function modifier_auto_attack:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW 
end

if not IsServer() then return end

function modifier_auto_attack:_print(...)
	if not IsInToolsMode() or Enfos:IsEnfosMode() then return end
	print("[AI]", self.hero_name, ...)
end


function modifier_auto_attack:OnCreated()
--	print("modifier_auto_attack created:", self:GetParent():GetUnitName())
	self.parent = self:GetParent()
	self.team = self:GetParent():GetTeam()
	self.hero_name = self.parent:GetUnitName()

	self.reindex_counter = 0
	self.DEFAULT_THINK_TIME = 0.5
	self.BUILD_MIN_ABILITY_COUNT = 2
	self.MAX_MASTERIES = 2

	self.map_name = GetMapName()
	self.player_id = self.parent:GetPlayerOwnerID()
	self.player = self.parent:GetPlayerOwner()

	self.state = self.map_name == "ffa" and STATE_SOLO or STATE_DUOS
	if TestMode:IsTestMode() then self.state = TestMode.bot_ai_level end

	self.idle_counter = 0

	self.item_cursor = 1  -- starting from item component at index 0 and advancing when affordable
	self.build_name = nil
	self.items_queue = {}
	self.has_paragon_book = (self.parent.nParagonsBooksUsed or 0) > 0
	self.used_masteries = {}

	self.summons = {}

	self.talents = {} -- [10] = {ab_1, ab_2}
	self.talent_cursor = 10 -- / min level
	self.talent_count = 0 -- / 2
	-- levels at which ai should choose one talent
	-- level - available
	self.TALENTS_REQUIRED_LEVELS = {
		[10] = true,
		[15] = true,
		[20] = true,
		[25] = true,
	}

	self.random_stream = CreateUniformRandomStream(math.floor(GetSystemTimeMS()))

	self.fully_abandoned = false

	self.timed_out_abilities = {}
	self.is_fake_client = PlayerResource:IsFakeClient(self.player_id)

	for i = 0, self.parent:GetAbilityCount() - 1 do
		local ability = self.parent:GetAbilityByIndex(i)
		
		if ability and not ability:IsNull() then
			local name = ability:GetAbilityName()
			if string.find(name, "innate_") then
				self.innate = ability
			elseif string.find(name, "special_bonus_") == nil then
				if self.is_fake_client then
					self.parent:RemoveAbilityByHandle(ability)
				end
			else
				-- if any talent at given treshold is leveled, then this treshold is already consumed
				if ability:GetLevel() > 0 then
					self.TALENTS_REQUIRED_LEVELS[self.talent_cursor] = false
				end
				ability.is_talent = true
				self.talents[self.talent_cursor] = self.talents[self.talent_cursor] or {}
				table.insert(self.talents[self.talent_cursor], ability)
				self.talent_count = self.talent_count + 1
				if self.talent_count == 2 then
					self.talent_cursor = self.talent_cursor + 5
					self.talent_count = 0
				end
			end
		end
	end

	self.parent.abilities = self.parent.abilities or {} 
	self.parent.ability_count = self.parent.ability_count or 0

	if self.is_fake_client then
		for i = 0, 5 do
			local new_ability = self.parent:AddAbility("empty_"..i)
			new_ability.placeholder = i + 1
		end

		self.parent.ability_count = 0
		self.parent.abilities = {}

		if not TestMode:IsTestMode() then
			self.state = STATE_SENTIENT
			self.DEFAULT_THINK_TIME = 0.25
			self.parent:SetGold(600, true)
			PlayerResource:SetGold(self.player_id, 600, true)
		end

		PLAYER_OPTIONS_AUTO_CONFIRM_BET_ENABLED[self.player_id] = true

		if Enfos:IsEnfosMode() then
			self.parent:RespawnHero(false, false)
		else
			self.parent:AddNewModifier(self.parent, nil, "modifier_aegis", {}):SetStackCount(HeroBuilder.initial_aegis_count)
		end
	end

	Timers:CreateTimer(0.1, function()	
		self:PickAbility()
		self:PickAbility()
		self:ReindexItems()
		self:ReindexAbilities()
		self:ReindexTalents()
	end)

	AI_Core:Register(self.player_id, self)

	self.timer = Timers:CreateTimer(self.DEFAULT_THINK_TIME, function()
		return self:AI_Think()
	end)
end


function modifier_auto_attack:OnDestroy()
	self:_print("[AI] destroyed")
	AI_Core:Unregister(self.player_id)
	Timers:RemoveTimer(self.timer)
end


function modifier_auto_attack:PickMastery()
	local mastery = AI_ItemBuilder:GetNextMastery(self.build_name, self.used_masteries)
	if not mastery then return end
	table.insert(self.used_masteries, mastery)

	BP_Masteries.players_owned_masteries[self.player_id][mastery] = BP_Masteries.players_owned_masteries[self.player_id][mastery] or {}
	BP_Masteries.players_owned_masteries[self.player_id][mastery][MASTERY_LEVEL_MAX] = true

	WearFunc:EquipItemInCategory(self.player_id, CHC_ITEM_TYPE_MASTERIES, mastery)

	if #self.used_masteries >= self.MAX_MASTERIES then
		self.masteries_selected = true
	end
end


function modifier_auto_attack:OnRoundPrepare(data)
	if self.state < STATE_ABANDONED then return end
	if not self.parent or self.parent:IsNull() then end
	if not data then return end

	if data.round_number >= 4 and not self.masteries_selected and self.build_name then
		self:PickMastery()
		self:PickMastery()
	end

	if data.round_number >= 2 and not self.innate and self.build_name then
		HeroBuilder.innate_choices[self.player_id] = table.random_some(HeroBuilder.innate_ability_list, 12)
		local random_innate = AI_ItemBuilder:SelectInnate(self.build_name, HeroBuilder.innate_choices[self.player_id])
		HeroBuilder:ValidateInnate(self.player_id, random_innate)
		self.innate = random_innate
	end
end


function modifier_auto_attack:PickAbility(data)
	if self.state < STATE_ABANDONED then return end
	if not self.parent or self.parent:IsNull() then end
	
	local max_ability_count = HeroBuilder:GetMaxAbilityCountForPlayer(self.player_id)
	if #self.parent.abilities >= max_ability_count then 
		-- print("[AI] current max ability count reached!")
		return 
	end

	local abilities = HeroBuilder:GetNewAbilitySelection(self.parent)
	-- search for hero own abilities and prioritize them
	for _, ability_data in pairs(abilities) do
		local hero_owner_name = HeroBuilder.ability_hero_map[ability_data.ability_name]
		if hero_owner_name and "npc_dota_hero_" .. hero_owner_name == self.hero_name then
			-- print("[AI] selected ", ability_data.ability_name, "since it belongs to current hero - ", self.hero_name)
			HeroBuilder:AddAbility(self.player_id, ability_data.ability_name, nil, true)
			self.parent.ability_count = self.parent.ability_count + 1
			return
		end
	end
	local random_ability = table.random(abilities)
	if not random_ability then return end
	-- print("[AI] randomed ability: ", random_ability.ability_name, "for", self.hero_name)
	HeroBuilder:AddAbility(self.player_id, random_ability.ability_name, nil, true)
	self.parent.ability_count = self.parent.ability_count + 1
end


function modifier_auto_attack:PickNeutralItem(data)
	if not self.parent or self.parent:IsNull() then end
	if self.state < STATE_ABANDONED then return end
	-- make sure neutral items module has enough time to do it's thing
	Timers:CreateTimer(1, function()
		if not self.parent or self.parent:IsNull() then end
		local choices = ItemLoot.player_choices[self.player_id]
		if not choices or #choices == 0 then return end

		local present_item = self.parent:GetItemInSlot(DOTA_ITEM_NEUTRAL_SLOT)
		if present_item and not present_item:IsNull() then
			self.parent:SellItem(present_item)
		end

		ItemLoot:BossRewardChosen({
			PlayerID = self.player_id,
			itemNumber = RandomInt(1, #choices)
		})
	end)
end


function modifier_auto_attack:MakeBet(data)
	if not self.parent or self.parent:IsNull() then end
	if self.state < STATE_ABANDONED then return end
	if self.state == STATE_SENTIENT then return end
	if not data.bet_hero or data.bet_hero:IsNull() then return end
	if data.bet_hero:GetTeam() ~= self.team or data.bet_player_id == self.player_id then return end

	local bet_possible_gold = self.parent:GetGold()

	BetManager:ConfirmBet({
		PlayerID = self.player_id,
		value = bet_possible_gold * (data.bet_value / (data.original_gold / 2)),
		wish_team_id = data.target_team,
	})
end


function modifier_auto_attack:MakeBetSentient(data)
	if Enfos:IsEnfosMode() then return end

	if self.state < STATE_SENTIENT then return end
	if not self.parent:IsAlive() then return end
	local teams = data.teams

	if self.team == teams[1] or self.team == teams[2] then
		print("[AI] participating in duel, skipping bet", self.hero_name)
		return
	end

	local team_1_networth = AI_Core:GetTeamNetworth(teams[1])
	local team_2_networth = AI_Core:GetTeamNetworth(teams[2])

	local max_possible_bet = self.parent:GetGold() / 2
	local difference = math.abs(team_1_networth - team_2_networth)

	--[[
		bet strategy follows:
		 - take unsigned difference between teams networth
		 - use that difference relative to max expected difference as a multiplier to possible bet
		 - random that multiplier from min to max values
		 - min and max values are between base and doubled multiplier, not more then 0.7 - 0.99 and not less then 0.2-0.4
	]] 
		
	local percentage = math.min(math.max(difference / BET_MAX_EXPECTED_DIFFERENCE, 0.1), 0.5)
	local percentage_max = math.min(math.max(2 * difference / BET_MAX_EXPECTED_DIFFERENCE, 0.2), 0.7)
	local bet_data = {
		PlayerID = self.player_id,
		wish_team_id = teams[self.random_stream:RandomInt(1, 2)],
		value = math.floor(RandomFloat(percentage, percentage_max) * max_possible_bet)
	}

	-- update unconfirmed next frame so bet manager has time to init
	Timers:CreateTimer(0, function()
		BetManager:BetUpdate(bet_data)
	end)

	-- finish bet
	Timers:CreateTimer(RandomInt(1, 10), function()
		BetManager:ConfirmBet(bet_data)
	end)
end


function modifier_auto_attack:OnPvpCountdownEnded(data)
	if not Enfos:IsEnfosMode() then return end
	for _, hero in pairs(EnfosPVP.dueling_heroes[self.team]) do
		if self.parent == hero then
			self.targets = self:GetTargets()
			return
		end
	end
end


function modifier_auto_attack:SetBuild(scanned_ai_types)
	local primary_attribute = self.parent:GetPrimaryAttribute()
	if self.build_name then return end

	if scanned_ai_types[AI_ABILITY_TYPE_SUMMON] >= 1 then
		self.build_name = "summoner"
	elseif primary_attribute == DOTA_ATTRIBUTE_STRENGTH then
		self.build_name = "tank"
	elseif primary_attribute == DOTA_ATTRIBUTE_INTELLECT then
		self.build_name = "caster"
	elseif primary_attribute == DOTA_ATTRIBUTE_AGILITY then
		self.build_name = "attacker"
	end
	self:_print("[AI] bot selected build: ", self.build_name)
	self.items_queue = AI_ItemBuilder:GetBuildQueue(self.parent, self.build_name)
end


function modifier_auto_attack:ReindexItems()
	self.items = {}
	local free_slots = {}
	for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_6 do
		local item = self.parent:GetItemInSlot(i)
		if item and not item:IsNull() then
			local item_name = item:GetAbilityName()

			if COMPENSATION_ITEMS[item_name] then
				-- Bots can sell items only if player abandoned
				if self.state >= STATE_ABANDONED then 
					self.parent:SellItem(item)
				end
			elseif UNCASTABLE_ITEMS[item_name] then
				-- skipping if item shouldn't be casted by bot
			elseif not item:IsPassive() then
				table.insert(self.items, {
					ability = item,
					params = {
						item:GetAbilityTargetTeam(),
						item:GetAbilityTargetType(),
						item:GetAbilityTargetFlags(),
						AI_Core:InferAOERadius(item, item_name)
					}
				})
			end
		else
			free_slots[i] = true
		end
	end

	-- check if we have items in backpack
	if not next(free_slots) then return end

	for i = DOTA_ITEM_SLOT_7, DOTA_ITEM_SLOT_9 do
		local item = self.parent:GetItemInSlot(i)
		if item and not item:IsNull() and not item:IsNeutralDrop() then
			if COMPENSATION_ITEMS[item:GetAbilityName()] then
				self.parent:SellItem(item)
			else
				local free_slot = next(free_slots)
				if not free_slot then return end
				self.parent:SwapItems(i, free_slot)
				free_slots[free_slots] = nil
			end
		end
	end
end


function modifier_auto_attack:_GetAbilityAIType(ability, ability_name)
	if ability:IsPassive() then return AI_ABILITY_TYPE_PASSIVE end
	if table.contains(SUMMON_ABILITIES_KV, ability_name) then return AI_ABILITY_TYPE_SUMMON end
	return AI_ABILITY_TYPE_ACTIVE
end


function modifier_auto_attack:_TryUpgradeAbility(ability, current_level, ability_slot)
	if self.state < STATE_ABANDONED then return end
	if self.parent:GetAbilityPoints() > 0 and ability:GetLevel() < ability:GetMaxLevel() 
	and ability:GetHeroLevelRequiredToUpgrade() <= current_level then
		-- print("[AI] upgrading: ", ability:GetAbilityName(), self.hero_name, ability:IsHidden())
		self.parent:UpgradeAbility(ability)
	end
end


function modifier_auto_attack:ReindexAbilities()
	self.abilities = {}
	local ability_types = {
		[AI_ABILITY_TYPE_ACTIVE] = 0,
		[AI_ABILITY_TYPE_PASSIVE] = 0,
		[AI_ABILITY_TYPE_SUMMON] = 0,
	}
	local level = self.parent:GetLevel()
	for i = 0, self.parent:GetAbilityCount() - 1 do
		local ability = self.parent:GetAbilityByIndex(i)
		if ability and not ability:IsNull() and not ability:IsHidden() and not ability.is_talent then
			local ability_name = ability:GetAbilityName()
			local special_behaviour_filter = AI_SpecialBehaviours:Scan(self.parent, ability, ability_name)
			self:_TryUpgradeAbility(ability, level, i)
			local ability_ai_type = self:_GetAbilityAIType(ability, ability_name)

			ability_types[ability_ai_type] = ability_types[ability_ai_type] + 1

			if not ability:IsPassive() and special_behaviour_filter then
				table.insert(self.abilities, {
					ability = ability,
					ability_ai_type = ability_ai_type,
					original_hero = HeroBuilder.ability_hero_map[ability_name],
					params = {
						ability:GetAbilityTargetTeam(),
						ability:GetAbilityTargetType(),
						ability:GetAbilityTargetFlags(),
						AI_Core:InferAOERadius(ability, ability_name)
					}
				})
			end
		end
	end	

	-- only start building a build if we have at least 5 abilities to judge from
	if #self.parent.abilities >= self.BUILD_MIN_ABILITY_COUNT 
	and #self.items_queue == 0 and self.item_cursor ~= -1 then
		self:SetBuild(ability_types)
	end
end

function modifier_auto_attack:ReindexTalents()
	if self.state < STATE_ABANDONED then return end
	if not self.parent or self.parent:IsNull() then return end

	local current_level = self.parent:GetLevel()
	local ability_points = self.parent:GetAbilityPoints()
	local free_talents = current_level >= TALENTS_FREE_LEVEL

	if ability_points <= 0 then return end
	if next(self.talents) == nil then return end

	if free_talents then
		-- print("[AI] free talents leveling activated", self.hero_name)
		for level, talents in pairs(self.talents) do
			for i, talent in pairs(talents) do
				if talent and not talent:IsNull() then
					if talent:GetLevel() < talent:GetMaxLevel() then
						self.parent:UpgradeAbility(talent)
						ability_points = ability_points - 1
						if ability_points <= 0 then break end
					else
						table.remove(self.talents[level], i)
					end
				end
			end
			-- talents at certain level were fully leveled
			if #self.talents[level] == 0 then
				-- print("[AI] fully leveled talents at level: ", self.hero_name, level)
				self.talents[level] = nil
			end
		end
	else
		for min_level, available in pairs(self.TALENTS_REQUIRED_LEVELS) do
			if available and min_level <= current_level then
				local talent = self.talents[min_level][RandomInt(1, 2)]
				-- print("[AI] leveling talent at", min_level, self.hero_name)
				self.parent:UpgradeAbility(talent)
				self.TALENTS_REQUIRED_LEVELS[min_level] = false
				ability_points = ability_points - 1

				if ability_points <= 0 then return end
			end
		end
	end
end


function modifier_auto_attack:TryAbilityCast(ability_data, units)
	if not self.parent or self.parent:IsNull() or not self.parent:IsAlive() then return false end
	local ability = ability_data.ability
	if not ability or ability:IsNull() then return false end
	if ability:GetLevel() == 0 then return false end
	if not ability:IsFullyCastable() then return false end

	local ability_name = ability:GetAbilityName()
	if self.timed_out_abilities[ability_name] then return false end
	if DUEL_ONLY_ITEMS[ability_name] and not self.parent:IsDueling() then return false end

	local has_point_behavior = ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_POINT)
	local has_no_target_behavior = ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_NO_TARGET)
	-- assume that no target and point target spells require enemies to work if they don't specify any target team
	if (has_point_behavior or has_no_target_behavior) and ability_data.params[1] == 0 then
		ability_data.params[1] = DOTA_UNIT_TARGET_TEAM_ENEMY 
		if ability_data.params[2] == 0 then
			ability_data.params[2] = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC 
		end
	end
	local current_location = self.parent:GetAbsOrigin()
	-- cast range + inferred radius
	local base_cast_range = ability:GetCastRange(current_location, self.parent)
	local inferred_cast_range = ability_data.params[4]
	-- use cast range if present or attempt to use inferred one, based on ability specials
	cast_range = base_cast_range > 0 and base_cast_range or inferred_cast_range
	
	if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_AOE) then
		cast_range = cast_range + ability:GetAOERadius()
	end

	self:TimeoutAbility(ability_name, 1 + (ability:GetCastPoint() or 0) + (ability:GetChannelTime() or 0))

	for _, unit in pairs(units) do
		-- using goto to skip casting logic on invalid units, to avoid increase in indent
		-- there's way too much stuff involved to efficiently move per-unit cast into separate function
		if not unit or unit:IsNull() or not unit:IsAlive() then goto skip end

		local filter_result = UnitFilter(
			unit, ability_data.params[1], ability_data.params[2], ability_data.params[3], self.team
		)

		local unit_distance = (current_location - unit:GetAbsOrigin()):Length2D()

		local special_behaviour_filter = AI_SpecialBehaviours:Cast(
			self.parent, ability, ability_name, ability_data, filter_result, unit_distance
		)

--		print(cast_range, unit_distance)
		if (filter_result == UF_SUCCESS and (cast_range >= unit_distance or cast_range <= 0) and special_behaviour_filter) or ability_data.params[1] == 0 then
			if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_AUTOCAST) and not ability:GetAutoCastState() then
				CastToggleAutoCastAbility(self.parent, ability)
			end
			if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) then
				self:_print("casting unit target", ability_name, "at", unit:GetUnitName())
				CastTargetedAbility(self.parent, unit, ability)
				if not ability or ability:IsNull() then return self.DEFAULT_THINK_TIME end
				return ability:GetCastPoint() or self.DEFAULT_THINK_TIME / 2

			elseif has_point_behavior then
				self:_print("casting point", ability_name, "at", unit:GetAbsOrigin())
				CastPositionalAbility(self.parent, unit:GetAbsOrigin(), ability)
				if not ability or ability:IsNull() then return self.DEFAULT_THINK_TIME end
				return ability:GetCastPoint() or self.DEFAULT_THINK_TIME / 2

			elseif has_no_target_behavior then
				if ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_TOGGLE) then
					if ability:GetToggleState() then
						self:TimeoutAbility(ability_name, 30) 
						return false 
					end
					self:_print("casting toggle", ability_name)
					CastToggleAbility(self.parent, ability)

				elseif ability:HasBehavior(DOTA_ABILITY_BEHAVIOR_IMMEDIATE) then
					self:_print("casting immediate", ability_name)
					CastUntargetedAbility(self.parent, ability)
				else
					self:_print("casting no target", ability_name)
					CastUntargetedAbility(self.parent, ability)
				end
				if not ability or ability:IsNull() then return self.DEFAULT_THINK_TIME end
				return ability:GetCastPoint() or self.DEFAULT_THINK_TIME / 2
			end
		end
		::skip::
	end
	self:_print("cast failed", ability_name)
	return false
end


function modifier_auto_attack:CheckConnection()
	if TestMode:IsTestMode() then return end

	if GameMode:HasPlayerAbandoned(self.player_id) then
		print("[AI] is abandoned: ", self.hero_name)
		if self.state == STATE_SOLO then 
			print("[AI] player abandoned, destroying")
			self.parent:RemoveModifierByName("modifier_aegis")
			self.fully_abandoned = true
			Summon:KillAllForPlayer(self.player_id)
			AI_Core:Unregister(self.player_id)
			return
		else
			self.state = STATE_ABANDONED

			for i, player_id in pairs(GameMode.team_player_id_map[self.team]) do
				if not GameMode:HasPlayerAbandoned(player_id) then return end
			end
			print("[AI] team abandoned!", self.team)
			self.parent:RemoveModifierByName("modifier_aegis")
			self.fully_abandoned = true
			Summon:KillAllForPlayer(self.player_id)
			AI_Core:Unregister(self.player_id)
			return
		end
	end
end


function modifier_auto_attack:_FindAttackTarget(units)
	for _, unit in pairs(units) do
		if unit and not unit:IsNull() and unit:IsAlive() then
			local result = UnitFilter(
				unit, 
				DOTA_UNIT_TARGET_TEAM_ENEMY, 
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
				DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 
				self.team
			)
			if result == UF_SUCCESS then
				return unit
			end
		end
	end
end


function modifier_auto_attack:PurchaseItems()
	if self.state < STATE_ABANDONED then return end
	if not self.parent or self.parent:IsNull() or not self.parent:IsAlive() then end
	if self.parent:IsDueling() then return end
	
	local current_gold = self.parent:GetGold() - CONST_HOLD_GOLD
	if current_gold < 0 then return end

	if self.item_cursor == -1 then
		-- emulate paragon book purchase
		if not self.has_paragon_book and current_gold > CONST_PARAGON_BOOK_GOLD_COST then
			-- print("[AI] purchasing paragon book", self.hero_name)
			self.parent:SpendGold(CONST_PARAGON_BOOK_GOLD_COST, DOTA_ModifyGold_PurchaseItem)
			self.parent:AddNewModifier(self.parent, nil, "modifier_item_upgrade_book", {})
			self.parent.nParagonsBooksUsed = self.parent.nParagonsBooksUsed and self.parent.nParagonsBooksUsed + 1 or 1
			self.has_paragon_book = true	
			Timers:CreateTimer(1, function() self:PickAbility() end)
			return
		end
		-- purchase books if item build is finished
		if current_gold > CONST_BOOK_GOLD_COST * 2 and self.build_name then
			-- print("[AI] purchasing stats book", self.hero_name)
			local book_name = AI_ItemBuilder:GetNextBookName(self.build_name)
			if book_name then
				AI_Core:BuyAndUseItem(self.parent, book_name, CONST_BOOK_GOLD_COST)
			end
			return
		end
		return 
	end
	if not self.items_queue then return end
	if next(self.items_queue) == nil then return end

	local current_item_name, current_item_queue = next(self.items_queue)
	if not current_item_name then return end

	local item_component = current_item_queue[self.item_cursor]
	if not item_component then return end

	if item_component == "item_aghanims_shard" and self.parent:HasShard() then
		self.items_queue[current_item_name] = nil
		self.item_cursor = 1
		return
	end

	if item_component == "item_ultimate_scepter_2" and self.parent:HasScepter() then
		self.items_queue[current_item_name] = nil
		self.item_cursor = 1
		return
	end

	local current_gold = self.parent:GetGold()
	local item_cost = GetItemKV(item_component, "ItemCost")

	if item_cost and item_cost <= current_gold then
		-- print("[AI]", self.hero_name, "purchased", current_item)
		local item = self.parent:AddItemByName(item_component)
		if item and not item:IsNull() then
			item:SetPurchaseTime(0)
			self.parent:SpendGold(item_cost, DOTA_ModifyGold_PurchaseItem)
			self.item_cursor = self.item_cursor + 1

			-- move to next item in queue
			if self.item_cursor > #current_item_queue then
				self.items_queue[current_item_name] = nil
				self.item_cursor = 1

				if next(self.items_queue) == nil then
					self.item_cursor = -1
				end
			end
		end
	end
end


function modifier_auto_attack:TimeoutAbility(ability_name, duration)
	self.timed_out_abilities[ability_name] = true
	Timers:CreateTimer(duration or 2, function()
		self.timed_out_abilities[ability_name] = false
	end)
end


-- [Enfos] runs when bot can't find anything to attack in it's own range for a set of time 
function modifier_auto_attack:SeekObjective()
	-- move to center of 1v1 arena if bot participates in it
	-- move to further spot of group arena if group pvp is ongoing
	-- move to creeps spawn point, decided from player id (will always be uneven since there's 5 players though)
	if Enfos:IsPvpActive() then
		if GameMode:GetModeState() == GAME_STATE_ENFOS_PVP_TEAM then
			-- take further countdown spot as a target to move to
			local parent_origin = self.parent:GetAbsOrigin()

			local spots = EnfosPVP.group_arena_countdown_spots
			local desired_spot = spots[1]

			if (spots[2] - parent_origin):Length2D() > (spots[1] - parent_origin):Length2D() then
				desired_spot = spots[2]
			end

			self.parent:MoveToPositionAggressive(desired_spot)
		elseif self.parent:HasModifier("modifier_hero_dueling") then
			self.parent:MoveToPositionAggressive(EnfosPVP.single_arena_center)
		end
	else
		local spawn_point_position = AI_Core:GetEnfosSpawnPoint(self.player_id, self.team)
		if not spawn_point_position then return end

		if (spawn_point_position - self.parent:GetAbsOrigin()):Length2D() < 1000 then return end

		self.parent:MoveToPositionAggressive(spawn_point_position)
	end
end


-- [Enfos] runs when any player votes to unlock treasury, makes bots also vote after random delay
function modifier_auto_attack:OnEnfosTreasuryVoted(event)
	if PlayerResource:IsFakeClient(event.player_id) then return end
	if not event.state then return end
	if event.hero:GetTeam() ~= self.team then return end
	if self.treasury_voted then return end

	Timers:CreateTimer(RandomInt(5, 20), function()
		if not self or self:IsNull() then return end
		if EnfosTreasury.treasury_states[self.team].state then return end
		self.treasury_voted = true

		CustomChat:MessageToTeam(
			"%%Bot_VotedForTreasury%%", self.team, self.player_id
		)
		EnfosTreasury:VoteOpen({
			PlayerID = self.player_id,
			state = 1
		})
	end)
end


function modifier_auto_attack:_GetTargets()
	if Enfos:IsEnfosMode() then
		-- get heroes participating in Enfos PVP, either 2 for 1v1 duel or full teams for 5v5
		if Enfos:IsPvpActive() then
			if GameMode:GetModeState() == GAME_STATE_ENFOS_PVP_TEAM then
				local heroes = table.shallowcopy(EnfosPVP.dueling_heroes[Enfos.enemy_team[self.team]])
				
				if EnfosPVP.dueling_heroes[self.team] then
					for _, hero in pairs(EnfosPVP.dueling_heroes[self.team]) do
						table.insert(heroes, hero)
					end
				end
				
				return heroes
			elseif self.parent:HasModifier("modifier_hero_dueling") then
				return {EnfosPVP.dueling_heroes[ Enfos.enemy_team[self.team] ][1], EnfosPVP.dueling_heroes[self.team][1]}
			end
		-- or get creeps list for PVE
		else
			-- Enfos creeps go in 2 lanes, and effective splitting of separated bots is a bit too complex
			-- so we just skip search there and order bots to move towards portals
			self:SeekObjective()
		end
	else
		-- same for non-Enfos basically, get pvp participants when this bot is in pvp, or get creeps
		if self.parent:HasModifier("modifier_hero_dueling") then
			local heroes = {}
			local pvp_players = PvpManager:GetAllPvpPlayers()
			for _, player_id in pairs(pvp_players) do
				local hero = PlayerResource:GetSelectedHeroEntity(player_id)
				if hero and not hero:IsNull() then
					table.insert(heroes, hero)
				end
			end
			return heroes
		else
			local spawner = RoundManager:GetCurrentRoundSpawner(self.team)
			if spawner and spawner.current_creeps and #spawner.current_creeps > 0 then
				return spawner.current_creeps
			end
		end
	end
	-- fallback to usual search in case possible target lists above were somehow invalid
	-- technically should happen very rarely
	return FindUnitsInRadius(
		self.team, 
		self.parent:GetOrigin(), 
		self.parent, 
		1700, 
		DOTA_UNIT_TARGET_TEAM_BOTH,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_CLOSEST, 
		false 
	), true
end

function modifier_auto_attack:GetTargets(counter)
	-- fetch base targets if:
	-- > there are no known targets
	-- > or every 10 ticks
	-- > or no ticks counter (forced base targets cache reset)
	if not self.base_targets or (counter and counter % 10 == 0 or true) then
		self.base_targets, sorted = self:_GetTargets()
	end
	if not self.base_targets then return {} end
	if sorted then return self.base_targets end

	local caster_origin = self.parent:GetAbsOrigin()

	table.sort(self.base_targets, function(l, r) 
		if not l or l:IsNull() then return false end
		if not r or r:IsNull() then return true end
		return (caster_origin - l:GetAbsOrigin()):Length2D() < (caster_origin - r:GetAbsOrigin()):Length2D()
	end)
	return self.base_targets
end


function modifier_auto_attack:AI_Think()
	if not self or self:IsNull() then return end
	if self.fully_abandoned then return end
	local parent = self:GetParent()
	local on_base = parent:HasModifier("modifier_hero_refreshing")
	if parent:HasModifier("modifier_enfos_wizard_casting_spell") then return self.DEFAULT_THINK_TIME end

	if self.state == STATE_PASSIVE then return self.DEFAULT_THINK_TIME end

	if not parent or parent:IsNull() then return self.DEFAULT_THINK_TIME end
	if not parent:IsAlive() then return self.DEFAULT_THINK_TIME end

	self.reindex_counter = self.reindex_counter + 1

	-- search for targets every 5 ticks
	if self.reindex_counter % 5 == 0 and not on_base then
		self.targets = self:GetTargets(self.reindex_counter)
	end
	
	-- reindex available stuff every 20 ticks
	if self.reindex_counter == 20 then
		self:ReindexItems()
		self:ReindexAbilities()
		self:ReindexTalents()
		self.summons = Util:FindAllOwnedUnits(self.player_id) or {}
		self.reindex_counter = 0
	end
	self:PurchaseItems()
	
	self:CheckConnection()
	if on_base then return self.DEFAULT_THINK_TIME end

	if not self.targets or #self.targets == 0 then return self.DEFAULT_THINK_TIME end

	-- order our summons to attack regardless of caster states
	local attack_target = self:_FindAttackTarget(self.targets)

	if not attack_target or attack_target:IsNull() then return self.DEFAULT_THINK_TIME end

	for _, summon in pairs(self.summons) do
		if summon and not summon:IsNull() and summon:IsAlive() then
			summon:MoveToTargetToAttack(attack_target)
		end
	end
	
	local current_ability = parent:GetCurrentActiveAbility() 
	if current_ability then 
		return self.DEFAULT_THINK_TIME 
	end

	self.parent:MoveToTargetToAttack(attack_target)

	if not self.parent:IsStunned() and not self.parent:IsHexed() then
		if not self.parent:IsSilenced() then
			for _, ability_data in pairs(self.abilities or {}) do
				local cast_point = self:TryAbilityCast(ability_data, self.targets) 
				if cast_point then
					return cast_point
				end
			end
		end
		
		if not self.parent:IsMuted() then
			for _, item_data in pairs(self.items or {}) do
				local cast_point = self:TryAbilityCast(item_data, self.targets) 
				if cast_point then
					return cast_point
				end
			end
		end	
	end

	return self.DEFAULT_THINK_TIME
end


function modifier_auto_attack:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end


function modifier_auto_attack:GetModifierIncomingDamage_Percentage()
	if self.fully_abandoned then return 5000 end
	return 0
end




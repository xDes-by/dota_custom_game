function CDOTA_BaseNPC:IsMonkeyClone()
	return (self:HasModifier("modifier_monkey_king_fur_army_soldier") or self:HasModifier("modifier_wukongs_command_warrior"))
end

function CDOTA_BaseNPC:IsBoundsEnforced()
	return not (self:IsMonkeyClone() or self:HasModifier("modifier_cosmetic_pet") or self:HasModifier("modifier_hidden_caster_dummy"))
end

function CDOTA_BaseNPC:IsMainHero()
	return self and (not self:IsNull()) and self:IsRealHero() and (not self:IsTempestDouble()) and (not self:IsMonkeyClone())
end

function CDOTA_BaseNPC:RemoveAbilityForEmpty(ability_name)
	local ability = self:FindAbilityByName(ability_name)
	if not ability then return end
	local index = ability:GetAbilityIndex()
	-- if ability is hidden, and has secondary ability that is unhidden, 
	-- then secondary is active and we should swap placeholder with it
	-- to preserve keybinds slots
	if ability:IsHidden() then
		local hero = ability:GetCaster()
		local linked_abilities = HeroBuilder.linked_abilities[ability_name]
		local linked_unhidden = false
		for _, linked_ability_name in pairs(linked_abilities or {}) do
			local linked_ability = hero:FindAbilityByName(linked_ability_name)
			if linked_ability and not linked_ability:IsHidden() then
				linked_unhidden = true
				local linked_index = linked_ability:GetAbilityIndex()
				if linked_index < index then
					index = linked_ability:GetAbilityIndex()
				end
				break
			end
		end
	end
	ability:Disable()
	if index <= 5 then -- only swap if we get assigned hotkey, otherwise pointless
		self:SwapAbilities(ability_name, "empty_"..index, false, false)
	end

	ability:SetRemovalTimer()
end

function CDOTA_BaseNPC:AddNewAbility(ability_name)
	local ability = self:AddAbility(ability_name)
	ability:ClearFalseInnateModifiers()
	return ability
end

function CDOTA_BaseNPC:AddEndChannelListener(listener)
	local endChannelListeners = self.EndChannelListeners or {}
	self.EndChannelListeners = endChannelListeners
	local index = #endChannelListeners + 1
	endChannelListeners[index] = listener
end

--restructure abilities so hotkeys preserve
function CDOTA_BaseNPC:RemoveAbilityWithRestructure(ability_name)
	local ability = self:FindAbilityByName(ability_name)
	if not ability then return end

	ability:Disable()
	
	local index = ability:GetAbilityIndex()
	local placeholder_name = "empty_"..index

	self:SwapAbilities(ability_name, placeholder_name, false, false)

	ability:SetRemovalTimer()

	if index > 5 then return end
	Timers:CreateTimer(function()
		--reindexing entire ability tree 
		for i = index, 25 do
			local next_ability = self:GetAbilityByIndex(i + 1)
			if next_ability and not next_ability.placeholder and not next_ability:IsHidden() then
				local next_ability_name = next_ability:GetAbilityName()
				if not next_ability_name:find("special_bonus") then
					self:SwapAbilities(placeholder_name, next_ability_name, false, true)
				end
			end
		end
	end)
end


function CDOTA_BaseNPC_Hero:HeroLevelUpWithMinValue(min_level, play_particles)
	local needLevels = min_level + 1 - self:GetLevel()
	local totalLevels = needLevels > 0 and needLevels or 1
	for _ = 1, totalLevels do
		self:HeroLevelUp(play_particles)
	end
end

-- Has Aghanim's Shard
function CDOTA_BaseNPC:HasShard()
	if not self or self:IsNull() then return end

	return self:HasModifier("modifier_item_aghanims_shard")
end

-- Talent handling
function CDOTA_BaseNPC:HasTalent(talent_name)
	if not self or self:IsNull() then return end

	local talent = self:FindAbilityByName(talent_name)
	if talent and talent:GetLevel() > 0 then return true end
end


function CDOTA_BaseNPC:FindTalentValue(talent_name, key)
	if self:HasTalent(talent_name) then
		local value_name = key or "value"
		return self:FindAbilityByName(talent_name):GetSpecialValueFor(value_name)
	end
	return 0
end


function CDOTA_BaseNPC:IsBossCreep()
	return self.is_boss == true
end


function CDOTA_BaseNPC:IsClashRoshan()
	return (self:GetUnitName() == "npc_dota_roshan" or self:GetUnitName() == "npc_dota_duos_roshan")
end


function CDOTA_BaseNPC:IsDueling()
	return self:HasModifier("modifier_hero_dueling")
end


function CDOTA_BaseNPC:GetCreepGoldAmplification()
	local creep_gold_amp = 0

	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetModifierCreepGoldAmplification then
			creep_gold_amp = creep_gold_amp + modifier:GetModifierCreepGoldAmplification()
		end
	end

	return creep_gold_amp
end


function CDOTA_BaseNPC:GetBetGoldAmplification()
	local bet_gold_amp = 0

	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetModifierBetGoldAmplification then
			bet_gold_amp = bet_gold_amp + modifier:GetModifierBetGoldAmplification()
		end
	end

	return bet_gold_amp
end


function CDOTA_BaseNPC:GetDuelGoldAmplification()
	local duel_gold_amp = 0

	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetModifierDuelGoldAmplification then
			duel_gold_amp = duel_gold_amp + modifier:GetModifierDuelGoldAmplification()
		end
	end

	return duel_gold_amp
end


function CDOTA_BaseNPC:GetTalentValue(talent_name)
	local talent = self:FindAbilityByName(talent_name)
	if talent and talent:GetLevel() >= 1 then return talent:GetSpecialValueFor("value") end

	return 0
end


function CDOTA_BaseNPC:HasCooldownOnItems()
	if self:IsNull() or (not self:HasInventory()) then return true end

	for slot = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
		local item = self:GetItemInSlot(slot)
		if item and item:GetCooldownTimeRemaining() > 0 then
			return true
		end
	end

	return false
end

local auto_ready_ignored_abiliites = {
	["high_five_custom"] = true,
}

function CDOTA_BaseNPC:HasCooldownOnAbilities()

	for i = 0, self:GetAbilityCount() - 1 do
		local ability = self:GetAbilityByIndex(i)
		if ability and ability:GetCooldownTimeRemaining() > 0 and not auto_ready_ignored_abiliites[ability:GetName()]then
			return true
		end
	end
	return false
end

CDOTA_BaseNPC.GetStatusResistanceHero = CDOTA_BaseNPC.GetStatusResistance
function CDOTA_BaseNPC:GetStatusResistance()
	if self:IsHero() then
		return self:GetStatusResistanceHero()
	end

	local status_resistance_total = 1
	for _, modifier in pairs(self:FindAllModifiers()) do
		if modifier.GetModifierStatusResistanceStacking then
			status_resistance_total = status_resistance_total * (1 - modifier:GetModifierStatusResistanceStacking() / 100)
		end
	end
	return 1 - status_resistance_total
end

function CDOTA_BaseNPC:RegisterManuallySpentAttributePoint()
	local current = self.manually_spent_ability_points or 0
	self.manually_spent_ability_points = current + 1
end


function CDOTA_BaseNPC:GetManuallySpentAttributePoints()
	return self.manually_spent_ability_points or 0
end

function CDOTA_BaseNPC:IncrementCurseCount()
	local curse_modifier = self:FindModifierByName("modifier_loser_curse")

	-- Wait before hero alive to add modifier
	if self:IsReincarnating() then
		Timers:CreateTimer(1, function() 
			self:IncrementCurseCount()
			return
		end)
	end

	if not curse_modifier then
		curse_modifier = self:AddNewModifier(self, nil, "modifier_loser_curse", nil)
	end

	if not curse_modifier then return end

	curse_modifier:IncrementStackCount()

	local player_id = self:GetPlayerOwnerID()
	CustomGameEventManager:Send_ServerToAllClients("player_debuff_loser", {
		playerId = player_id, 
		loserCount = curse_modifier:GetStackCount()
	})

	local bear = self:GetSummonedBear()
	if bear then
		local modifier = bear:AddNewModifier(self, nil, "modifier_loser_curse", nil)
		if modifier then
			modifier:SetStackCount(curse_modifier:GetStackCount())
		end
	end
end

function CDOTA_BaseNPC:DecrementCurseCount()
	local curse_modifier = self:FindModifierByName("modifier_loser_curse")
	if not curse_modifier then return end

	curse_modifier:DecrementStackCount()
	local curse_count = curse_modifier:GetStackCount()

	local player_id = self:GetPlayerOwnerID()
	CustomGameEventManager:Send_ServerToAllClients("player_debuff_loser", {
		playerId = player_id, 
		loserCount = curse_count,
		decrement = true
	})

	if curse_count <= 0 then
		curse_modifier:Destroy()
	end

	local bear = self:GetSummonedBear()
	if bear then
		if curse_count > 0 then
			bear:AddNewModifier(self, nil, "modifier_loser_curse", nil):SetStackCount(curse_count)
		else
			bear:RemoveModifierByName("modifier_loser_curse")
		end
	end
end

function CDOTA_BaseNPC:RemoveCurse()
	self:RemoveModifierByName("modifier_loser_curse")

	local player_id = self:GetPlayerOwnerID()
	CustomGameEventManager:Send_ServerToAllClients("player_debuff_loser", {
		playerId = player_id, 
		loserCount = 0,
		decrement = true
	})

	local bear = self:GetSummonedBear()
	if bear then
		bear:RemoveModifierByName("modifier_loser_curse")
	end
end

function CDOTA_BaseNPC:ReduceCooldowns(amount)
	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local ability = self:GetAbilityByIndex(i)
		if ability then
			ability:ReduceCooldown(amount)
		end
	end

	for i = 0, DOTA_ITEM_MAX - 1 do
		local item = self:GetItemInSlot(i)
		if item then
			item:ReduceCooldown(amount)
		end
	end
end


function CDOTA_BaseNPC:RefreshIntrinsicModifiers()
	for i = 0, DOTA_MAX_ABILITIES - 1 do
		local ability = self:GetAbilityByIndex(i)
		if ability and not ability:IsNull() and ability:GetLevel() > 0 then
			ability:RefreshIntrinsicModifier()
		end
	end
end

function CDOTA_BaseNPC:FindItem(item_name, in_inventory, in_backpack, in_stash)
	local item_result

	if in_inventory then
		for i = 0, 5 do
			local item = self:GetItemInSlot(i)

			if item and item:GetAbilityName() == item_name then
				item_result = item
				break
			end
		end
	end

	if in_backpack then
		for i = 6, 8 do
			local item = self:GetItemInSlot(i)

			if item and item:GetAbilityName() == item_name then
				item_result = item
				break
			end
		end
	end

	if in_stash then
		for i = DOTA_STASH_SLOT_1, DOTA_STASH_SLOT_6 do
			local item = self:GetItemInSlot(i)

			if item and item:GetAbilityName() == item_name then
				item_result = item
				break
			end
		end
	end

	return item_result
end

function CDOTA_BaseNPC:OverdueItemsInInventory()
	local current_time = GameRules:GetGameTime()
	
	for i = 0, 5 do
		local item = self:GetItemInSlot(i)
		if item and current_time - item:GetPurchaseTime() < 10 then
			item:SetPurchaseTime(current_time - 11)
		end
	end
end

function CDOTA_BaseNPC:ApplyStatusResistance(value)
	return value * (1 - self:GetStatusResistance())
end

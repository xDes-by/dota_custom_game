--[[
Ability Charge Lib written specifically for CHClash by Sanctus Animus

Charges can be set in kv
"ChargeInitial"	"1"			// starting value for charges
"ChargeCount"		"7 8 9 12" 	// this is sufficient
"ChargeCooldown" 	"25" 		// optional, if not specified, ability cooldown will be used instead
"ChargeIncrement"	"2"			// optional, sets value added to charge count conditionally (time or round based), defaults to 1.
								// however, increment is clamped to max charges, so it can't break anything really
Cooldown can still be specified for tooltip, yet this key has higher priority

Currently 2 types of charges are support:
> TIME_BASED - default charge type, replenishes with time flow
> ROUND_BASED - increments only when round ends
"ChargeType"	"ROUND_BASED"

Note, that ChargeCooldown (and it's predecessor AbilityCooldown) change their behavior based on charge type.
Thus, for round-based ChargeCooldown means amount of rounds needed to restore charge increment value.
Meaning, that you can set your ability to restore 3 charges every 4 rounds with that in kv

By default "refresh" type abilities and items also restore charges, this behavior can be disabled however with kv:
"IsRefreshable"		"0"
Or by overriding "IsRefreshable" function of ability.

Charge count can be influenced by talents with AbilitySpecial
"03"
{
	"var_type"				"FIELD_INTEGER"
	"AbilityCharges"		""
	"LinkedSpecialBonus"	"special_bonus_custom_morphling_6" // talent name, must have field 'value'
	"ChargeOperation"		"Add" // or "Set", optional, defaults to "Set", decides what to do with talent value (add to max or replace max)
}

If ability have Valve charges, they must be disabled to proceed
"AbilityCharges"				""
"AbilityChargeRestoreTime"		""
^^ will not work if charges added with scepter

After ability is initialized, following methods are added to it:
	ability:GetCurrentCharges() --> int, returns current charges
	ability:SetCurrentCharges(new_count: int), sets current charges
	ability:SetMaxCharges(new_count: int, bRefillToMax: bool), sets maximum charges to ability, optionally refilling current to match max
	ability:GetMaxCharges() --> int, returns max charges (takes into account ability level, talents, scepters etc.)
	ability:GetChargeIncrement() --> int, return charge increment value, that is used for restoring ability charges conditionally (time or round based)
	ability:IncrementCharges(), increments charge count of ability by increment value
	ability:DecrementCharges(), reduces charge count by 1 (NOTICE, that this func does not use increment value but const 1)
	ability:GetChargeCooldown() --> int, returns charge cooldown of charges of this ability on it's current level
	ability:GetCurrentChargeCooldown() --> int, returns remaining cooldown time for charge
	ability:GetChargeType() --> charge_type_enum, returns conversed charge type of ability
	ability:_RefreshCharges(), restores all charges on ability and resets charge cooldown
Any of those functions can be overriden in lua abilities

Lib also provides following callbacks to Charge-based ability:
	ability:OnChargeSpent(prev_count: int, new_count: int), when ability spends charge
	ability:OnChargesEnded(), when ability spends last charge
	ability:OnChargeGained(prev_count: int, new_count: int), when ability gains charge
	ability:OnChargesRefill(max_charges: int), when ability restores all charges

Please refrain from trying to set ability cooldown on charge-based abilities, since it is synced and will be reset

Example of KV for charge-based ability,
 - round-based restoration
 - starts with 2 charges, max of 4
 - incrementing 2 charges every 3 rounds
 - charges cannot be refreshed

{
	"ChargeType"		"ROUND_BASED"

	"ChargeInitial"		"2"
	"ChargeCount" 		"4"

	"ChargeCooldown" 	"3"
	"ChargeIncrement"	"2"

	"IsRefreshable"		"0"
}

]]

COOLDOWN_REDUCTION_CLAMP = 80

TIME_BASED = 1
ROUND_BASED = 2

local charge_type_enum = {
	["TIME_BASED"] = TIME_BASED,
	["ROUND_BASED"] = ROUND_BASED,
}

if not AbilityCharges then
	AbilityCharges = {}
	AbilityCharges.__index = AbilityCharges

	LinkLuaModifier("modifier_charge_controller", "libraries/modifiers/modifier_charge_controller", LUA_MODIFIER_MOTION_NONE)
	LinkLuaModifier("modifier_charge_counter", "libraries/modifiers/modifier_charge_counter", LUA_MODIFIER_MOTION_NONE)

	print("[AbilityCharges] initialized AbilityCharges")
	-- AbilitySpecial field name for scepter charge upgrade
	AbilityCharges.scepter_ability_specials = {
		"max_charges_scepter", "max_charges", "scepter_max_charges"
	}

	AbilityCharges.shard_ability_specials = {
		"max_charges_shard", "max_charges", "shard_max_charges"
	}
	-- AbilitySpecial field name for talent charge change
	AbilityCharges.talent_charge_special = "AbilityCharges"

	AbilityCharges.charge_type = "ChargeType"
	AbilityCharges.default_charge_type = TIME_BASED

	AbilityCharges.charge_increment = "ChargeIncrement"

	AbilityCharges.default_increment = 1
	AbilityCharges.default_refreshable_state = 1

	AbilityCharges.round_end_listeners = {}

	ListenToGameEvent("dota_player_learned_ability", function(event) AbilityCharges:OnPlayerLearnedAbility(event) end, nil)
end


function ParseKVString(kv_string, string_type)
	if not kv_string then return nil end
	values = string.split(kv_string)
	casted_values = {}
	for _, value in pairs(values) do
		if string_type then
			table.insert(casted_values, value)
		else
			table.insert(casted_values, tonumber(value))
		end
	end
	return casted_values
end

function PrintKV(kv)
	if not kv then return "nil" end
	kv_string = ""
	for i, x in pairs(kv) do
		kv_string = kv_string .. x .. " / "
	end
	return kv_string
end


function AbilityCharges:InitHero(hero)
	if not hero or hero:IsNull() then return end
	if hero:HasModifier("modifier_charge_controller") then return end
	hero:AddNewModifier(hero, nil, "modifier_charge_controller", {})
end

function AbilityCharges:FindChargeKVModifiers(charge_modifier, kv)
	local ability_special = kv['AbilitySpecial'] 
	local ability_values = kv['AbilityValues'] 

	if ability_special then
		for key, value in pairs(ability_special) do
			-- since there are multiple scepter charges names, gotta check them all and check for scepter
			-- since max_charges also present without it
			for _, spec_name in pairs(self.scepter_ability_specials) do
				if value[spec_name] then
					if value['RequiresScepter'] then
						charge_modifier.scepter_max = ParseKVString(value[spec_name])
					end
				end
			end

			for _, spec_name in pairs(self.shard_ability_specials) do
				if value[spec_name] then
					if value['RequiresShard'] then
						charge_modifier.shard_max = ParseKVString(value[spec_name])
					end
				end
			end
			-- also link talent name to check in
			-- and operation (Set charges or Add them to existing)
			if value[self.talent_charge_special] then
				charge_modifier.talent_charge_special = value['LinkedSpecialBonus']
				if value['ChargeOperation'] or value['LinkedSpecialBonusOperation'] then
					charge_modifier.talent_operation = value['ChargeOperation'] or value['LinkedSpecialBonusOperation']
				else
					charge_modifier.talent_operation = 'Set'
				end
				if value['AbilityChargeRestoreTime'] then
					charge_modifier.talent_domain = 'AbilityChargeRestoreTime'
				end
			end
		end
	end

	if ability_values then
		for value_name, value in pairs(ability_values) do
			if type(value) == "table" then
				
				for _, spec_name in pairs(self.scepter_ability_specials) do
					if value_name == spec_name then
						if value['RequiresScepter'] then
							charge_modifier.scepter_max = ParseKVString(value.value)
						end
					end
				end

				for _, spec_name in pairs(self.shard_ability_specials) do
					if value_name == spec_name then
						if value['RequiresShard'] then
							charge_modifier.shard_max = ParseKVString(value.value)
						end
					end
				end

				if value_name == self.talent_charge_special then
					charge_modifier.talent_charge_special = value['LinkedSpecialBonus']
					if value['ChargeOperation'] or value['LinkedSpecialBonusOperation'] then
						charge_modifier.talent_operation = value['ChargeOperation'] or value['LinkedSpecialBonusOperation']
					else
						charge_modifier.talent_operation = 'Set'
					end
					if value['AbilityChargeRestoreTime'] then
						charge_modifier.talent_domain = 'AbilityChargeRestoreTime'
					end
				end

			end


		end
	end
end


function AbilityCharges:GetAbilityCooldown(ability)
	local max_level = ability:GetMaxLevel()
	local cooldown_table = {}
	for level=0, max_level do
		local cd_on_level = ability:GetCooldown(level)
		if not cd_on_level then
			break
		end
		table.insert(cooldown_table, cd_on_level)
	end
	return cooldown_table
end

function AbilityCharges:OnAbilityAdded(ability)
	if not ability or ability:IsNull() then return end
	if ability.charge_modifier then return end
	
	local hero = ability:GetCaster()

	if hero and not hero:IsAlive() then 
		Timers:CreateTimer(0.5, function()
			AbilityCharges:OnAbilityAdded(ability)
		end)
	end

	AbilityCharges:InitHero(hero)

	local ability_owner = ability:GetCaster()
	local ability_kv = ability:GetAbilityKeyValues()

	local ability_charge_count = ParseKVString(ability_kv['ChargeCount'])
	local ability_charge_init = ParseKVString(ability_kv['ChargeInitial'])
	local ability_charge_cooldown = ParseKVString(ability_kv['ChargeCooldown'])
	local ability_charge_type = ParseKVString(ability_kv["ChargeType"], true)
	local ability_charge_increment = ParseKVString(ability_kv["ChargeIncrement"])
	local ability_refreshable = ParseKVString(ability_kv["IsRefreshable"])

	if not ability_charge_increment then
		ability_charge_increment = {AbilityCharges.default_increment}
	end

	if not ability_refreshable then
		ability_refreshable = AbilityCharges.default_refreshable_state
	else
		ability_refreshable = tonumber(ability_refreshable[1])
	end
	-- set default charge type to TIME_BASED if not set, or if value is not supported
	if not ability_charge_type then
		ability_charge_type = AbilityCharges.default_charge_type
	elseif charge_type_enum[ability_charge_type[1]] then
		ability_charge_type = charge_type_enum[ability_charge_type[1]]
	else
		ability_charge_type = AbilityCharges.default_charge_type
	end

	if not ability_charge_count then return end

	local mod = ability_owner:AddNewModifier(ability_owner, ability, "modifier_charge_counter", {charge_type = ability_charge_type})
	if not mod or mod:IsNull() then return end -- getting some weird errors that `mod` is nil here, wth
	mod.GetTexture = ability.GetAbilityTextureName

	mod.max_count = ability_charge_count[1]
	mod.max_count_kv = ability_charge_count
	mod.charge_cooldown_kv = ability_charge_cooldown
	mod.charge_type = ability_charge_type
	mod.charge_increment = ability_charge_increment
	mod.refreshable = ability_refreshable

	self:FindChargeKVModifiers(mod, ability_kv)

	ability.charge_modifier = mod

	AbilityCharges:SetCallbacks(ability)

	if ability_charge_init then
		ability:SetCurrentCharges(ability_charge_init[1])
	else
		ability:SetCurrentCharges(ability_charge_count[1])
	end

	local cooldown = ability:GetChargeCooldown()

	if ability_charge_init and ability_charge_init[1] == ability_charge_count[1] then
		mod:SetDuration(cooldown, true)
		mod:SetRemainingTimeCustom(cooldown)
	else
		mod:SetDuration(-1, true)
		mod:SetRemainingTimeCustom(-1)
	end

	ability.current_round_used_charges = 0
end


function AbilityCharges:OnAbilityRemoved(ability)
	
end


function of_level_or_last(kv_table, level, value_mod_func)
	local value
	if level == 0 then
		value = kv_table[1]
	elseif kv_table[level] then
		value = kv_table[level]
	else
		value = kv_table[#kv_table]
	end
	if value_mod_func then
		return value_mod_func(value)
	else
		return value
	end
end


function AbilityCharges:SetCallbacks(ability)
	-- items already have those defined by default
	if not ability:IsItem() then
		-- get current present charges
		ability.GetCurrentCharges = ability.GetCurrentCharges or function(self)
			if not ability.charge_modifier or ability.charge_modifier:IsNull() then return 0 end
			return ability.charge_modifier:GetStackCount()
		end
		-- set current charges
		ability.SetCurrentCharges = ability.SetCurrentCharges or function(self, count)
			if not ability.charge_modifier or ability.charge_modifier:IsNull() then return end
			ability.charge_modifier:SetStackCount(count)
		end
	end
	-- set max charges
	ability.SetMaxCharges = ability.SetMaxCharges or function(self, count, restore_to_max)
		if not ability.charge_modifier or ability.charge_modifier:IsNull() then return end
		ability.charge_modifier.max_count = count
		if restore_to_max then
			ability:SetCurrentCharges(count)
		end
	end

	ability.GetChargeIncrement = ability.GetChargeIncrement or function(self)
		if not ability.charge_modifier or ability.charge_modifier:IsNull() then return end
		return of_level_or_last(ability.charge_modifier.charge_increment)
	end

	-- increase ability charges by increment value (default to 1, can be changed)
	ability.IncrementCharges = ability.IncrementCharges or function(self, count)
		local mod = ability.charge_modifier
		if not mod or mod:IsNull() then return end
		mod.passed_rounds = 0
		local current = ability:GetCurrentCharges()
		count = count or ability:GetChargeIncrement()
		AbilityCharges:SetCharges(ability, current, current + count)
	end

	-- decrease ability charges by 1
	ability.DecrementCharges = ability.DecrementCharges or function(self)
		if not ability.charge_modifier or ability.charge_modifier:IsNull() then return end
		
		if ability:GetCaster():HasModifier("modifier_demo_free_spells") then return end

		local current = ability:GetCurrentCharges()
		AbilityCharges:SetCharges(ability, current, current - 1)

		ability.current_round_used_charges = ability.current_round_used_charges + 1
	end

	-- get max charges based on ability level
	ability.GetMaxCharges = ability.GetMaxCharges or function(self)
		local caster = ability:GetCaster()
		local charge_modifier = ability.charge_modifier
		if not charge_modifier or charge_modifier:IsNull() then return 0 end
		local max_count_kv = charge_modifier.max_count_kv
		local max_count_scepter = charge_modifier.scepter_max
		local max_count_shard = charge_modifier.shard_max

		local talent_name = charge_modifier.talent_charge_special
		local talent_value

		if caster:HasShard() and max_count_shard then
			max_count_kv = max_count_shard
		end

		if caster:HasScepter() and max_count_scepter then
			max_count_kv = max_count_scepter
		end

		local ability_level = ability:GetLevel()

		if talent_name then
			local talent_ability = caster:FindAbilityByName(talent_name)
			if talent_ability and talent_ability:GetLevel() ~= 0 then
				local talent_value = talent_ability:GetSpecialValueFor("value")
				if charge_modifier.talent_operation == "Set" then
					return talent_value
				elseif charge_modifier.talent_operation == "Add" then
					return of_level_or_last(
						max_count_kv, 
						ability_level, 
						function(value) return value + talent_value end
					)
				end
			end
		end

		return of_level_or_last(max_count_kv, ability_level)
	end
	-- get charge cooldown based on ability level
	ability.GetChargeCooldown = ability.GetChargeCooldown or function(self)
		if not ability.charge_modifier or ability.charge_modifier:IsNull() then return -1 end

		local cooldown_kv = ability.charge_modifier.charge_cooldown_kv
		local talent_name = ability.charge_modifier.talent_charge_special
		local talent_value
		local ability_level = ability:GetLevel()
		local cooldown_reduction = 1

		if ability.charge_modifier.charge_type == ROUND_BASED then return -1 end

		if not cooldown_kv then
			local charge_restore_time = ability:GetAbilityChargeRestoreTime(-1)
			if charge_restore_time > 0 then
				return charge_restore_time
			end

			return self:GetEffectiveCooldown(-1)
		end

		local caster = ability:GetCaster()
		if caster then
			cooldown_reduction = caster:GetCooldownReduction()
			if cooldown_reduction >= COOLDOWN_REDUCTION_CLAMP then cooldown_reduction = COOLDOWN_REDUCTION_CLAMP end
		end

		local result_modifier = function(value) return value end

		-- Modeled after max charges above, but used the default kv value names so there are minimal changes in that regard.
		-- Just make sure to add "AbilityCharges"		"" in npc_abilities_custom.txt in the appropriate ability and also
		-- in the ability's specials that are relevant so that the special will be activated and checked in this callback.
		if talent_name and ability.charge_modifier.talent_domain == 'AbilityChargeRestoreTime' then
			local talent_ability = caster:FindAbilityByName(talent_name)
			if talent_ability and talent_ability:GetLevel() ~= 0 then
				talent_value = talent_ability:GetSpecialValueFor('value')
				if ability.charge_modifier.talent_operation == 'SPECIAL_BONUS_SUBTRACT' then
					result_modifier = function(value) return value - talent_value end
				elseif ability.charge_modifier.talent_operation == 'SPECIAL_BONUS_ADD' then
					result_modifier = function(value) return value + talent_value end
				end
			end
		end
		return of_level_or_last(cooldown_kv, ability_level, result_modifier) * cooldown_reduction
	end

	-- get time remaining til new charge is given
	ability.GetCurrentChargeCooldown = ability.GetCurrentChargeCooldown or function(self)
		local mod = ability.charge_modifier
		if not mod or mod:IsNull() then return -1 end
		if mod.charge_type == ROUND_BASED then
			return mod.passed_rounds
		end
		return mod:GetRemainingTimeCustom()
	end

	-- refill charges to max value
	ability._RefreshCharges = ability._RefreshCharges or function(self, forced)
		if not ability.charge_modifier or ability.charge_modifier:IsNull() then return end

		-- check refreshable state for charges, but always allow round-based charges to refresh on duels
		if ability:GetChargeType() == TIME_BASED 
		or (ability:GetChargeType() == ROUND_BASED and not ability:GetCaster():IsDueling()) then
			if ability.charge_modifier.refreshable == 0 and not forced then return end
			if not ability:IsRefreshable() and not forced then return end
		end

		ability.current_round_used_charges = 0

		ability.charge_modifier:SetDuration(0, true)
		ability.charge_modifier:SetRemainingTimeCustom(0)
		ability:SetCurrentCharges(ability:GetMaxCharges())

		if ability.charge_modifier.charge_type == ROUND_BASED then
			ability:SetActivated(true)
		end
	end

	-- get charge type (ROUND_BASED OR TIME_BASED)
	ability.GetChargeType = ability.GetChargeType or function(self)
		if not ability.charge_modifier or ability.charge_modifier:IsNull() then return nil end
		return ability.charge_modifier.charge_type
	end
end


function AbilityCharges:OnAbilityExecuted(ability)
	local current_charges = ability:GetCurrentCharges()
	local charge_modifier = ability.charge_modifier
	-- callback for spent charge if present
	if ability.OnChargeSpent then
		ErrorTracking.Try(ability.OnChargeSpent, ability, current_charges, current_charges-1)
	end

	if ability:GetMaxCharges() == current_charges then -- prevent instant refill of last charge
		charge_modifier:SetDuration(ability:GetChargeCooldown(), true)
		charge_modifier:SetRemainingTimeCustom(ability:GetChargeCooldown())
	end

	ability:DecrementCharges()

	if ability:GetCurrentCharges() == 0 then
		--callback to inform that ability spent all charges
		if ability.OnChargesEnded then
			ErrorTracking.Try(ability.OnChargesEnded, ability)
		end

		if ability.charge_modifier.charge_type == ROUND_BASED and not ability:IsItem() then
			ability:SetActivated(false)
		end

		ability:StartCooldown(charge_modifier:GetRemainingTimeCustom())
	else
		Timers:CreateTimer(0.05, function() -- ending cooldown with some delay, cause original ability cooldown is not applied yet
			ability:EndCooldown()
		end)
	end
end

function AbilityCharges:SetCharges(ability, prev_stack_count, new_stack_count)	
	local charge_modifier = ability.charge_modifier

	if charge_modifier and not prev_stack_count then
		prev_stack_count = charge_modifier:GetStackCount()
	end

	-- callback to inform that ability gained charge
	if ability.OnChargeGained then
		ErrorTracking.Try(ability.OnChargeGained, ability, prev_stack_count, new_stack_count)
	end

	local max_charges = ability:GetMaxCharges()

	if ability.charge_modifier.charge_type == ROUND_BASED then
		max_charges = math.max(0, max_charges - ability.current_round_used_charges)
	end

	-- gotta not go into the negatives!
	new_stack_count = math.max(0, new_stack_count)
	-- gotta respect charge limits!
	if new_stack_count > max_charges then
		new_stack_count = max_charges
	end

	ability:SetCurrentCharges(new_stack_count)

	if new_stack_count > 0 then
		ability:EndCooldown()
	end

	if new_stack_count > 0 and not ability:IsActivated() then
		local caster = ability:GetCaster()
		local ability_name = ability:GetAbilityName()

		-- if caster is on fountain, do not re-activate ability which is in fountain blacklist
		if IsValidEntity(caster) then
			if caster:HasModifier("modifier_hero_refreshing") then
				if not HeroBuilder.fountain_disabled_skills[ability_name] then
					ability:SetActivated(true)
				end
			else
				ability:SetActivated(true)
			end
		end
	end

	if new_stack_count == ability:GetMaxCharges() then
		-- callback to inform that all charges are refilled
		if ability.OnChargesRefilled then
			ErrorTracking.Try(ability.OnChargesRefilled, ability, new_stack_count)
		end

		charge_modifier:SetDuration(0, true)
		charge_modifier:SetRemainingTimeCustom(0)
	elseif charge_modifier:GetRemainingTimeCustom() <= 0 then
		charge_modifier:SetDuration(ability:GetChargeCooldown(), true)
		charge_modifier:SetRemainingTimeCustom(ability:GetChargeCooldown())
	end
end


function AbilityCharges:RefreshCharges(hero, forced)
	for i = 0, hero:GetAbilityCount() - 1 do
		local ability = hero:GetAbilityByIndex(i)
		if ability and ability:IsRefreshable() and ability.charge_modifier then
			ability:_RefreshCharges(forced)
		end
	end
end


function AbilityCharges:ReduceChargesCooldown(target, reduction)
	for i = 0, target:GetAbilityCount() - 1 do
		local ability = target:GetAbilityByIndex(i)
		if ability and not ability:IsNull() and ability.charge_modifier then
			ability:ReduceCooldown(reduction)
		end
	end
end


function AbilityCharges:InitAllAbilities(hero)
	for i = 0, hero:GetAbilityCount() - 1 do
		local ability = hero:GetAbilityByIndex(i)
		if ability then
			AbilityCharges:OnAbilityAdded(ability)
		end
	end
end


function AbilityCharges:RegisterRoundEndListener(modifier)
	modifier.passed_rounds = 0
	table.insert(self.round_end_listeners, modifier)
end

function AbilityCharges:OnRoundEnded()
	for index, modifier in pairs(self.round_end_listeners) do
		modifier:OnRoundEnded()
	end
end

function AbilityCharges:OnPlayerLearnedAbility(event)
	-- Wait 1 frame since sometimes ability still not leveled-up when event comes
	Timers:CreateTimer(0.01, function()
		local hero = PlayerResource:GetSelectedHeroEntity(event.PlayerID)
		if not hero then return end
			
		local ability = hero:FindAbilityByName(event.abilityname)
		if not ability or not ability.charge_modifier then return end

		if ability.charge_modifier.charge_type == ROUND_BASED then
			local new_charges = ability:GetMaxCharges() - ability.current_round_used_charges
			local current_charges = ability:GetCurrentCharges()

			if new_charges > 0 and current_charges < new_charges then
				AbilityCharges:SetCharges(ability, current_charges, new_charges)
				ability:EndCooldown()
			end
		else
			if ability:GetCurrentCharges() < ability:GetMaxCharges() and ability:GetCurrentChargeCooldown() <= 0 then
				ability:_RefreshCharges(true)
			end
		end
	end)
end


EventDriver:Listen("HeroBuilder:hero_init_finished", function(event)
	AbilityCharges:InitHero(event.hero)
end)


EventDriver:Listen("Round:round_ended", function(event)
	AbilityCharges:OnRoundEnded()
end)


EventDriver:Listen("HeroBuilder:ability_added", function(event)
	AbilityCharges:OnAbilityAdded(event.ability)
end)


EventDriver:Listen("Hero:scepter_received", function(event)
	for index = 0, event.hero:GetAbilityCount() - 1 do
		ability = event.hero:GetAbilityByIndex(index)
		-- update charges abilities that are off-cooldown to update max charges count in case any of them have it with scepter
		if ability and not ability:IsNull() and ability.charge_modifier then
			if ability.charge_modifier.charge_type == ROUND_BASED then
				local new_charges = ability:GetMaxCharges() - ability.current_round_used_charges
				local current_charges = ability:GetCurrentCharges()

				if new_charges > 0 and current_charges < new_charges then
					AbilityCharges:SetCharges(ability, current_charges, new_charges)
					ability:EndCooldown()
				end
			else
				if ability:GetCurrentCharges() < ability:GetMaxCharges() and ability:GetCurrentChargeCooldown() <= 0 then
					ability:_RefreshCharges(true)
				end
			end
		end
	end
end)


EventDriver:Listen("Hero:scepter_lost", function(event)
	for index = 0, event.hero:GetAbilityCount() - 1 do
		ability = event.hero:GetAbilityByIndex(index)
		-- if hero removed scepter, need to remove leftover charges as well, in case there are
		if ability and not ability:IsNull() and ability.charge_modifier then
			if ability:GetCurrentCharges() > ability:GetMaxCharges() then
				ability:_RefreshCharges(true)
			end
		end
	end
end)

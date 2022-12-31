-- shard abilities system [Planned]
ShardAbilities = ShardAbilities or class({})

CONST_SHARD_COST = 1400

function ShardAbilities:Init()
	self.shard_owners = {}

	EventDriver:Listen("Hero:shard_received", ShardAbilities.OnShardAdded, ShardAbilities)

	EventDriver:Listen("HeroBuilder:ability_added", ShardAbilities.OnAbilityAdded, ShardAbilities)
	EventDriver:Listen("HeroBuilder:ability_removed", ShardAbilities.OnAbilityRemoved, ShardAbilities)
end


function ShardAbilities:OnShardAdded(event)
	local hero = event.hero
	if not hero then return end

	if not ShardAbilities:HasShardUpgrades(hero) then
		ShardAbilities:RefundShard(hero)
		return true
	end

	local player_id = hero:GetPlayerOwnerID()
	if not player_id then return end

	self.shard_owners[player_id] = hero

	-- abilities which are hero specific and should be spell specific
	-- if shard is bought AFTER the ability
	for ability_name, modifier_name in pairs(HeroBuilder.shard_hero_specific) do
		local ability = hero:FindAbilityByName(ability_name)
		if ability and not ability:IsNull() then
			hero:AddNewModifier(hero, ability, modifier_name, {})
		else
			-- this makes sure the modifier is not hero specific
			Timers:CreateTimer(0.1, function()		-- sometimes we don't catch the modifier
				if hero and not hero:IsNull() then
					hero:RemoveModifierByName(modifier_name)
				end
			end)
		end
	end	

	for i, ability_name in pairs(hero.abilities or {}) do
		local ability = hero:FindAbilityByName(ability_name)
		if ability then
			Timers:CreateTimer(0, function()
				if hero and not hero:IsNull() and ability and not ability:IsNull() then
					if ability:GetLevel() > 0 then
						ability:RefreshIntrinsicModifier()
					end
					self:_OnAbilityAdded(hero, player_id, ability)
				end
			end)
		end
	end
end


function ShardAbilities:OnAbilityAdded(event)
	if not self.shard_owners[event.player_id] then return end

	local hero = event.hero
	local ability = event.ability
	if not hero or not hero:HasShard() then return end
	if not ability or ability:IsNull() then return end

	-- abilities which are hero specific and should be spell specific
	-- if shard is bought BEFORE the ability
	local ability_name = ability:GetAbilityName()
	if HeroBuilder.shard_hero_specific[ability_name] then
		hero:AddNewModifier(hero, ability, HeroBuilder.shard_hero_specific[ability_name], {})
	end

	Timers:CreateTimer(0.1, function()
		self:_OnAbilityAdded(hero, event.player_id, ability)
	end)
end


function ShardAbilities:_OnAbilityAdded(hero, player_id, ability)
	local shard_ability_name = ability:GetKeyValue("AbilityDraftUltShardAbility")
	if not shard_ability_name then print(ability:GetAbilityName(), "has no shard ability!") return end
	if type(shard_ability_name) ~= "string" then return end

	local present_ability = hero:FindAbilityByName(shard_ability_name)

	if present_ability then
		present_ability:CancelRemovalTimer(1, false)
		return 
	end

	local shard_ability = hero:AddAbility(shard_ability_name)
	-- somehow shard_ability can be nil here, according to script errors
	if not shard_ability then return end 
	shard_ability:SetLevel(1)
	shard_ability:SetHidden(false)
	ability.shard_ability_name = shard_ability_name
	
	-- For some reason the modifier has to be readded to the unit to work
	if HeroBuilder.shard_modifier_reapply[shard_ability_name] then
		shard_ability:ClearFalseInnateModifiers(true)
		hero:AddNewModifier(hero, shard_ability, HeroBuilder.shard_modifier_reapply[shard_ability_name], {})
	end

	Timers:CreateTimer(0.15, function()
		HeroBuilder:SetAbilityToSlot(hero, shard_ability)
		HeroBuilder:RefreshAbilityOrder(player_id)
	end)
	AbilityCharges:OnAbilityAdded(shard_ability)
end


function ShardAbilities:OnAbilityRemoved(event)
	local ability = event.ability
	if not ability or ability:IsNull() then return end
	if not ability.shard_ability_name then return end

	event.hero:RemoveAbilityWithRestructure(ability.shard_ability_name)
	HeroBuilder:RefreshAbilityOrder(event.player_id)
end


function ShardAbilities:HasShardUpgrades(hero)
	if not hero or hero:IsNull() then return end

	local player_id = hero:GetPlayerOwnerID()
	if not player_id then return end

	if hero.received_aghs_blessing then return true end
	if hero:HasAbility("innate_aghanims_blessing") or hero:HasModifier("modifier_innate_aghanims_blessing") then return true end
	if ScepterAbilities.prevented_purchase[player_id] then return true end
	if not PLAYER_OPTIONS_AGHS_CHECK_ENABLED[player_id] then return true end

	for i, ability_name in pairs(hero.abilities or {}) do
		local ability = hero:FindAbilityByName(ability_name)
		if ability and not ability:IsNull() then
			local shard_linked_ability = ability:GetKeyValue("AbilityDraftUltShardAbility")
			local shard_status = ability:GetKeyValue("HasShardUpgrade")

			if shard_linked_ability or shard_status then return true end
		end
	end
	return false
end


function ShardAbilities:RefundShard(hero, proc_count)
	if not hero or hero:IsNull() then return end
	if proc_count and proc_count >= 10 then return end

	local player = hero:GetPlayerOwner()
	if not player then return end

	local shard_modifier = hero:FindModifierByName("modifier_item_aghanims_shard")
	local shard_item = hero:FindItemInInventory("item_aghanims_shard")

	if shard_modifier and not shard_modifier:IsNull() then
		shard_modifier:Destroy()
		
		hero:ModifyGold(CONST_SHARD_COST, true, DOTA_ModifyGold_SellItem)

		-- destroying modifier leaves shard item behind for some ungodly reason, we have to clean it up
		if shard_item then
			shard_item:Destroy()
		else
			ShardAbilities:SeekShardItem(hero, 0)
		end
		-- restock shard, just to be sure
		GameRules:SetItemStockCount(1, hero:GetTeamNumber(), "item_aghanims_shard", hero:GetPlayerOwnerID())

		ScepterAbilities.prevented_purchase[hero:GetPlayerOwnerID()] = true
		CustomGameEventManager:Send_ServerToPlayer(player, "OpenAghsPreventNotification", {})
	else
		Timers:CreateTimer(0, function()
			local proc_count = (proc_count or 0) + 1
			ShardAbilities:RefundShard(hero, proc_count)
		end)
	end
end


function ShardAbilities:SeekShardItem(hero, counter)
	if counter > 10 then return end
	if not hero or hero:IsNull() then return end

	local shard_item = hero:FindItemInInventory("item_aghanims_shard")

	if shard_item then 
		shard_item:Destroy() 
		return
	end

	Timers:CreateTimer(0, function()
		ShardAbilities:SeekShardItem(hero, counter + 1)
	end)
end

ShardAbilities:Init()

local cast_orders = {
	[DOTA_UNIT_ORDER_CAST_POSITION] 	= true,
	[DOTA_UNIT_ORDER_CAST_TARGET] 		= true,
	[DOTA_UNIT_ORDER_CAST_TARGET_TREE] 	= true,
	[DOTA_UNIT_ORDER_CAST_NO_TARGET] 	= true,
}


local reorder_interrupt_orders = {
	[DOTA_UNIT_ORDER_MOVE_TO_POSITION] 	= true,
	[DOTA_UNIT_ORDER_MOVE_TO_TARGET] 	= true,
	[DOTA_UNIT_ORDER_ATTACK_MOVE]		= true,
	[DOTA_UNIT_ORDER_ATTACK_TARGET] 	= true,
	[DOTA_UNIT_ORDER_CAST_POSITION] 	= true,
	[DOTA_UNIT_ORDER_CAST_TARGET] 		= true,
	[DOTA_UNIT_ORDER_CAST_TARGET_TREE] 	= true,
	[DOTA_UNIT_ORDER_CAST_NO_TARGET] 	= true,
	[DOTA_UNIT_ORDER_CAST_TOGGLE] 		= true,
}


local tempest_double_prohibited_orders = {
	[DOTA_UNIT_ORDER_DROP_ITEM] 		= true,
	[DOTA_UNIT_ORDER_GIVE_ITEM] 		= true,
	[DOTA_UNIT_ORDER_PICKUP_ITEM] 		= true,
	[DOTA_UNIT_ORDER_PURCHASE_ITEM] 	= true,
	[DOTA_UNIT_ORDER_SELL_ITEM] 		= true,
	[DOTA_UNIT_ORDER_DISASSEMBLE_ITEM] 	= true,
	[DOTA_UNIT_ORDER_MOVE_ITEM] 		= true,

	[DOTA_UNIT_ORDER_DROP_ITEM_AT_FOUNTAIN] = true,
	[DOTA_UNIT_ORDER_TAKE_ITEM_FROM_NEUTRAL_ITEM_STASH] = true,
}

local spirit_bear_prohibited_items = {
	["item_book_of_strength"] 		= true,
	["item_book_of_strength_2"] 	= true,
	["item_book_of_agility"] 		= true,
	["item_book_of_agility_2"] 		= true,
	["item_book_of_intelligence"] 	= true,
	["item_book_of_intelligence_2"] = true,
}

local ILLUSION_DISABLED_ABILITIES = { -- abilities & items
	item_moon_shard = true,
}

local FOUNTAIN_DISABLED_ABILITIES = { -- abilities & items
	item_shadow_amulet = true,
	item_silver_edge = true,
	item_invis_sword = true,
	item_glimmer_cape = true,
	item_demonicon = true,
	item_trickster_cloak = true,
	item_wraith_pact_lua = true,
}

local backpack_slots = {
	[6] = true,
	[7] = true,
	[8] = true,
}


local stash_slots = {
	[9]  = true,
	[10] = true,
	[11] = true,
	[12] = true,
	[13] = true,
	[14] = true,
}

ORDER_RESULT_CONTINUE = -1

function Filters:ExecuteOrderFilter(keys)
	local order_type = keys.order_type

	local player_id = keys.issuer_player_id_const
	if not player_id then return true end

	local location = Vector(keys.position_x, keys.position_y, keys.position_z)

	local target = keys.entindex_target ~= 0 and EntIndexToHScript(keys.entindex_target) or nil

	if order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE then
		target = EntIndexToHScript(GetEntityIndexForTreeId(keys.entindex_target))
	end

	local ability = keys.entindex_ability ~= 0 and EntIndexToHScript(keys.entindex_ability) or nil

	local player = PlayerResource:GetPlayer(player_id)
	if not player then return true end
	-- `entindex_ability` is item id in some orders without entity
	if ability and not ability.GetAbilityName then ability = nil end
	local ability_name = ability and ability:GetAbilityName() or nil

	local unit
	-- TODO: Are there orders without a unit?
	if keys.units and keys.units["0"] then
		unit = EntIndexToHScript(keys.units["0"])
	end
	if not unit or unit:IsNull() or not unit.HasModifier then return true end

	local unit_name = unit:GetUnitName()
	local is_unit_bear = unit_name:find("npc_dota_lone_druid_bear")

	local hero = PlayerResource:GetSelectedHeroEntity(player_id)
	if not hero or hero:IsNull() then return end
	-- disallow orders from dead players
	if not hero:IsAlive() and not hero:IsReincarnating() and not Enfos:IsEnfosMode() and not hero:IsDueling() then
		return false
	end

	local map_name = GetMapName()

	-- Prevent Training Bear ability during pre duel
	if order_type == DOTA_UNIT_ORDER_TRAIN_ABILITY and unit:HasModifier("modifier_hero_pre_duel_frozen") and ability_name == "lone_druid_spirit_bear" then
		return false
	end

	if keys.queue == 0 and order_type == DOTA_UNIT_ORDER_ATTACK_TARGET and target then
		if target.treasury_item then
			DisplayError(player_id, "#dota_hud_error_target_attack_immune")
			return false
		end
	end
	
	if order_type == DOTA_UNIT_ORDER_SELL_ITEM and ability and not ability:IsNull() then
		if ability.unsellable then
			CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", { message = "#dota_hud_error_cant_sell_item"})
			return false
		end

		if ability_name == "item_relearn_book_lua" and ability:IsItem() and ability:GetPurchaser() ~= unit then 
			return false 
		end

		-- Prevent players for selling for double the price in pregame
		if ability_name == "item_random_gift" and ability:IsItem() then
			return false
		end
	end

	if unit:HasModifier("modifier_hero_refreshing") and not TestMode:IsTestMode() then --unit stay at fountain
		--Prevent casting target abilities on enemies during preparation phase
		if order_type == DOTA_UNIT_ORDER_CAST_TARGET and target and target:GetTeam() ~= unit:GetTeam() then
			DisplayError(player_id, "#hud_error_cant_cast_on_fountain")
			return false
		end
	end

	if cast_orders[order_type] then
		local res = OnCastOrders(ability, ability_name, unit, player, player_id, location, target, order_type)
		if res ~= ORDER_RESULT_CONTINUE then return res end
	end

	if order_type == DOTA_UNIT_ORDER_GIVE_ITEM then
		if target:GetClassname() == "ent_dota_shop" then
			if ability.unsellable then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(player_id), "display_custom_error", { message = "#dota_hud_error_cant_sell_item"})
				return false
			else
				return true
			end
		end
	end

	if hero:HasModifier("modifier_hero_dueling") then
		local res = OnDuelistOrder(order_type, keys.entindex_target, ability, player)
		if res ~= ORDER_RESULT_CONTINUE then return res end
	end

	-- Item pickup filter

	if keys.queue == 0 and order_type == DOTA_UNIT_ORDER_PICKUP_ITEM then
		local res = OnItemPickUp(target, keys.issuer_player_id_const, map_name, unit)
		if res ~= ORDER_RESULT_CONTINUE then return res end
	end


	if order_type == DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH and keys.queue == 0 then     
		return false
	end

	if order_type == DOTA_UNIT_ORDER_DROP_ITEM and keys.queue == 0 then     
		if ability and ability:IsItem() then
			if ability:GetName() and "item_rapier" == ability:GetName() then
				return false
			end
		end
	end

	if order_type == DOTA_UNIT_ORDER_DROP_ITEM_AT_FOUNTAIN and keys.queue == 0  then
		local res = OnItemDroppedAtFountain(ability, ability_name, unit, player_id)
		if res ~= ORDER_RESULT_CONTINUE then return res end
	end

	if reorder_interrupt_orders[keys.order_type] 
	and HeroBuilder.toggled_reorder[player_id] then
		HeroBuilder.toggled_reorder[player_id] = false
		CustomGameEventManager:Send_ServerToPlayer(player, "reorder:interrupt", {state = false})
	end

	if unit.IsMainHero and not unit:IsMainHero() and not is_unit_bear and tempest_double_prohibited_orders[keys.order_type] then
		return false
	end

	if target and target.GetUnitName then
		local target_name = target:GetUnitName()
		local is_target_bear = target_name:find("npc_dota_lone_druid_bear")
		if target.IsMainHero and not target:IsMainHero() and not is_target_bear and keys.order_type == DOTA_UNIT_ORDER_GIVE_ITEM then
			return false
		end
	end

	if order_type == DOTA_UNIT_ORDER_CAST_POSITION and ability and ability_name == "abyssal_underlord_dark_portal" then
		local location = Vector(keys.position_x, keys.position_y, keys.position_z)
		if not BoundEnforcer:IsLocationInBounds(unit, location) or unit:IsDueling() then
			return false
		end
	end

	return true
end


function OnItemDroppedAtFountain(ability, ability_name, unit, player_id)
	if not ability or not ability:IsItem() or not ability_name 
	or ability:IsPurchasable() then return ORDER_RESULT_CONTINUE end

	local item_slot = ability:GetItemSlot()
	if not (unit:HasItemInInventory(ability_name) or (item_slot >= 9 and item_slot <= 14)) then return false end

	if (unit:IsNull() or unit:IsTempestDouble() or unit:IsIllusion() or (not unit:IsRealHero())) then
		return false
	end
	--Must be your own order
	return ORDER_RESULT_CONTINUE
end


function OnItemPickUp(target, issuer_player_id_const, map_name, ordered_unit)
	if not target then return ORDER_RESULT_CONTINUE end

	-- In demo player can pick up enemies items
	if TestMode:IsTestMode() then return true end

	local item_position = target:GetAbsOrigin()
	local item_contained = target:GetContainedItem()
	local player_team = PlayerResource:GetTeam(issuer_player_id_const)


	if Enfos:IsEnfosMode() then
		if not item_contained or item_contained:IsNull() then return true end
		if not item_contained.treasury_item then return true end
		if not EnfosTreasury.treasury_states[player_team].state then
			print("can't pick up disabled treasury items!")
			DisplayError(issuer_player_id_const, "#treasury_items_locked")
			return false 
		end
		return true 
	end
	-- Disallow pickups from other players
	if item_contained then

		local droppable_items = {
			["item_rapier"] = true,
			["item_gem"] = true,
		}

		if not droppable_items[item_contained:GetName()] then
			local item_purchaser = item_contained:GetPurchaser()
			if item_purchaser and ordered_unit:GetTeamNumber() ~= item_purchaser:GetTeamNumber() then
				CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(issuer_player_id_const), "display_custom_error", {
					message = "#hud_error_cant_pickup_enemy_items" 
				})
				return false
			end
		end
	end

	-- Allow fountain and pvp arena pickups
	if (item_position - GameMode.fountain_center):Length2D() < BoundEnforcer.playerBounds[map_name].fountain then
		return true
	end

	if IsPositionInRect2D(item_position, GameMode.pvp_center, BoundEnforcer.playerBounds[map_name].pvp_inner + 200) then
		return true
	end

	-- Disallow pickups from other players
	if not IsPositionInRect2D(item_position, GameMode.arena_centers[player_team], BoundEnforcer.playerBounds[map_name].pve_inner + 200) then
		return false
	end
	return ORDER_RESULT_CONTINUE
end

---@param ability CDOTABaseAbility
function OnCastOrders(ability, ability_name, unit, player, player_id, location, target, order_type)
	if not ability or not ability_name or not unit then return ORDER_RESULT_CONTINUE end

	-- Prevent players from issuing orders outside of the bounds of their current arena
	if not Enfos:IsEnfosMode() and not ability.isCosmeticAbility and not ability:IsCosmetic(nil) then
		local order_loc = location

		if (order_type == DOTA_UNIT_ORDER_CAST_TARGET or order_type == DOTA_UNIT_ORDER_CAST_TARGET_TREE) and target then
			order_loc = target:GetAbsOrigin()
		elseif order_type == DOTA_UNIT_ORDER_CAST_NO_TARGET then
			order_loc = unit:GetAbsOrigin()
		end

		local team = PlayerResource:GetTeam(player_id)

		local center = GameMode.arena_centers[team]
		local bounds = BoundEnforcer.map_bounds.pve_inner

		if GameMode:IsPlayerDueling(player_id) and GameMode.pvp_center then
			center = GameMode.pvp_center
			bounds = BoundEnforcer.map_bounds.pvp_inner
		end

		if GameMode:IsTeamInFountain(team) and GameMode.fountain_center then
			local distance = (order_loc - GameMode.fountain_center):Length2D()

			if distance > BoundEnforcer.map_bounds.fountain then
				--print("Too far Fountain")
				return false
			end
		else
			if not IsPositionInRect2D(order_loc, center, bounds + 800) then
				--print("Too far PVE/PVP")
				return false
			end
		end

	end

	if GameMode:IsPlayerInFountain(player_id) and not Enfos:IsEnfosMode() and not TestMode:IsTestMode() then
		if FOUNTAIN_DISABLED_ABILITIES[ability_name] then
			DisplayError(player_id, "#hud_error_cant_cast_on_fountain")
			return false
		end
	end
	
	if ability_name == "tinker_rearm_lua" then
		if unit:HasModifier("modifier_juggernaut_omnislash") or unit:HasModifier("modifier_tusk_snowball_movement") then
			CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", { message = "#hud_error_rearm_cast"})
			return false
		end
	end

	if ability.charge_modifier and ability:GetCurrentCharges() == 0 then
		CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", {
			message = "#dota_hud_error_no_charges" 
		})
		return false
	end

	if (unit:IsIllusion() or unit:IsTempestDouble()) and ILLUSION_DISABLED_ABILITIES[ability_name] then
		return false
	end

	if unit and unit:GetUnitName():find("npc_dota_lone_druid_bear") and spirit_bear_prohibited_items[ability_name] then
		DisplayError(player_id, "#dota_hud_error_spiritbear_items")
		return false
	end

	-- Prevent Walrus Kick can spam Aftershock indefinitely
	if ability_name == "tusk_walrus_kick" then
		local radius = ability:GetSpecialValueFor("search_radius")
		local team_filter = ability:GetAbilityTargetTeam()
		local type_filter = ability:GetAbilityTargetType()
		local flags = ability:GetAbilityTargetFlags()
		local targets = FindUnitsInRadius(unit:GetTeam(), unit:GetAbsOrigin(), nil, radius, team_filter, type_filter, flags, FIND_ANY_ORDER, false)

		if #targets == 0 then
			return false
		end
	end

	return ORDER_RESULT_CONTINUE
end


function OnDuelistOrder(order_type, entindex_target, ability, player)

	if order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM or order_type == DOTA_UNIT_ORDER_SELL_ITEM then
		CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", { message = "#dota_hud_error_cant_use_shop_during_duel"})
		return false
	end

	if ability and entindex_target and order_type == DOTA_UNIT_ORDER_MOVE_ITEM then
		local origin_slot = ability:GetItemSlot()
		local target_slot = entindex_target

		-- Prohibit stash transfers
		if (stash_slots[origin_slot] and (not stash_slots[target_slot])) or (stash_slots[target_slot] and (not stash_slots[origin_slot])) then
			CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_error", { message = "#dota_hud_error_cant_use_shop_during_duel"})
			return false
		end

		-- If transfer is from the backpack, put the item on cooldown
		if (backpack_slots[origin_slot] and not (backpack_slots[target_slot] or stash_slots[target_slot])) then
			if ability:GetCooldownTimeRemaining() < 6 then
				ability:StartCooldown(6)
			end
		end
	end

	return ORDER_RESULT_CONTINUE
end

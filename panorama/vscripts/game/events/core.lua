-- events that are too small to put unto separate files go here

function GameMode:OnHeroLevelUp(keys)
	local player = PlayerResource:GetPlayer(keys.player_id)
	local hero = player:GetAssignedHero()
	local hero_level = hero:GetLevel()

	-- refund auto leveled attribute points
	local attributes_ability = hero:FindAbilityByName('special_bonus_attributes')
	if not attributes_ability then return end
	
	local spent_points = attributes_ability:GetLevel()
	local spent_points_manually = hero:GetManuallySpentAttributePoints()

	if spent_points > spent_points_manually then
		attributes_ability:SetLevel(spent_points_manually)
		hero:SetAbilityPoints(hero:GetAbilityPoints() + 1)
	end

	if hero:GetAbilityPoints() > 0 then
		CustomGameEventManager:Send_ServerToPlayer(player, "ability_controls:leveling_state_refresh", {})
	end
end


function GameMode:OnPlayerLearnedAbility(keys)
	local player = PlayerResource:GetPlayer(keys.PlayerID)
	local owner = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)

	CustomGameEventManager:Send_ServerToPlayer(player, "ability_controls:leveling_state_refresh", {})

	if keys.abilityname == "special_bonus_attributes" then
		owner:RegisterManuallySpentAttributePoint()
	elseif keys.abilityname == "weaver_time_lapse" then
		if not owner:HasModifier("modifier_weaver_timelapse") then
			local ability = owner:FindAbilityByName("weaver_time_lapse")
			owner:AddNewModifier(owner, ability, "modifier_weaver_timelapse", {})
		end
	end
end

function GameMode:OnPlayerUsedAbility(data)
	local owner = PlayerResource:GetSelectedHeroEntity(data.PlayerID)

	if data.abilityname == 'arc_warden_tempest_double_lua' then
		local units = FindUnitsInRadius(PlayerResource:GetTeam(data.PlayerID), owner:GetAbsOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD + DOTA_UNIT_TARGET_FLAG_PLAYER_CONTROLLED, FIND_ANY_ORDER, false)
		for _,unit in ipairs(units) do
			-- Make sure we found the right spirit bears
			-- unit:GetOwner() is different here from local owner since we're dealing with a TD
			if unit and unit:GetUnitName():find("npc_dota_lone_druid_bear") and unit:GetOwner():IsTempestDouble() then
				local droppable_items = {
					["item_rapier"] = true,
					["item_gem"] = true,
				}
				if not unit:GetOwner().spiritbear_tempestdouble_items then
					unit:GetOwner().spiritbear_tempestdouble_items = {}
				end
				for i = 0, 16 do
					local item = unit:GetItemInSlot(i)
					if item and not item:IsNull() and droppable_items[item:GetName()] then
						table.insert(unit:GetOwner().spiritbear_tempestdouble_items, item:GetName())
						UTIL_Remove(item)
					end
				end
			end
		end
	end

	-- Reduce Ice Blast's projectile max travel distance
	if data.abilityname == "ancient_apparition_ice_blast" then
		local caster = EntIndexToHScript(data.caster_entindex)
		local ability = caster:FindAbilityByName(data.abilityname)
		
		local max_duration = ability:GetSpecialValueFor("max_distance") / ability:GetSpecialValueFor("speed")

		Timers:CreateTimer(max_duration, function()
			if not IsValidEntity(caster) or not IsValidEntity(ability) or not caster:IsAlive() then return end

			local release = caster:FindAbilityByName("ancient_apparition_ice_blast_release")

			if release and not release:IsHidden() then
				release:OnSpellStart()
			end
		end)

	end
end 


function GameMode:OnHeroKilled(keys)
	local hero = PlayerResource:GetSelectedHeroEntity(keys.PlayerID)
end


function GameMode:OnHeroPicked(event)
	local hero = EntIndexToHScript(event.heroindex)
	if hero:GetUnitName() == "npc_dummy_caster" then return end

	local player_id = hero:GetPlayerID()
	if not player_id then return end

	-- For bots to get right state in case they are added after game starts (usually in tools)
	if PlayerResource:IsFakeClient(player_id) then
		GameMode:ActivateTeam(PlayerResource:GetTeam(player_id))
		GameMode:ActivateBot(player_id)
		GameMode:SetPlayerState(player_id, PLAYER_STATE_ON_BASE)
	end

	HeroBuilder:InitPlayerHero(hero, false, false)
end

function GameMode:OnItemSpawned(event)
	local item = EntIndexToHScript(event.item_ent_index)

	if item and item:GetAbilityName() == "item_urn_of_shadows" then
		item:SetCurrentCharges(item:GetSpecialValueFor("soul_initial_charge"))
	end
end

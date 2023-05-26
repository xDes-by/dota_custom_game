function Spawn(entityKeyValues)
    if not IsServer() then
        return
    end

    if not thisEntity then
        return
    end

    thisEntity:SetContextThink("NeutralThink", NeutralThink, 1)
    thisEntity.bSearchedForItems = false
    thisEntity.bSearchedForSpells = false
end

function NeutralThink()
    if not thisEntity.bSearchedForItems then
        SearchForItems()
		if #thisEntity.items == 0 then
			return 1
		end
        thisEntity.bSearchedForItems = true
    end

    if not thisEntity.bSearchedForSpells then
        SearchForSpells()
        thisEntity.bSearchedForSpells = true
    end

    if not thisEntity:IsAlive() or GameRules:IsGamePaused() or thisEntity:IsChanneling() or thisEntity:IsDisarmed() then
        return 1
    end

    local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, thisEntity:GetAcquisitionRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    if #enemies == 0 then
        return 1
    end
	
	local target = enemies[RandomInt(1, #enemies)]
	local abilities = {}

    for _, abilityName in ipairs(thisEntity.spells) do
        local ability = thisEntity:FindAbilityByName(abilityName)
        if ability and ability:IsFullyCastable() then
            table.insert(abilities, ability)
        end
    end

    for _, itemName in ipairs(thisEntity.items) do
        local item = thisEntity:FindItemInInventory(itemName)
        if item and item:IsFullyCastable() then
            table.insert(abilities, item)
        end
    end

    if #abilities == 0 then
        return 1
    end

    local ability = abilities[RandomInt(1, #abilities)]
    if not ability then
        return 1
    end
	
	if ability:IsItem() then
		behavior = ability:GetBehavior()
	else
		behavior = ability:GetBehaviorInt()
	end
	
    if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
		ability.Behavior = "target"
        Cast(ability, target)
    elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
		ability.Behavior = "no_target"
        Cast(ability, target)
    elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
		ability.Behavior = "point"
        Cast(ability, target)
    elseif bit.band(behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE) == DOTA_ABILITY_BEHAVIOR_TOGGLE then
        ToggleAbility(ability)
	else
		return 0.1
    end

    return 1
end

function SearchForSpells()
	thisEntity.spells = {}
	for i = 0, 10 do
		local ability = thisEntity:GetAbilityByIndex(i)
		if ability then
			local abilityName = ability:GetName()
			if abilityName ~= "attribute_bonus" and abilityName ~= "generic_hidden" and abilityName ~= "backdoor_protection" and abilityName ~= "twin_gate_portal_warp" and abilityName ~= "necronomicon_warrior_sight" then
				table.insert(thisEntity.spells, abilityName)
			end
		end
	end
end

function SearchForItems()
	thisEntity.items = {}
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot(i)
		if item then
			local itemName = item:GetName()
			table.insert(thisEntity.items, itemName)
		end
	end
end

function Cast(Spell, enemy)
	local order_type
	local vTargetPos = enemy:GetOrigin()

    if Spell.Behavior == "target" then
        order_type = DOTA_UNIT_ORDER_CAST_TARGET
    elseif Spell.Behavior == "no_target" then
        order_type = DOTA_UNIT_ORDER_CAST_NO_TARGET
    elseif Spell.Behavior == "point" then
        order_type = DOTA_UNIT_ORDER_CAST_POSITION
    elseif Spell.Behavior == "passive" then
        return
    end
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = order_type,
		Position = vTargetPos,
		TargetIndex = enemy:entindex(),  
		AbilityIndex = Spell:entindex(),
		Queue = false,
	})
end
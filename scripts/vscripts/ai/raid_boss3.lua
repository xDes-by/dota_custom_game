function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	NoTargetAbility = thisEntity:FindAbilityByName( "raid_clap" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "raid_enrage" )
	NoTargetAbility3 = thisEntity:FindAbilityByName( "raid_shadow" )

	thisEntity:SetContextThink( "HellbearThink", HellbearThink, 1 )
end
--------------------------------------------------------------------------------

function HellbearThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if thisEntity:IsChanneling() then
        return 1 
    end
	
	if thisEntity:IsInvulnerable() then
        return 1 
    end
	
	if not thisEntity.bInitialized then
		local ent = Entities:FindByName( nil, "point_center3")
		local point = ent:GetAbsOrigin() 
		thisEntity.vInitialSpawnPos = point
		thisEntity.bInitialized = true
	end
	
	if ( not thisEntity.bAcqRangeModified ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 1050 )
		thisEntity.bAcqRangeModified = true
	end

	if thisEntity:GetAggroTarget() then
		thisEntity.fTimeWeLostAggro = nil
	end

	if thisEntity:GetAggroTarget() and ( thisEntity.fTimeAggroStarted == nil ) then
		thisEntity.fTimeAggroStarted = GameRules:GetGameTime()
	end

	if ( not thisEntity:GetAggroTarget() ) and ( thisEntity.fTimeAggroStarted ~= nil ) then
		thisEntity.fTimeWeLostAggro = GameRules:GetGameTime()
		thisEntity.fTimeAggroStarted = nil
	end

	if ( not thisEntity:GetAggroTarget() ) then
		if thisEntity.fTimeWeLostAggro and ( GameRules:GetGameTime() > ( thisEntity.fTimeWeLostAggro + 1.0 ) ) then
			return RetreatHome()
		end
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1050, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
	if #enemies > 0 then
     
		if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable() then
			NoTargetAbilityCast(unit)
			return 1
		end

-----------------------------------------------------------------------------------------------------------		
		if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable() and not thisEntity:IsInvisible() then
			NoTargetAbilityCast2(unit)
			return 1
		end	
		
-----------------------------------------------------------------------------------------------------------		
		if NoTargetAbility3 ~= nil and NoTargetAbility3:IsFullyCastable() then
			if not (thisEntity:HasModifier("modifier_raid_enrage_1") or thisEntity:HasModifier("modifier_raid_enrage_2") or thisEntity:HasModifier("modifier_raid_enrage_3"))  then
				NoTargetAbilityCast3(unit)
			end
			return 1
		end	

-----------------------------------------------------------------------------------------------------------		
		
		if thisEntity:IsInvisible() then
			local attackOrder = {
					UnitIndex = thisEntity:entindex(), 
					OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
					Position = thisEntity:GetAbsOrigin()
					}
				ExecuteOrderFromTable(attackOrder)
			return 1 
		end
		
-----------------------------------------------------------------------------------------------------------		

		if PointAbility ~= nil and PointAbility:IsFullyCastable() then
		for _,unit in pairs(enemies) do
			if unit then
				PointAbilityCast(unit)
				end
				end
			end
			return 1
		end
	return 2
end

--------------------------------------------------------------------------------
function RetreatHome()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
		Position = thisEntity.vInitialSpawnPos,
	})
	return 0.5
end

function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_shivas_guard_lua" then
				thisEntity.hBlademailAbility = item
			end
			if item:GetAbilityName() == "item_blink" then
				thisEntity.hBlink = item
			end
		end
	end
end

function NoTargetAbilityCast(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function NoTargetAbilityCast2(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility2:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function NoTargetAbilityCast3(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility3:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end
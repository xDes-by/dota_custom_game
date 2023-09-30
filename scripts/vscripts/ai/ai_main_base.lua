function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
	
    thisEntity:SetContextThink( "NeutralThink", NeutralThink, 1 )
	
	thisEntity.NoTarget_1 = thisEntity:FindAbilityByName( "treant_overgrowth_tron" )
	thisEntity.NoTarget_2 = thisEntity:FindAbilityByName( "tidehunter_ravage_tron" )
end

function NeutralThink()
    if ( not thisEntity:IsAlive() ) then
		return -1
	end
	if GameRules:IsGamePaused() == true then
		return 1
	end

	if thisEntity:GetHealthPercent() < 50 and thisEntity.NoTarget_1 and thisEntity.NoTarget_1:IsFullyCastable() then
		return NoTargetAbilityCast1()	
	end
	
	if thisEntity:GetHealthPercent() < 25 and thisEntity.NoTarget_2 and thisEntity.NoTarget_2:IsFullyCastable() then
		return NoTargetAbilityCast2()
	end
	return 1
end

function NoTargetAbilityCast1()
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = thisEntity.NoTarget_1:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function NoTargetAbilityCast2()
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = thisEntity.NoTarget_2:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end
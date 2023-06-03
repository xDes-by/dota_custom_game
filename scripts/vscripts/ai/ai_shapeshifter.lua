function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
	
    thisEntity:SetContextThink( "NeutralThink", NeutralThink, 1 )
end

function NeutralThink()
    if ( not thisEntity:IsAlive() ) then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if thisEntity:IsChanneling() then
        return 1 
    end

	
	local shapeshifter_ability1 = thisEntity:FindAbilityByName("shapeshifter_ability1")
	local shapeshifter_ability3 = thisEntity:FindAbilityByName("shapeshifter_ability3")
	local enemies = GetEnemiesInRadius( thisEntity, 800 )
	if shapeshifter_ability1:IsFullyCastable() and #enemies > 0 then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
			TargetIndex = enemies[1]:entindex(),  
			AbilityIndex = shapeshifter_ability1:entindex(),
			Queue = false,
		})
		return 0.5
	end
	if shapeshifter_ability3:IsFullyCastable() and #enemies > 0 then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = shapeshifter_ability3:entindex(),
			Queue = false,
		})
		return 0.5
	end
	if #enemies > 0 then
        ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(), 
            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
            Position = enemies[1]:GetAbsOrigin(),
			Queue = false,
        })
    end
	return 1
end

function GetEnemiesInRadius(caster, radius)
    return FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
end

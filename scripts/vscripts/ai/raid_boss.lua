function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	NoTargetAbility = thisEntity:FindAbilityByName( "flame_strike" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "fire_raze" )
	NoTargetAbility3 = thisEntity:FindAbilityByName( "fire_storm" )
	PointAbility = thisEntity:FindAbilityByName( "ability_thdots_nue04" )
	NoTargetAbility4 = thisEntity:FindAbilityByName( "custom_sustrike_delay" )
	TargetAbility = thisEntity:FindAbilityByName( "custom_sunray" )
	
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
		local ent = Entities:FindByName( nil, "point_center")
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

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1050, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #enemies > 0 then
         if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
				NoTargetAbilityCast(unit)
			end
			end
			return 2
		end
			
		 if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
				NoTargetAbilityCast2(unit)
			end
			end
			return 2
		end	
		
		if NoTargetAbility3 ~= nil and NoTargetAbility3:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
				NoTargetAbilityCast3(unit)
			end
			end
			return 4.1
		end	
		
		if NoTargetAbility4 ~= nil and NoTargetAbility4:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
				NoTargetAbilityCast4(unit)
			end
			end
			return 3
		end	
		
		if TargetAbility ~= nil and TargetAbility:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
				TargetAbilityCast(unit)
			end
			end
			return 3
		end	

		if PointAbility ~= nil and PointAbility:IsFullyCastable() then
		for _,unit in pairs(enemies) do
			if unit then
				PointAbilityCast(unit)
				end
				end
			end
			return 2
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
			if item:GetAbilityName() == "item_shivas_guard" then
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

function NoTargetAbilityCast4(unit)
	ProjectileManager:ProjectileDodge(thisEntity) 
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, thisEntity) 
    thisEntity:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local ent = Entities:FindByName( nil, "point_center")
	local point = ent:GetAbsOrigin() 
	thisEntity:SetAbsOrigin( point )
	FindClearSpaceForUnit(thisEntity, point, false)
	thisEntity:Stop() 

      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility4:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function PointAbilityCast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos + RandomVector( RandomFloat( 150, 150 )),
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
    return 0.5
end

function TargetAbilityCast(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),    --индекс кастера
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,    -- тип приказа
        AbilityIndex = TargetAbility:entindex(), -- индекс способности
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
    return 0.5
end
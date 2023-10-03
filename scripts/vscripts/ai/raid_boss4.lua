function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	TargetAbility = thisEntity:FindAbilityByName( "raid_splinter_blast" )
	TargetAbility2 = thisEntity:FindAbilityByName( "raid_curse" )
	NoTargetAbility = thisEntity:FindAbilityByName( "custom_arctic_field" )

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
		local ent = Entities:FindByName( nil, "point_center4")
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
			if TargetAbility ~= nil and TargetAbility:IsFullyCastable() then
				for _,unit in pairs(enemies) do
					if unit then
						TargetAbilityCast( enemies[ RandomInt( 1, #enemies ) ] )
					end
				end
			return 3
		end
-----------------------------------------------------------------------------------------------------------		
		if TargetAbility2 ~= nil and TargetAbility2:IsFullyCastable() then
				for _,unit in pairs(enemies) do
					if unit and not (unit:HasModifier("modifier_generic_silenced_lua") or unit:HasModifier("modifier_raid_splinter_blast_colba")) then
						TargetAbilityCast2( enemies[ RandomInt( 1, #enemies ) ] )
					end
				end
			return 3
		end
-----------------------------------------------------------------------------------------------------------		
			if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable() then
				NoTargetAbilityCast(unit)
				return 1
			end		
		end
	return 3
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

function TargetAbilityCast(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),    --индекс кастера
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,    -- тип приказа
        AbilityIndex = TargetAbility:entindex(), -- индекс способности
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
    return 1
end

function TargetAbilityCast2(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),    --индекс кастера
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,    -- тип приказа
        AbilityIndex = TargetAbility2:entindex(), -- индекс способности
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
    return 1
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
function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
	
	TargetAbility = thisEntity:FindAbilityByName( "furion_sprout_lua" )
	TargetAbility2 = thisEntity:FindAbilityByName( "forest_seed" )
	PointAbility2 = thisEntity:FindAbilityByName( "penek" )
	NoTargetAbility = thisEntity:FindAbilityByName( "custom_forest" )
  
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

    local npc = thisEntity

    if not thisEntity.bInitialized then
       npc.vInitialSpawnPos  = npc:GetOrigin()
        npc.fMaxDist = npc:GetAcquisitionRange()
        npc.bInitialized = true
        npc.agro = false
      
    end
	
	local health = thisEntity:GetHealthPercent()

	search_radius = npc.fMaxDist
  
    local fDist = ( npc:GetOrigin() - npc.vInitialSpawnPos ):Length2D()
    if fDist > search_radius then
        RetreatHome()
        return 3
    end
  
    local enemies = FindUnitsInRadius(
                        npc:GetTeamNumber(),  
                       npc:GetOrigin(),   
                        nil, 
                        search_radius + 50,   
                        DOTA_UNIT_TARGET_TEAM_ENEMY,   
                        DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  
                        FIND_CLOSEST, 
                        false )

    if #enemies == 0 then   
        if npc.agro then
            RetreatHome() 
        end     
        return 0.5
    end

-------------------------------------
	if #enemies > 0 then
		if health == 100 then
			thisEntity:EmitSound("furion_furi_battlebegins_01")
			return 5
		end
		
			
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end
-------------------------------------
	
	if PointAbility2 ~= nil and PointAbility2:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
					PointAbility2Cast(unit)
					local fura =  {"furion_furi_attack_10"}
					thisEntity:EmitSound(fura[RandomInt(1, #fura)])
				end
			end
		return 2
	end	
--------------------------------------------
	 if TargetAbility ~= nil and TargetAbility:IsFullyCastable()  then
		   for _,unit in pairs(enemies) do
				if unit then
						TargetAbilityCast( enemies[ RandomInt( 1, #enemies ) ] )
						local fura =  {"furion_furi_ability_sprout_02","furion_furi_ability_sprout_06"}
						thisEntity:EmitSound(fura[RandomInt(1, #fura)])
						end
					end
			return 2
		end  
		
	if TargetAbility2 ~= nil and TargetAbility2:IsFullyCastable()  then
		   for _,unit in pairs(enemies) do
				if unit then
						TargetAbilityCast2( enemies[ RandomInt( 1, #enemies ) ] )
						local fura =  {"furion_furi_ability_sprout_02","furion_furi_ability_sprout_06"}
						thisEntity:EmitSound(fura[RandomInt(1, #fura)])
						end
					end
			return 2
		end  	
	
	if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
					NoTargetAbilityCast(unit)
					local fura =  {"furion_furi_ability_sprout 04"}
					thisEntity:EmitSound(fura[RandomInt(1, #fura)])
				end
			end
			return 2
		end
	
		if thisEntity.item_shivas_guard and thisEntity.item_shivas_guard:IsFullyCastable() then
			return UseNoTarget( enemies[ RandomInt( 1, #enemies ) ] )	
		end
		
		if thisEntity.item_crimson_guard and thisEntity.item_crimson_guard:IsFullyCastable() then
			return UseNoTarget2( enemies[ RandomInt( 1, #enemies ) ] )	
		end
		
		if thisEntity.item_pipe and thisEntity.item_pipe:IsFullyCastable() then
			return UseNoTarget3( enemies[ RandomInt( 1, #enemies ) ] )	
		end
			
		if thisEntity.item_veil_of_discord and thisEntity.item_veil_of_discord:IsFullyCastable() then
			return UsePoint( enemies[ RandomInt( 1, #enemies ) ] )
		end
		
		if thisEntity.item_ethereal_blade and thisEntity.item_ethereal_blade:IsFullyCastable() then
			return UseTraget( enemies[ RandomInt( 1, #enemies ) ] )
		end
		return 1
	end
  
    local enemy = enemies[1]  
   
    if npc.agro then
        AttackMove(npc, enemy)
    else
        local allies = FindUnitsInRadius( 
                npc:GetTeamNumber(),
               npc:GetOrigin(),
                nil,
                npc.fMaxDist,
                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                FIND_CLOSEST,
                false )
              
        for i=1,#allies do  
            local ally = allies[i]
            ally.agro = true  
            AttackMove(ally, enemy) 
        end 
    end 	
    return 3
end

---------------------------------------

function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_shivas_guard" then
				thisEntity.item_shivas_guard = item
			end
			if item:GetAbilityName() == "item_crimson_guard" then
				thisEntity.item_crimson_guard = item
			end
			if item:GetAbilityName() == "item_veil_of_discord" then
				thisEntity.item_veil_of_discord = item
			end
			if item:GetAbilityName() == "item_ethereal_blade" then
				thisEntity.item_ethereal_blade = item
			end
			if item:GetAbilityName() == "item_pipe" then
				thisEntity.item_pipe = item
			end
		end
	end
end

function UsePoint( hEnemy )
local vTargetPos = hEnemy:GetOrigin()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = thisEntity.item_veil_of_discord:entindex(),
		Queue = false,
	})
    return 1.5
end

function UseTraget( hEnemy )
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
		TargetIndex = hEnemy:entindex(),
		AbilityIndex = thisEntity.item_ethereal_blade:entindex(),
		Queue = false,
	})
	return 2
end

function UseNoTarget()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.item_shivas_guard:entindex(),
		Queue = false,
	})
	return 2
end

function UseNoTarget2()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.item_crimson_guard:entindex(),
		Queue = false,
	})
	return 2
end

function UseNoTarget3()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.item_pipe:entindex(),
		Queue = false,
	})
	return 2
end


---------------------------------------

function AttackMove( unit, enemy )
    if enemy == nil then
        return
    end
    ExecuteOrderFromTable({
        UnitIndex = unit:entindex(),       
        OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,   
        Position = enemy:GetOrigin(),         
        Queue = false,
    })

    return 1
end

function RetreatHome()
    thisEntity.agro = false  

    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),
        OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
        Position = thisEntity.vInitialSpawnPos     
    })
end

------------------------------------------------------------

function PointAbility2Cast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility2:entindex(),
		Queue = false,
	})
    return 1.5
end


function TargetAbilityCast(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),    --индекс кастера
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,    -- тип приказа
        AbilityIndex = TargetAbility:entindex(), -- индекс способности
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
   
    return 1.5
end

function TargetAbilityCast2(enemy)
    ExecuteOrderFromTable({
        UnitIndex = thisEntity:entindex(),    --индекс кастера
        OrderType = DOTA_UNIT_ORDER_CAST_TARGET,    -- тип приказа
        AbilityIndex = TargetAbility2:entindex(), -- индекс способности
        TargetIndex = enemy:entindex(),
        Queue = false,
    })
   
    return 1.5
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
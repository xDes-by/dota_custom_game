function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
	
	NoTargetAbility2 = thisEntity:FindAbilityByName( "gaven_create_stone" )
	NoTargetAbility = thisEntity:FindAbilityByName( "wisp_spirits_datadriven" )
	PointAbility2 = thisEntity:FindAbilityByName( "split_earth_datadriven")
	TargetAbility = thisEntity:FindAbilityByName( "earth_spirit_boulder_smash" )
	NoTargetAbility4 = thisEntity:FindAbilityByName( "npc_mines_boss_spawn_shaker" )
	NoTargetAbility3 = thisEntity:FindAbilityByName( "npc_mines_boss_wawe" )
  
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
       npc.vInitialSpawnPos = npc:GetOrigin()
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
		if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end
-------------------------------------
		if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
					NoTargetAbility2Cast(unit)
					local earth =  {"earth_spirit_earthspi_stonecaller_06","earth_spirit_earthspi_stonecaller_02","earth_spirit_earthspi_stonecaller_09"}
					thisEntity:EmitSound(earth[RandomInt(1, #earth)])
				end
			end
			return 2
		end
		if NoTargetAbility3 ~= nil and NoTargetAbility3:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
					NoTargetAbility3Cast(unit)
					local earth =  {"earth_spirit_earthspi_stonecaller_06","earth_spirit_earthspi_stonecaller_02","earth_spirit_earthspi_stonecaller_09"}
					thisEntity:EmitSound(earth[RandomInt(1, #earth)])
				end
			end
			return 2
		end
		if NoTargetAbility4 ~= nil and NoTargetAbility4:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
					NoTargetAbility4Cast(unit)
					local earth =  {"earth_spirit_earthspi_stonecaller_06","earth_spirit_earthspi_stonecaller_02","earth_spirit_earthspi_stonecaller_09"}
					thisEntity:EmitSound(earth[RandomInt(1, #earth)])
				end
			end
			return 2
		end		
		if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
					NoTargetAbilityCast(unit)
					local earth =  {"earth_spirit_earthspi_kill_13","earth_spirit_earthspi_levelup_01","earth_spirit_earthspi_bouldersmash_01"}
					thisEntity:EmitSound(earth[RandomInt(1, #earth)])
				end
			end
			return 2
		end	
	
	if PointAbility2 ~= nil and PointAbility2:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
					PointAbility2Cast(unit)
					local earth =  {"earth_spirit_earthspi_magnetize_02","earth_spirit_earthspi_magnetize_04","earth_spirit_earthspi_magnetize_05"}
					thisEntity:EmitSound(earth[RandomInt(1, #earth)])
				end
			end
		return 2
	end	
  
--------------------------------------------
	 if TargetAbility ~= nil and TargetAbility:IsFullyCastable()  then
		   for _,unit in pairs(enemies) do
				if unit then
						TargetAbilityCast( enemies[ RandomInt( 1, #enemies ) ] )
						local earth =  {"earth_spirit_earthspi_thanks_04","earth_spirit_earthspi_kill_18","earth_spirit_earthspi_rollingboulder_15"}
						thisEntity:EmitSound(earth[RandomInt(1, #earth)])
						end
					end
			return 2
		end  
	
		if health == 100 then
			local earth =  {"earth_spirit_earthspi_rollingboulder_20","earth_spirit_earthspi_deny_05"}
			thisEntity:EmitSound(earth[RandomInt(1, #earth)])
			return 5
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

function NoTargetAbilityCast(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function NoTargetAbility2Cast(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility2:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function NoTargetAbility3Cast(unit)
	ExecuteOrderFromTable({
		  UnitIndex = thisEntity:entindex(),    --индекс кастера
		  OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
		  AbilityIndex = NoTargetAbility3:entindex(), -- индекс способности
		  Queue = false,
	  })
  return 1
end

function NoTargetAbility4Cast(unit)
	ExecuteOrderFromTable({
		  UnitIndex = thisEntity:entindex(),    --индекс кастера
		  OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
		  AbilityIndex = NoTargetAbility4:entindex(), -- индекс способности
		  Queue = false,
	  })
  return 1
end
-------------------------------------------------------------------------


function SearchForItems()
	for i = 0, 5 do
		local item = thisEntity:GetItemInSlot( i )
		if item then
			if item:GetAbilityName() == "item_shivas_guard2" then
				thisEntity.item_shivas_guard = item
			end
			if item:GetAbilityName() == "item_crimson_guard2" then
				thisEntity.item_crimson_guard = item
			end
			if item:GetAbilityName() == "item_veil_of_discord2" then
				thisEntity.item_veil_of_discord = item
			end
			if item:GetAbilityName() == "item_ethereal_blade2" then
				thisEntity.item_ethereal_blade = item
			end
			if item:GetAbilityName() == "item_pipe2" then
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
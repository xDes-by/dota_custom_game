function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
	
	TargetAbility = thisEntity:FindAbilityByName( "pudge_dismember_lua" )
	PointAbility = thisEntity:FindAbilityByName( "mars_arena_of_blood_custom" )
	PointAbility2 = thisEntity:FindAbilityByName( "pudge_meat_hook_custom" )
	PointAbility3 = thisEntity:FindAbilityByName( "boss_2_spray" )
	PointAbility4 = thisEntity:FindAbilityByName( "pudge_chaos_meteor_lua" )
  
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
	
	if thisEntity:IsControllableByAnyPlayer() then
        return -1
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
	
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end
-------------------------------------
	if PointAbility2 ~= nil and PointAbility2:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
					PointAbility2Cast(unit)
					local pudge =  {"pudge_pud_ability_hook_01","pudge_pud_ability_hook_03","pudge_pud_ability_hook_06"}
					thisEntity:EmitSound(pudge[RandomInt(1, #pudge)])
				end
			end
		return 0.5
	end	
	
	if PointAbility3 ~= nil and PointAbility3:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
					PointAbility3Cast(unit)
					local pudge =  {"pudge_pud_ability_hook_01","pudge_pud_ability_hook_03","pudge_pud_ability_hook_06"}
					thisEntity:EmitSound(pudge[RandomInt(1, #pudge)])
				end
			end
		return 0.5
	end	
	
	if TargetAbility ~= nil and TargetAbility:IsFullyCastable()  then
		   for _,unit in pairs(enemies) do
				if unit then
						TargetAbilityCast( enemies[ RandomInt( 1, #enemies ) ] )
						local pudge = {"pudge_pud_ability_devour_07","pudge_pud_ability_devour_12","pudge_pud_ability_devour_09"}
						thisEntity:EmitSound(pudge[RandomInt(1, #pudge)])
						end
					end
			return 0.5
		end 
	
	if PointAbility ~= nil and PointAbility:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
					PointAbilityCast(unit)
					local pudge =  {"pudge_pud_ability_hook_miss_04","pudge_pud_ability_hook_miss_06","pudge_pud_ability_hook_miss_08"}
					thisEntity:EmitSound(pudge[RandomInt(1, #pudge)])
				end
			end
		return 0.5
	end	
	if PointAbility4 ~= nil and PointAbility4:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
					PointAbility4Cast(unit)
				end
			end
		return 0.5
	end	
--------------------------------------------
		if health == 100 then
			local pudge =  {"pudge_pud_ability_hook_miss_04","pudge_pud_ability_hook_miss_06","pudge_pud_ability_hook_miss_08"}
			thisEntity:EmitSound(pudge[RandomInt(1, #pudge)])
			return 3
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
		return 0.5
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
    return 0.5
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

function PointAbilityCast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
    return 1.5
end

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

function PointAbility3Cast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility3:entindex(),
		Queue = false,
	})
    return 1.5
end

function PointAbility4Cast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility4:entindex(),
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

----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

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

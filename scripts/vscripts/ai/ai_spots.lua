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
  
    if thisEntity:IsControllableByAnyPlayer() then
        return -1
    end
  
    local npc = thisEntity

    if not thisEntity.bInitialized then
        npc.vInitialSpawnPos = npc:GetOrigin()
        npc.fMaxDist = npc:GetAcquisitionRange()
        npc.bInitialized = true
        npc.agro = false
      
    end

    local search_radius
    if npc.agro then
        search_radius = npc.fMaxDist * 2
    else
        search_radius = npc.fMaxDist
    end
  
    local fDist = ( npc:GetOrigin() - npc.vInitialSpawnPos ):Length2D()
    if fDist > search_radius then
        RetreatHome()
        return 3
    end
  
    local enemies = FindUnitsInRadius( npc:GetTeamNumber(), npc.vInitialSpawnPos, nil, search_radius + 50, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE, FIND_CLOSEST, false )
    if #enemies == 0 then   
        if npc.agro then
            RetreatHome() 
        end     
        return 0.5
    end 
    local enemy = enemies[1]  
    if npc.agro then     
        AttackMove(npc, enemy)
    else
        local allies = FindUnitsInRadius( 
                npc:GetTeamNumber(),
                npc.vInitialSpawnPos,
                nil,
                npc.fMaxDist,
                DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
                FIND_CLOSEST,
                false )
              
        for i=1,#allies do  
            local ally = allies[i]
				ally.agro = true  
				AttackMove(ally, enemy) 
        end 
    end 
    return 1
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
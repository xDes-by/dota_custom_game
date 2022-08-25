function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
	
	NoTargetAbility = thisEntity:FindAbilityByName( "custom_greater_pit" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "custom_solar_flare" )
	NoTargetAbility3 = thisEntity:FindAbilityByName( "night_stalker_crippling_fear" )
	PointAbility = thisEntity:FindAbilityByName( "creature_fire_breath")
	
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
  
    local enemies = FindUnitsInRadius( npc:GetTeamNumber(), npc:GetOrigin(), nil,  search_radius + 50, DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
    if #enemies == 0 then   
        if npc.agro then
            RetreatHome() 
        end     
        return 0.5
    end

-------------------------------------
	if #enemies > 0 then
-------------------------------------
		if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
					NoTargetAbilityCast(unit)
					local mega = {"doom_bringer_doom_attack_08","doom_bringer_doom_laugh_03","doom_bringer_doom_ability_doom_bringer_doom_02"}
					thisEntity:EmitSound(mega[RandomInt(1, #mega)])
				end
			end
			return 2
		end
		
		if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
					NoTargetAbilityCast2(unit)
					local mega =  {"doom_bringer_doom_ability_scorched_02","doom_bringer_doom_level_04","doom_bringer_doom_ability_doom_bringer_doom_05"}
					thisEntity:EmitSound(mega[RandomInt(1, #mega)])
				end
			end
			return 2
		end
		
		if NoTargetAbility3 ~= nil and NoTargetAbility3:IsFullyCastable()  then
            for _,unit in pairs(enemies) do
				if unit then
					NoTargetAbilityCast3(unit)
					local mega =  {"doom_bringer_doom_rival_11","doom_bringer_doom_rival_12","doom_bringer_doom_rival_13","doom_bringer_doom_rival_14"}
					thisEntity:EmitSound(mega[RandomInt(1, #mega)])
				end
			end
			return 2
		end
		
	if PointAbility ~= nil and PointAbility:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
					PointAbilityCast(unit)
					local mega = {"doom_bringer_doom_ability_scorched_01","doom_bringer_doom_cast_01","pud_attack_06","doom_bringer_doom_radiance_02"}
					thisEntity:EmitSound(mega[RandomInt(1, #mega)])
				end
			end
		return 2
	end	
	
		if health == 100 then
			local mega =  {"doom_bringer_doom_respawn_08","doom_bringer_doom_respawn_10","doom_bringer_doom_spawn_03"}
			thisEntity:EmitSound(mega[RandomInt(1, #mega)])
			return 5
		end
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

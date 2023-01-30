function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
	
    thisEntity:SetContextThink( "NeutralThink", NeutralThink, 1 )
	
	NoTargetAbility = thisEntity:FindAbilityByName( "ability_npc_boss_plague_squirrel_spell1" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "ability_npc_boss_plague_squirrel_spell2" )
	NoTargetAbility3 = thisEntity:FindAbilityByName( "ability_npc_boss_plague_squirrel_spell3" )
	NoTargetAbility4 = thisEntity:FindAbilityByName( "ability_npc_boss_plague_squirrel_spell4" )
	NoTargetAbility5 = thisEntity:FindAbilityByName( "ability_npc_boss_plague_squirrel_spell5" )
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
	
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end
	
    if not thisEntity.bInitialized then
		thisEntity.vInitialSpawnPos = thisEntity:GetOrigin()
        thisEntity.fMaxDist = thisEntity:GetAcquisitionRange()
        thisEntity.bInitialized = true
        thisEntity.agro = false
    end
	
	local health = thisEntity:GetHealthPercent()
	search_radius = npc.fMaxDist
  
    local fDist = ( npc:GetOrigin() - npc.vInitialSpawnPos ):Length2D()
    if fDist > search_radius then
        RetreatHome()
        return 3
    end
  
    local enemies = FindUnitsInRadius( npc:GetTeamNumber(), npc:GetOrigin(), nil, search_radius + 50, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    if #enemies == 0 then   
        if npc.agro then
            RetreatHome() 
        end     
        return 0.5
    end
	if #enemies > 0 then	
		if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable() then
			NoTargetAbilityCast(NoTargetAbility)
			return 1
		end
		
		if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable() then
			NoTargetAbilityCast(NoTargetAbility2)
			return 1
		end
		
		if NoTargetAbility3 ~= nil and NoTargetAbility3:IsFullyCastable() then
			NoTargetAbilityCast(NoTargetAbility3)
			return 1
		end
		
		if NoTargetAbility4 ~= nil and NoTargetAbility4:IsFullyCastable() then
			NoTargetAbilityCast(NoTargetAbility4)
			return 1
		end
		
		if NoTargetAbility5 ~= nil and NoTargetAbility5:IsFullyCastable() then
			NoTargetAbilityCast(NoTargetAbility5)
			return 1
		end
		
		if thisEntity.ItemAbility and thisEntity.ItemAbility:IsFullyCastable() then
			return UseItem()
		end	
	end	
	return 1
end


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
			for _, T in ipairs(AutoCastItem) do
				if item:GetAbilityName() == T then
					thisEntity.ItemAbility = item
				end
			end
		end
	end
end

function UseItem()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
		AbilityIndex = thisEntity.ItemAbility:entindex(),
		Queue = false,
	})

	return 1
end

function NoTargetAbilityCast(abil)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = abil:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end
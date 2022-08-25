function Spawn( entityKeyValues )    -- вызывается когда юнит появляется
    if not IsServer() then        -- если сервер не отвечает
        return
    end
    if thisEntity == nil then    -- если данного юнита не существует
        return
    end

    thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 0.1 )    -- поведение юнита каждую секунду
end

function NecroLordThink()

    if ( not thisEntity:IsAlive() ) then        --если юнит мертв
        return -1  
    end
   
    if GameRules:IsGamePaused() == true then    --если игра приостановлена
        return 1  
    end

    local enemies = FindUnitsInRadius(
                        thisEntity:GetTeamNumber(),    --команда юнита
                        thisEntity:GetOrigin(),        --местоположение юнита
                        nil,    --айди юнита (необязательно)
                        20000,    --радиус поиска
                        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- юнитов чьей команды ищем вражеской/дружественной
                        DOTA_UNIT_TARGET_ALL,    --юнитов какого типа ищем
                        DOTA_UNIT_TARGET_FLAG_NONE,    --поиск по флагам
                        FIND_CLOSEST,    --сортировка от ближнего к дальнему или от дальнего к ближнему
                        false )
				if #enemies > 0 then    -- если количество найденных юнитов больше нуля
					local enemy = enemies[1]
					if enemy ~= nil then
					return Approach( enemy )
					end
		end
	return 0.5 
end

function Approach( unit )
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 0.5
end
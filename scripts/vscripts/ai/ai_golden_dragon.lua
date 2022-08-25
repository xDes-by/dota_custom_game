function Spawn( entityKeyValues )    -- вызывается когда юнит появляется
    if not IsServer() then        -- если сервер не отвечает
        return
    end
    if thisEntity == nil then    -- если данного юнита не существует
        return
    end

	PointAbility1 = thisEntity:FindAbilityByName( "dragon_knight_breathe_fire" )
	PointAbility2 = thisEntity:FindAbilityByName( "lina_stun" )


    thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 0.5 )    -- поведение юнита каждую секунду
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
                        700,    --радиус поиска
                        DOTA_UNIT_TARGET_TEAM_ENEMY,    -- юнитов чьей команды ищем вражеской/дружественной
                        DOTA_UNIT_TARGET_HERO,    --юнитов какого типа ищем
                        DOTA_UNIT_TARGET_FLAG_NONE,    --поиск по флагам
                        FIND_CLOSEST,    --сортировка от ближнего к дальнему или от дальнего к ближнему
                        false )
				if #enemies > 0     then    -- если количество найденных юнитов больше нуля
					if PointAbility2 ~= nil and PointAbility2:IsFullyCastable()  then    --если абилка существует и её можно использовать
						for _,unit in pairs(enemies) do
							if unit then -- Тут все твои проверки на хп и прочее.
								PointAbility2Cast(unit)
							end
							end
						return 1
					end	

					if PointAbility1 ~= nil and PointAbility1:IsFullyCastable()  then    --если абилка существует и её можно использовать
						for _,unit in pairs(enemies) do
							if unit then -- Тут все твои проверки на хп и прочее.
								PointAbility1Cast(unit)
							end
							end
						return 1
					end						
		end
	return 0.5 
end



function PointAbility1Cast(unit)
local vTargetPos = unit:GetOrigin()
ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
		Position = vTargetPos,
		AbilityIndex = PointAbility1:entindex(),
		Queue = false,
	})
    return 0.5
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
    return 0.5
end
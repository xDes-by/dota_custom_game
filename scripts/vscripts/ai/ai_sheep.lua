function Spawn( entityKeyValues )    -- вызывается когда юнит появляется
	if not IsServer() then        -- если сервер не отвечает
        return
    end
    if thisEntity == nil then    -- если данного юнита не существует
        return
    end
    thisEntity:SetContextThink( "NecroLordThink", NecroLordThink, 0.5 )    -- поведение юнита каждую секунду
end

function NecroLordThink()
	if thisEntity:GetRenderColor() then
		--thisEntity:SetRenderColor( 104, 85, 70 )
		end
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
                        100,    --радиус поиска
                        DOTA_UNIT_TARGET_TEAM_FRIENDLY,    -- юнитов чьей команды ищем вражеской/дружественной
                        DOTA_UNIT_TARGET_HERO,    --юнитов какого типа ищем
                        DOTA_UNIT_TARGET_FLAG_NONE,    --поиск по флагам
                        FIND_CLOSEST,    --сортировка от ближнего к дальнему или от дальнего к ближнему
                        false )

   for _, hEnemy in pairs( enemies ) do
	local id = hEnemy:GetPlayerID()
	
	Quests:UpdateCounter("bonus", id, 4, 1)
		end
	return 0.1
end


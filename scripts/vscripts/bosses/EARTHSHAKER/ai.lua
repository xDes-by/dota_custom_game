function math_round( roundIn , roundDig ) -- первый аргумент - число которое надо округлить, второй аргумент - количество символов после запятой.
    local mul = math.pow( 10, roundDig )
    return ( math.floor( ( roundIn * mul ) + 0.5 )/mul )
end
local threshold = nil
local prev_hp = nil
local owner = nil

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
		if not DataBase:isCheatOn() then
			DataBase:AddRP(owner:GetPlayerID(), 1)
			DataBase:Event2021Boss(owner:GetPlayerID())
		end
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if thisEntity:IsChanneling() then
        return 1 
    end

	if not threshold then
		prev_hp = thisEntity:GetMaxHealth()
		threshold = prev_hp * 0.05
	end
	if not owner then
		owner = thisEntity.summoner
	end
	local badguys_fort = Entities:FindByName(nil, "badguys_fort")
	if ( not badguys_fort or not badguys_fort:IsAlive() ) and _G.kill_invoker == false then
		thisEntity:AddNewModifier(nil, nil, "modifier_boss_invoker_active", {duration = 2})
		return 0.1
	end
	local hp_now = thisEntity:GetHealth()
	local AbilityTotem = thisEntity:FindAbilityByName("earthshaker_enchant_totem_lua")
	local AbilityEcho = thisEntity:FindAbilityByName("earthshaker_echo_slam_lua")
	local AbilityFissure = thisEntity:FindAbilityByName("earthshaker_fissure_lua")
	local AbilityEnrage = thisEntity:FindAbilityByName("earthshaker_enrage_lua")
	local AbilityVacuum = thisEntity:FindAbilityByName("earthshaker_vacuum_lua")
	local unitsInArea = GetEnemiesInRadius(thisEntity, 1100)

	if AbilityVacuum:IsFullyCastable() then
		local vacuum_point = FindBestClusterCenter(thisEntity, 1000, 600)
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = vacuum_point,
			AbilityIndex = AbilityVacuum:entindex(),
			Queue = false,
		})
	end
	if prev_hp - hp_now > threshold and AbilityEnrage:IsFullyCastable() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = AbilityEnrage:entindex(),
			Queue = false,
		})
	end
	prev_hp = hp_now
	if AbilityEcho:IsFullyCastable() and AbilityTotem:IsFullyCastable() then
		local echo_point = FindBestClusterCenter(thisEntity, 1100, 600)
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
			Position = echo_point,
			AbilityIndex = AbilityTotem:entindex(),
			Queue = false,
		})
		Timers:CreateTimer(1.1 ,function()
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = AbilityEcho:entindex(),
				Queue = false,
			})
		end)
		return 1
	end
	if AbilityTotem:IsFullyCastable() then
		local best_position, best_target, best_hit_count = FindBestSplashTarget(thisEntity, 1100, 1100, 150, 360, 10, 100)
		if best_position and best_target then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				Position = best_position,
				AbilityIndex = AbilityTotem:entindex(),
				Queue = false,
			})
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(), 
				OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
				TargetIndex = best_target:entindex(),
				Queue = true
			})
		end
	end
	if #unitsInArea < 1 and thisEntity.summoner:IsAlive() then
        ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(), 
            OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
            Position = owner:GetAbsOrigin()
        })
    end
	return 1
end

function IsTargetAncient(target)
    if target:GetUnitName() == "npc_main_base" then
        return true
    end
    return false
end

function FindBestClusterCenter(caster, search_radius, cluster_radius)
    local enemy_units = FindUnitsInRadius(
        caster:GetTeamNumber(),
        caster:GetAbsOrigin(),
        nil,
        search_radius,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    local best_cluster_center = caster:GetAbsOrigin()
    local max_enemies_in_cluster = 0

    for _, center_enemy in pairs(enemy_units) do
        local center_position = center_enemy:GetAbsOrigin()
        local enemies_in_cluster = {}
        local total_positions = Vector(0, 0, 0)

        for _, other_enemy in pairs(enemy_units) do
            local distance_to_center = (center_position - other_enemy:GetAbsOrigin()):Length2D()

            if distance_to_center <= cluster_radius then
                table.insert(enemies_in_cluster, other_enemy)
                total_positions = total_positions + other_enemy:GetAbsOrigin()
            end
        end

        if #enemies_in_cluster > max_enemies_in_cluster then
            max_enemies_in_cluster = #enemies_in_cluster
            best_cluster_center = total_positions / #enemies_in_cluster
        end
    end

    return best_cluster_center
end

function FindUnitsInCone( nTeamNumber, vCenterPos, vStartPos, vEndPos, fStartRadius, fEndRadius, hCacheUnit, nTeamFilter, nTypeFilter, nFlagFilter, nOrderFilter, bCanGrowCache )
	local direction = vEndPos-vStartPos
	direction.z = 0

	local distance = direction:Length2D()
	direction = direction:Normalized()

	local big_radius = distance + math.max(fStartRadius, fEndRadius)

	local units = FindUnitsInRadius(
		nTeamNumber,	-- int, your team number
		vCenterPos,	-- point, center point
		nil,	-- handle, cacheUnit. (not known)
		big_radius,	-- float, radius. or use FIND_UNITS_EVERYWHERE
		nTeamFilter,	-- int, team filter
		nTypeFilter,	-- int, type filter
		nFlagFilter,	-- int, flag filter
		nOrderFilter,	-- int, order filter
		bCanGrowCache	-- bool, can grow cache
	)

	local targets = {}
	for _,unit in pairs(units) do
		local vUnitPos = unit:GetOrigin()-vStartPos
		local fProjection = vUnitPos.x*direction.x + vUnitPos.y*direction.y + vUnitPos.z*direction.z
		fProjection = math.max(math.min(fProjection,distance),0)
		local vProjection = direction*fProjection
		local fUnitRadius = (vUnitPos - vProjection):Length2D()
		local fInterpRadius = (fProjection/distance)*(fEndRadius-fStartRadius) + fStartRadius
		if fUnitRadius<=fInterpRadius then
			table.insert( targets, unit )
		end
	end
	return targets
end

function GetSplashHitCount(caster, target, splash_origin, search_radius, cleave_radius, starting_width, ending_width, step_angle, offset_distance)
    local UnitsInCone = FindUnitsInCone( caster:GetTeamNumber(), target:GetOrigin(), splash_origin, cleave_radius, starting_width, ending_width, nil, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	if #UnitsInCone > 0 then 
		return #UnitsInCone
	end
	return 0
end

function GetEnemiesInRadius(caster, radius)
    return FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
end

function FindBestSplashPosition(caster, target, search_radius, cleave_radius, starting_width, ending_width, step_angle, offset_distance)
    local best_hit_count = 0
    local best_direction = nil

    for angle = 0, 360, step_angle do
        local direction = RotatePosition(Vector(0, 0, 0), QAngle(0, angle, 0), caster:GetForwardVector())
        local splash_origin = target:GetAbsOrigin() + direction * offset_distance
        local hit_count = GetSplashHitCount(caster, target, splash_origin, search_radius, splash_origin + (-direction*cleave_radius/2), starting_width, ending_width, step_angle, offset_distance)

        if hit_count > best_hit_count then
            best_hit_count = hit_count
            best_direction = direction
        end
    end
	if not best_direction then return false end
    return {target = target, position = target:GetAbsOrigin() + best_direction * offset_distance, hit_count = best_hit_count}
end

function FindBestSplashTarget(caster, search_radius, cleave_radius, starting_width, ending_width, step_angle, offset_distance)
	local enemies = GetEnemiesInRadius(caster, search_radius)
	local targets = {}
	if #enemies < 1 then return false end
	for _,target in ipairs(enemies) do
		table.insert(targets, FindBestSplashPosition(caster, target, search_radius, cleave_radius, starting_width, ending_width, step_angle, offset_distance))
	end
	local best_hit_count = 0
	local best_target = nil
	local best_position = nil
	for _,target in ipairs(targets) do
		if target.hit_count > best_hit_count then
			best_hit_count = target.hit_count
			best_target = target.target
			best_position = target.position
		end
	end
	return best_position, best_target, best_hit_count
end




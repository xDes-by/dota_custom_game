require("data/data")

function Spawn( entityKeyValues )
    if not IsServer() then
        return
    end

    if thisEntity == nil then
        return
    end
	
	NoTargetAbility = thisEntity:FindAbilityByName( "invoker_sun" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "invoker_meteor" )
	NoTargetAbility3 = thisEntity:FindAbilityByName( "invoker_nova" )
	NoTargetAbility4 = thisEntity:FindAbilityByName( "wisp_spirits_datadriven" )
	NoTargetAbility5 = thisEntity:FindAbilityByName( "nyx_borrow" )
	TargetAbility = thisEntity:FindAbilityByName( "invoker_telekinesis" )
	PointAbility = thisEntity:FindAbilityByName( "custom_earth_splitter" )
	
	-- NoTargetAbility6 = thisEntity:FindAbilityByName( "custom_nyx_skill" )
	-- PointAbility2 = thisEntity:FindAbilityByName( "tusk_snowball_meteor")
	-- PointAbility3 = thisEntity:FindAbilityByName( "custom_earth_splitter")

    thisEntity:SetContextThink( "NeutralThink", NeutralThink, 1 )
end

function NeutralThink()


   local ancient = Entities:FindByName(nil, "npc_main_base")
	if ancient ~= nil then
		if thisEntity:IsAlive() then
		if not thisEntity:IsChanneling() and thisEntity:GetCurrentActiveAbility() == nil and not thisEntity:IsCommandRestricted() then
				if not thisEntity:IsDisarmed() then
					local attackOrder = {
						UnitIndex = thisEntity:entindex(), 
						OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
						Position = ancient:GetAbsOrigin()
						}
				ExecuteOrderFromTable(attackOrder)
			else 
				local attackOrder = {
					UnitIndex = thisEntity:entindex(), 
					OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
					Position = thisEntity:GetAbsOrigin()
					}
				ExecuteOrderFromTable(attackOrder)
			end
		end
    end
	end

    if ( not thisEntity:IsAlive() ) then
		return -1
	end	

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if thisEntity:IsChanneling() then
        return 1 
    end
	
	local search_radius = thisEntity:GetAcquisitionRange()
	local hp = thisEntity:GetHealthPercent()
	local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then
		--enemy = enemies[1]
		
		if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
		end
		
			if hp == 100 then
				local invoker_invo = {"invoker_invo_thanks_02","invoker_invo_spawn_04","invoker_invo_kill_01","invoker_invo_level_01","invoker_invo_rare_05"}
				thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
				return 5
			end

			if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
						NoTargetAbilityCast(unit)
						local invoker_invo = {"invoker_invo_level_06","invoker_invo_deny_06"}
						thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
					end
				end
				return 2
			end
			
			if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
						NoTargetAbilityCast2(unit)
						local invoker_invo =  {"invoker_invo_ability_invoker_invoke_15","invoker_invo_ability_sunstrike_04","invoker_invo_ability_sunstrike_05","invoker_invo_ability_sunstrike_01"}
						thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
					end
				end
				return 2
			end
			
			if TargetAbility ~= nil and TargetAbility:IsFullyCastable()  then
			   for _,unit in pairs(enemies) do
					if unit then
							TargetAbilityCast( enemies[ RandomInt( 1, #enemies ) ] )
							local invoker_invo =  {"invoker_invo_ability_invoker_invoke_15","invoker_invo_ability_sunstrike_04","invoker_invo_ability_sunstrike_05","invoker_invo_ability_sunstrike_01"}
							thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
							end
						end
				return 2
			end 
			
			if NoTargetAbility3 ~= nil and NoTargetAbility3:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
						NoTargetAbilityCast3(unit)
						local invoker_invo =  {"invoker_invo_thanks_02","invoker_invo_spawn_04","nvo_ability_icewall_04"}
						thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
					end
				end
				return 2
			end
			
		if PointAbility ~= nil and PointAbility:IsFullyCastable()  then
					for _,unit in pairs(enemies) do
						if unit then
						PointAbilityCast(unit)
						local invoker_invo = {"invoker_invo_respawn_02","pud_attack_05","pud_attack_06"}
						thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
					end
				end
			return 2
		end	
		
		if NoTargetAbility4 ~= nil and NoTargetAbility3:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
						NoTargetAbilityCast3(unit)
						local invoker_invo =  {"invoker_invo_attack_04.vsnd","invoker_invo_invis_02"}
						thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
					end
				end
				return 2
			end
		
		if PointAbility2 ~= nil and PointAbility2:IsFullyCastable()  then
					for _,unit in pairs(enemies) do
						if unit then
						PointAbilityCast2(unit)
						local invoker_invo = {"invoker_invo_ability_chaosmeteor_07","invoker_invo_items_08","invoker_invo_ability_icewall_05"}
						thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
					end
				end
			return 2
		end	
		
		if PointAbility3 ~= nil and PointAbility3:IsFullyCastable()  then
					for _,unit in pairs(enemies) do
						if unit then
						PointAbilityCast3(unit)
						local invoker_invo = {"invoker_invo_level_12","invoker_invo_ability_chaosmeteor_03","pud_attack_06"}
						thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
					end
				end
			return 2
		end	
		
		if NoTargetAbility5 ~= nil and NoTargetAbility5:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
						NoTargetAbilityCast5(unit)
						local invoker_invo = {"invoker_invo_move_13","invoker_invo_spawn_03"}
						thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
					end
				end
				return 2
			end
			
		if NoTargetAbility6 ~= nil and NoTargetAbility6:IsFullyCastable()  then
				for _,unit in pairs(enemies) do
					if unit then
						NoTargetAbilityCast6(unit)
						local invoker_invo = {"invoker_invo_ability_deafeningblast_03","invoker_invo_ability_coldsnap_02"}
						thisEntity:EmitSound(invoker_invo[RandomInt(1, #invoker_invo)])
					end
				end
				return 2
			end
		
			for i = 1, 6, 1 do
			local Item = thisEntity.ItemAbillaty[i]
			if thisEntity.ItemAbillaty[i] and thisEntity.ItemAbillaty[i]:IsFullyCastable() then
				local Behavior = Item:GetBehavior()
				if bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
					Item.Behavior = "target"
					if bit.band( Item:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_ENEMY ) == DOTA_UNIT_TARGET_TEAM_ENEMY then
							UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
						--elseif bit.band( Item:GetAbilityTargetTeam(), DOTA_UNIT_TARGET_TEAM_FRIENDLY ) == DOTA_UNIT_TARGET_TEAM_FRIENDLY then
							--if #friends > 0 then 
								--UseItem(thisEntity.ItemAbillaty[i], friends[ math.random( 1, #friends ) ])
							--end
						end
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
					Item.Behavior = "no_target"
					if Item:GetAbilityName() == "item_black_king_bar" then
						if thisEntity:IsSilenced() then
							UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
						end
					elseif Item:GetAbilityName() == "item_lotus_orb" then
						if hp < 90 then
							UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
						end
					elseif Item:GetAbilityName() == "item_ethereal_blade_lua" then
						if hp < 90 then
							UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
						end
					else
						UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
					end
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_POINT ) == DOTA_ABILITY_BEHAVIOR_POINT then
					Item.Behavior = "point"
					UseItem(thisEntity.ItemAbillaty[i], enemies[ math.random( 1, #enemies ) ])
				end
			end
		end
		return 1
	end	
	GridNav:DestroyTreesAroundPoint( thisEntity:GetOrigin(), 400, true )
	return 1
end

function SearchForItems()
		thisEntity.ItemAbillaty = {nil, nil, nil, nil, nil, nil}
		for i = 0, 5 do
			local item = thisEntity:GetItemInSlot( i )
			if item then
			for _, T in ipairs(AutoCastItem) do
				if item:GetAbilityName() == T then
					if not thisEntity.ItemAbillaty[1] then
						thisEntity.ItemAbillaty[1] = item
					elseif not thisEntity.ItemAbillaty[2] then
						thisEntity.ItemAbillaty[2] = item
					elseif not thisEntity.ItemAbillaty[3] then
						thisEntity.ItemAbillaty[3] = item
					elseif not thisEntity.ItemAbillaty[4] then
						thisEntity.ItemAbillaty[4] = item
					elseif not thisEntity.ItemAbillaty[5] then
						thisEntity.ItemAbillaty[5] = item
					elseif not thisEntity.ItemAbillaty[6] then
						thisEntity.ItemAbillaty[6] = item
					end
				end
			end
		end
	end
end


function UseItem(item , enemy)
	local order_type
	local vTargetPos = enemy:GetOrigin()
	
	if item.Behavior == "target" then
        order_type = DOTA_UNIT_ORDER_CAST_TARGET    -- на цель
    elseif item.Behavior == "no_target" then
        order_type = DOTA_UNIT_ORDER_CAST_NO_TARGET    -- без цели
    elseif item.Behavior == "point" then
        order_type = DOTA_UNIT_ORDER_CAST_POSITION    -- на точку
    elseif item.Behavior == "passive" then
        return
    end
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = order_type,
		Position = vTargetPos,
		TargetIndex = enemy:entindex(),  
		AbilityIndex = item:entindex(),
		Queue = false,
	})
	return 0.1
end


function Cast( Spell , enemy )
	local order_type
	local vTargetPos = enemy:GetOrigin()
	
    if Spell.Behavior == "target" then
        order_type = DOTA_UNIT_ORDER_CAST_TARGET
    elseif Spell.Behavior == "no_target" then
        order_type = DOTA_UNIT_ORDER_CAST_NO_TARGET
    elseif Spell.Behavior == "point" then
        order_type = DOTA_UNIT_ORDER_CAST_POSITION
    elseif Spell.Behavior == "passive" then
        return
    end

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = order_type,
		Position = vTargetPos,
		TargetIndex = enemy:entindex(),  
		AbilityIndex = Spell:entindex(),
		Queue = false,
	})
end
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

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

function NoTargetAbilityCast4(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility4:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function NoTargetAbilityCast5(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility5:entindex(), -- индекс способности
            Queue = false,
        })
    return 1
end

function NoTargetAbilityCast6(unit)
      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility6:entindex(), -- индекс способности
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

function PointAbilityCast2(unit)
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

function PointAbilityCast3(unit)
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

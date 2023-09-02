require("data/data")

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
	local ancient = Entities:FindByName(nil, "npc_main_base")
	if ancient ~= nil then
		if thisEntity:IsAlive() then
		if not thisEntity:IsChanneling() and thisEntity:GetCurrentActiveAbility() == nil and not thisEntity:IsCommandRestricted() and not thisEntity:IsAttacking() then
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
	print("A")
	
	local search_radius = thisEntity:GetAcquisitionRange()
	local hp = thisEntity:GetHealthPercent()
	local enemies = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, search_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false )
	if #enemies > 0 then
	enemy = enemies[1]
	print("1")
		for _, T in ipairs(bosses_ability) do
			local Spell = thisEntity:FindAbilityByName(T)
			print("2")
			if Spell then
			print("3")
				local Behavior = Spell:GetBehaviorInt()
				if bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET ) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
					Spell.Behavior = "target"
					Cast( Spell, enemy )
					print("4")
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET ) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
					Spell.Behavior = "no_target"
					print("5")
					if Spell:GetSpecialValueFor("radius") == 0 then
						Cast( Spell, enemy )
					elseif ( enemy:GetOrigin()- thisEntity:GetOrigin() ):Length2D() < Spell:GetSpecialValueFor("radius") then
						Cast( Spell, enemy )
					end
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_POINT ) == DOTA_ABILITY_BEHAVIOR_POINT then
				print("6")
					Spell.Behavior = "point"
					Cast( Spell, enemy )
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_TOGGLE ) == DOTA_ABILITY_BEHAVIOR_POINT then
				print("7")
					Spell.Behavior = "toggle"
					if not Spell:GetToggleState() then 
						Spell:ToggleAbility()
					end
				elseif bit.band( Behavior, DOTA_ABILITY_BEHAVIOR_PASSIVE ) == DOTA_ABILITY_BEHAVIOR_PASSIVE then
				print("8")
					Spell.Behavior = "passive"
				end
			end
		end		
	end			
	return 1
end

function Cast( Spell , enemy )
print("cast")
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

print(order_type)
print(enemy)
print(vTargetPos)
print(Spell)

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = order_type,
		Position = vTargetPos,
		TargetIndex = enemy:entindex(),  
		AbilityIndex = Spell:entindex(),
		Queue = false,
	})
end




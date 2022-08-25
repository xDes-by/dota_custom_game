function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	NoTargetAbility = thisEntity:FindAbilityByName( "boss_split" )
	NoTargetAbility2 = thisEntity:FindAbilityByName( "raid_thunder_clap" )
	NoTargetAbility3 = thisEntity:FindAbilityByName( "fallen_meteor" )
	PointAbility = thisEntity:FindAbilityByName( "raid_boss_tornado" )

	thisEntity:SetContextThink( "HellbearThink", HellbearThink, 1 )
end

raid_clap = 0
raid_fallen = 0
raid_tornado = 0

--------------------------------------------------------------------------------

function HellbearThink()
	if ( not thisEntity:IsAlive() ) then
		return -1
	end
	
	if not thisEntity.bSearchedForItems then
		SearchForItems()
		thisEntity.bSearchedForItems = true
	end

	if GameRules:IsGamePaused() == true then
		return 1
	end
	
	if thisEntity:IsChanneling() then
        return 1 
    end
	
	if thisEntity:IsInvulnerable() then
        return 1 
    end
	
	if not thisEntity.bInitialized then
		local ent = Entities:FindByName( nil, "point_center2")
		local point = ent:GetAbsOrigin() 
		thisEntity.vInitialSpawnPos = point
		thisEntity.bInitialized = true
	end
	
	if ( not thisEntity.bAcqRangeModified ) and thisEntity:GetAggroTarget() then
		thisEntity:SetAcquisitionRange( 1050 )
		thisEntity.bAcqRangeModified = true
	end

	if thisEntity:GetAggroTarget() then
		thisEntity.fTimeWeLostAggro = nil
	end

	if thisEntity:GetAggroTarget() and ( thisEntity.fTimeAggroStarted == nil ) then
		thisEntity.fTimeAggroStarted = GameRules:GetGameTime()
	end

	if ( not thisEntity:GetAggroTarget() ) and ( thisEntity.fTimeAggroStarted ~= nil ) then
		thisEntity.fTimeWeLostAggro = GameRules:GetGameTime()
		thisEntity.fTimeAggroStarted = nil
	end

	if ( not thisEntity:GetAggroTarget() ) then
		if thisEntity.fTimeWeLostAggro and ( GameRules:GetGameTime() > ( thisEntity.fTimeWeLostAggro + 1.0 ) ) then
			return RetreatHome()
		end
	end

	local enemies = FindUnitsInRadius( thisEntity:GetTeamNumber(), thisEntity:GetOrigin(), nil, 1050, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
	if #enemies > 0 then
        if NoTargetAbility ~= nil and NoTargetAbility:IsFullyCastable() and thisEntity:GetHealthPercent() <= 20  then
			NoTargetAbilityCast(unit)
			return 1
		end

-----------------------------------------------------------------------------------------------------------		
			
		if NoTargetAbility2 ~= nil and NoTargetAbility2:IsFullyCastable() and raid_clap < #enemies then
			raid_clap = raid_clap + 1
            for _,unit in pairs(enemies) do
				if unit then--and not unit:HasModifier("modifier_raid_thunder_clap") then						
				NoTargetAbilityCast2(unit)
				 Timers:CreateTimer({endTime = 0.2, callback = function()
						NoTargetAbility2:EndCooldown()
					end})
				end
			end
			return 0.7
		end	
		
		if raid_clap >= #enemies then 
			raid_clap = 0
			NoTargetAbility2:StartCooldown(15)
		end	
		
-----------------------------------------------------------------------------------------------------------		
	
		if NoTargetAbility3 ~= nil and NoTargetAbility3:IsFullyCastable() and raid_fallen < 3 then
		raid_fallen = raid_fallen + 1
            for _,unit in pairs(enemies) do
				if unit then
				NoTargetAbilityCast3(unit)
				 Timers:CreateTimer({endTime = 0.2, callback = function()
						NoTargetAbility3:EndCooldown()
					end})
				end
			end
			return 1.3
		end	
		
		if raid_fallen >= 3 then 
			raid_fallen = 0
			NoTargetAbility3:StartCooldown(12)
		end	

-----------------------------------------------------------------------------------------------------------		

		if PointAbility ~= nil and PointAbility:IsFullyCastable() and raid_tornado < 3 then
		raid_tornado = raid_tornado + 1
		for _,unit in pairs(enemies) do
			if unit then
				PointAbilityCast(unit)
				 Timers:CreateTimer({endTime = 0.2, callback = function()
					PointAbility:EndCooldown()
				end})
				end
			end
			return 1
		end
		
		if raid_tornado >= 3 then 
			raid_tornado = 0
			PointAbility:StartCooldown(10)
		end	
		
			return 1
		end
	return 2
end

--------------------------------------------------------------------------------
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
			if item:GetAbilityName() == "item_shivas_guard" then
				thisEntity.hBlademailAbility = item
			end
			if item:GetAbilityName() == "item_blink" then
				thisEntity.hBlink = item
			end
		end
	end
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
	ProjectileManager:ProjectileDodge(thisEntity) 
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, thisEntity) 
    thisEntity:EmitSound("DOTA_Item.BlinkDagger.Activate")
	local point = unit:GetAbsOrigin() 
	thisEntity:SetAbsOrigin( point )
	FindClearSpaceForUnit(thisEntity, point, false)
	thisEntity:Stop() 

      ExecuteOrderFromTable({
            UnitIndex = thisEntity:entindex(),    --индекс кастера
            OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,    -- тип приказа
            AbilityIndex = NoTargetAbility2:entindex(), -- индекс способности
            Queue = false,
        })
    return 0.2
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
		Position = vTargetPos + RandomVector( RandomFloat( 150, 150 )),
		AbilityIndex = PointAbility:entindex(),
		Queue = false,
	})
    return 0.5
end
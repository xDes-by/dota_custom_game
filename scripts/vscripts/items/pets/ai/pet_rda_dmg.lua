function Spawn( entityKeyValues )
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end
	
	thisEntity:SetContextThink( "BanditArcherThink", BanditArcherThink, 0.5 )
end

--------------------------------------------------------------------------------
function BanditArcherThink()
	if not IsServer() then
		return
	end

	if ( not thisEntity:IsAlive() ) then
		return -1
	end

	if GameRules:IsGamePaused() == true then
		return 0.5
	end
	
	local owner = thisEntity:GetOwner()
	
	if owner:HasModifier("modifier_rda_pet_dmg") then
		thisEntity:AddNoDraw()
	else
		thisEntity:RemoveNoDraw()
	end	
	
	local flDist = ( thisEntity:GetOwner():GetOrigin() - thisEntity:GetOrigin() ):Length2D()
			if flDist < 400 then
				return Retreat(owner)
			end
			if flDist >= 400 and flDist < 800 then
				return Approach(owner)
			end
			
			if flDist > 1000 then
				return blink(owner)
			end
	return 0.5
end


function blink(unit)
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()
	
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		thisEntity:SetAbsOrigin( unit:GetOrigin() + RandomVector( RandomFloat(50, 50 ))  )
	})
	FindClearSpaceForUnit(thisEntity, unit:GetOrigin()+ RandomVector( RandomFloat(50, 50 )), false)
	return 1
end

function Approach(unit)
	local vToEnemy = unit:GetOrigin() - thisEntity:GetOrigin()
	vToEnemy = vToEnemy:Normalized()
	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = thisEntity:GetOrigin() + vToEnemy * thisEntity:GetIdealSpeed()
	})
	return 1
end

function Retreat(unit)
	local vAwayFromEnemy = thisEntity:GetOrigin() - unit:GetOrigin()
	vAwayFromEnemy = vAwayFromEnemy:Normalized()
	local vMoveToPos = thisEntity:GetOrigin() + vAwayFromEnemy * thisEntity:GetIdealSpeed()
	local nAttempts = 0
	while ( ( not GridNav:CanFindPath( thisEntity:GetOrigin(), vMoveToPos ) ) and ( nAttempts < 5 ) ) do
		vMoveToPos = thisEntity:GetOrigin() + RandomVector( thisEntity:GetIdealSpeed() )
		nAttempts = nAttempts + 1
	end
	
	thisEntity.fTimeOfLastRetreat = GameRules:GetGameTime()

	ExecuteOrderFromTable({
		UnitIndex = thisEntity:entindex(),
		OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
		Position = vMoveToPos,
	})
	return 1.5
end

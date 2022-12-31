function Spawn(entityKeyValues)
	if IsServer() and thisEntity and thisEntity:GetTeam() == DOTA_TEAM_NEUTRALS then
		thisEntity:SetContextThink("CreepThink", CreepThink, 0.5)
	end
end

function CreepThink()
	local status, nextCall = ErrorTracking.Try(function()

		-- If this unit is dead, stop thinking
		if not thisEntity:IsAlive() then
			return
		end

		-- If the game is paused or this unit is channeling, come back later
		if GameRules:IsGamePaused() or thisEntity:IsChanneling() or (not RoundManager:IsRoundStarted()) then
			return 0.1
		end

		-- Attempt to cast spell
		local flAbilityCastTime = CastAbilities()
		if flAbilityCastTime then
			return flAbilityCastTime + 0.2

		-- If it can't be cast, wait
		else
			return 0.1
		end
	end)
	
	-- If an error happened, calculate again after 1 second
	if status then
		return nextCall
	else
		return 1
	end
end

-------------------------------------------------------------------

function ContainsValue(nSum,nValue)
	return bit.band(nSum, nValue) == nValue
end

-------------------------------------------------------------------

function CastAbilities()

	for i = 0, (DOTA_MAX_ABILITIES - 1) do
		local hAbility = thisEntity:GetAbilityByIndex(i)
		if hAbility and (not hAbility:IsPassive()) and hAbility:IsFullyCastable() and hAbility:IsActivated() then
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hAbility:entindex(),
			})
			return hAbility:GetCastPoint()
		end
	end

	return nil
end

function CreepThink(thisEntity)
	local function _CreepThink()
		local status, nextCall = ErrorTracking.Try(function()

			-- If this unit is dead, stop thinking
			if not thisEntity:IsAlive() then
				return
			end

			-- If the game is paused or this unit is channeling, come back later
			if GameRules:IsGamePaused() or thisEntity:IsChanneling() or (not RoundManager:IsRoundStarted()) then
				return 0.1
			end

			local hTarget

			-- If there isn't a valid target, search for one
			if thisEntity.hTarget and (not thisEntity.hTarget:IsNull()) and thisEntity.hTarget:IsAlive() then
				hTarget = thisEntity.hTarget
				--print("Old target", thisEntity.hTarget:GetUnitName())
			else
				local vEnemies = {}
				--print("Find new target")

				-- Search for a target among the spawned unit's target team
				if thisEntity.spawn_team then
					vEnemies = FindUnitsInRadius(thisEntity.spawn_team, thisEntity:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, FIND_CLOSEST, false)
					vEnemies = table.filter_array(vEnemies, DummyFilterFunc)

					--for k,v in pairs(vEnemies) do
					--	print(v:GetUnitName(), v:entindex())
					--end
				-- If there's no valid team, self-destruct
				else
					thisEntity:ForceKill(false)
					return
				end

				-- Target the closest enemy
				if #vEnemies > 0 then
					thisEntity.hTarget = vEnemies[1]
					--print("New target", thisEntity.hTarget:GetUnitName())
					hTarget = thisEntity.hTarget
					CelebrateIfDead(thisEntity, hTarget)
				-- If there's no valid target, wait in place
				else
					thisEntity.hTarget = nil
					IdleCelebration(thisEntity)
					return 0.1
				end
			end

			-- Attempt to cast spells
			local flAbilityCastTime = thisEntity.CastAbilities(thisEntity.hTarget)

			if flAbilityCastTime then
				return flAbilityCastTime + 0.2
			-- If there are no spells to cast, attack
			else
				if not thisEntity:IsAttacking() then
					ExecuteOrderFromTable({
						UnitIndex = thisEntity:entindex(),
						OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
						Position = hTarget:GetAbsOrigin()
					})
				end

				return 0.5
			end
		end)

		-- If an error happened, calculate again after 1 second
		if status then
			return nextCall
		else
			return 1
		end
	end
	return _CreepThink
end

function CelebrateIfDead(unit, target)
	if not unit or unit:IsNull() then return end
	unit.idle_counter = 0

	if not target or target:IsNull() then
		unit:StartGesture(ACT_DOTA_VICTORY)
		return
	end

	if not target:IsAlive() and not target:IsReincarnating() then
		unit:StartGesture(ACT_DOTA_VICTORY)
	end
	unit:RemoveGesture(ACT_DOTA_VICTORY)
end


function IdleCelebration(unit)
	if not unit then return end
	if unit:IsNull() then return end

	if not unit.idle_counter then unit.idle_counter = 1 end
	unit.idle_counter = unit.idle_counter + 1
	if unit.idle_counter >= 5 then
		unit:StartGesture(ACT_DOTA_VICTORY)
	end
end


function ContainsValue(nSum,nValue)
	return bit.band(nSum, nValue) == nValue
end

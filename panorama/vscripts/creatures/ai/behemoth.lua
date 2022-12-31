require("creatures/ai/ai_shared")

function Spawn(entityKeyValues)
	if IsServer() and thisEntity and thisEntity:GetTeam() == DOTA_TEAM_NEUTRALS then
		thisEntity.CastAbilities = CastAbilities
		thisEntity:SetContextThink("CreepThink", CreepThink(thisEntity), 0.5)
	end
end

function CastAbilities(hTarget)

	local hAbility = thisEntity:FindAbilityByName("boss_black_hole")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() then
		local enemies = FindUnitsInRadius(thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
				AbilityIndex = hAbility:entindex(),
				Position = enemy:GetAbsOrigin()
			})
			return hAbility:GetCastPoint()
		end
	end

	hAbility = thisEntity:FindAbilityByName("boss_chemical_rage")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() and thisEntity:GetHealthPercent() < 70 then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hAbility:entindex(),
		})
		return hAbility:GetCastPoint()
	end

	hAbility = thisEntity:FindAbilityByName("boss_borrowed_time")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() and thisEntity:GetHealthPercent() < 40 then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hAbility:entindex(),
		})
		return hAbility:GetCastPoint()
	end

	hAbility = thisEntity:FindAbilityByName("boss_ravage")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() and thisEntity:GetHealthPercent() < 80 then
		local enemies = FindUnitsInRadius(thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = hAbility:entindex(),
			})
			return hAbility:GetCastPoint()
		end
	end

	hAbility = thisEntity:FindAbilityByName("boss_life_drain")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() and thisEntity:GetHealthPercent() < 60 then
		local enemies = FindUnitsInRadius(thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, 800, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
			ExecuteOrderFromTable({
				UnitIndex = thisEntity:entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
				AbilityIndex = hAbility:entindex(),
				TargetIndex = enemy:entindex()
			})
			return hAbility:GetCastPoint()
		end
	end

	hAbility = thisEntity:FindAbilityByName("boss_overcharge")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() and thisEntity:GetHealthPercent() < 40 then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hAbility:entindex(),
		})
		return hAbility:GetCastPoint()
	end

	return nil
end

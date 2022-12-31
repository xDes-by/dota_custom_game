require("creatures/ai/ai_shared")

function Spawn(entityKeyValues)
	if IsServer() and thisEntity and thisEntity:GetTeam() == DOTA_TEAM_NEUTRALS then
		thisEntity.CastAbilities = CastAbilities
		thisEntity:SetContextThink("CreepThink", CreepThink(thisEntity), 0.5)
	end
end

function CastAbilities(hTarget)

	local hAbility = thisEntity:FindAbilityByName("creature_shared_soul")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() then
		local allies = FindUnitsInRadius(thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, 1000, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_ANY_ORDER, false)
		for _, ally in pairs(allies) do
			if ally ~= thisEntity and ally:FindAbilityByName("creature_shared_soul") and (not ally:HasModifier("modifier_creature_shared_soul")) then
				ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
					AbilityIndex = hAbility:entindex(),
					TargetIndex = ally:entindex()
				})
				return hAbility:GetCastPoint()
			end
		end
	end

	return nil
end

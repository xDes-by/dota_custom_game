require("creatures/ai/ai_shared")

function Spawn(entityKeyValues)
	if IsServer() and thisEntity and thisEntity:GetTeam() == DOTA_TEAM_NEUTRALS then
		thisEntity.CastAbilities = CastAbilities
		thisEntity:SetContextThink("CreepThink", CreepThink(thisEntity), 0.5)
	end
end

function CastAbilities(hTarget)

	local spawn_abilities = {
		"boss_spawn_spiderling",
		"boss_spawn_baneling",
		"boss_spawn_spiderite"
	}

	for _, ability_name in pairs(spawn_abilities) do
		local hAbility = thisEntity:FindAbilityByName(ability_name)
		if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() then
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

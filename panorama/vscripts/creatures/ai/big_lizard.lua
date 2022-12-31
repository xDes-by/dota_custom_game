require("creatures/ai/ai_shared")

function Spawn(entityKeyValues)
	if IsServer() and thisEntity and thisEntity:GetTeam() == DOTA_TEAM_NEUTRALS then
		thisEntity.CastAbilities = CastAbilities
		thisEntity:SetContextThink("CreepThink", CreepThink(thisEntity), 0.5)
	end
end

function CastAbilities(hTarget)

	local hAbility = thisEntity:FindAbilityByName("big_thunder_lizard_slam")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() then
		local enemies = FindUnitsInRadius(thisEntity:GetTeam(), thisEntity:GetAbsOrigin(), nil, 225, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _, enemy in pairs(enemies) do
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

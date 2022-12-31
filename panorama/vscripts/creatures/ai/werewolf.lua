require("creatures/ai/ai_shared")

function Spawn(entityKeyValues)
	if IsServer() and thisEntity and thisEntity:GetTeam() == DOTA_TEAM_NEUTRALS then
		thisEntity.CastAbilities = CastAbilities
		thisEntity:SetContextThink("CreepThink", CreepThink(thisEntity), 0.5)
	end
end

function CastAbilities(hTarget)

	local hAbility = thisEntity:FindAbilityByName("boss_shapeshift")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() and thisEntity:GetHealthPercent() <= 90 and (not thisEntity:HasModifier("modifier_lycan_shapeshift")) then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hAbility:entindex(),
		})
		return hAbility:GetCastPoint() + 0.8
	end

	hAbility = thisEntity:FindAbilityByName("boss_howl")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() then
		ExecuteOrderFromTable({
			UnitIndex = thisEntity:entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = hAbility:entindex(),
		})
		return hAbility:GetCastPoint()
	end

	return nil
end

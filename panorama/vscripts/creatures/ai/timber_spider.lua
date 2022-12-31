require("creatures/ai/ai_shared")

function Spawn(entityKeyValues)
	if IsServer() and thisEntity and thisEntity:GetTeam() == DOTA_TEAM_NEUTRALS then
		thisEntity.CastAbilities = CastAbilities
		thisEntity:SetContextThink("CreepThink", CreepThink(thisEntity), 0.5)
	end
end

function CastAbilities(hTarget)

	local hAbility = thisEntity:FindAbilityByName("creature_timber_chain")
	if hAbility and hAbility:IsFullyCastable() and hAbility:IsActivated() then
		local thisEntityLoc = thisEntity:GetAbsOrigin()
		local maxRangeDirection = (hTarget:GetAbsOrigin() - thisEntityLoc):Normalized()
		local currentDistance = 0
		for step = 1, 20 do
			currentDistance = step * 90
			local trees = GridNav:GetAllTreesAroundPoint(thisEntityLoc + maxRangeDirection * currentDistance, 180, true)
			for _, tree in pairs(trees) do
				if tree.IsStanding and tree:IsStanding() then
					ExecuteOrderFromTable({
						UnitIndex = thisEntity:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
						AbilityIndex = hAbility:entindex(),
						Position = tree:GetAbsOrigin()
					})
					return hAbility:GetCastPoint()
				end
			end
		end
	end

	return nil
end

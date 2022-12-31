require("creatures/ai/ai_shared")

function Spawn(entityKeyValues)
	if IsServer() and thisEntity and thisEntity:GetTeam() == DOTA_TEAM_NEUTRALS then
		thisEntity.CastAbilities = CastAbilities
		thisEntity:SetContextThink("CreepThink", CreepThink(thisEntity), 0.5)
	end
end

function CastAbilities(hTarget)

	for i = 0, (DOTA_MAX_ABILITIES - 1) do
		local hAbility = thisEntity:GetAbilityByIndex(i)
		if hAbility and (not hAbility:IsPassive()) and hAbility:IsFullyCastable() and hAbility:IsActivated() then
			local cast_behavior = hAbility:GetBehaviorInt()
			local target_team = hAbility:GetAbilityTargetTeam()

			-- Unit targeting abilities
			if ContainsValue(cast_behavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) and (not ContainsValue(cast_behavior, DOTA_ABILITY_BEHAVIOR_ATTACK)) then
				
				-- Enemy-targeted abilities
				if ContainsValue(target_team, DOTA_UNIT_TARGET_TEAM_ENEMY) or ContainsValue(target_team, DOTA_UNIT_TARGET_TEAM_CUSTOM) then
					ExecuteOrderFromTable({
						UnitIndex = thisEntity:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						AbilityIndex = hAbility:entindex(),
						TargetIndex = hTarget:entindex()
					})
					return hAbility:GetCastPoint()
				end

				-- Self-targeted abilities
				if ContainsValue(target_team, DOTA_UNIT_TARGET_TEAM_FRIENDLY) then
					ExecuteOrderFromTable({
						UnitIndex = thisEntity:entindex(),
						OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
						AbilityIndex = hAbility:entindex(),
						TargetIndex = thisEntity:entindex()
					})
					return hAbility:GetCastPoint()
				end
			end

			-- Ground-targeted abilities
			if ContainsValue(cast_behavior, DOTA_ABILITY_BEHAVIOR_POINT) then

				-- Always casts on the target's direction
				local vTargetPos = hTarget:GetOrigin()

				-- Exception for Wild Axes
				if hAbility:GetAbilityName() == "jabber_wild_axes" then
					vTargetPos = vTargetPos + 500 * (vTargetPos - thisEntity:GetAbsOrigin()):Normalized()
				end

				ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_POSITION,
					Position =  vTargetPos,
					AbilityIndex = hAbility:entindex(),
				})
				return hAbility:GetCastPoint()
			end

			-- Abilities without targeting
			if ContainsValue(cast_behavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) and (not ContainsValue(cast_behavior, DOTA_ABILITY_BEHAVIOR_AUTOCAST)) then
					
				ExecuteOrderFromTable({
					UnitIndex = thisEntity:entindex(),
					OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
					AbilityIndex = hAbility:entindex(),
				})
				return hAbility:GetCastPoint()
			end

			-- Auto-cast abilities (toggles them on)
			if ContainsValue(cast_behavior, DOTA_ABILITY_BEHAVIOR_AUTOCAST) then
				if not hAbility:GetAutoCastState() then
					hAbility:ToggleAutoCast()
				end
			end
		end
	end

	return nil
end

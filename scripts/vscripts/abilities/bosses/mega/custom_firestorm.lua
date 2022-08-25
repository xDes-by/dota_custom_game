function firestorm(keys)
	local caster = keys.caster
	local ability = keys.ability
	local firestorm = caster:FindAbilityByName("custom_pit")
	local heroes = ai_alive_heroes()
	for _, hero in ipairs(heroes) do
		caster:CastAbilityOnPosition(hero:GetAbsOrigin(), firestorm, -1)	
	end
end


function ai_alive_heroes()
	local heroes_alive = {}

	for playerID = 0, DOTA_MAX_TEAM_PLAYERS - 1 do
		if PlayerResource:HasSelectedHero(playerID) then
			local hero = PlayerResource:GetSelectedHeroEntity(playerID)
			if hero:IsAlive() and hero:GetTeam() == DOTA_TEAM_GOODGUYS  then
				table.insert(heroes_alive, hero)
			end
		end
	end
	return heroes_alive
end
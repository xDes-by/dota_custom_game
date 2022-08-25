function steal(keys)
	local caster = keys.caster
	local ability = keys.ability
	local ability_level = ability:GetLevel() - 1
	local gold = ability:GetLevelSpecialValueFor("gold", ability_level)
	local heroes = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, FIND_UNITS_EVERYWHERE, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
		for i = 1, #heroes do
            local playerID = heroes[i]:GetPlayerID()
            local player = PlayerResource:GetSelectedHeroEntity(playerID )
			if player:IsRealHero() then
            player:ModifyGold( -gold, true, 0 )
            SendOverheadEventMessage(player, OVERHEAD_ALERT_DEATH , player, gold, nil)
			player:EmitSound("DOTA_Item.Hand_Of_Midas")
		end	
	end		
end
function call_tank(params)
    local caster = params.caster
    local player = caster:GetOwner()
    local ability = params.ability
    local position = caster:GetAbsOrigin()
    base_damage = caster:GetStrength() * 5
	if caster:FindAbilityByName("npc_dota_hero_sniper_str_last") ~= nil then
		base_damage = caster:GetStrength() * 5 * 3
	end
    
	if not caster:IsMuted() then
	
    local unit = CreateUnitByName("sniper_tank", position, true, caster,player, DOTA_TEAM_GOODGUYS)
    unit:SetOwner( caster )
    unit:SetControllableByPlayer(player:GetPlayerID(), false)
    unit:SetBaseDamageMax(base_damage)
    unit:SetBaseDamageMin(base_damage)
	

	unit:AddAbility("sniper_ult"):SetLevel(6)
	unit:AddAbility("kill_skelet"):SetLevel(1)
	unit:AddNewModifier(caster,ability,"modifier_invulnerable",{})
	end
end
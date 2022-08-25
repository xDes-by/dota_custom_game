function DoCleaveDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local cleave_radius = ability:GetSpecialValueFor("cleave_radius")
	local cleave_damage_pct = ability:GetSpecialValueFor("cleave_damage")
	local damage_type = DAMAGE_TYPE_PHYSICAL
	local caster_damage = caster:GetBaseDamageMin()
	
		local abil = caster:FindAbilityByName("npc_dota_hero_sniper_agi11")
		if abil ~= nil then 
		caster_damage = caster:GetAverageTrueAttackDamage(nil)
		end
	flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION 
	if caster:FindAbilityByName("npc_dota_hero_sniper_agi_last") ~= nil then
		flags = DOTA_DAMAGE_FLAG_NONE 
		damage_type = DAMAGE_TYPE_MAGICAL
	end
	local cleave_damage = math.ceil(caster_damage*cleave_damage_pct/100)
	local AllEnemies = FindUnitsInRadius(DOTA_UNIT_TARGET_TEAM_ENEMY, target:GetAbsOrigin(), nil, cleave_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for i=1, #AllEnemies do
		--if AllEnemies[i]:IsAvile() then 
			ApplyDamage({victim = AllEnemies[i], attacker = caster, damage = cleave_damage, damage_type = damage_type,damage_flags = flags})
	--	end
	end
end
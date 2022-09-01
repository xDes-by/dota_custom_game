function DoCleaveDamage(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local damage = ability:GetSpecialValueFor("damage")
	local damage_type = DAMAGE_TYPE_PHYSICAL
	local caster_damage = caster:GetBaseDamageMin()
	
	local abil = caster:FindAbilityByName("npc_dota_hero_sniper_agi11")
	if abil ~= nil then 
		caster_damage = caster:GetAverageTrueAttackDamage(nil)
	end
	
	flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION 
	
	if caster:FindAbilityByName("npc_dota_hero_sniper_agi_last") ~= nil then
		flags = DOTA_DAMAGE_FLAG_NONE 
	end
	
	local boom_damage = math.ceil(caster_damage * damage / 100)
	
	local enemies = FindUnitsInRadius(DOTA_UNIT_TARGET_TEAM_ENEMY, target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	for _,enemy in pairs(enemies) do
		ApplyDamage({victim = enemy, attacker = caster, damage = boom_damage, damage_type = damage_type, damage_flags = flags})
	end
end
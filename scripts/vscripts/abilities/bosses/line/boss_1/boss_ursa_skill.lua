function ToDamage( keys )
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local int_caster = caster:GetHealthPercent()
	local damage = ability:GetLevelSpecialValueFor("damage_pct", (ability:GetLevel() -1)) 
	

	local damage_table = {}

	damage_table.attacker = caster
	damage_table.damage_type = DAMAGE_TYPE_PHYSICAL
	damage_table.ability = ability
	damage_table.victim = target

	damage_table.damage = (100 - int_caster) * damage / 100

	ApplyDamage(damage_table)
end
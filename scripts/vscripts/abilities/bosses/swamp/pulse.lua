
function ApplyDPS(keys)
	local caster = keys.caster
	local target = keys.target
	local ability = keys.ability
	
	local health_percent = ability:GetLevelSpecialValueFor("damage_percent", ability:GetLevel() -1)
	
	ApplyDamage({victim = target, attacker = caster, damage = health_percent, damage_type = ability:GetAbilityDamageType()})
end

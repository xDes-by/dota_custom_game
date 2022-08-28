function HeartstopperAura( keys )
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	local aura_damage_interval = ability:GetLevelSpecialValueFor("aura_damage_interval", (ability:GetLevel() - 1))
	local aura_damage = target:GetHealth() * (ability:GetLevelSpecialValueFor("aura_damage", (ability:GetLevel() - 1)) * 0.01)
	
	local abil = caster:FindAbilityByName("npc_dota_hero_pugna_str10")	
		if abil ~= nil then 
		aura_damage = target:GetHealth() * (ability:GetLevelSpecialValueFor("aura_damage", (ability:GetLevel() - 1)) * 0.01) * 2
		end
	local abil = caster:FindAbilityByName("npc_dota_hero_pugna_int_last")	
		if abil ~= nil then 
		aura_damage = aura_damage * 2
		end	
		if target:IsAncient() then	
		aura_damage = aura_damage / 4
		end
		
	local damage_table = {}
	damage_table.attacker = caster
	damage_table.victim = target
	damage_table.damage_type = DAMAGE_TYPE_PURE
	damage_table.ability = ability
	damage_table.damage = aura_damage * aura_damage_interval
	damage_table.damage_flags = DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	ApplyDamage(damage_table)
	
	local abil = caster:FindAbilityByName("npc_dota_hero_pugna_str11")	
	if abil == nil then 
	caster:Heal(aura_damage * aura_damage_interval, keys.caster)	
	end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_pugna_str11")	
	if abil ~= nil then 
	local nearby_allied_units = FindUnitsInRadius(keys.caster:GetTeam(), keys.caster:GetAbsOrigin(), nil, 700,	DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)	
		for i, nearby_ally in ipairs(nearby_allied_units) do
			nearby_ally:Heal(aura_damage * aura_damage_interval, keys.caster)	
		end
	end
end
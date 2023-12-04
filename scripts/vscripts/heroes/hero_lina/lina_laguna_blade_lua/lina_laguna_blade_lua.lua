lina_laguna_blade_lua = lina_laguna_blade_lua or class({})
 
function lina_laguna_blade_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_lina_int7") ~= nil then 
		return 50 + math.min(65000, self:GetCaster():GetIntellect() / 200)
	end
	return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end


 function lina_laguna_blade_lua:OnSpellStart()
	 local caster 			= self:GetCaster()
	 local ability 			= self
	 local jump_delay 		= ability:GetSpecialValueFor("jump_delay")
	 local max_jump_count 	= ability:GetSpecialValueFor("jump_count")
	 local radius 			= ability:GetSpecialValueFor("radius")
	 local damage 			= ability:GetSpecialValueFor("damage")
	 if _G.lagunatarget ~= nil then
		target = _G.lagunatarget
		_G.lagunatarget = nil
	else
	 	target = self:GetCursorTarget()
	end
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_lina_int50")	
	if abil ~= nil then 
		damage = damage + self:GetCaster():GetIntellect() * 0.5
	end	 
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_int9")	
	if abil ~= nil then 
		max_jump_count = 5
	end

	 caster:EmitSound("Ability.LagunaBladeImpact")

	 local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_WORLDORIGIN, caster)
	 ParticleManager:SetParticleControl(lightningBolt, 0, Vector(caster:GetAbsOrigin().x, caster:GetAbsOrigin().y , caster:GetAbsOrigin().z + caster:GetBoundingMaxs().z ))   
	 ParticleManager:SetParticleControl(lightningBolt, 1, Vector(target:GetAbsOrigin().x, target:GetAbsOrigin().y, target:GetAbsOrigin().z + target:GetBoundingMaxs().z ))

	 local nearby_enemy_units = FindUnitsInRadius(
		 caster:GetTeam(),
		 target:GetAbsOrigin(), 
		 nil, 
		 radius, 
		 DOTA_UNIT_TARGET_TEAM_ENEMY,
		 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
		 DOTA_UNIT_TARGET_FLAG_NONE, 
		 FIND_CLOSEST, 
		 false
	 )
	damage_flags = DOTA_DAMAGE_FLAG_NONE
	
	local abil = caster:FindAbilityByName("npc_dota_hero_lina_str11")	
	if abil ~= nil then 
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		damage = caster:GetHealth()
	end
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_lina_agi50")	
	if abil ~= nil then 
		damage = damage + self:GetCaster():GetIntellect() * 2
	end
	 local damage_table 		= {}
	 damage_table.attacker 		= caster
	 damage_table.ability 		= ability
	 damage_table.damage_type 	= ability:GetAbilityDamageType() 
	 damage_table.damage		= damage
	 damage_table.damage_flags	= damage_flags
	 damage_table.victim 		= target
	 ApplyDamage(damage_table)

	
	 local hit_list = {}
	 hit_list[target] = 1
	 
	  local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_lina_int9")	
		if abil ~= nil then 

	 Timers:CreateTimer(jump_delay, function() 
		 for _,enemy in pairs(nearby_enemy_units) do 
			 if not enemy:IsNull() and enemy:IsAlive() and not enemy:IsMagicImmune() and target ~= enemy and ((enemy:GetAbsOrigin() - target:GetAbsOrigin()):Length2D() <= radius) then
				 lina_laguna_blade_lua:Chain(caster, target, enemy, ability, damage, radius, jump_delay, max_jump_count, 0, hit_list)		 
				 break
			 end
		 end
	 end)
	 end
 end

 function lina_laguna_blade_lua:Chain(caster, origin_target, chained_target, ability, damage, radius, jump_delay, max_jump_count, num_jumps_done, hit_list)
	 if IsServer() then 
		
		num_jumps_done = num_jumps_done + 1
		 if hit_list[chained_target] == nil then
			 hit_list[chained_target] = 1	
		 else
			 hit_list[chained_target] = hit_list[chained_target] + 1
		 end

		 origin_target:EmitSound("Ability.LagunaBladeImpact")

		 local lightningBolt = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_laguna_blade.vpcf", PATTACH_WORLDORIGIN, origin_target)
		 ParticleManager:SetParticleControl(lightningBolt, 0, Vector(origin_target:GetAbsOrigin().x, origin_target:GetAbsOrigin().y , origin_target:GetAbsOrigin().z + origin_target:GetBoundingMaxs().z ))   
		 ParticleManager:SetParticleControl(lightningBolt, 1, Vector(chained_target:GetAbsOrigin().x, chained_target:GetAbsOrigin().y, chained_target:GetAbsOrigin().z + chained_target:GetBoundingMaxs().z ))

		 local nearby_enemy_units = FindUnitsInRadius(	
			 caster:GetTeam(), 
			 chained_target:GetAbsOrigin(), 
			 nil, 
			 radius, 
			 DOTA_UNIT_TARGET_TEAM_ENEMY, 
			 DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
			 DOTA_UNIT_TARGET_FLAG_NONE, 
			 FIND_CLOSEST, 
			 false
		 )
		 
		damage_flags = DOTA_DAMAGE_FLAG_NONE
	
		local abil = caster:FindAbilityByName("npc_dota_hero_lina_str11")	
		if abil ~= nil then 
		damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
		damage = caster:GetMaxHealth()
		end

		 local damage_table 			= {}
		 damage_table.attacker 		= caster
		 damage_table.ability 		= ability
		 damage_table.damage_type 	= ability:GetAbilityDamageType() 
		 damage_table.damage		= damage
		 damage_table.damage_flags	= damage_flags
		 damage_table.victim 		= chained_target
		 ApplyDamage(damage_table)
	
		 if num_jumps_done < max_jump_count then
			 Timers:CreateTimer(jump_delay, function() 
				 local has_chained = false
				
				 for _,enemy in pairs(nearby_enemy_units) do 
					 if origin_target ~= enemy and chained_target ~= enemy then
						 if lina_laguna_blade_lua:HitCheck(caster, enemy, hit_list) then 
							 lina_laguna_blade_lua:Chain(caster, chained_target, enemy, ability, damage, radius, jump_delay, max_jump_count, num_jumps_done, hit_list)
							 has_chained = true
						 end
						 break
					 end
				 end
			 end)
		 end
		 
		 if num_jumps_done >= max_jump_count then return end 
	 end
 end

 function lina_laguna_blade_lua:HitCheck(caster, enemy, hit_list)
	 if IsServer() then
		 if not enemy:IsNull() and enemy:IsAlive() and not enemy:IsMagicImmune() then 
			 if hit_list[enemy] == nil then
				 return true
			 end
		 end
		 return false
	 end
 end

LinkLuaModifier( "modifier_sand_caustic_debuff", "heroes/hero_sand/sand_caustic/modifier_sand_caustic_debuff", LUA_MODIFIER_MOTION_NONE )

function sandking_waves(keys)
	local caster = keys.caster
	local ability = keys.ability
	local radius = ability:GetSpecialValueFor("radius")
	local chance = ability:GetSpecialValueFor("chance")
	sand_ult_damage = ability:GetSpecialValueFor("damage")

	if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_sand_king_agi50") ~= nil then 
		radius = radius + 300
	end

	if caster:FindAbilityByName("npc_dota_hero_sand_king_str11") ~= nil then 
		sand_ult_damage = ability:GetSpecialValueFor("damage") + caster:GetStrength() * 0.75
	end
	
	if caster:FindAbilityByName("npc_dota_hero_sand_king_str_last") ~= nil then 
		sand_ult_damage = sand_ult_damage + caster:GetStrength() * 2
	end
	
	if caster:FindAbilityByName("npc_dota_hero_sand_king_agi9") ~= nil then 
		sand_ult_damage = caster:GetAgility()
	end
	
	if caster:FindAbilityByName("npc_dota_hero_sand_king_int9") ~= nil then 
        chance = 15
    end
	
	if caster:FindAbilityByName("npc_dota_hero_sand_king_agi_last") ~= nil then 
        chance = 101
    end
	
	if RandomInt(1,100) < chance then

	local damage_table = {}
	damage_table.attacker = caster
	damage_table.damage = sand_ult_damage
	damage_table.ability = ability
	damage_table.damage_type = DAMAGE_TYPE_MAGICAL
	local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
    for _, unit in ipairs(units) do
	if unit:IsAlive() then
	
		if caster:FindAbilityByName("npc_dota_hero_sand_king_agi8") ~= nil then 
		ability2 = caster:FindAbilityByName("sand_caustic") 
			if ability2 ~= nil and ability2:IsTrained() then 
			unit:AddNewModifier( caster, ability, "modifier_sand_caustic_debuff", { duration = 5 } )
			end
		end
		
        damage_table.victim = unit
		ApplyDamage(damage_table)
	end
	end
	-- StartSoundEvent( "Ability.SandKing_Epicenter.spell", caster )
	-- Timers:CreateTimer(0.1, function() 
	-- StopSoundEvent( "Ability.SandKing_Epicenter.spell", caster )
	-- end)
	
		Timers:CreateTimer(0.01, function() 
		caster.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
		ParticleManager:SetParticleControl(caster.ShieldParticle, 1, Vector(radius,0,radius))


		-- Proper Particle attachment courtesy of BMD. Only PATTACH_POINT_FOLLOW will give the proper shield position
		ParticleManager:SetParticleControlEnt(caster.ShieldParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
	end)
	end
end



function talent(keys)
	local caster = keys.caster
	local abil = caster:FindAbilityByName("npc_dota_hero_sand_king_str8")
	if abil ~= nil then 
		local ability = keys.ability
		local radius = ability:GetSpecialValueFor("radius")
		sand_ult_damage = ability:GetSpecialValueFor("damage")
		
		if caster:FindAbilityByName("npc_dota_hero_sand_king_str11") ~= nil then 
		sand_ult_damage = ability:GetSpecialValueFor("damage") + caster:GetStrength() * 0.5
		end

		if caster:FindAbilityByName("npc_dota_hero_sand_king_str_last") ~= nil then 
		sand_ult_damage = sand_ult_damage + caster:GetStrength() * 2
		end
		
		if caster:FindAbilityByName("npc_dota_hero_sand_king_agi9") ~= nil then 
		sand_ult_damage = caster:GetAgility()
		end

		local damage_table = {}
		damage_table.attacker = caster
		damage_table.damage = sand_ult_damage
		damage_table.ability = ability
		damage_table.damage_type = DAMAGE_TYPE_MAGICAL
		local units = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for _, unit in ipairs(units) do
		if unit:IsAlive() then
			damage_table.victim = unit
			ApplyDamage(damage_table)
		end
		end
		-- StartSoundEvent( "Ability.SandKing_Epicenter.spell", caster )
		-- Timers:CreateTimer(0.1, function() 
		-- StopSoundEvent( "Ability.SandKing_Epicenter.spell", caster )
		-- end)
			Timers:CreateTimer(0.01, function() 
				caster.ShieldParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster)
				ParticleManager:SetParticleControl(caster.ShieldParticle, 1, Vector(radius,0,radius))
				ParticleManager:SetParticleControlEnt(caster.ShieldParticle, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
			end)
		end
end
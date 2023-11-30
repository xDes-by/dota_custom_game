LinkLuaModifier("modifier_turret", "modifiers/modifier_turret.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_tower_range", "heroes/hero_builder/modifier_tower_range", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_armor_debuff", "heroes/hero_builder/modifier_armor_debuff", LUA_MODIFIER_MOTION_NONE )

function build(data)
	local caster = data.caster
	local ability = data.ability
	local position = caster:GetCursorPosition()
	local sound_cast = "Hero_Rattletrap.Power_Cogs"
	count = ability:GetSpecialValueFor("count")
	if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_tinker_agi50") ~= nil then
		count = count + 2
	end
	local modifier = caster:AddNewModifier(caster, ability,  "modifier_turret", nil)
	local currentStacks = caster:GetModifierStackCount( "modifier_turret", ability)
	
	local abil = caster:FindAbilityByName("npc_dota_hero_tinker_agi6")
	if abil ~= nil then
	count = count + 1
	end
	
	if currentStacks < count then
	
	caster:SetModifierStackCount( "modifier_turret", caster,currentStacks + 1 )

	EmitSoundOn( sound_cast, caster )	
	dummy_unit_turret = CreateUnitByName("npc_turret", position, true, caster, nil, caster:GetTeam())
	dummy_unit_turret:SetControllableByPlayer(caster:GetPlayerID(), true)
	dummy_unit_turret:SetOwner(caster)
	local hero_health = caster:GetMaxHealth() / 2
	
		local abil = caster:FindAbilityByName("npc_dota_hero_tinker_str7")
		if abil ~= nil then
			hero_health = hero_health * 3
		end
	
	local max_hp = dummy_unit_turret:GetMaxHealth()
	dummy_unit_turret:SetBaseMaxHealth(hero_health- 100)
	dummy_unit_turret:SetMaxHealth(hero_health- 100)
	dummy_unit_turret:SetHealth(hero_health- 100)
	
	local dmg_mnoz = ability:GetLevelSpecialValueFor( "dmg", ability:GetLevel() - 1 )
	
	local abil = caster:FindAbilityByName("npc_dota_hero_tinker_agi8")
	if abil ~= nil then
	dmg_mnoz = dmg_mnoz + 100
	end
	hero_dmg = caster:GetBaseDamageMin() 
	if caster:FindAbilityByName("npc_dota_hero_tinker_agi_last") ~= nil then
		hero_dmg = caster:GetBaseDamageMin() * 2
	end	
	dummy_unit_turret:SetBaseDamageMin(hero_dmg * (dmg_mnoz* 0.01))
	dummy_unit_turret:SetBaseDamageMax(hero_dmg * (dmg_mnoz* 0.01))
	
	local abil = caster:FindAbilityByName("npc_dota_hero_tinker_str10")
	if abil ~= nil then
	local hero_armor = caster:GetPhysicalArmorBaseValue()
	dummy_unit_turret:SetPhysicalArmorBaseValue(hero_armor)	
	end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_tinker_int9")
	if abil ~= nil then
	dummy_unit_turret:AddNewModifier(caster,ability,"modifier_magic_immune",{}	)
	end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_tinker_agi11")
	if abil ~= nil then
	dummy_unit_turret:AddNewModifier(caster,ability,"modifier_armor_debuff",{}	)
	end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_tinker_agi7")
	if abil ~= nil then
	dummy_unit_turret:AddNewModifier(caster,ability,"modifier_tower_range",{}	)
	end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_tinker_agi9")
	if abil ~= nil then
		dummy_unit_turret:AddAbility("sniper_ult"):SetLevel(6)
	end
	
	dummy_unit_turret:SetModelScale(0.2)	
end
end

function boom(data)
	local caster = data.caster
	caster:SetModel("models/development/invisiblebox.vmdl")
	local particle_explosion = "particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf"
	local particle_explosion_fx = ParticleManager:CreateParticle(particle_explosion, PATTACH_WORLDORIGIN, caster)
	ParticleManager:SetParticleControl(particle_explosion_fx, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_explosion_fx, 1, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_explosion_fx, 2, Vector(100, 1, 1))
	ParticleManager:ReleaseParticleIndex(particle_explosion_fx)

	data.caster:EmitSound("Hero_Tinker.Heat-Seeking_Missile_Dud")
	data.caster:ForceKill(false)
end

function die(data)
	local caster = data.caster
	if caster:GetUnitName() == "npc_turret" then
		local own = caster:GetOwner()
		local currentStacks = own:GetModifierStackCount( "modifier_turret", ability)
		own:SetModifierStackCount( "modifier_turret", own,currentStacks - 1 )
	end
end
-------------------------------------------------------------------------------------------------------


pugna_nether_blast_lua = class({})
LinkLuaModifier("modifier_pugna_nether_blast", "heroes/hero_pugna/pugna_blast/pugna_blast", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier( "modifier_armor_debuff", "heroes/hero_pugna/modifier_armor_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_pugna_from_hit", "heroes/hero_pugna/pugna_blast/pugna_blast", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_stun_cooldown", "heroes/hero_pugna/pugna_blast/pugna_blast", LUA_MODIFIER_MOTION_NONE )

modifier_pugna_from_hit = class({})

function modifier_pugna_from_hit:IsHidden()
	return true
end

function modifier_pugna_from_hit:IsDebuff()
	return false
end

function modifier_pugna_from_hit:IsPurgable()
	return false
end

function modifier_pugna_from_hit:DeclareFunctions()
	return {MODIFIER_EVENT_ON_ATTACK_LANDED}
end

function modifier_pugna_from_hit:OnAttackLanded(params)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_agi_last") ~= nil then
		local abil = params.attacker:FindAbilityByName("pugna_nether_blast_lua")
		rand = 10
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_pugna_agi50") ~= nil then
			rand = rand + 15
		end
		if RollPercentage(rand) and  abil ~= nil and abil:GetLevel() > 0 then
			_G.blasttarget = params.target
			abil:OnSpellStart()
		end
	end
end
------------------------------------------------

function pugna_nether_blast_lua:GetIntrinsicModifierName()
	return "modifier_pugna_from_hit"
end


function pugna_nether_blast_lua:GetAbilityTextureName()
	return "pugna_nether_blast"
end

function pugna_nether_blast_lua:GetCastRange()
	return self:GetSpecialValueFor("cast_range")
end

function pugna_nether_blast_lua:GetAOERadius()
	return self:GetSpecialValueFor("main_blast_radius")
end

function pugna_nether_blast_lua:IsNetherWardStealable()
	return true
end

function pugna_nether_blast_lua:IsHiddenWhenStolen()
	return false
end

function pugna_nether_blast_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function pugna_nether_blast_lua:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	if _G.blasttarget ~= nil then
		target_point = _G.blasttarget:GetAbsOrigin()
	else
	 	target_point = self:GetCursorPosition()
	end
	local sound_precast = "Hero_Pugna.NetherBlastPreCast"
	local sound_cast = "Hero_Pugna.NetherBlast"
	local particle_pre_blast = "particles/units/heroes/hero_pugna/pugna_netherblast_pre.vpcf"
	local particle_blast = "particles/units/heroes/hero_pugna/pugna_netherblast.vpcf"

	local mini_blast_count = ability:GetSpecialValueFor("mini_blast_count")
	local magic_res_duration = ability:GetSpecialValueFor("magic_res_duration")
	local blast_delay = ability:GetSpecialValueFor("blast_delay")
	local damage = ability:GetSpecialValueFor("damage")
	local damage_buildings_pct = ability:GetSpecialValueFor("damage_buildings_pct")
	local mini_blast_distance = ability:GetSpecialValueFor("mini_blast_distance")
	local mini_blast_radius = ability:GetSpecialValueFor("mini_blast_radius")
	local main_blast_radius = ability:GetSpecialValueFor("main_blast_radius")
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_int11")	
	if abil ~= nil then 
	mini_blast_count = 3
	end			
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_int9")	
	if abil ~= nil then 
	damage = self:GetCaster():GetIntellect()
	end		
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_str9")	
	if abil ~= nil then 
	damage = self:GetCaster():GetStrength()
	end	


	EmitSoundOn(sound_cast, caster)

	local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
		target_point,
		nil,
		mini_blast_distance + mini_blast_radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE,
		FIND_ANY_ORDER,
		false)

	for i = 1, mini_blast_count do
		local angle_gaps = 360 / mini_blast_count

		local qangle = QAngle(0, (i-1)*angle_gaps, 0)
		local direction = (target_point - caster:GetAbsOrigin()):Normalized()

		local spawn_point = target_point + direction * mini_blast_distance

		local mini_blast_center = RotatePosition(target_point, qangle, spawn_point)

		local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_blast_fx, 0, mini_blast_center)
		ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(mini_blast_radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_blast_fx)

		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			mini_blast_center,
			nil,
			mini_blast_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,enemy in pairs(enemies) do
		

			
			
				local damageTable = {victim = enemy,
									damage = damage,
									damage_type = DAMAGE_TYPE_MAGICAL,
									attacker = caster,
									ability = ability
									}
				ApplyDamage(damageTable)
		end
	end

	-- Add main blast preparation particle and sound only to allies
	local particle_pre_blast_fx = ParticleManager:CreateParticle(particle_pre_blast, PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(particle_pre_blast_fx, 0, target_point)
	ParticleManager:SetParticleControl(particle_pre_blast_fx, 1, Vector(main_blast_radius, blast_delay, 1))
	ParticleManager:ReleaseParticleIndex(particle_pre_blast_fx)

	EmitSoundOnLocationForAllies(caster:GetAbsOrigin(), sound_precast, caster)

	-- Create a timer to delay the main blast
	Timers:CreateTimer(blast_delay, function()
		-- Blow up! Add particle effect
		local particle_blast_fx = ParticleManager:CreateParticle(particle_blast, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControl(particle_blast_fx, 0, target_point)
		ParticleManager:SetParticleControl(particle_blast_fx, 1, Vector(main_blast_radius, 0, 0))
		ParticleManager:ReleaseParticleIndex(particle_blast_fx)

		-- Find all enemies, including buildings
		local enemies = FindUnitsInRadius(caster:GetTeamNumber(),
			target_point,
			nil,
			main_blast_radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
			DOTA_UNIT_TARGET_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		for _,enemy in pairs(enemies) do
			local blast_damage = damage
			
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_agi6")	
			if abil ~= nil then 
			enemy:AddNewModifier(caster, ability, "modifier_armor_debuff", {duration = 2})
			end
			
			
			local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_pugna_str8")	
			if abil ~= nil then 
				if not enemy:HasModifier("modifier_stun_cooldown") then
					enemy:AddNewModifier(caster, ability, "modifier_generic_stunned_lua", {duration = 2})
					enemy:AddNewModifier(caster, ability, "modifier_stun_cooldown", {duration = 10})
				end
			end

			if enemy:IsBuilding() then
				blast_damage = blast_damage * damage_buildings_pct * 0.01
			end

			-- Deal damage
			local damageTable = {victim = enemy,
				damage = blast_damage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				attacker = caster,
				ability = ability
			}

			ApplyDamage(damageTable)
		end
	end)
	_G.blasttarget = nil
end

modifier_stun_cooldown = class({})
--Classifications template
function modifier_stun_cooldown:IsHidden()
	return true
end

function modifier_stun_cooldown:IsDebuff()
	return false
end

function modifier_stun_cooldown:IsPurgable()
	return false
end

function modifier_stun_cooldown:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_stun_cooldown:IsStunDebuff()
	return false
end

function modifier_stun_cooldown:RemoveOnDeath()
	return true
end

function modifier_stun_cooldown:DestroyOnExpire()
	return true
end

LinkLuaModifier( "modifier_generic_stunned_lua", "heroes/generic/modifier_generic_stunned_lua", LUA_MODIFIER_MOTION_NONE )

function check(keys)
local caster = keys.caster
local ability = keys.ability
local radius = ability:GetLevelSpecialValueFor( "radius" , ability:GetLevel() - 1  ) 
local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  ) 
local cd = ability:GetCooldown(ability:GetLevel() - 1)
local special_bonus_unique_npc_dota_hero_luna_int50 = caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_luna_int50")
	local abil = caster:FindAbilityByName("npc_dota_hero_luna_int6")
	if abil ~= nil then 
	damage = damage + caster:GetIntellect()/2
	end
	
	local abil = caster:FindAbilityByName("npc_dota_hero_luna_str6")
	if abil ~= nil then 
		damage = caster:GetStrength()
	end
 	if special_bonus_unique_npc_dota_hero_luna_int50 then
		damage = damage + caster:GetIntellect()
	end
	local enemy = FindUnitsInRadius(caster:GetTeam(),caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if ability:IsFullyCastable() then		
		if #enemy > 0 then
			caster:EmitSound("Hero_Luna.LucentBeam.Cast")
			for _,target_enemy in pairs(enemy) do
				if caster:FindAbilityByName("npc_dota_hero_luna_int_last") == nil then
					target_enemy = enemy[1]
				end
				target_enemy:EmitSound("Hero_Luna.LucentBeam.Target")
				local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_luna/luna_lucent_beam.vpcf", PATTACH_POINT_FOLLOW, caster)
				ParticleManager:SetParticleControl(particle, 1, target_enemy:GetAbsOrigin())
				ParticleManager:SetParticleControlEnt(particle,	5, target_enemy, PATTACH_POINT_FOLLOW, "attach_hitloc", target_enemy:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(particle,	6, caster, PATTACH_POINT_FOLLOW, "attach_attack1", caster:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(particle)
				
				-- "Lucent Beam first applies the damage, then the debuff."
				local damageTable = {
					victim 			= target_enemy,
					damage 			= damage,
					damage_type		= DAMAGE_TYPE_MAGICAL,
					damage_flags 	= DOTA_DAMAGE_FLAG_NONE,
					attacker 		= caster,
					ability 		= ability
				}
				ApplyDamage(damageTable)	
				
				local abil = caster:FindAbilityByName("npc_dota_hero_luna_int7")
				if abil ~= nil and special_bonus_unique_npc_dota_hero_luna_int50 == nil then 
					target_enemy:AddNewModifier(target_enemy,self,"modifier_generic_stunned_lua",{ duration = 1 })
				end
			end
			if special_bonus_unique_npc_dota_hero_luna_int50 then
				ability:StartCooldown(1)
			else
				ability:StartCooldown(cd)
			end
		end
	end
end
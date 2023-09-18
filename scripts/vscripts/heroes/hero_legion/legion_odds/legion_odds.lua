legion_odds = class({})



function legion_odds:OnAbilityPhaseInterrupted()
	if self.thundergod_spell_cast then
		ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end
end


function legion_odds:GetManaCost(iLevel)
	return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end


function legion_odds:OnSpellStart() 
	if IsServer() then
		local ability 				= self
		local caster 				= self:GetCaster()
		local damage 				= ability:GetSpecialValueFor("damage")
		local radius 				= ability:GetSpecialValueFor("radius")
		local pierce_spellimmunity 	= false

		-- if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int_last") ~= nil then
		-- 	damage = damage + self:GetCaster():GetIntellect()/2
		-- end
		local position 				= self:GetCaster():GetAbsOrigin()	

		if self.thundergod_spell_cast then
			ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
		end
		
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int10")
		if abil ~= nil then 
			damage = damage + caster:GetIntellect()
		end

		EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_LegionCommander.Overwhelming.Location", self:GetCaster())

		local damage_table 			= {}
		damage_table.attacker 		= self:GetCaster()
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage_flags	= damage_flags
		
		
		local hEnemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			for _,hero in pairs(hEnemies) do 
				if hero:IsAlive() and hero:GetTeam() ~= caster:GetTeam() then 
					local target_point = hero:GetAbsOrigin()

					local thundergod_strike_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
					ParticleManager:SetParticleControl(thundergod_strike_particle, 0, Vector(target_point.x, target_point.y, target_point.z + hero:GetBoundingMaxs().z))
					ParticleManager:SetParticleControl(thundergod_strike_particle, 1, Vector(target_point.x, target_point.y, 2000))
					ParticleManager:SetParticleControl(thundergod_strike_particle, 2, Vector(target_point.x, target_point.y, target_point.z + hero:GetBoundingMaxs().z))

					if (not hero:IsMagicImmune() or pierce_spellimmunity) and (not hero:IsInvisible() or caster:CanEntityBeSeenByMyTeam(hero)) then
						
						damage_table.damage	 = damage
						damage_table.victim  = hero
						ApplyDamage(damage_table)

						Timers:CreateTimer(FrameTime(), function()
							if not hero:IsAlive() then
								local thundergod_kill_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zeus/zues_kill_empty.vpcf", PATTACH_WORLDORIGIN, nil)
								ParticleManager:SetParticleControl(thundergod_kill_particle, 0, hero:GetAbsOrigin())
								ParticleManager:SetParticleControl(thundergod_kill_particle, 1, hero:GetAbsOrigin())
								ParticleManager:SetParticleControl(thundergod_kill_particle, 2, hero:GetAbsOrigin())
								ParticleManager:SetParticleControl(thundergod_kill_particle, 3, hero:GetAbsOrigin())
								ParticleManager:SetParticleControl(thundergod_kill_particle, 6, hero:GetAbsOrigin())
							end
						end)
					end

				hero:EmitSound("Hero_LegionCommander.Overwhelming.Creep")
			end
		end
	end
end
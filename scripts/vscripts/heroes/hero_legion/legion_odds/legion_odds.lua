legion_odds = class({})

LinkLuaModifier( "modifier_legion_odds_talents", "heroes/hero_legion/legion_odds/legion_odds", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_special_bonus_unique_npc_dota_hero_legion_commander_int50", "heroes/hero_legion/legion_odds/legion_odds", LUA_MODIFIER_MOTION_NONE )

function legion_odds:GetIntrinsicModifierName()
	return "modifier_legion_odds_talents"
end

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
		
		-- local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int10")
		-- if abil ~= nil then 
		-- 	damage = damage + caster:GetIntellect()
		-- end

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
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_legion_commander_int50") then
			self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_special_bonus_unique_npc_dota_hero_legion_commander_int50", {duration = 5})
		end
	end
end

modifier_legion_odds_talents = class({})
--Classifications template
function modifier_legion_odds_talents:IsHidden()
	return true
end

function modifier_legion_odds_talents:IsDebuff()
	return false
end

function modifier_legion_odds_talents:IsPurgable()
	return false
end

function modifier_legion_odds_talents:IsPurgeException()
	return false
end

-- Optional Classifications
function modifier_legion_odds_talents:IsStunDebuff()
	return false
end

function modifier_legion_odds_talents:RemoveOnDeath()
	return false
end

function modifier_legion_odds_talents:DestroyOnExpire()
	return false
end

function modifier_legion_odds_talents:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE 
	}
end

function modifier_legion_odds_talents:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
	end
	return 0
end

function modifier_legion_odds_talents:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = data.ability:GetLevelSpecialValueNoOverride( data.ability_special_value, data.ability_special_level )
			if self:GetCaster():FindAbilityByName("npc_dota_hero_legion_commander_int10") then
				damage = damage + self:GetCaster():GetIntellect()
			end
			return damage
		end
	end
	return 0
end

modifier_special_bonus_unique_npc_dota_hero_legion_commander_int50 = class({})


function modifier_special_bonus_unique_npc_dota_hero_legion_commander_int50:IsHidden()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_legion_commander_int50:IsDebuff()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_legion_commander_int50:IsPurgable()
	return false
end

function modifier_special_bonus_unique_npc_dota_hero_legion_commander_int50:OnCreated( kv )
	if not IsServer() then return end
	self.damage = self:GetCaster():GetBaseDamageMax() * 2
end

function modifier_special_bonus_unique_npc_dota_hero_legion_commander_int50:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
	}
	return funcs
end

function modifier_special_bonus_unique_npc_dota_hero_legion_commander_int50:GetModifierBaseAttack_BonusDamage()
	return self.damage
end
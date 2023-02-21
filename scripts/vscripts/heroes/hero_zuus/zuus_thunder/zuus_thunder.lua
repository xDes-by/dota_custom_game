zuus_thundergods_wrath_lua = class({})

LinkLuaModifier( "zuus_thundergods_wrath_lua_charges", "heroes/hero_zuus/zuus_thunder/zuus_thunder.lua", LUA_MODIFIER_MOTION_NONE )

function zuus_thundergods_wrath_lua:GetIntrinsicModifierName()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str_last") ~= nil then
		return "zuus_thundergods_wrath_lua_charges"
	end
end

function zuus_thundergods_wrath_lua:OnAbilityPhaseStart()
	self:GetCaster():EmitSound("Hero_Zuus.GodsWrath.PreCast")

	local attack_lock = self:GetCaster():GetAttachmentOrigin(self:GetCaster():ScriptLookupAttachment("attach_attack1"))

	self.thundergod_spell_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	ParticleManager:SetParticleControl(self.thundergod_spell_cast, 0, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	ParticleManager:SetParticleControl(self.thundergod_spell_cast, 1, Vector(attack_lock.x, attack_lock.y, attack_lock.z))
	ParticleManager:SetParticleControl(self.thundergod_spell_cast, 2, Vector(attack_lock.x, attack_lock.y, attack_lock.z))

	return true
end

function zuus_thundergods_wrath_lua:OnAbilityPhaseInterrupted()
	if self.thundergod_spell_cast then
		ParticleManager:DestroyParticle(self.thundergod_spell_cast, true)
		ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
	end
end


function zuus_thundergods_wrath_lua:GetManaCost(iLevel)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int10")	
	if abil ~= nil then 
        return math.min(65000, self:GetCaster():GetIntellect()*1.5)
		end
        return math.min(65000, self:GetCaster():GetIntellect()*3)
end


function zuus_thundergods_wrath_lua:OnSpellStart() 
	if IsServer() then
		local ability 				= self
		local caster 				= self:GetCaster()
		local true_sight_radius 	= ability:GetSpecialValueFor("true_sight_radius")
		local sight_radius_day 		= ability:GetSpecialValueFor("sight_radius_day")
		local sight_radius_night 	= ability:GetSpecialValueFor("sight_radius_night")
		local sight_duration 		= ability:GetSpecialValueFor("sight_duration")
		local damage 				= ability:GetSpecialValueFor("damage")
		local pierce_spellimmunity 	= false

		local position 				= self:GetCaster():GetAbsOrigin()	

		if self.thundergod_spell_cast then
			ParticleManager:ReleaseParticleIndex(self.thundergod_spell_cast)
		end
		
		local thundergods_focus_stacks = 0

		EmitSoundOnLocationForAllies(self:GetCaster():GetAbsOrigin(), "Hero_Zuus.GodsWrath", self:GetCaster())

				damage_flags = DOTA_DAMAGE_FLAG_NONE
				local abil = caster:FindAbilityByName("npc_dota_hero_zuus_agi11")	
				if abil ~= nil then 
			--	damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
					damage = caster:GetAgility()
				end
				
				damage_flags = DOTA_DAMAGE_FLAG_NONE
				local abil = caster:FindAbilityByName("npc_dota_hero_zuus_str11")	
				if abil ~= nil then 
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
					damage = caster:GetMaxHealth()
				end

		local damage_table 			= {}
		damage_table.attacker 		= self:GetCaster()
		damage_table.ability 		= ability
		damage_table.damage_type 	= ability:GetAbilityDamageType() 
		damage_table.damage_flags	= damage_flags
		
		count = 1
		
		local abil = caster:FindAbilityByName("npc_dota_hero_zuus_int9")	
			if abil ~= nil then 
			count = 2
		end
		
		if count == 1 then
		
		local hEnemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, true_sight_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			for _,hero in pairs(hEnemies) do 
				if hero:IsAlive() and hero:GetTeam() ~= caster:GetTeam() then 
					local target_point = hero:GetAbsOrigin()

					local thundergod_strike_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
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

					hero:EmitSound("Hero_Zuus.GodsWrath.Target")
				end
			end
			end
		if count == 2 then
		local hEnemies = FindUnitsInRadius( caster:GetTeamNumber(), caster:GetOrigin(), nil, true_sight_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false )
			for _,hero in pairs(hEnemies) do 
				if hero:IsAlive() and hero:GetTeam() ~= caster:GetTeam() then 
					local target_point = hero:GetAbsOrigin()

					local thundergod_strike_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
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

					hero:EmitSound("Hero_Zuus.GodsWrath.Target")
				end
			end
			Timers:CreateTimer(1, function()
				for _,hero in pairs(hEnemies) do 
				if hero:IsAlive() and hero:GetTeam() ~= caster:GetTeam() then 
					local target_point = hero:GetAbsOrigin()

					local thundergod_strike_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
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

					hero:EmitSound("Hero_Zuus.GodsWrath.Target")
				end
			end
			end)
	end
	end
	
end

zuus_thundergods_wrath_lua_charges = class({})

--------------------------------------------------------------------------------
-- Classifications
function zuus_thundergods_wrath_lua_charges:IsHidden()
	return false
end

function zuus_thundergods_wrath_lua_charges:IsDebuff()
	return false
end

function zuus_thundergods_wrath_lua_charges:IsPurgable()
	return false
end

function zuus_thundergods_wrath_lua_charges:DestroyOnExpire()
	return false
end
--------------------------------------------------------------------------------
-- Initializations
function zuus_thundergods_wrath_lua_charges:OnCreated( kv )
	-- references
	self.max_charges = 3 -- special value

	if IsServer() then
		self:SetStackCount( self.max_charges )
		self:CalculateCharge()
	end
end

function zuus_thundergods_wrath_lua_charges:OnRefresh( kv )
	-- references
	self.max_charges = 3 -- special value

	if IsServer() then
		self:CalculateCharge()
	end
end

function zuus_thundergods_wrath_lua_charges:OnDestroy( kv )

end

--------------------------------------------------------------------------------
-- Modifier Effects
function zuus_thundergods_wrath_lua_charges:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_FULLY_CAST,
	}

	return funcs
end

function zuus_thundergods_wrath_lua_charges:OnAbilityFullyCast( params )
	if IsServer() then
		if params.unit~=self:GetParent() or params.ability~=self:GetAbility() then
			return
		end

		self:DecrementStackCount()
		self:CalculateCharge()
	end
end
--------------------------------------------------------------------------------
-- Interval Effects
function zuus_thundergods_wrath_lua_charges:OnIntervalThink()
	self:IncrementStackCount()
	self:StartIntervalThink(-1)
	self:CalculateCharge()
end

function zuus_thundergods_wrath_lua_charges:CalculateCharge()
	self:GetAbility():EndCooldown()
	if self:GetStackCount()>=self.max_charges then
		-- stop charging
		self:SetDuration( -1, false )
		self:StartIntervalThink( -1 )
	else
		-- if not charging
		if self:GetRemainingTime() <= 0.05 then
			-- start charging
			local charge_time = self:GetAbility():GetCooldown( -1 )
			self:StartIntervalThink( charge_time )
			self:SetDuration( charge_time, true )
		end

		-- set on cooldown if no charges
		if self:GetStackCount()==0 then
			self:GetAbility():StartCooldown( self:GetRemainingTime() )
		end
	end
end
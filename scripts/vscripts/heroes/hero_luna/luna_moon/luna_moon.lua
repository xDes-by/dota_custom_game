LinkLuaModifier("modifier_dummy", "modifiers/modifier_dummy.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_moon_call", "heroes/hero_luna/luna_moon/luna_moon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_spell_ampl_moon", "heroes/hero_luna/luna_moon/luna_moon", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_cd", "heroes/hero_luna/luna_moon/luna_moon", LUA_MODIFIER_MOTION_NONE )


luna_moon = class({})

function luna_moon:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end

function luna_moon:GetCooldown(level)
	local caster = self:GetCaster()
	local abil = caster:FindAbilityByName("npc_dota_hero_luna_int9")
	if abil ~= nil	then 
		return self.BaseClass.GetCooldown( self, level ) - 60
	end
	return self.BaseClass.GetCooldown( self, level )	
end

function luna_moon:OnSpellStart()
	local caster = self:GetCaster()
	local ability = self
	local position = self:GetCaster():GetAbsOrigin()
	local sound_cast = "Hero_Luna.Eclipse.Cast"
	
	local starfall_ability = caster:FindAbilityByName("luna_starfall")
		if starfall_ability ~= nil then
			owner_level = starfall_ability:GetLevel()
		end
	EmitSoundOn( sound_cast, caster )	
	if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_luna_str50") then
		caster:AddNewModifier(caster, self, "modifier_invulnerable", {duration = 5})
	end
	local dummy = CreateUnitByName("npc_dummy_unit", position, false, caster, caster, caster:GetTeamNumber())
	dummy:AddNewModifier(dummy, nil, "modifier_dummy", {})
	dummy:SetControllableByPlayer(caster:GetPlayerID(), true)
	dummy:AddNewModifier(dummy, nil, "modifier_spell_ampl_moon",  { }) 
	dummy:AddAbility("luna_moon_starfall"):SetLevel(owner_level)

	
	strike_particle_fx = ParticleManager:CreateParticle("particles/luna/luna_moon.vpcf", PATTACH_ABSORIGIN, dummy)
	ParticleManager:SetParticleControl(strike_particle_fx, 0, dummy:GetAbsOrigin())
	dummy:SetOwner(caster)
	
	
	local ult_time = 5
	
		local starfall_ability = caster:FindAbilityByName("npc_dota_hero_luna_int11")
		if starfall_ability ~= nil then
			ult_time = 10
		end
	
	Timers:CreateTimer(ult_time, function()
						dummy:ForceKill(false)
						ParticleManager:DestroyParticle( strike_particle_fx, false )
						ParticleManager:ReleaseParticleIndex( strike_particle_fx )
						EmitSoundOn("Hero_Luna.Eclipse.Target", caster)
					end)
end



function check(keys)
local caster = keys.caster
local ability = keys.ability
local radius = ability:GetLevelSpecialValueFor( "radius" , ability:GetLevel() - 1  ) 
local damage = ability:GetLevelSpecialValueFor( "damage" , ability:GetLevel() - 1  ) 
local cd = ability:GetCooldown(ability:GetLevel() - 1)
local owner = caster:GetOwner()

		local abil = owner:FindAbilityByName("npc_dota_hero_luna_int10")
		if abil ~= nil	then 
		cd = cd - 0.5
		end

	local abil = owner:FindAbilityByName("npc_dota_hero_luna_int6")
	if abil ~= nil then 
	damage = owner:GetIntellect()/2
	end
	
	local abil = owner:FindAbilityByName("npc_dota_hero_luna_str6")
	if abil ~= nil then 
	damage = owner:GetStrength()
	end

	local enemy = FindUnitsInRadius(caster:GetTeam(),caster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
		if ability:IsFullyCastable() then		
		if #enemy > 0 then 
		ability:StartCooldown(cd)
			for _,target_enemy in pairs(enemy) do
			--	target_enemy = enemy[1]
				target_enemy:AddNewModifier(caster, nil, "modifier_moon_call", {duration = 1.1})
				caster:EmitSound("Hero_Luna.LucentBeam.Cast")
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
			end
		end
	end
end

---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

modifier_moon_call = class({})

function modifier_moon_call:IgnoreTenacity()	return true end
function modifier_moon_call:IsPurgable() 		return false end

function modifier_moon_call:GetEffectName()
	return "particles/units/heroes/hero_keeper_of_the_light/keeper_dazzling_debuff.vpcf"
end

function modifier_moon_call:GetStatusEffectName()
	return "particles/status_fx/status_effect_keeper_dazzle.vpcf"
end

function modifier_moon_call:OnCreated()
	if IsServer() then
		self.ability				= self:GetAbility()
		self.caster					= self:GetCaster()
		self.parent					= self:GetParent()

		local attackOrder = {
							UnitIndex = self.parent:entindex(), 
							OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
							Position = self.caster:GetAbsOrigin()
							}
					ExecuteOrderFromTable(attackOrder)
	end
end

function modifier_moon_call:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_MUTED] = true,
		[MODIFIER_STATE_COMMAND_RESTRICTED] = true,
		--[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true
	}
end

function modifier_moon_call:DeclareFunctions()
    return {
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
    }
end

function modifier_moon_call:GetModifierMoveSpeed_Absolute()
    return 50
end

---------------------------------------------------------------------------------------------------

modifier_spell_ampl_moon = class({})

function modifier_spell_ampl_moon:IsHidden()
	return false
end

function modifier_spell_ampl_moon:IsPurgable()
	return false
end

function modifier_spell_ampl_moon:OnCreated()
if IsServer() then
	caster = self:GetCaster()
    player = caster:GetOwner()
	spell_amp_spirits = player:GetSpellAmplification(false) * 100
	end
end

function modifier_spell_ampl_moon:DeclareFunctions()
	return {MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE}
end

function modifier_spell_ampl_moon:GetModifierSpellAmplify_Percentage()
	return spell_amp_spirits
end
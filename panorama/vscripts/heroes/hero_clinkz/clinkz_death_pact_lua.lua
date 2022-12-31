-- Author: Shush
-- Date: 31/01/2021

----------------
-- DEATH PACT --
----------------

---@class clinkz_death_pact_lua:CDOTA_Ability_Lua
clinkz_death_pact_lua = class({})
LinkLuaModifier('modifier_clinkz_death_pact_lua', 'heroes/hero_clinkz/clinkz_death_pact_lua.lua', LUA_MODIFIER_MOTION_NONE)

---@param target CDOTA_BaseNPC
function clinkz_death_pact_lua:CastFilterResultTarget(target)

	if target:GetUnitName() == "npc_dota_clinkz_skeleton_archer" then
		return UF_SUCCESS
	end

	return UnitFilter(target, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS, self:GetCaster():GetTeamNumber())
end

function clinkz_death_pact_lua:OnSpellStart()
	-- Ability properties
	local caster = self:GetCaster()
	local ability = self
	local target = self:GetCursorTarget()
	local modifier_death_pact = "modifier_clinkz_death_pact_lua"
	local cast_response = "clinkz_clinkz_ability_pact_0"..math.random(1, 6)
	local sound_cast = "Hero_Clinkz.DeathPact.Cast"
	local particle_pact = "particles/units/heroes/hero_clinkz/clinkz_death_pact.vpcf"

	-- Ability specials
	local duration = self:GetSpecialValueFor("duration")	

	-- If target has Linken's Sphere off cooldown, do nothing
	if target:GetTeam() ~= caster:GetTeam() then
		if target:TriggerSpellAbsorb(ability) then
			return nil
		end
	end

	-- Roll for cast response
	if RollPercentage(50) and caster:IsHero() then
		EmitSoundOn(cast_response, caster)
	end

	-- Play cast sound	
	EmitSoundOn(sound_cast, caster)

	-- Play particle effect	
	local particle_pact_fx = ParticleManager:CreateParticle(particle_pact, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle_pact_fx, 0, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_pact_fx, 1, target:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle_pact_fx, 5, target:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(particle_pact_fx)

	-- If already have a modifier, remove it
	if caster:HasModifier(modifier_death_pact) then
		caster:RemoveModifierByName(modifier_death_pact)
	end

	-- Give modifier to self
	local modifier = caster:AddNewModifier(caster, self, modifier_death_pact, {duration = duration})
	if modifier then
		-- Set stacks to round number, then heal self to match the new value		
		modifier:SetStackCount(RoundManager:GetCurrentRoundNumber())		
	end

	-- Kill target unit
	target:Kill(ability, caster)
end

-------------------------
-- DEATH PACT MODIFIER --
-------------------------

modifier_clinkz_death_pact_lua = class({})
function modifier_clinkz_death_pact_lua:IsHidden() return false end
function modifier_clinkz_death_pact_lua:IsPurgable() return false end
function modifier_clinkz_death_pact_lua:IsDebuff() return false end

function modifier_clinkz_death_pact_lua:OnCreated()
	-- Ability properties
	self.caster = self:GetCaster()
	self.ability = self:GetAbility()
	self.particle_pact_buff = "particles/units/heroes/hero_clinkz/clinkz_death_pact_buff.vpcf"
	
	-- Ability specials
	self:GetAbilitySpecials()

	-- Buff particle effect, assuming it's the first time it was triggered	
	if not self.particle_pact_buff_fx then
		self.particle_pact_buff_fx = ParticleManager:CreateParticle(self.particle_pact_buff, PATTACH_POINT_FOLLOW, self:GetCaster())
		ParticleManager:SetParticleControlEnt(self.particle_pact_buff_fx, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(self.particle_pact_buff_fx, 2, self:GetCaster():GetAbsOrigin())
		ParticleManager:SetParticleControl(self.particle_pact_buff_fx, 8, Vector(1,0,0))
		self:AddParticle(self.particle_pact_buff_fx, false, false, -1, false, false)
	end

	if IsServer() then 
		Timers:CreateTimer(FrameTime(), function()
			-- Heal based on base health bonus
			self.caster:Heal(self.health_gain, self)
		end)
	end
end

function modifier_clinkz_death_pact_lua:GetAbilitySpecials()	
	self.health_gain = self.ability:GetSpecialValueFor("health_gain")
	self.damage_gain = self.ability:GetSpecialValueFor("damage_gain")
	self.health_gain_per_round  = self.ability:GetSpecialValueFor("health_gain_per_round")
	self.damage_gain_per_round = self.ability:GetSpecialValueFor("damage_gain_per_round")	
end

function modifier_clinkz_death_pact_lua:OnStackCountChanged(old_stacks)
	if not IsServer() then return end

	-- Recalculate health
	self.caster:CalculateStatBonus(true)

	-- Only apply if the stacks actually increased
	local current_stacks = self:GetStackCount()
	if current_stacks <= old_stacks then return end

	-- Heal the caster based on the difference of stacks
	local new_stacks = current_stacks - old_stacks
	local health_bonus = self.health_gain_per_round * new_stacks	
	self.caster:Heal(health_bonus, self.ability)
end

function modifier_clinkz_death_pact_lua:OnRoundStart(keys)
	if not IsServer() then return end

	-- Set stacks based on new round's number
	self:SetStackCount(keys.round_number or 1)	
end

function modifier_clinkz_death_pact_lua:DeclareFunctions()
	local funcs = {MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS, 
				  MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE}

	return funcs
end

function modifier_clinkz_death_pact_lua:GetModifierExtraHealthBonus()	
	return self.health_gain + self.health_gain_per_round * self:GetStackCount()
end

function modifier_clinkz_death_pact_lua:GetModifierPreAttack_BonusDamage()
	return self.damage_gain + self.damage_gain_per_round * self:GetStackCount()
end

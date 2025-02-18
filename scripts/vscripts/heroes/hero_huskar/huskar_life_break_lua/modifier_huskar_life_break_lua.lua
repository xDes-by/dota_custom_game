-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Break behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_huskar_life_break_lua = class({})
-- local tempTable = require("util/tempTable")

--------------------------------------------------------------------------------
-- Classifications
function modifier_huskar_life_break_lua:IsHidden()
	return false
end

function modifier_huskar_life_break_lua:IsDebuff()
	return false
end

function modifier_huskar_life_break_lua:IsStunDebuff()
	return false
end

function modifier_huskar_life_break_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_huskar_life_break_lua:OnCreated( kv )
	-- references
	self.speed = self:GetAbility():GetSpecialValueFor( "charge_speed" )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.cost_pct = self:GetAbility():GetSpecialValueFor( "health_cost_percent" )
	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_int7") then
		self.damage = self.damage + self:GetCaster():GetIntellect() * 2
	end
	self.close_distance = 80
	self.far_distance = 1450
	
	if IsServer() then
		
		self.target = EntIndexToHScript( kv.entindex )

		-- basic purge
		self:GetParent():Purge( false, true, false, false, false )

		-- try apply
		if self:ApplyHorizontalMotionController() == false then
			self:Destroy()
		end
	end
end

function modifier_huskar_life_break_lua:OnRefresh( kv )
	
end

function modifier_huskar_life_break_lua:OnRemoved()
end

function modifier_huskar_life_break_lua:OnDestroy()
	if IsServer() then
		-- IMPORTANT: this is a must, or else the game will crash!
		self:GetParent():InterruptMotionControllers( true )

		damage_flags = 0
		if not self.success then return end
		if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_huskar_str50") then
			if self.target:GetUnitName() ~= "npc_boss_plague_squirrel" or self.target:GetUnitName() ~= "npc_invoker_boss" then
				if self.target:GetHealthPercent() > 95 then
					self.damage = self.damage + self.target:GetHealth() * 0.4
					damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
				end
			end
		end
		-- percentage enemy damage
		local damageTable = {
			victim = self.target,
			attacker = self:GetCaster(),
			damage = self.damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			damage_flags = damage_flags, --Optional.
		}
		print(ApplyDamage(damageTable))
		local burning_spear = self:GetCaster():FindAbilityByName("huskar_burning_spear_lua")
		-- percentage self damage
		damageTable.victim = self:GetCaster()
		damageTable.damage = self:GetCaster():GetHealth() / 100 * self.cost_pct
		damageTable.damage_type = DAMAGE_TYPE_PURE
		damageTable.damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL
		-- ApplyDamage(damageTable)

		-- play effects
		self:PlayEffects()
	end
end

--------------------------------------------------------------------------------
-- Status Effects
function modifier_huskar_life_break_lua:CheckState()
	local state = {
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}

	return state
end

--------------------------------------------------------------------------------
-- Motion Effects
function modifier_huskar_life_break_lua:UpdateHorizontalMotion( me, dt )
	local origin = self:GetParent():GetOrigin()

	if not self.target:IsAlive() then
		self:EndCharge( false )
	end

	-- get direction
	local direction = self.target:GetOrigin() - origin
	direction.z = 0
	local distance = direction:Length2D()
	direction = direction:Normalized()

	-- stop if close to target
	if distance<self.close_distance then
		self:EndCharge( true )
	elseif distance>self.far_distance then
		self:EndCharge( false )
	end

	-- move towards direction
	local target = origin + direction * self.speed * dt
	self:GetParent():SetOrigin( target )

	-- face towards target
	self:GetParent():FaceTowards( self.target:GetOrigin() )
end

function modifier_huskar_life_break_lua:OnHorizontalMotionInterrupted()
	self:Destroy()
end

function modifier_huskar_life_break_lua:EndCharge( success )
	-- cancel debuff if linken
	if success and (not self.target:TriggerSpellAbsorb(self:GetAbility())) then
		self.success = true
	end
	self:Destroy()
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_huskar_life_break_lua:PlayEffects()
	-- Get Resources
	local particle_cast = "particles/units/heroes/hero_huskar/huskar_life_break.vpcf"
	local sound_target = "Hero_Huskar.Life_Break.Impact"

	-- Create Particle
	local effect_cast = ParticleManager:CreateParticle( particle_cast, PATTACH_ABSORIGIN_FOLLOW, self.target )
	ParticleManager:SetParticleControl( effect_cast, 1, self.target:GetOrigin() )
	ParticleManager:ReleaseParticleIndex( effect_cast )

	-- Create Sound
	EmitSoundOn( sound_target, self.target )
end
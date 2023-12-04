-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_huskar_burning_spear_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_huskar_burning_spear_lua:IsHidden()
	return false
end

function modifier_huskar_burning_spear_lua:IsDebuff()
	return true
end

function modifier_huskar_burning_spear_lua:IsStunDebuff()
	return false
end

function modifier_huskar_burning_spear_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_huskar_burning_spear_lua:OnCreated( kv )
	-- references
	self.dps = self:GetAbility():GetSpecialValueFor( "burn_damage" )

	if IsServer() then
		self.auto_attack = kv.auto_attack
		if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_int10") then
			self:AddStack(7)
		else
			self:AddStack(self:GetAbility():GetSpecialValueFor("stack"))
		end

		-- increment stack
		-- if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_agi8") and RandomInt(1,100) <= 20 then
		-- 	self:AddStack()
		-- end

		-- precache damage
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = 500,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
			damage_flags = DOTA_DAMAGE_FLAG_NONE,
		}

		-- start interval
		self.interval = 0.5
		self:StartIntervalThink( self.interval )
	end
end

function modifier_huskar_burning_spear_lua:AddStack(count)
	count = count or 1
	local mod = self:GetParent():AddNewModifier(
		self:GetParent(), -- player source
		self:GetAbility(), -- ability source
		"modifier_huskar_burning_spear_lua_stack", -- modifier name
		{
			duration = self:GetAbility():GetSpecialValueFor("duration"),
		}
	)
	mod:SetStackCount( mod:GetStackCount() +  count)
	self:SetStackCount( self:GetStackCount() +  count )
end



function modifier_huskar_burning_spear_lua:OnRefresh( kv )
	-- references
	self.dps = self:GetAbility():GetSpecialValueFor( "burn_damage" )

	if IsServer() then
		self:AddStack()
		if kv.auto_attack == true then
			self.auto_attack = true
		end
		-- increment stack
		if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_agi9") and RollPseudoRandomPercentage(20, self:GetParent():entindex(), self:GetParent()) then
			self:AddStack()
		end
	end
end

function modifier_huskar_burning_spear_lua:OnRemoved()
	-- stop effects
	local sound_cast = "Hero_Huskar.Burning_Spear"
	StopSoundOn( sound_cast, self:GetParent() )
end

function modifier_huskar_burning_spear_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Interval Effects
function modifier_huskar_burning_spear_lua:OnIntervalThink()
	-- apply dot damage
	if self.auto_attack == 1 then
		self.damageTable.damage = self:CalculateDamage()
	else
		self.damageTable.damage = self:CalculateDamage() * 0.75
	end
	ApplyDamage( self.damageTable )
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_huskar_burning_spear_lua:GetEffectName()
	return "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf"
end

function modifier_huskar_burning_spear_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_huskar_burning_spear_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end


function modifier_huskar_burning_spear_lua:CalculateDamage()
	local caster = self:GetCaster()
	local damage = self.dps
	if caster:FindAbilityByName("npc_dota_hero_huskar_agi11") then
		damage = damage + caster:GetAgility() * 0.10
	end
	if caster:FindAbilityByName("npc_dota_hero_huskar_int11") then
		damage = damage + caster:GetIntellect() * 0.10
	end
	if caster:FindAbilityByName("npc_dota_hero_huskar_str8") then
		damage = damage + caster:GetStrength() * 0.07
	end
	if caster:FindAbilityByName("npc_dota_hero_huskar_agi_last") then
		damage = damage + self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()) * 0.25
		self.damageTable.damage_type = DAMAGE_TYPE_PHYSICAL
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	end
	if caster:FindAbilityByName("npc_dota_hero_huskar_int_last") then
		damage = damage * 1.4
	end
	if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_huskar_int50") then
		damage = damage + self:GetCaster():GetHealth() * 0.01
	end
	if caster:FindAbilityByName("special_bonus_unique_npc_dota_hero_huskar_agi50") then
		damage = damage * self:GetCaster():GetSpellAmplification(false) * 0.01 + damage
	end
	return self:GetStackCount() * damage * self.interval
end

function modifier_huskar_burning_spear_lua:GetModifierPhysicalArmorBonus()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_agi7") then
		if self:GetStackCount() > self:GetAbility():GetLevel() then
			return self:GetAbility():GetLevel() * -1
		end
		return self:GetStackCount() * -1
	end
	return 0
end
-- 
function modifier_huskar_burning_spear_lua:OnTakeDamage(params)
	-- if params.attacker == self:GetCaster() and self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_agi_last") and params.damage_type == DAMAGE_TYPE_PHYSICAL and RollPseudoRandomPercentage(10, self:GetParent():entindex(), self:GetParent()) then
	-- 	self.damageTable.damage = self:CalculateDamage()
	-- 	print(self.damageTable.damage)
	-- 	ApplyDamage( self.damageTable )
	-- end
end
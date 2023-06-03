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
		self:AddStack()
		-- increment stack
		if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_agi8") and RandomInt(1,100) <= 20 then
			self:AddStack()
		end

		-- precache damage
		self.damageTable = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			-- damage = 500,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility(), --Optional.
		}

		-- start interval
		self:StartIntervalThink( 1 )
		self:OnIntervalThink()
	end
end

function modifier_huskar_burning_spear_lua:AddStack()
	mod = self:GetParent():AddNewModifier(
		self:GetCaster(), -- player source
		self:GetAbility(), -- ability source
		"modifier_huskar_burning_spear_lua_stack", -- modifier name
		{
			duration = self:GetAbility():GetSpecialValueFor("duration"),
		} -- kv
	)
	mod.modifier = self
	self:IncrementStackCount()
end

function modifier_huskar_burning_spear_lua:OnRefresh( kv )
	-- references
	self.dps = self:GetAbility():GetSpecialValueFor( "burn_damage" )

	if IsServer() then
		self:AddStack()
		-- increment stack
		if self:GetCaster():FindAbilityByName("npc_dota_hero_huskar_agi8") and RandomInt(1,100) <= 20 then
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
	
	self.damageTable.damage = self:CalculateDamage()
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
		damage = damage + self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()) * 0.15
		self.damageTable.damage_type = DAMAGE_TYPE_PHYSICAL
		self.damageTable.damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION
	end
	if caster:FindAbilityByName("npc_dota_hero_huskar_int_last") then
		damage = damage * 1.4
	end
	return self:GetStackCount() * damage
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
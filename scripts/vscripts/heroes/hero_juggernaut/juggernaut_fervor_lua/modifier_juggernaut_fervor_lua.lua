modifier_juggernaut_fervor_lua = class({})

--------------------------------------------------------------------------------
-- Initializations

function modifier_juggernaut_fervor_lua:IsHidden()
	if self:GetStackCount() >= 1 then 
		return false
	else
		return true
	end
end

function modifier_juggernaut_fervor_lua:IsDebuff( kv )
	return false
end

function modifier_juggernaut_fervor_lua:IsPurgable( kv )
	return false
end

--------------------------------------------------------------------------------
-- Life cycle

function modifier_juggernaut_fervor_lua:OnCreated( kv )
	self:SetStackCount(0)
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("attack_speed")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_juggernaut_agi_last") ~= nil then
		self.damage = self:GetAbility():GetSpecialValueFor("damage") * 15
		self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks") + 10
	else
        self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
	end
	self.currentTarget = {}
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_juggernaut_agi9") 
	if abil ~= nil then
	self.max_stacks = self.max_stacks + 4
	end
end

function modifier_juggernaut_fervor_lua:OnRefresh( kv )
	self.stack_multiplier = self:GetAbility():GetSpecialValueFor("attack_speed")
	if self:GetCaster():FindAbilityByName("npc_dota_hero_juggernaut_agi_last") ~= nil then
		self.damage = self:GetAbility():GetSpecialValueFor("damage") * 15
		self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks") + 10
	else
        self.damage = self:GetAbility():GetSpecialValueFor("damage")
		self.max_stacks = self:GetAbility():GetSpecialValueFor("max_stacks")
	end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_juggernaut_agi9") 
	if abil ~= nil then
	self.max_stacks = self.max_stacks + 4
	end
end

--------------------------------------------------------------------------------
-- Declare functions

function modifier_juggernaut_fervor_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_juggernaut_fervor_lua:GetModifierHealthRegenPercentage( params )
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_juggernaut_str9") 
	if abil ~= nil then
	return 5
	end
	return 0
end

function modifier_juggernaut_fervor_lua:GetModifierPercentageManaRegen( params )
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_juggernaut_str9") 
	if abil ~= nil then
	return 1
	end
	return 0
end


function modifier_juggernaut_fervor_lua:OnAttack( params )
	if IsServer() then
		-- filter
		pass = false
		if params.attacker==self:GetParent() then
			pass = true
		end

		-- logic
		if pass then
			-- check if it is the same target
			local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_juggernaut_agi50") 
			if self.currentTarget==params.target then
				self:AddStack()
			else
				if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_juggernaut_agi50")  then
					self:SetStackCount(self:GetStackCount() * 0.7)
				else
					self:ResetStack()
				end
				self.currentTarget = params.target
			end
		end
	end
end

function modifier_juggernaut_fervor_lua:GetModifierPhysicalArmorBonus( params )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_juggernaut_str8") 
	if abil ~= nil then
	local passive = 1
	if self:GetParent():PassivesDisabled() then
		passive = 0
	end
	return (self:GetStackCount() * self.stack_multiplier * passive) / 2
	end
	return 0
end

function modifier_juggernaut_fervor_lua:GetModifierMagicalResistanceBonus( params )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_juggernaut_str11") 
	if abil ~= nil then
	local passive = 1
	if self:GetParent():PassivesDisabled() then
		passive = 0
	end
	return (self:GetStackCount() * self.stack_multiplier * passive) / 2
	end
	return 0
end

function modifier_juggernaut_fervor_lua:GetModifierAttackSpeedBonus_Constant( params )
	local passive = 1
	if self:GetParent():PassivesDisabled() then
		passive = 0
	end
	return self:GetStackCount() * self.stack_multiplier * passive
end

function modifier_juggernaut_fervor_lua:GetModifierPreAttack_BonusDamage( params )
	local passive = 1
	if self:GetParent():PassivesDisabled() then
		passive = 0
	end
	return self:GetStackCount() * self.damage * passive
end
--------------------------------------------------------------------------------
-- Helper functions

function modifier_juggernaut_fervor_lua:AddStack()
	if not self:GetParent():PassivesDisabled() then
		if self:GetStackCount() < self.max_stacks then
			self:IncrementStackCount()
		end
	end
end

function modifier_juggernaut_fervor_lua:ResetStack()
	if not self:GetParent():PassivesDisabled() then
		self:SetStackCount(0)
	end
end

function modifier_juggernaut_fervor_lua:GetModifierBonusStats_Strength()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_juggernaut_agi50") then
		return self:GetAbility():GetLevel() * 10 * self:GetStackCount()
	end
end

function modifier_juggernaut_fervor_lua:GetModifierBonusStats_Agility()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_juggernaut_agi50") then
		return self:GetAbility():GetLevel() * 10 * self:GetStackCount()
	end
end

function modifier_juggernaut_fervor_lua:GetModifierBonusStats_Intellect()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_juggernaut_agi50") then
		return self:GetAbility():GetLevel() * 10 * self:GetStackCount()
	end
end
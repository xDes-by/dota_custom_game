modifier_viper_nethertoxin_intrinsic_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_viper_nethertoxin_intrinsic_lua:IsHidden()
	return true
end

function modifier_viper_nethertoxin_intrinsic_lua:IsDebuff()
	return false
end

function modifier_viper_nethertoxin_intrinsic_lua:IsPurgable()
	return false
end

function modifier_viper_nethertoxin_intrinsic_lua:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_viper_nethertoxin_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
        MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end

function modifier_viper_nethertoxin_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "min_damage" then
			return 1
		end
		if data.ability_special_value == "max_damage" then
			return 1
		end
		if data.ability_special_value == "move_slow" then
			return 1
		end
        if data.ability_special_value == "max_duration" then
			return 1
		end
        if data.ability_special_value == "duration" then
			return 1
		end
        if data.ability_special_value == "attack_proc" then
			return 1
		end
		if data.ability_special_value == "AbilityCharges" then
			return 1
		end
	end
	return 0
end

function modifier_viper_nethertoxin_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "min_damage" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "min_damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int10") then
                value = value + self:GetCaster():GetIntellect() * 0.1
            end
            return value
		end
		if data.ability_special_value == "max_damage" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "max_damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int10") then
                value = value + self:GetCaster():GetIntellect() * 0.5
            end
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi13") then
                value = value * 4
            end
            return value
		end
		if data.ability_special_value == "move_slow" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "move_slow", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str9") then
                value = 100
            end
            return value
		end
        if data.ability_special_value == "max_duration" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "max_duration", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi13") then
                value = value * 3
            end
            return value
		end
        if data.ability_special_value == "duration" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "duration", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi7") then
                value = value + 6
            end
            return value
		end
        if data.ability_special_value == "attack_proc" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "attack_proc", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi12") then
                value = 10
            end
            return value
		end
		if data.ability_special_value == "AbilityCharges" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "AbilityCharges", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int7") then
                value = 2
            end
            return value
		end
	end
	return 0
end

function modifier_viper_nethertoxin_intrinsic_lua:OnAttack(params)
	if IsServer() then
		if params.attacker == self:GetParent() and RollPercentage(self:GetAbility():GetSpecialValueFor("attack_proc")) then
			self:GetCaster():SetCursorPosition(params.target:GetAbsOrigin())
            self:GetAbility():OnSpellStart(true)
		end
	end
end
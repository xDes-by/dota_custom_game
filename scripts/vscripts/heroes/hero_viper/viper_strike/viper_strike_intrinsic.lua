modifier_viper_viper_strike_intrinsic_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_viper_viper_strike_intrinsic_lua:IsHidden()
	return true
end

function modifier_viper_viper_strike_intrinsic_lua:IsDebuff()
	return false
end

function modifier_viper_viper_strike_intrinsic_lua:IsPurgable()
	return false
end

function modifier_viper_viper_strike_intrinsic_lua:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_viper_viper_strike_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_viper_viper_strike_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "bonus_attack_speed" then
			return 1
		end
		if data.ability_special_value == "AbilityCharges" then
			return 1
		end
        if data.ability_special_value == "AbilityChargeRestoreTime" then
			return 1
		end
        if data.ability_special_value == "damage" then
			return 1
		end
	end
	return 0
end

function modifier_viper_viper_strike_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "bonus_attack_speed" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "bonus_attack_speed", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_str6") then
                value = value * 2
            end
            return value
		end
		if data.ability_special_value == "AbilityCharges" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "AbilityCharges", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_agi9") then
                value = 2
            end
            return value
		end
        if data.ability_special_value == "AbilityChargeRestoreTime" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "AbilityChargeRestoreTime", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int11") then
                value = 10
            end
            return value
		end
        if data.ability_special_value == "damage" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_viper_int8") then
                value = value + self:GetCaster():GetIntellect()
            end
            return value
		end
	end
	return 0
end
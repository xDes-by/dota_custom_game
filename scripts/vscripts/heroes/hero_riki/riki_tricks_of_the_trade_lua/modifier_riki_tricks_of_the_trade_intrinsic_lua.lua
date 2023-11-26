modifier_riki_tricks_of_the_trade_intrinsic_lua = class({})

function modifier_riki_tricks_of_the_trade_intrinsic_lua:IsHidden()
	return true
end

function modifier_riki_tricks_of_the_trade_intrinsic_lua:IsPurgable()
	return false
end

function modifier_riki_tricks_of_the_trade_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_riki_tricks_of_the_trade_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_riki_tricks_of_the_trade_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "area_of_effect" then
			return 1
		end
		if data.ability_special_value == "target_count" then
			return 1
		end
		if data.ability_special_value == "dmg_perc" then
			return 1
		end
		if data.ability_special_value == "extra_agility" then
			return 1
		end
		if data.ability_special_value == "AbilityCharges" then
			return 1
		end
		if data.ability_special_value == "AbilityChargeRestoreTime" then
			return 1
		end
		if data.ability_special_value == "target_count" then
			return 1
		end
	end
	return 0
end

function modifier_riki_tricks_of_the_trade_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "area_of_effect" then
			local area_of_effect = self:GetAbility():GetLevelSpecialValueNoOverride( "area_of_effect", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int11") then
                area_of_effect = area_of_effect + 150
            end
            return area_of_effect
		end
		if data.ability_special_value == "target_count" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "target_count", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int8") then
                value = 999
            end
            return value
		end
		if data.ability_special_value == "dmg_perc" then
			local dmg_perc = self:GetAbility():GetLevelSpecialValueNoOverride( "dmg_perc", data.ability_special_level )
			if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_str13") then
				dmg_perc = dmg_perc + 300
			end
            return dmg_perc
		end
		if data.ability_special_value == "extra_agility" then
			local extra_agility = self:GetAbility():GetLevelSpecialValueNoOverride( "extra_agility", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi7") then
                extra_agility = extra_agility + 60
            end
            return extra_agility
		end
		if data.ability_special_value == "AbilityCharges" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "AbilityCharges", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi6") then
                value = 2
            end
            return value
		end
		if data.ability_special_value == "AbilityChargeRestoreTime" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "AbilityChargeRestoreTime", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int6") then
                value = value / 2
            end
            return value
		end
		if data.ability_special_value == "target_count" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "target_count", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int8") then
                value = 999
            end
            return value
		end
	end
	return 0
end
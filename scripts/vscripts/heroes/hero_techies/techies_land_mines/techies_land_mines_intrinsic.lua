techies_land_mines_intrinsic = class({})

function techies_land_mines_intrinsic:IsHidden()
	return true
end

function techies_land_mines_intrinsic:IsPurgable()
	return false
end

function techies_land_mines_intrinsic:RemoveOnDeath()
	return false
end


function techies_land_mines_intrinsic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function techies_land_mines_intrinsic:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "AbilityChargeRestoreTime" then
			return 1
		end
	end
	return 0
end

function techies_land_mines_intrinsic:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "AbilityChargeRestoreTime" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "AbilityChargeRestoreTime", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_techies_int50") then
                value = value / 2
            end
            return value
		end
	end
	return 0
end
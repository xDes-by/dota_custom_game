modifier_vengeful_tempest_double_intrinsic = class({})

function modifier_vengeful_tempest_double_intrinsic:IsHidden()
	return true
end

function modifier_vengeful_tempest_double_intrinsic:IsPurgable()
	return false
end

function modifier_vengeful_tempest_double_intrinsic:RemoveOnDeath()
	return false
end


function modifier_vengeful_tempest_double_intrinsic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_vengeful_tempest_double_intrinsic:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "AbilityCharges" then
			return 1
		end
	end
	return 0
end

function modifier_vengeful_tempest_double_intrinsic:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "AbilityCharges" then
			local value = self:GetAbility():GetLevelSpecialValueNoOverride( "AbilityCharges", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_str12") then
                value = 3
            end
            return value
		end
	end
	return 0
end


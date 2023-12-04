modifier_lina_firehell_intrinsic_lua = class({})

function modifier_lina_firehell_intrinsic_lua:IsHidden()
	return true
end

function modifier_lina_firehell_intrinsic_lua:IsPurgable()
	return false
end

function modifier_lina_firehell_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_lina_firehell_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_lina_firehell_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "base_damage_per_second" then
			return 1
		end
	end
	return 0
end

function modifier_lina_firehell_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "base_damage_per_second" then
			local base_damage_per_second = self:GetAbility():GetLevelSpecialValueNoOverride( "base_damage_per_second", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_str7") then
                base_damage_per_second = base_damage_per_second + self:GetCaster():GetStrength() * 0.5
            end
			if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int13") then
				base_damage_per_second = base_damage_per_second + self:GetCaster():GetIntellect() * 0.4
			elseif self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int12") then
				base_damage_per_second = base_damage_per_second + self:GetCaster():GetIntellect() * 0.2
			end
            return base_damage_per_second
		end
	end
	return 0
end
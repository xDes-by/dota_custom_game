modifier_leshrac_lightning_storm_intrinsic_lua = class({})

function modifier_leshrac_lightning_storm_intrinsic_lua:IsHidden()
	return true
end

function modifier_leshrac_lightning_storm_intrinsic_lua:IsPurgable()
	return false
end

function modifier_leshrac_lightning_storm_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_leshrac_lightning_storm_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_leshrac_lightning_storm_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
		if data.ability_special_value == "jump_count" then
			return 1
		end
	end
	return 0
end

function modifier_leshrac_lightning_storm_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_int10") then
                damage = damage + self:GetCaster():GetIntellect() * 1.0
            end
            return damage
		end
		if data.ability_special_value == "jump_count" then
			local jump_count = self:GetAbility():GetLevelSpecialValueNoOverride( "jump_count", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_str12") then
                jump_count = jump_count * 2
            end
            return jump_count
		end
	end
	return 0
end
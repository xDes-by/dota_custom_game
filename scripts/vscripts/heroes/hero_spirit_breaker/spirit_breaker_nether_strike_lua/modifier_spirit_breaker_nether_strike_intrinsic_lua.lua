modifier_spirit_breaker_nether_strike_intrinsic_lua = class({})

function modifier_spirit_breaker_nether_strike_intrinsic_lua:IsHidden()
	return true
end

function modifier_spirit_breaker_nether_strike_intrinsic_lua:IsDebuff()
	return false
end

function modifier_spirit_breaker_nether_strike_intrinsic_lua:IsPurgable()
	return false
end

function modifier_spirit_breaker_nether_strike_intrinsic_lua:RemoveOnDeath()
	return false
end

function modifier_spirit_breaker_nether_strike_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_spirit_breaker_nether_strike_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
	end
	return 0
end

function modifier_spirit_breaker_nether_strike_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_spirit_breaker_int8") then
                damage = damage + self:GetCaster():GetIntellect() * 2
            end
            return damage
		end
	end
	return 0
end
modifier_leshrac_pulse_nova_intrinsic_lua = class({})

function modifier_leshrac_pulse_nova_intrinsic_lua:IsHidden()
	return true
end

function modifier_leshrac_pulse_nova_intrinsic_lua:IsPurgable()
	return false
end

function modifier_leshrac_pulse_nova_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_leshrac_pulse_nova_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_leshrac_pulse_nova_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
		if data.ability_special_value == "interval" then
			return 1
		end
		if data.ability_special_value == "radius" then
			return 1
		end
	end
	return 0
end

function modifier_leshrac_pulse_nova_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_int6") then
                damage = damage + self:GetCaster():GetIntellect() * 0.35
            end
			if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_int7") then
                damage = damage + self:GetCaster():GetIntellect() * 0.35
            end
			if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_int8") then
                damage = damage + self:GetCaster():GetIntellect() * 0.35
            end
            return damage
		end
		if data.ability_special_value == "interval" then
			local interval = self:GetAbility():GetLevelSpecialValueNoOverride( "interval", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_int12") then
                interval = 0.5
            end
			if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_int13") then
                interval = 0.2
            end
            return interval
		end
		if data.ability_special_value == "radius" then
			local radius = self:GetAbility():GetLevelSpecialValueNoOverride( "radius", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_str10") then
                radius = 800
            end
            return radius
		end
	end
	return 0
end
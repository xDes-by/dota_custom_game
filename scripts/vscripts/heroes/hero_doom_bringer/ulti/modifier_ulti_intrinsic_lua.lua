modifier_ulti_intrinsic_lua = class({})

function modifier_ulti_intrinsic_lua:IsHidden()
	return true
end

function modifier_ulti_intrinsic_lua:IsPurgable()
	return false
end

function modifier_ulti_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_ulti_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_ulti_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "duration" then
			return 1
		end
	end
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage_per_soul" then
			return 1
		end
	end
	return 0
end

function modifier_ulti_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "duration" then
			local duration = self:GetAbility():GetLevelSpecialValueNoOverride( "duration", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_str9") then
                duration = 40
            end
            return duration
		end
		if data.ability_special_value == "damage_per_soul" then
			local damage_per_soul = self:GetAbility():GetLevelSpecialValueNoOverride( "damage_per_soul", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int8") then
                damage_per_soul = damage_per_soul + self:GetCaster():GetIntellect() * 0.05
            end
			if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int13") then
				damage_per_soul = damage_per_soul + self:GetCaster():GetIntellect() * 0.4
			elseif self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int12") then
				damage_per_soul = damage_per_soul + self:GetCaster():GetIntellect() * 0.2
			end
            return damage_per_soul
		end
	end
	return 0
end
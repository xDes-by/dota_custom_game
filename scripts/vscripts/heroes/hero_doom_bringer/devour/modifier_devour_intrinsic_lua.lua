modifier_devour_intrinsic_lua = class({})

function modifier_devour_intrinsic_lua:IsHidden()
	return false
end

function modifier_devour_intrinsic_lua:IsPurgable()
	return false
end

function modifier_devour_intrinsic_lua:RemoveOnDeath()
	return false
end
function modifier_devour_intrinsic_lua:GetTexture()
	return "soul"
end

function modifier_devour_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}

	return funcs
end

function modifier_devour_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "base_damage_per_second" then
			return 1
		end
		if data.ability_special_value == "bonus_gold" then
			return 1
		end
		if data.ability_special_value == "devour_damage" then
			return 1
		end
	end
	return 0
end

function modifier_devour_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "base_damage_per_second" then
			local base_damage_per_second = self:GetAbility():GetLevelSpecialValueNoOverride( "base_damage_per_second", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_str7") then
                base_damage_per_second = base_damage_per_second + self:GetCaster():GetStrength() * 0.5
            end
            return base_damage_per_second
		end
		if data.ability_special_value == "bonus_gold" then
			local bonus_gold = self:GetAbility():GetLevelSpecialValueNoOverride( "bonus_gold", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_agi8") then
                bonus_gold = bonus_gold * 3
            end
            return bonus_gold
		end
		if data.ability_special_value == "devour_damage" then
			local devour_damage = self:GetAbility():GetLevelSpecialValueNoOverride( "devour_damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_agi13") then
                devour_damage = devour_damage * 7
			elseif self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_agi12") then
				devour_damage = devour_damage * 4
			end
            return devour_damage
		end
	end
	return 0
end

function modifier_devour_intrinsic_lua:GetSoulsStackCount()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_int6") and self:GetStackCount() % 3 == 0 then
		return self:GetStackCount() * 1.5
	end
	return self:GetStackCount()
end

function modifier_devour_intrinsic_lua:GetModifierPreAttack_CriticalStrike()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_doom_bringer_agi6") and RandomInt(1, 100) <= 15 then
		return 100 + self:GetSoulsStackCount() * 5
	end
	return 0
end
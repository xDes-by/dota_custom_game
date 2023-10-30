modifier_dawnbreaker_solar_guardian_intrinsic_lua = class({})

function modifier_dawnbreaker_solar_guardian_intrinsic_lua:IsHidden()
	return true
end

function modifier_dawnbreaker_solar_guardian_intrinsic_lua:IsPurgable()
	return false
end

function modifier_dawnbreaker_solar_guardian_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_dawnbreaker_solar_guardian_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_dawnbreaker_solar_guardian_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "arc_damage" then
			return 1
		end
	end
	return 0
end

function modifier_dawnbreaker_solar_guardian_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		-- if data.ability_special_value == "arc_damage" then
		-- 	local arc_damage = self:GetAbility():GetLevelSpecialValueNoOverride( "arc_damage", data.ability_special_level )
        --     if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int6") then
        --         arc_damage = arc_damage + self:GetCaster():GetIntellect() * 0.5
        --     end
        --     if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int13") then
        --         arc_damage = arc_damage + self:GetCaster():GetIntellect() * 1.0
        --     end
        --     return arc_damage
		-- end
	end
	return 0
end

function modifier_dawnbreaker_solar_guardian_intrinsic_lua:GetEffectName()
	return "particles/units/heroes/hero_dawnbreaker/dawnbreaker_solar_guardian.vpcf"
end
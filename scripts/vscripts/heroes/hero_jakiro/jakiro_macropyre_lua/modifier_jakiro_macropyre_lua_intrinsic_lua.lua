modifier_jakiro_macropyre_lua_intrinsic_lua = class({})

function modifier_jakiro_macropyre_lua_intrinsic_lua:IsHidden()
	return true
end

function modifier_jakiro_macropyre_lua_intrinsic_lua:IsPurgable()
	return false
end

function modifier_jakiro_macropyre_lua_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_jakiro_macropyre_lua_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_jakiro_macropyre_lua_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
		if data.ability_special_value == "path_radius" then
			return 1
		end
		if data.ability_special_value == "damage" then
			return 1
		end
	end
	return 0
end

function modifier_jakiro_macropyre_lua_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_str8") then
                damage = damage + self:GetCaster():GetStrength() * 1.0
            end
            return damage
		end
		if data.ability_special_value == "path_radius" then
			local path_radius = self:GetAbility():GetLevelSpecialValueNoOverride( "path_radius", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_str10") then
                path_radius = path_radius + 150
            end
            return path_radius
		end
		if data.ability_special_value == "cast_range" then
			local cast_range = self:GetAbility():GetLevelSpecialValueNoOverride( "cast_range", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_str10") then
                cast_range = cast_range + 150
            end
            return cast_range
		end
	end
	return 0
end
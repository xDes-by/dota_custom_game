modifier_zuus_thundergods_wrath_intrinsic = class({})

function modifier_zuus_thundergods_wrath_intrinsic:IsHidden()
	return true
end

function modifier_zuus_thundergods_wrath_intrinsic:IsPurgable()
	return false
end

function modifier_zuus_thundergods_wrath_intrinsic:RemoveOnDeath()
	return false
end


function modifier_zuus_thundergods_wrath_intrinsic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
        MODIFIER_EVENT_ON_DEATH,
	}

	return funcs
end

function modifier_zuus_thundergods_wrath_intrinsic:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
		if data.ability_special_value == "radius" then
			return 1
		end
	end
	return 0
end

function modifier_zuus_thundergods_wrath_intrinsic:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str11") then
                damage = damage + self:GetCaster():GetStrength() * 0.5
            end
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int8") then
                damage = damage + self:GetCaster():GetIntellect() * 1.0
            end
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int13") then
                damage = damage + self:GetCaster():GetIntellect() * 0.5
            end
            return damage
		end
		if data.ability_special_value == "radius" then
			local radius = self:GetAbility():GetLevelSpecialValueNoOverride( "radius", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi10") then
                radius = radius + 300
            end
            return radius
		end
	end
	return 0
end

function modifier_zuus_thundergods_wrath_intrinsic:OnDeath(params)
    if params.unit == self:GetCaster() and self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str13") then
        self:GetAbility():GlobalCast(1.0)
    end
end
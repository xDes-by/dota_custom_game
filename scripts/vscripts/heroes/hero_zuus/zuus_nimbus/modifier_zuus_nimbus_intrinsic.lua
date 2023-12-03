modifier_zuus_nimbus_intrinsic = class({})

function modifier_zuus_nimbus_intrinsic:IsHidden()
	return true
end

function modifier_zuus_nimbus_intrinsic:IsPurgable()
	return false
end

function modifier_zuus_nimbus_intrinsic:RemoveOnDeath()
	return false
end


function modifier_zuus_nimbus_intrinsic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_zuus_nimbus_intrinsic:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "cloud_duration" then
			return 1
		end
        if data.ability_special_value == "cloud_interval" then
			return 1
		end
        if data.ability_special_value == "cloud_radius" then
			return 1
		end
        if data.ability_special_value == "cast_range" then
			return 1
		end
	end
	return 0
end

function modifier_zuus_nimbus_intrinsic:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "cloud_duration" then
			local cloud_duration = self:GetAbility():GetLevelSpecialValueNoOverride( "cloud_duration", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi12") then
                cloud_duration = 40
            end
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi13") then
                cloud_duration = 50
            end
            return cloud_duration
		end
        if data.ability_special_value == "cloud_interval" then
			local cloud_interval = self:GetAbility():GetLevelSpecialValueNoOverride( "cloud_interval", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi12") then
                cloud_interval = 2
            end
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi13") then
                cloud_interval = 1
            end
            return cloud_interval
		end
        if data.ability_special_value == "cloud_radius" then
			local cloud_radius = self:GetAbility():GetLevelSpecialValueNoOverride( "cloud_radius", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi12") then
                cloud_radius = 800
            end
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi13") then
                cloud_radius = 1200
            end
            return cloud_radius
		end
        if data.ability_special_value == "cast_range" then
			local cast_range = self:GetAbility():GetLevelSpecialValueNoOverride( "cast_range", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi12") then
                cast_range = 2000
            end
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi13") then
                cast_range = 3000
            end
            return cast_range
		end
	end
	return 0
end

function modifier_zuus_nimbus_intrinsic:OnCreated( kv )
    if not IsServer() then return end
    self:StartIntervalThink(0.2)
    self:OnIntervalThink()
end

function modifier_zuus_nimbus_intrinsic:OnIntervalThink()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi12") then
        self:GetAbility():SetHidden(false)
    else
        self:GetAbility():SetHidden(true)
    end
end
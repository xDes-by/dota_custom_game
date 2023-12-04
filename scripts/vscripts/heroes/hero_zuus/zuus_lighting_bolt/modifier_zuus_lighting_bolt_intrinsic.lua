modifier_zuus_lighting_bolt_intrinsic = class({})

function modifier_zuus_lighting_bolt_intrinsic:IsHidden()
	return true
end

function modifier_zuus_lighting_bolt_intrinsic:IsPurgable()
	return false
end

function modifier_zuus_lighting_bolt_intrinsic:RemoveOnDeath()
	return false
end


function modifier_zuus_lighting_bolt_intrinsic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_zuus_lighting_bolt_intrinsic:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
        if data.ability_special_value == "sight_duration" then
			return 1
		end
	end
	return 0
end

function modifier_zuus_lighting_bolt_intrinsic:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_str7") then
                damage = damage + self:GetCaster():GetStrength() * 0.5
            end
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int7") then
                damage = damage + self:GetCaster():GetIntellect() * 1.0
            end
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int13") then
                damage = damage + self:GetCaster():GetIntellect() * 0.5
            end
            return damage
		end
        if data.ability_special_value == "sight_duration" then
			local sight_duration = self:GetAbility():GetLevelSpecialValueNoOverride( "sight_duration", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_agi11") then
                sight_duration = sight_duration + 3
            end
            return sight_duration
		end
	end
	return 0
end

function modifier_zuus_lighting_bolt_intrinsic:OnCreated( kv )
    if not IsServer() then return end
    self:StartIntervalThink(3)
    self:OnIntervalThink()
end

function modifier_zuus_lighting_bolt_intrinsic:OnIntervalThink()
    caster = self:GetCaster()
    if caster:FindAbilityByName("npc_dota_hero_zuus_agi7") then
        local enemies = FindUnitsInRadius( caster:GetTeamNumber(),  caster:GetAbsOrigin(),  nil,  700,  DOTA_UNIT_TARGET_TEAM_ENEMY,  DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,  DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,  FIND_ANY_ORDER,  false )
        if #enemies > 0 then
            self:GetAbility():CastLightningBolt(caster, self:GetAbility(), enemies[1], enemies[1]:GetAbsOrigin())
        end
    end
end

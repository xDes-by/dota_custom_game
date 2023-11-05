modifier_necrolyte_heartstopper_aura_intrinsic = class({})

function modifier_necrolyte_heartstopper_aura_intrinsic:OnCreated()
	self.radius = self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_necrolyte_heartstopper_aura_intrinsic:OnRefresh()
	if IsServer() then
		self:OnCreated()
	end
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetAuraEntityReject(target)
	return false
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetAuraRadius()
	return self.radius
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetModifierAura()
	return "modifier_necrolyte_heartstopper_aura_damage"
end

function modifier_necrolyte_heartstopper_aura_intrinsic:IsAura()
	if self:GetCaster():PassivesDisabled() then
		return false
	end
	return true
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_necrolyte_heartstopper_aura_intrinsic:IsHidden()
	return self:GetStackCount() == 0
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetEffectName()
	return "particles/auras/aura_heartstopper.vpcf"
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetEffectAttachType()
	return PATTACH_POINT_FOLLOW
end

function modifier_necrolyte_heartstopper_aura_intrinsic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
        MODIFIER_EVENT_ON_DEATH,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}

	return funcs
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "heal_regen_to_damage" then
			return 1
		end
		if data.ability_special_value == "boss_multiplier" then
			return 1
		end
		if data.ability_special_value == "regen_duration" then
			return 1
		end
	end
	return 0
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "heal_regen_to_damage" then
			local heal_regen_to_damage = self:GetAbility():GetLevelSpecialValueNoOverride( "heal_regen_to_damage", data.ability_special_level )
			if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_str9") then
            	heal_regen_to_damage = heal_regen_to_damage * 1.5
			end
            return heal_regen_to_damage
		end
		if data.ability_special_value == "boss_multiplier" then
			local boss_multiplier = self:GetAbility():GetLevelSpecialValueNoOverride( "boss_multiplier", data.ability_special_level )
			if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_agi6") then
				boss_multiplier = 12
			end
            return boss_multiplier
		end
		if data.ability_special_value == "regen_duration" then
			local regen_duration = self:GetAbility():GetLevelSpecialValueNoOverride( "regen_duration", data.ability_special_level )
			if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_agi9") then
				regen_duration = 15
			end
            return regen_duration
		end
	end
	return 0
end

function IsMyKilledBadGuys(hero, params)
    if params.unit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS then
        return false
    end
    local attacker = params.attacker
    if hero == attacker then
        return true
    else
        if hero == attacker:GetOwner() then
            return true
        else
            return false
        end
    end
end

function modifier_necrolyte_heartstopper_aura_intrinsic:OnDeath(params)
	local parent = self:GetParent()
	if IsMyKilledBadGuys(parent, params) then
        mod = parent:FindModifierByName("modifier_necrolyte_heartstopper_aura_buff")
        if not mod then
            mod = parent:AddNewModifier(parent, self:GetAbility(), "modifier_necrolyte_heartstopper_aura_buff", {duration = self:GetAbility():GetSpecialValueFor("regen_duration")})
        end
        if not table.has_value(bosses_names, params.unit) then
		    mod:IncrementStackCount()
        else
            for i = 1, self:GetAbility():GetSpecialValueFor("boss_multiplier") do
                mod:IncrementStackCount()
            end
        end
	end
end

function modifier_necrolyte_heartstopper_aura_intrinsic:GetModifierHealthRegenPercentage()
	
end
modifier_jakiro_dual_breath_intrinsic_lua = class({})

function modifier_jakiro_dual_breath_intrinsic_lua:IsHidden()
	return true
end

function modifier_jakiro_dual_breath_intrinsic_lua:IsPurgable()
	return false
end

function modifier_jakiro_dual_breath_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_jakiro_dual_breath_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_jakiro_dual_breath_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
		if data.ability_special_value == "duration" then
			return 1
		end
		if data.ability_special_value == "AbilityCharges" then
			return 1
		end
		if data.ability_special_value == "range" then
			return 1
		end
	end
	return 0
end

function modifier_jakiro_dual_breath_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_int7") then
                damage = damage + self:GetCaster():GetIntellect() * 0.3
            end
            return damage
		end
		if data.ability_special_value == "duration" then
			local duration = self:GetAbility():GetLevelSpecialValueNoOverride( "duration", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_int10") then
                duration = duration + 2
            end
            return duration
		end
		if data.ability_special_value == "AbilityCharges" then
			local AbilityCharges = self:GetAbility():GetLevelSpecialValueNoOverride( "AbilityCharges", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_agi8") then
                AbilityCharges = 2
            end
            return AbilityCharges
		end
		if data.ability_special_value == "range" then
			local range = self:GetAbility():GetLevelSpecialValueNoOverride( "range", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_jakiro_agi10") then
                range = range * 2
            end
            return range
		end
	end
	return 0
end

function modifier_jakiro_dual_breath_intrinsic_lua:OnCreated( kv )
	if not IsServer() then return end
	self:OnIntervalThink()
end

function modifier_jakiro_dual_breath_intrinsic_lua:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if caster:FindAbilityByName("npc_dota_hero_jakiro_str6") then
		ability:UseAbility(caster:GetForwardVector())
	end
	local level = ability:GetLevel()
	local cdr = caster:GetCooldownReduction()
	local cooldown = ability:GetCooldown(level)
	local interval = cooldown * cdr * 1.5
	self:StartIntervalThink(interval)
end
modifier_necrolyte_death_pulse_intrinsic_lua = class({})

function modifier_necrolyte_death_pulse_intrinsic_lua:IsHidden()
	return true
end

function modifier_necrolyte_death_pulse_intrinsic_lua:IsPurgable()
	return false
end

function modifier_necrolyte_death_pulse_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_necrolyte_death_pulse_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_necrolyte_death_pulse_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
	end
	return 0
end

function modifier_necrolyte_death_pulse_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_str10") then
                damage = damage + self:GetCaster():GetStrength() * 0.5
            end
			if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_int6") then
                damage = damage + self:GetCaster():GetIntellect() * 0.6
            end
            return damage
		end
	end
	return 0
end

function modifier_necrolyte_death_pulse_intrinsic_lua:OnCreated( kv )
	if not IsServer() then return end
	self.ability = self:GetAbility()
	self.caster = self:GetCaster()
	self:OnIntervalThink()
end

function modifier_necrolyte_death_pulse_intrinsic_lua:OnIntervalThink()
	if self.caster:FindAbilityByName("npc_dota_hero_necrolyte_agi10") and self.ability:GetLevel() > 0 then
		self.ability:OnSpellStart(
			self.caster:GetAbsOrigin(),
			self.ability:GetSpecialValueFor("radius")
		)
	end
	local cooldown = self.ability:GetCooldown(self.ability:GetLevel())
	local interval = cooldown * 1.7 * self.caster:GetCooldownReduction()
	self:StartIntervalThink(interval)
end
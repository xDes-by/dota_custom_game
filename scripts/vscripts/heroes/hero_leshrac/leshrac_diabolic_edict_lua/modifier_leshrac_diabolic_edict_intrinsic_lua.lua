modifier_leshrac_diabolic_edict_intrinsic_lua = class({})

function modifier_leshrac_diabolic_edict_intrinsic_lua:IsHidden()
	return true
end

function modifier_leshrac_diabolic_edict_intrinsic_lua:IsPurgable()
	return false
end

function modifier_leshrac_diabolic_edict_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_leshrac_diabolic_edict_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}

	return funcs
end

function modifier_leshrac_diabolic_edict_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
		if data.ability_special_value == "duration_tooltip" then
			return 1
		end
		if data.ability_special_value == "num_explosions" then
			return 1
		end
	end
	return 0
end

function modifier_leshrac_diabolic_edict_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_int11") then
                damage = damage + self:GetCaster():GetIntellect() * 0.25
            end
            return damage
		end
		if data.ability_special_value == "duration_tooltip" then
			local duration_tooltip = self:GetAbility():GetLevelSpecialValueNoOverride( "duration_tooltip", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi12") then
                duration_tooltip = duration_tooltip * 2
            end
            return duration_tooltip
		end
		if data.ability_special_value == "num_explosions" then
			local num_explosions = self:GetAbility():GetLevelSpecialValueNoOverride( "num_explosions", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi12") then
                num_explosions = num_explosions * 3
            end
            return num_explosions
		end
	end
	return 0
end

function modifier_leshrac_diabolic_edict_intrinsic_lua:OnCreated( kv )
	if not IsServer() then return end
	self.caster = self:GetCaster()
	self:StartIntervalThink( 0.2 )
end

function modifier_leshrac_diabolic_edict_intrinsic_lua:OnIntervalThink()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi11") and not self:GetCaster():HasModifier("modifier_leshrac_diabolic_edict_permanent_lua") then
		self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_leshrac_diabolic_edict_permanent_lua", {})
	elseif not self:GetCaster():FindAbilityByName("npc_dota_hero_leshrac_agi11") and self:GetCaster():HasModifier("modifier_leshrac_diabolic_edict_permanent_lua") then
		self:GetCaster():RemoveModifierByName("modifier_leshrac_diabolic_edict_permanent_lua")
	end
end
modifier_necrolyte_reapers_scythe_intrinsic_lua = class({})

function modifier_necrolyte_reapers_scythe_intrinsic_lua:IsHidden()
	return true
end

function modifier_necrolyte_reapers_scythe_intrinsic_lua:IsPurgable()
	return false
end

function modifier_necrolyte_reapers_scythe_intrinsic_lua:RemoveOnDeath()
	return false
end


function modifier_necrolyte_reapers_scythe_intrinsic_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
		MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end

function modifier_necrolyte_reapers_scythe_intrinsic_lua:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			return 1
		end
		if data.ability_special_value == "damage_increase" then
			return 1
		end
	end
	return 0
end

function modifier_necrolyte_reapers_scythe_intrinsic_lua:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "damage" then
			local damage = self:GetAbility():GetLevelSpecialValueNoOverride( "damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_int7") then
                damage = damage + self:GetCaster():GetIntellect() * 1.0
            end
            return damage
		end
		if data.ability_special_value == "damage_increase" then
			local damage_increase = self:GetAbility():GetLevelSpecialValueNoOverride( "damage_increase", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_int12") then
                damage_increase = damage_increase + 1
            end
			if self:GetCaster():FindAbilityByName("npc_dota_hero_necrolyte_int13") then
                damage_increase = damage_increase + 1.5
            end
            return damage_increase
		end
	end
	return 0
end

function modifier_necrolyte_reapers_scythe_intrinsic_lua:OnCreated( kv )
	self.caster = self:GetCaster()
end

function modifier_necrolyte_reapers_scythe_intrinsic_lua:OnAttack( data )
	if data.attacker == self.caster and (self.caster:FindAbilityByName("npc_dota_hero_necrolyte_agi12") or self.caster:FindAbilityByName("npc_dota_hero_necrolyte_agi13")) then
		local chance = 0
		if self.caster:FindAbilityByName("npc_dota_hero_necrolyte_agi12") then
			chance = 7
		end
		if self.caster:FindAbilityByName("npc_dota_hero_necrolyte_agi13") then
			chance = 12
		end
		if RandomInt(1, 100) <= chance and self:GetAbility():GetAutoCastState() and not data.target:IsMagicImmune() and not data.target:IsBuilding() then
			local mana_cost = self:GetAbility():GetManaCost(self:GetAbility():GetLevel())
			if mana_cost <= self:GetCaster():GetMana() then 
				self.caster:SetCursorCastTarget( data.target )
				self:GetAbility():OnSpellStart(true)
				self.caster:SpendMana( mana_cost, self:GetAbility() )
			end
		end
	end
end
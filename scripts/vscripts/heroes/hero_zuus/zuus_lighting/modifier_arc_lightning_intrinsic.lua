modifier_arc_lightning_intrinsic = class({})

function modifier_arc_lightning_intrinsic:IsHidden()
	return true
end

function modifier_arc_lightning_intrinsic:IsPurgable()
	return false
end

function modifier_arc_lightning_intrinsic:RemoveOnDeath()
	return false
end


function modifier_arc_lightning_intrinsic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
        MODIFIER_EVENT_ON_ATTACK,
	}

	return funcs
end

function modifier_arc_lightning_intrinsic:GetModifierOverrideAbilitySpecial(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "arc_damage" then
			return 1
		end
        if data.ability_special_value == "jump_count" then
			return 1
		end
	end
	return 0
end

function modifier_arc_lightning_intrinsic:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability and data.ability == self:GetAbility() then
		if data.ability_special_value == "arc_damage" then
			local arc_damage = self:GetAbility():GetLevelSpecialValueNoOverride( "arc_damage", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int6") then
                arc_damage = arc_damage + self:GetCaster():GetIntellect() * 0.35
            end
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int13") then
                arc_damage = arc_damage + self:GetCaster():GetIntellect() * 0.5
            end
            return arc_damage
		end
        if data.ability_special_value == "jump_count" then
			local jump_count = self:GetAbility():GetLevelSpecialValueNoOverride( "jump_count", data.ability_special_level )
            if self:GetCaster():FindAbilityByName("npc_dota_hero_zuus_int9") then
                jump_count = jump_count + 2
            end
            return jump_count
		end
	end
	return 0
end

function modifier_arc_lightning_intrinsic:OnAttack(params)
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    if params.attacker == self:GetParent() and self.caster:FindAbilityByName("npc_dota_hero_zuus_agi6") and self.ability:IsFullyCastable() and not params.target:IsMagicImmune() and not params.target:IsBuilding() then
        self.caster:SetCursorCastTarget( params.target )
        self.ability:OnSpellStart()
        self.ability:UseResources( true, false, false, true )
    end
end

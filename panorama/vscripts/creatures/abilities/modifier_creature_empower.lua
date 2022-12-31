modifier_creature_empower = class({})

function modifier_creature_empower:IsHidden() return true end
function modifier_creature_empower:IsDebuff() return false end
function modifier_creature_empower:IsPurgable() return false end

function modifier_creature_empower:OnCreated(keys)
	if IsClient() then return end

	local parent = self:GetParent()
	parent:AddNewModifier(parent, nil, "modifier_creature_armor_boost", {}):SetStackCount(10 * keys.armor_boost)
	parent:AddNewModifier(parent, nil, "modifier_creature_magic_resist_boost", {}):SetStackCount(keys.magic_resist_boost)
	parent:AddNewModifier(parent, nil, "modifier_creature_status_resist_boost", {}):SetStackCount(keys.status_resist_boost)
	parent:AddNewModifier(parent, nil, "modifier_creature_attack_speed_boost", {}):SetStackCount(keys.attack_speed_boost)
	parent:AddNewModifier(parent, nil, "modifier_creature_move_speed_boost", {}):SetStackCount(keys.move_speed_boost)

	self.accuracy_boost = keys.accuracy_boost
	self.damage_reduction_boost = keys.damage_reduction_boost
	self.spell_amp_boost = keys.spell_amp_boost

	self.boost = keys.boost

	self:SetStackCount(self.boost)
end

function modifier_creature_empower:DeclareFunctions()
	if IsServer() then
		return {
			MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
			MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
			MODIFIER_PROPERTY_PROCATTACK_FEEDBACK 
		}
	else
		return {
			MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
			MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE
		}
	end
end

function modifier_creature_empower:GetModifierIgnoreMovespeedLimit()
	return 1
end

function modifier_creature_empower:GetModifierIncomingDamage_Percentage()
	return (-1) * self.damage_reduction_boost
end

function modifier_creature_empower:GetModifierSpellAmplify_Percentage()
	return self.spell_amp_boost
end

function modifier_creature_empower:GetModifierProcAttack_Feedback(keys)
	if self:GetStackCount() <= 0 then return end

	if (not keys.target) or (not keys.attacker) or (keys.target:IsNull() or keys.attacker:IsNull()) then return end

	-- Target damage amplification
	local armor_modifier = keys.target:AddNewModifier(keys.attacker, nil, "modifier_creature_armor_reduction_boost", {duration = 10})
	if armor_modifier then
		armor_modifier:IncrementStackCount()
	end
end





modifier_creature_armor_boost = class({})

function modifier_creature_armor_boost:IsHidden() return true end
function modifier_creature_armor_boost:IsDebuff() return false end
function modifier_creature_armor_boost:IsPurgable() return false end

function modifier_creature_armor_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_creature_armor_boost:GetModifierPhysicalArmorBonus()
	return 0.1 * self:GetStackCount()
end



modifier_creature_magic_resist_boost = class({})

function modifier_creature_magic_resist_boost:IsHidden() return true end
function modifier_creature_magic_resist_boost:IsDebuff() return false end
function modifier_creature_magic_resist_boost:IsPurgable() return false end

function modifier_creature_magic_resist_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_creature_magic_resist_boost:GetModifierMagicalResistanceBonus()
	return self:GetStackCount()
end



modifier_creature_status_resist_boost = class({})

function modifier_creature_status_resist_boost:IsHidden() return true end
function modifier_creature_status_resist_boost:IsDebuff() return false end
function modifier_creature_status_resist_boost:IsPurgable() return false end

function modifier_creature_status_resist_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING
	}
end

function modifier_creature_status_resist_boost:GetModifierStatusResistanceStacking()
	return self:GetStackCount()
end



modifier_creature_attack_speed_boost = class({})

function modifier_creature_attack_speed_boost:IsHidden() return true end
function modifier_creature_attack_speed_boost:IsDebuff() return false end
function modifier_creature_attack_speed_boost:IsPurgable() return false end

function modifier_creature_attack_speed_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_creature_attack_speed_boost:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end



modifier_creature_move_speed_boost = class({})

function modifier_creature_move_speed_boost:IsHidden() return true end
function modifier_creature_move_speed_boost:IsDebuff() return false end
function modifier_creature_move_speed_boost:IsPurgable() return false end

function modifier_creature_move_speed_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE
	}
end

function modifier_creature_move_speed_boost:GetModifierMoveSpeedBonus_Percentage()
	return self:GetStackCount()
end



modifier_creature_armor_reduction_boost = class({})

function modifier_creature_armor_reduction_boost:IsHidden() return false end
function modifier_creature_armor_reduction_boost:IsDebuff() return true end
function modifier_creature_armor_reduction_boost:IsPurgable() return false end
function modifier_creature_armor_reduction_boost:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_creature_armor_reduction_boost:GetTexture() return "item_desolator" end

function modifier_creature_armor_reduction_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_creature_armor_reduction_boost:GetModifierIncomingDamage_Percentage()
	return 0.1 * self:GetStackCount()
end



modifier_creature_accuracy_boost = class({})

function modifier_creature_accuracy_boost:IsHidden() return false end
function modifier_creature_accuracy_boost:IsDebuff() return true end
function modifier_creature_accuracy_boost:IsPurgable() return false end

function modifier_creature_accuracy_boost:GetTexture() return "item_monkey_king_bar" end

function modifier_creature_accuracy_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_NEGATIVE_EVASION_CONSTANT
	}
end

function modifier_creature_accuracy_boost:GetModifierNegativeEvasion_Constant()
	return self:GetStackCount()
end



modifier_creature_level_indicator = class({})

function modifier_creature_level_indicator:IsHidden() return false end
function modifier_creature_level_indicator:IsDebuff() return false end
function modifier_creature_level_indicator:IsPurgable() return false end

function modifier_creature_level_indicator:GetTexture() return "modifier_invulnerable" end

function modifier_creature_level_indicator:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end

function modifier_creature_level_indicator:OnTooltip()
	return self:GetStackCount()
end



modifier_creature_mana_cost_boost = class({})

function modifier_creature_mana_cost_boost:IsHidden() return false end
function modifier_creature_mana_cost_boost:IsDebuff() return true end
function modifier_creature_mana_cost_boost:IsPurgable() return false end
function modifier_creature_mana_cost_boost:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end

function modifier_creature_mana_cost_boost:GetTexture() return "nyx_assassin_mana_burn" end

function modifier_creature_mana_cost_boost:OnCreated(keys)
	if IsClient() then return end

	self:SetStackCount(keys.stacks or 1)
	self:StartIntervalThink(1.0)
end

function modifier_creature_mana_cost_boost:OnIntervalThink()
	if IsServer() then self:IncrementStackCount() end
end

function modifier_creature_mana_cost_boost:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE_STACKING
	}
end

function modifier_creature_mana_cost_boost:GetModifierPercentageManacostStacking()
	return (-20) * self:GetStackCount()
end

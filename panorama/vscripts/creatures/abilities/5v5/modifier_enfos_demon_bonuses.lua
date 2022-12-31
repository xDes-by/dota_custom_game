modifier_enfos_demon_armor = class({})

function modifier_enfos_demon_armor:IsHidden() return true end
function modifier_enfos_demon_armor:IsDebuff() return false end
function modifier_enfos_demon_armor:IsPurgable() return false end

function modifier_enfos_demon_armor:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.value)
	end
end

function modifier_enfos_demon_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_enfos_demon_armor:GetModifierPhysicalArmorBonus()
	return self:GetStackCount()
end





modifier_enfos_demon_as = class({})

function modifier_enfos_demon_as:IsHidden() return true end
function modifier_enfos_demon_as:IsDebuff() return false end
function modifier_enfos_demon_as:IsPurgable() return false end

function modifier_enfos_demon_as:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.value)
	end
end

function modifier_enfos_demon_as:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_enfos_demon_as:GetModifierAttackSpeedBonus_Constant()
	return self:GetStackCount()
end





modifier_enfos_demon_ms = class({})

function modifier_enfos_demon_ms:IsHidden() return true end
function modifier_enfos_demon_ms:IsDebuff() return false end
function modifier_enfos_demon_ms:IsPurgable() return false end

function modifier_enfos_demon_ms:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.value)
	end
end

function modifier_enfos_demon_ms:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT
	}
end

function modifier_enfos_demon_ms:GetModifierMoveSpeedBonus_Constant()
	return self:GetStackCount()
end





modifier_enfos_demon_mr = class({})

function modifier_enfos_demon_mr:IsHidden() return true end
function modifier_enfos_demon_mr:IsDebuff() return false end
function modifier_enfos_demon_mr:IsPurgable() return false end

function modifier_enfos_demon_mr:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.value)
	end
end

function modifier_enfos_demon_mr:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS
	}
end

function modifier_enfos_demon_mr:GetModifierMagicalResistanceBonus()
	return self:GetStackCount()
end





modifier_enfos_demon_damage_block = class({})

function modifier_enfos_demon_damage_block:IsHidden() return true end
function modifier_enfos_demon_damage_block:IsDebuff() return false end
function modifier_enfos_demon_damage_block:IsPurgable() return false end

function modifier_enfos_demon_damage_block:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.value * self:GetParent():GetLevel())
	end
end

function modifier_enfos_demon_damage_block:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK
	}
end

function modifier_enfos_demon_damage_block:GetModifierPhysical_ConstantBlock()
	return self:GetStackCount()
end





modifier_enfos_demon_status_resist = class({})

function modifier_enfos_demon_status_resist:IsHidden() return true end
function modifier_enfos_demon_status_resist:IsDebuff() return false end
function modifier_enfos_demon_status_resist:IsPurgable() return false end

function modifier_enfos_demon_status_resist:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.value)
	end
end

function modifier_enfos_demon_status_resist:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE
	}
end

function modifier_enfos_demon_status_resist:GetModifierStatusResistance()
	return self:GetStackCount()
end





modifier_enfos_demon_damage_mitigation = class({})

function modifier_enfos_demon_damage_mitigation:IsHidden() return true end
function modifier_enfos_demon_damage_mitigation:IsDebuff() return false end
function modifier_enfos_demon_damage_mitigation:IsPurgable() return false end

function modifier_enfos_demon_damage_mitigation:OnCreated(keys)
	if IsServer() then self.value = keys.value end
end

function modifier_enfos_demon_damage_mitigation:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end

function modifier_enfos_demon_damage_mitigation:GetModifierIncomingDamage_Percentage()
	return (IsServer() and (-1) * self.value) or 0
end





modifier_enfos_demon_attack_range = class({})

function modifier_enfos_demon_attack_range:IsHidden() return true end
function modifier_enfos_demon_attack_range:IsDebuff() return false end
function modifier_enfos_demon_attack_range:IsPurgable() return false end

function modifier_enfos_demon_attack_range:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.value)
	end
end

function modifier_enfos_demon_attack_range:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end

function modifier_enfos_demon_attack_range:GetModifierAttackRangeBonus()
	return self:GetStackCount()
end





modifier_enfos_demon_elite_bonus = class({})

function modifier_enfos_demon_elite_bonus:IsHidden() return true end
function modifier_enfos_demon_elite_bonus:IsDebuff() return false end
function modifier_enfos_demon_elite_bonus:IsPurgable() return false end

function modifier_enfos_demon_elite_bonus:CheckState()
	return { [MODIFIER_STATE_CANNOT_MISS] = true }
end

function modifier_enfos_demon_elite_bonus:DeclareFunctions()
	if IsServer() then return { MODIFIER_PROPERTY_PROCATTACK_FEEDBACK } end
end

function modifier_enfos_demon_elite_bonus:GetModifierProcAttack_Feedback(keys)
	if (not keys.target) or (not keys.attacker) or (keys.target:IsNull() or keys.attacker:IsNull()) then return end

	local damage_amp_modifier = keys.target:AddNewModifier(keys.attacker, nil, "modifier_creature_armor_reduction_boost", {duration = 10})
	if damage_amp_modifier then
		damage_amp_modifier:SetStackCount(damage_amp_modifier:GetStackCount() + 10)
	end
end





modifier_enfos_demon_evasion = class({})

function modifier_enfos_demon_evasion:IsHidden() return true end
function modifier_enfos_demon_evasion:IsDebuff() return false end
function modifier_enfos_demon_evasion:IsPurgable() return false end

function modifier_enfos_demon_evasion:OnCreated(keys)
	if IsServer() then
		self:SetStackCount(keys.value)
	end
end

function modifier_enfos_demon_evasion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_EVASION_CONSTANT
	}
end

function modifier_enfos_demon_evasion:GetModifierEvasion_Constant()
	return self:GetStackCount()
end

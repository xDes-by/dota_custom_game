modifier_summon_refreshing = class({})

function modifier_summon_refreshing:GetTexture()
	return "rune_regen"
end

function modifier_summon_refreshing:IsHidden()
	return false
end

function modifier_summon_refreshing:IsDebuff()
	return false
end

function modifier_summon_refreshing:IsPurgable()
	return false
end

function modifier_summon_refreshing:OnCreated(kv)
	self:SetHasCustomTransmitterData(true)
	
	if IsClient() then return end
	self.kv = kv

	-- Remove totem and round 51+ debuffs
	self:GetParent():RemoveModifierByName("modifier_creature_armor_reduction_boost")
	self:GetParent():RemoveModifierByName("modifier_creature_accuracy_boost")
	self:GetParent():RemoveModifierByName("modifier_creature_mana_cost_boost")
end

function modifier_summon_refreshing:AddCustomTransmitterData()
	return self.kv
end

function modifier_summon_refreshing:HandleCustomTransmitterData(data)
	self.kv = data
end

function modifier_summon_refreshing:GetPriority()
	return 9999
end

function modifier_summon_refreshing:CheckState()
	local states = {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_INVISIBLE] = false
	}
	return states
end

function modifier_summon_refreshing:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_STATUS_RESISTANCE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,

		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
	return funcs
end

function modifier_summon_refreshing:GetModifierHealthRegenPercentage(params)
	return self.kv.health_regen_pct
end

function modifier_summon_refreshing:GetModifierTotalPercentageManaRegen(params)
	return self.kv.mana_regen_pct
end

function modifier_summon_refreshing:GetAbsoluteNoDamagePhysical()
	return self.kv.disable_damage
end

function modifier_summon_refreshing:GetAbsoluteNoDamageMagical()
	return self.kv.disable_damage
end

function modifier_summon_refreshing:GetAbsoluteNoDamagePure()
	return self.kv.disable_damage
end

function modifier_summon_refreshing:GetModifierStatusResistance()
	return self.kv.status_resistance
end

function modifier_summon_refreshing:GetModifierInvisibilityLevel()
	return 0
end

function modifier_summon_refreshing:OnTooltip()
	return self.kv.cooldown_reduction
end

modifier_dark_willow_talent_enabler = class({})

function modifier_dark_willow_talent_enabler:IsHidden() return true end
function modifier_dark_willow_talent_enabler:IsDebuff() return false end
function modifier_dark_willow_talent_enabler:IsPurgable() return false end
function modifier_dark_willow_talent_enabler:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_dark_willow_talent_enabler:OnCreated(keys)
	if IsClient() then return end
	self.listener = ListenToGameEvent("dota_player_learned_ability", Dynamic_Wrap(modifier_dark_willow_talent_enabler, "OnPlayerLearnedAbility"), self)
end

function modifier_dark_willow_talent_enabler:OnPlayerLearnedAbility(keys)
	if IsClient() then return end

	if keys.abilityname == "special_bonus_unique_dark_willow_4" then
		if self and (not self:IsNull()) and self:GetParent() and (not self:GetParent():IsNull()) and keys.PlayerID == self:GetParent():GetPlayerID() then
			local talent = self:GetParent():FindAbilityByName("special_bonus_unique_dark_willow_4")
			if talent then
				self:SetStackCount(talent:GetSpecialValueFor("value"))
				StopListeningToGameEvent(self.listener)
			end
		end
	end
end

function modifier_dark_willow_talent_enabler:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}
end

function modifier_dark_willow_talent_enabler:GetModifierOverrideAbilitySpecial(keys)
	if (not keys.ability) or (not keys.ability_special_value) then return 0 end

	if keys.ability_special_value == "attack_damage" and keys.ability:GetAbilityName() == "frostivus2018_dark_willow_bedlam" then
		return 1
	end

	return 0
end

function modifier_dark_willow_talent_enabler:GetModifierOverrideAbilitySpecialValue(keys)
	if keys.ability_special_value == "attack_damage" and keys.ability:GetAbilityName() == "frostivus2018_dark_willow_bedlam" then
		local base_value = keys.ability:GetLevelSpecialValueNoOverride(keys.ability_special_value, keys.ability_special_level)

		return base_value + self:GetStackCount()
	end

	return 0
end

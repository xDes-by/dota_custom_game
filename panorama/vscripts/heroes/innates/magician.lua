innate_magician = class({})

LinkLuaModifier("modifier_innate_magician", "heroes/innates/magician", LUA_MODIFIER_MOTION_NONE)

function innate_magician:GetIntrinsicModifierName()
	return "modifier_innate_magician"
end





modifier_innate_magician = class({})

function modifier_innate_magician:IsHidden() return true end
function modifier_innate_magician:IsDebuff() return false end
function modifier_innate_magician:IsPurgable() return false end
function modifier_innate_magician:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_magician:OnCreated(keys)
	self:OnRefresh(keys)

	self.ability_exceptions = {
		phantom_assassin_blur = true,
	}

	self.aoe_keywords = {
		"aoe",
		"area_of_effect",
		"radius",
	}

	self.other_keywords = {
		scepter_range = true,
		arrow_range_multiplier = true,
		wave_width = true,
		agility_range = true,
		aftershock_range = true,
		echo_slam_damage_range = true,
		echo_slam_echo_search_range = true,
		echo_slam_echo_range = true,
		torrent_max_distance = true,
		cleave_ending_width = true,
		cleave_distance = true,
		ghostship_width = true,
		dragon_slave_distance = true,
		dragon_slave_width_initial = true,
		dragon_slave_width_end = true,
		width = true,
		arrow_width = true,
		requiem_line_width_start = true,
		requiem_line_width_end = true,
		orb_vision = true,
		hook_distance = true,
		flesh_heap_range = true,
		hook_width = true,
		end_distance = true,
		burrow_width = true,
		splash_width = true,
		splash_range = true,
		jump_range = true,
		bounce_range = true,
		attack_spill_range = true,
		attack_spill_width = true,
	}
end

function modifier_innate_magician:OnRefresh(keys)
	local ability = self:GetAbility()
	local parent = self:GetParent()

	if (not ability) or (not parent) or (parent:IsNull() or ability:IsNull()) then return end

	self.base_int = ability:GetSpecialValueFor("base_int") or 0
	self.level_int = ability:GetSpecialValueFor("level_int") or 0
	self.aoe_multiplier = 1 + 0.01 * (ability:GetSpecialValueFor("aoe_radius_increase") or 0)

	if IsClient() then return end

	parent:SetPrimaryAttribute(DOTA_ATTRIBUTE_INTELLECT)
end

function modifier_innate_magician:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
	}
end

function modifier_innate_magician:GetModifierBonusStats_Intellect()
	return self.base_int + self.level_int * (self:GetParent():GetLevel() or 0)
end

function modifier_innate_magician:GetModifierOverrideAbilitySpecial(keys)
	if (not keys.ability) or (not keys.ability_special_value) or (not self.aoe_keywords) then return 0 end

	if self.ability_exceptions and self.ability_exceptions[keys.ability:GetAbilityName()] then
		return 0
	end

	for _, keyword in pairs(self.aoe_keywords) do
		if string.find(keys.ability_special_value, keyword) then
			return 1
		end
	end

	if (self.other_keywords and self.other_keywords[keys.ability_special_value]) then
		return 1
	end 

	return 0
end

function modifier_innate_magician:GetModifierOverrideAbilitySpecialValue(keys)
	local value = keys.ability:GetLevelSpecialValueNoOverride(keys.ability_special_value, keys.ability_special_level)

	for _, keyword in pairs(self.aoe_keywords) do
		if string.find(keys.ability_special_value, keyword) then
			return value * (self.aoe_multiplier or 1)
		end
	end

	if (self.other_keywords and self.other_keywords[keys.ability_special_value]) then
		return value * (self.aoe_multiplier or 1)
	end 

	return value
end

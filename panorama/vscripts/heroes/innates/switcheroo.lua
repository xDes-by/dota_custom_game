innate_switcheroo = class({})
LinkLuaModifier("modifier_innate_switcheroo", "heroes/innates/switcheroo", LUA_MODIFIER_MOTION_NONE)

function innate_switcheroo:GetIntrinsicModifierName()
	return "modifier_innate_switcheroo"
end



modifier_innate_switcheroo = class({})

function modifier_innate_switcheroo:IsHidden() return true end
function modifier_innate_switcheroo:IsDebuff() return false end
function modifier_innate_switcheroo:IsPurgable() return false end
function modifier_innate_switcheroo:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_innate_switcheroo:OnCreated(keys)
	local ability = self:GetAbility()
	if not ability or ability:IsNull() then return end
	
	self.parent = self:GetParent()
	if not self.parent or self.parent:IsNull() then return end

	self.melee_armor_base = ability:GetLevelSpecialValueFor("melee_armor_base", 1)
	self.melee_armor_gain = ability:GetLevelSpecialValueFor("melee_armor_gain", 1)
	self.melee_status_resistance = ability:GetLevelSpecialValueFor("melee_status_resistance", 1)
	self.ranged_base_attack_range = ability:GetLevelSpecialValueFor("ranged_base_attack_range", 1)
	self.ranged_attack_speed_base = ability:GetLevelSpecialValueFor("ranged_attack_speed_base", 1)
	self.ranged_attack_speed_gain = ability:GetLevelSpecialValueFor("ranged_attack_speed_gain", 1)

	if IsClient() then return end

	if self.parent:IsIllusion() then
		local player = self.parent:GetPlayerOwner()
		if not player or player:IsNull() then return end
		local main_hero = player:GetAssignedHero()
		self.parent:SetAttackCapability(main_hero.original_attack_capability)
		self.parent:SetRangedProjectileName(main_hero:GetRangedProjectileName())
		self.parent.original_attack_capability = main_hero.original_attack_capability
	else
		if not self.switch_active then
			self.switch_active = true
			if self.parent.original_attack_capability == DOTA_UNIT_CAP_RANGED_ATTACK then
				self.parent.original_attack_capability = DOTA_UNIT_CAP_MELEE_ATTACK
			else
				self.parent.original_attack_capability = DOTA_UNIT_CAP_RANGED_ATTACK
				self.parent:SetRangedProjectileName("particles/neutral_fx/mud_golem_hurl_boulder.vpcf")
			end
			self.parent:SetAttackCapability(self.parent.original_attack_capability)
			self:SetStackCount(self.parent.original_attack_capability)
		end
	end
end

function modifier_innate_switcheroo:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BASE_OVERRIDE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_STATUS_RESISTANCE_STACKING,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
end

-- Client doesn't have attack capability enum defined

function modifier_innate_switcheroo:GetModifierAttackRangeOverride()
	if IsValidEntity(self.parent) and self:GetStackCount() == (DOTA_UNIT_CAP_RANGED_ATTACK or 2) then
		return self.ranged_base_attack_range
	end

	return 150
end

function modifier_innate_switcheroo:GetModifierAttackSpeedBonus_Constant()
	if IsValidEntity(self.parent) and self:GetStackCount() == (DOTA_UNIT_CAP_RANGED_ATTACK or 2) then
		return self.ranged_attack_speed_base + self.ranged_attack_speed_gain * (self.parent:GetLevel() or 0)
	end
end

function modifier_innate_switcheroo:GetModifierStatusResistanceStacking()
	if IsValidEntity(self.parent) and self:GetStackCount() == (DOTA_UNIT_CAP_MELEE_ATTACK or 1) then
		return self.melee_status_resistance
	end
end

function modifier_innate_switcheroo:GetModifierPhysicalArmorBonus()
	if IsValidEntity(self.parent) and self:GetStackCount() == (DOTA_UNIT_CAP_MELEE_ATTACK or 1) then
		return self.melee_armor_base + self.melee_armor_gain * (self.parent:GetLevel() or 0)
	end
end

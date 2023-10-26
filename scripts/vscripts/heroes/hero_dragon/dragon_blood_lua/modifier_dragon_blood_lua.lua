LinkLuaModifier("modifier_blood_aura", "heroes/hero_dragon/dragon_blood_lua/modifier_dragon_blood_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_blood_aura_effect", "heroes/hero_dragon/dragon_blood_lua/modifier_dragon_blood_lua", LUA_MODIFIER_MOTION_NONE)

modifier_dragon_blood_lua = class({})

function modifier_dragon_blood_lua:IsHidden()
	return true
end

function modifier_dragon_blood_lua:IsDebuff()
	return false
end

function modifier_dragon_blood_lua:IsPurgable()
	return false
end

function modifier_dragon_blood_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) * level
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" ) * level
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_str_last") ~= nil then
		self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) * level * 3
		self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" ) * level * 3
	end
	self:StartIntervalThink(0.5)
end

function modifier_dragon_blood_lua:OnRefresh( kv )
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) * level
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" ) * level
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_str_last") ~= nil then
		self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) * level * 3
		self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" ) * level * 3
	end

	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_dragon_knight_str50") ~= nil then
		self.armor = self.armor * 5
		self.regen = self.regen * 5
	end

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_str9")	
	if abil ~= nil then 
		if not self:GetCaster():HasModifier("modifier_blood_aura") then
			self:GetCaster():AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_blood_aura", {})
		end
	end
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_str11")	
	if abil ~= nil then 
	self.regen = self.regen * 2
	self.armor = self.armor * 2
	end
end

function modifier_dragon_blood_lua:OnIntervalThink()
self:OnRefresh()
end


function modifier_dragon_blood_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end

function modifier_dragon_blood_lua:GetModifierConstantHealthRegen()
	if not self:GetParent():PassivesDisabled() then
		return self.regen
	end
end

function modifier_dragon_blood_lua:GetModifierPhysicalArmorBonus()
	if not self:GetParent():PassivesDisabled() then
		return self.armor
	end
end

function modifier_dragon_blood_lua:GetModifierMagicalResistanceBonus()
	if not self:GetParent():PassivesDisabled() then
		local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_str10")	
		if abil ~= nil then 
		return 25
		end
		return 0
	end
end

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

modifier_blood_aura = class({})

function modifier_blood_aura:IsDebuff() return false end
function modifier_blood_aura:AllowIllusionDuplicate() return true end
function modifier_blood_aura:IsHidden() return false end
function modifier_blood_aura:IsPurgable() return false end

function modifier_blood_aura:GetAuraRadius()
	return 700
end

function modifier_blood_aura:GetAuraEntityReject(target)
	return false
end

function modifier_blood_aura:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_blood_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_blood_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

function modifier_blood_aura:GetModifierAura()
	return "modifier_blood_aura_effect"
end

function modifier_blood_aura:IsAura()
	return true
end
---------------------------------------------------------------------------------------------------------------------------------------------
modifier_blood_aura_effect = class({})

function modifier_blood_aura_effect:OnCreated()
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) * level / 2
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" ) * level / 2 
end

function modifier_blood_aura_effect:OnRefresh()
	self.caster = self:GetCaster()
	local level = self.caster:GetLevel()
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) * level / 2 
	self.regen = self:GetAbility():GetSpecialValueFor( "bonus_health_regen" ) * level / 2 
end

function modifier_blood_aura_effect:IsHidden() return false end
function modifier_blood_aura_effect:IsPurgable() return false end
function modifier_blood_aura_effect:IsDebuff() return false end

function modifier_blood_aura_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_blood_aura_effect:GetModifierConstantHealthRegen()
	if not self:GetParent():PassivesDisabled() then
		if self:GetParent() ~= self:GetCaster() then
		return self.regen
		else
		return 0
		end
	end
end

function modifier_blood_aura_effect:GetModifierPhysicalArmorBonus()
	if not self:GetParent():PassivesDisabled() then
		if self:GetParent() ~= self:GetCaster() then
		return self.armor
		else
		return 0
		end
	end
end
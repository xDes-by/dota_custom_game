modifier_axe_berserkers_call_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_axe_berserkers_call_lua:IsHidden()
	return false
end

function modifier_axe_berserkers_call_lua:IsDebuff()
	return false
end

function modifier_axe_berserkers_call_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_axe_berserkers_call_lua:OnCreated( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_axe_agi50") then
		self.armor = self.armor * 5
	end
end

function modifier_axe_berserkers_call_lua:OnRefresh( kv )
	-- references
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" )
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_axe_agi50") then
		self.armor = self.armor * 5
	end
end

function modifier_axe_berserkers_call_lua:OnRemoved()
end

function modifier_axe_berserkers_call_lua:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_axe_berserkers_call_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_axe_berserkers_call_lua:GetModifierPhysicalArmorBonus()
	return self.armor
end

--------------------------------------------------------------------------------
-- Graphics & Animations
function modifier_axe_berserkers_call_lua:GetEffectName()
	return "particles/units/heroes/hero_axe/axe_beserkers_call.vpcf"
end

function modifier_axe_berserkers_call_lua:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

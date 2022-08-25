modifier_drow_ranger_aura = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_drow_ranger_aura:IsHidden()
	return true
end

function modifier_drow_ranger_aura:IsDebuff()
	return false
end

function modifier_drow_ranger_aura:IsPurgable()
	return false
end
--------------------------------------------------------------------------------
-- Aura
function modifier_drow_ranger_aura:IsAura()
	return (not self:GetCaster():PassivesDisabled())
end

function modifier_drow_ranger_aura:GetModifierAura()
	return "modifier_drow_ranger_aura_effect"
end

function modifier_drow_ranger_aura:GetAuraRadius()
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_drow_ranger_str10")
		if abil ~= nil then 
		return FIND_UNITS_EVERYWHERE
		else
	return 700
end
end

function modifier_drow_ranger_aura:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_drow_ranger_aura:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end
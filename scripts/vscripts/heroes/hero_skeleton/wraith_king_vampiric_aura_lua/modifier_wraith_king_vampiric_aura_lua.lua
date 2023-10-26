modifier_wraith_king_vampiric_aura_lua = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_wraith_king_vampiric_aura_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------
-- Aura
function modifier_wraith_king_vampiric_aura_lua:IsAura()
	return true
end

function modifier_wraith_king_vampiric_aura_lua:GetModifierAura()
	return "modifier_wraith_king_vampiric_aura_lua_lifesteal"
end

function modifier_wraith_king_vampiric_aura_lua:GetAuraRadius()

	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_skeleton_king_str11")
		if abil ~= nil then 
	return self.aura_radius
	else
	return 0
	end
end

function modifier_wraith_king_vampiric_aura_lua:GetAuraSearchTeam()
	if not self:GetParent():PassivesDisabled() then
		return DOTA_UNIT_TARGET_TEAM_FRIENDLY
	end
end

function modifier_wraith_king_vampiric_aura_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_wraith_king_vampiric_aura_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end
--------------------------------------------------------------------------------
-- Initializations
function modifier_wraith_king_vampiric_aura_lua:OnCreated( kv )
	-- references
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "vampiric_aura_radius" ) -- special value
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_skeleton_king_int50") then
		self.atr = self:GetCaster():GetPrimaryAttribute()
		self.atr_bonus = self:GetCaster():GetLevel() * 20
	end
end

function modifier_wraith_king_vampiric_aura_lua:OnRefresh( kv )
	-- references
	self.aura_radius = self:GetAbility():GetSpecialValueFor( "vampiric_aura_radius" ) -- special value
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_skeleton_king_int50") then
		self.atr = self:GetCaster():GetPrimaryAttribute()
		self.atr_bonus = self:GetCaster():GetLevel() * 20
	end
end

function modifier_wraith_king_vampiric_aura_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS
	}
end

function modifier_wraith_king_vampiric_aura_lua:GetModifierBonusStats_Intellect()
	if self.atr == DOTA_ATTRIBUTE_INTELLECT then
		return self.atr_bonus
	end
end

function modifier_wraith_king_vampiric_aura_lua:GetModifierBonusStats_Strength()
	if self.atr == DOTA_ATTRIBUTE_STRENGTH then
		return self.atr_bonus
	end
end

function modifier_wraith_king_vampiric_aura_lua:GetModifierBonusStats_Agility()
	if self.atr == DOTA_ATTRIBUTE_AGILITY then
		return self.atr_bonus
	end
end

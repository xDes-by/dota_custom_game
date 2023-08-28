modifier_riki_smoke_screen_lua_aura_base_armor		= modifier_riki_smoke_screen_lua_aura_base_armor or class({})

function modifier_riki_smoke_screen_lua_aura_base_armor:OnCreated()
	self.radius		= self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_riki_smoke_screen_lua_aura_base_armor:IsAura() 				return true end
function modifier_riki_smoke_screen_lua_aura_base_armor:IsAuraActiveOnDeath()	return false end

function modifier_riki_smoke_screen_lua_aura_base_armor:GetAuraRadius()			return self.radius or 0 end
function modifier_riki_smoke_screen_lua_aura_base_armor:GetAuraSearchFlags()		return DOTA_UNIT_TARGET_FLAG_NONE end
function modifier_riki_smoke_screen_lua_aura_base_armor:GetAuraSearchTeam()		return DOTA_UNIT_TARGET_TEAM_FRIENDLY end

function modifier_riki_smoke_screen_lua_aura_base_armor:GetAuraSearchType()		return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC end
function modifier_riki_smoke_screen_lua_aura_base_armor:GetModifierAura()		return "modifier_riki_smoke_screen_lua_base_armor" end

----------------------------------------------
-- modifier_riki_smoke_screen_lua_base_armor --
----------------------------------------------

modifier_riki_smoke_screen_lua_base_armor		= modifier_riki_smoke_screen_lua_base_armor or class({})

function modifier_riki_smoke_screen_lua_base_armor:OnCreated()
end

function modifier_riki_smoke_screen_lua_base_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_riki_smoke_screen_lua_base_armor:GetModifierPhysicalArmorBonus()
	return self:GetParent():GetPhysicalArmorBaseValue() * 0.5
end

-- 
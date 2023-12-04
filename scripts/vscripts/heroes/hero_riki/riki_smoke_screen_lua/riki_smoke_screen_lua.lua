LinkLuaModifier("modifier_riki_smoke_screen_lua_aura", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_smoke_screen_lua", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_smoke_screen_lua_aura_buff", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua_aura_buff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_smoke_screen_lua_buff", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua_aura_buff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_bloodthorn_attacker_crit", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_smoke_screen_lua_aura_base_armor", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua_aura_base_armor", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_smoke_screen_lua_base_armor", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua_aura_base_armor", LUA_MODIFIER_MOTION_NONE)

riki_smoke_screen_lua					= riki_smoke_screen_lua or class({})

function riki_smoke_screen_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function riki_smoke_screen_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_int9") then
		return 0
	end
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end
function riki_smoke_screen_lua:OnUpgrade()
	if self:GetCaster():HasAbility("imba_riki_blink_strike_723") and self:GetCaster():FindAbilityByName("imba_riki_blink_strike_723"):GetLevel() == 1 and not self.bUpgradeResponse and self:GetCaster():GetName() == "npc_dota_hero_riki" then
		self:GetCaster():EmitSound("riki_riki_ability_invis_04")
		
		self.bUpgradeResponse = true
	end
end

function riki_smoke_screen_lua:GetCooldown(level)
	if self:GetName() == "riki_smoke_screen_lua" then
		return self.BaseClass.GetCooldown(self, level)
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function riki_smoke_screen_lua:OnSpellStart()
	self:GetCaster():EmitSound("Hero_Riki.Smoke_Screen")
	CreateModifierThinker(self:GetCaster(), self, "modifier_riki_smoke_screen_lua_aura", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi9") then
		CreateModifierThinker(self:GetCaster(), self, "modifier_riki_smoke_screen_lua_aura_buff", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_str11") then
		CreateModifierThinker(self:GetCaster(), self, "modifier_riki_smoke_screen_lua_aura_base_armor", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	end
end
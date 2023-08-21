LinkLuaModifier("modifier_riki_smoke_screen_lua_aura", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_smoke_screen_lua", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_smoke_screen_lua_aura_buff", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua_aura_buff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_riki_smoke_screen_lua_buff", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua_aura_buff", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_imba_bloodthorn_attacker_crit", "heroes/hero_riki/riki_smoke_screen_lua/modifier_riki_smoke_screen_lua", LUA_MODIFIER_MOTION_NONE)

riki_smoke_screen_lua					= riki_smoke_screen_lua or class({})

function riki_smoke_screen_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
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

	if self:GetCaster():GetName() == "npc_dota_hero_riki" then
		if RollPercentage(15) then
			if not self.uncommon_responses then
				self.uncommon_responses = {
					"riki_riki_ability_smokescreen_03",
					"riki_riki_ability_smokescreen_05"
				}
			end
		
			self:GetCaster():EmitSound(self.uncommon_responses[RandomInt(1, #self.uncommon_responses)])
		elseif RollPercentage(75) then
			if not self.responses then
				self.responses = {
					"riki_riki_ability_smokescreen_01",
					"riki_riki_ability_smokescreen_02",
					"riki_riki_ability_smokescreen_04"
				}
			end
		
			self:GetCaster():EmitSound(self.responses[RandomInt(1, #self.responses)])
		end
	end

	CreateModifierThinker(self:GetCaster(), self, "modifier_riki_smoke_screen_lua_aura", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_riki_agi9") then
		CreateModifierThinker(self:GetCaster(), self, "modifier_riki_smoke_screen_lua_aura_buff", {duration = self:GetSpecialValueFor("duration")}, self:GetCursorPosition(), self:GetCaster():GetTeamNumber(), false)
	end
end
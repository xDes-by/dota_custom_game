dragon_form_lua = class({})
LinkLuaModifier( "modifier_dragon_form_lua", "heroes/hero_dragon/dragon_form_lua/modifier_dragon_form_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_form_lua_corrosive", "heroes/hero_dragon/dragon_form_lua/modifier_dragon_form_lua_corrosive", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_dragon_form_lua_frost", "heroes/hero_dragon/dragon_form_lua/modifier_dragon_form_lua_frost", LUA_MODIFIER_MOTION_NONE )


function dragon_form_lua:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect()/30)
end

function dragon_form_lua:GetCooldown( level )
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int6") 
	if abil ~= nil then
		return self.BaseClass.GetCooldown(self, level) - self.BaseClass.GetCooldown(self, level) * 0.25
	else
		return self.BaseClass.GetCooldown(self, level)
	end
end

function dragon_form_lua:OnSpellStart()

	local caster = self:GetCaster()
	duration = self:GetSpecialValueFor("duration")
	-- if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_dragon_knight_agi50") ~= nil then
	-- 	duration = -1
	-- end
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_agi11") 
		if abil ~= nil then
		duration = 180
		end
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_dragon_form_lua", -- modifier name
		{ duration = duration } -- kv
	)
end
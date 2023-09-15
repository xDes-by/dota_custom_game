enchantress_natures_attendants_lua = class({})
LinkLuaModifier( "modifier_enchantress_natures_attendants_lua", "heroes/hero_enchantress/enchantress_natures_attendants_lua/modifier_enchantress_natures_attendants_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_resist", "heroes/hero_enchantress/enchantress_natures_attendants_lua/modifier_enchantress_natures_attendants_lua", LUA_MODIFIER_MOTION_NONE )


function enchantress_natures_attendants_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int8")  ~= nil then 
		return (100 + math.min(65000, self:GetCaster():GetIntellect() / 200)) / 2
	end
	return 100 + math.min(65000,self:GetCaster():GetIntellect() / 200)
end


function enchantress_natures_attendants_lua:GetCooldown(level)
	local cooldown = self.BaseClass.GetCooldown(self, level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str6")  ~= nil then 
		return cooldown / 2
	end
	return cooldown
end


function enchantress_natures_attendants_lua:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetDuration()
	
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_enchantress_natures_attendants_lua", -- modifier name
		{ duration = duration } -- kv
	)
if self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str11") ~= nil then 
	
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_resist", -- modifier name
		{ duration = duration } -- kv
	)	
	end
end
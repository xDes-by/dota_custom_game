enchantress_natures_attendants_lua = class({})
LinkLuaModifier( "modifier_enchantress_natures_attendants_lua", "heroes/hero_enchantress/enchantress_natures_attendants_lua/modifier_enchantress_natures_attendants_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_resist", "heroes/hero_enchantress/enchantress_natures_attendants_lua/modifier_enchantress_natures_attendants_lua", LUA_MODIFIER_MOTION_NONE )



function enchantress_natures_attendants_lua:GetManaCost(iLevel)
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_int8")             
	if abil ~= nil then 
		local ability = self:GetCaster():FindAbilityByName("enchantress_natures")
			if ability:GetLevel() > 0 then
				mp_loss = ability:GetSpecialValueFor("mana_cost") * 0.01
				 return self:GetCaster():GetIntellect()/2 - (self:GetCaster():GetIntellect() * mp_loss)
			end	
		return self:GetCaster():GetIntellect()/2
	end
---------------------------------------------------------------------------------------------------------------------------------
		local ability = self:GetCaster():FindAbilityByName("enchantress_natures")
			if ability:GetLevel() > 0 then
				mp_loss = ability:GetSpecialValueFor("mana_cost") * 0.01
				 return self:GetCaster():GetIntellect() - (self:GetCaster():GetIntellect() * 2 * mp_loss)
			end	
				return self:GetCaster():GetIntellect()
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
local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_enchantress_str11")             
	if abil ~= nil then 
	
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_resist", -- modifier name
		{ duration = duration } -- kv
	)	
	end
end
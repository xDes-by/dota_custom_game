axe_enrage_lua = class({})
LinkLuaModifier( "modifier_axe_enrage_lua", "heroes/hero_axe/axe_enrage_lua/modifier_axe_enrage_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_enrage_cleave_lua", "heroes/hero_axe/axe_enrage_lua/modifier_axe_enrage_cleave_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_enrage_other_lua", "heroes/hero_axe/axe_enrage_lua/modifier_axe_enrage_other_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_enrage_all_damage_lua_from_int_last", "heroes/hero_axe/axe_enrage_lua/modifier_axe_enrage_all_damage_lua_from_int_last", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_axe_enrage_str_last", "heroes/hero_axe/axe_enrage_lua/modifier_axe_enrage_str_last", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
function axe_enrage_lua:GetManaCost(iLevel)
    return 150 + math.min(65000, self:GetCaster():GetIntellect() / 30)
end

function axe_enrage_lua:GetCooldown(level)
	local abil = self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_axe_str50") 
	if abil ~= nil then
		return self.BaseClass.GetCooldown(self, level) / 2
	end
	return self.BaseClass.GetCooldown(self, level)
end

function axe_enrage_lua:OnSpellStart()

	local bonus_duration = self:GetSpecialValueFor("duration")
	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_axe_int7") ~= nil then 
		bonus_duration = 12
	end

	self:GetCaster():Purge(false, true, false, true, false)

	-- Add buff modifier
	self:GetCaster():AddNewModifier(
		self:GetCaster(),
		self,
		"modifier_axe_enrage_lua",
		{ duration = bonus_duration }
	)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_axe_agi9")			-------- получает клив
		if abil ~= nil then 
			self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_axe_enrage_cleave_lua",
			{ duration = bonus_duration }
	)
		end
		
	-- local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_axe_int11")			--ВСЕ АТРИБУТЫ
	-- 	if abil ~= nil then 
	-- 		self:GetCaster():AddNewModifier(
	-- 		self:GetCaster(),
	-- 		self,
	-- 		"modifier_axe_enrage_other_lua",
	-- 		{ duration = bonus_duration }
	-- )
	-- end	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_axe_int_last")			--- усиливает весь исходящий
		if abil ~= nil then 
			self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_axe_enrage_all_damage_lua_from_int_last",
			{ duration = bonus_duration }
	)
	end	
	if self:GetCaster():FindAbilityByName("npc_dota_hero_axe_int10") ~= nil then  --immun
			self:GetCaster():AddNewModifier(
			self:GetCaster(),
			self,
			"modifier_magic_immune",
			{ duration = bonus_duration }
	)
	end	

	self:PlayEffects()
end

function axe_enrage_lua:PlayEffects()
	local sound_cast = "Hero_Ursa.Enrage"

	EmitSoundOn( sound_cast, self:GetCaster() )
end
arc_flux_lua = class({})
LinkLuaModifier( "modifier_arc_flux_lua", "heroes/hero_arc/arc_flux//modifier_arc_flux_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_flux_lua_debuff", "heroes/hero_arc/arc_flux//modifier_arc_flux_lua_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_flux_lua_hp", "heroes/hero_arc/arc_flux//modifier_arc_flux_lua_hp", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_arc_flux_lua_hp_buff", "heroes/hero_arc/arc_flux//modifier_arc_flux_lua_hp_buff", LUA_MODIFIER_MOTION_NONE )


function arc_flux_lua:GetManaCost(iLevel)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int8")
		if abil ~= nil then
		return math.min(65000, self:GetCaster():GetIntellect()/2)
		else
        return math.min(65000, self:GetCaster():GetIntellect())
	end
end

function arc_flux_lua:OnSpellStart()

	local caster = self:GetCaster()

	local duration = self:GetSpecialValueFor( "duration" )

	-- create aura
	local modifier = caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_arc_flux_lua", -- modifier name
		{ duration = duration } -- kv
	)
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_int11")
	if abil ~= nil then
		local ability = caster:FindAbilityByName( "ark_spark_lua")
		if ability~=nil and ability:GetLevel()>=1 then
			ability:OnSpellStart()
		end
	end
	
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_arc_warden_str11")
	if abil ~= nil then	
		local modifier = caster:AddNewModifier(
			caster, -- player source
			self, -- ability source
			"modifier_arc_flux_lua_hp", -- modifier name
			{duration = duration} -- kv
		)
	end
end


dragon_fire_ball_lua = class({})
LinkLuaModifier( "modifier_dragon_fire_ball_lua_thinker", "heroes/hero_dragon/dragon_fire_ball/modifier_dragon_fire_ball_lua_thinker", LUA_MODIFIER_MOTION_NONE )

function dragon_fire_ball_lua:GetManaCost(iLevel)
    return 100 + math.min(65000, self:GetCaster():GetIntellect() / 100)
end

function dragon_fire_ball_lua:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end

function dragon_fire_ball_lua:OnSpellStart()

	local caster = self:GetCaster()
	local point = self:GetCursorPosition()
	
	

	duration = self:GetSpecialValueFor("duration")
	
	local abil = self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int11")	
	if abil ~= nil then 
	duration = duration + 4
	end
	if self:GetCaster():FindAbilityByName("npc_dota_hero_dragon_knight_int_last") ~= nil then
		duration = duration + 7
	end
	CreateModifierThinker(
		caster, -- player source
		self, -- ability source
		"modifier_dragon_fire_ball_lua_thinker", -- modifier name
		{ duration = duration }, -- kv
		point,
		caster:GetTeamNumber(),
		false
	)
end
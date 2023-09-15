slark_shadow_dance_lua = class({})
LinkLuaModifier( "modifier_slark_shadow_dance_lua", "heroes/hero_slark/slark_shadow_dance_lua/modifier_slark_shadow_dance_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_shadow_dance_lua_passive", "heroes/hero_slark/slark_shadow_dance_lua/modifier_slark_shadow_dance_lua_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function slark_shadow_dance_lua:GetIntrinsicModifierName()
	return "modifier_slark_shadow_dance_lua_passive"
end

function slark_shadow_dance_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int6") ~= nil	then 
		return 50 + math.min(65000, self:GetCaster():GetIntellect()/ 60)
	end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/30)
end


function slark_shadow_dance_lua:OnSpellStart()
	-- unit identifier
	local caster = self:GetCaster()

	-- load data
	local bDuration = self:GetSpecialValueFor("duration")

	-- Add modifier
	caster:AddNewModifier(
		caster, -- player source
		self, -- ability source
		"modifier_slark_shadow_dance_lua", -- modifier name
		{ duration = bDuration } -- kv
	)
end
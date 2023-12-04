slark_shadow_dance_lua = class({})
LinkLuaModifier( "modifier_slark_shadow_dance_lua", "heroes/hero_slark/slark_shadow_dance_lua/modifier_slark_shadow_dance_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_slark_shadow_dance_lua_passive", "heroes/hero_slark/slark_shadow_dance_lua/modifier_slark_shadow_dance_lua_passive", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function slark_shadow_dance_lua:GetIntrinsicModifierName()
	return "modifier_slark_shadow_dance_lua_passive"
end

function slark_shadow_dance_lua:GetBehavior()
	-- if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_slark_str50") then
	-- 	return DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_POINT
	-- else
	-- 	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
	-- end
	return DOTA_ABILITY_BEHAVIOR_NO_TARGET
end

function slark_shadow_dance_lua:GetManaCost(iLevel)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_slark_int6") ~= nil	then 
		return 50 + math.min(65000, self:GetCaster():GetIntellect()/ 60)
	end
	return 100 + math.min(65000, self:GetCaster():GetIntellect()/30)
end


function slark_shadow_dance_lua:OnSpellStart()
	local duration = self:GetSpecialValueFor("duration")
	local target = self:GetCursorTarget()
	if self:GetCaster():FindAbilityByName("special_bonus_unique_npc_dota_hero_slark_str50") then
		duration = duration + 10
	end
	if target then
		target:AddNewModifier(self:GetCaster(),self,"modifier_slark_shadow_dance_lua",{ duration = duration })
		target:AddNewModifier(self:GetCaster(),self,"modifier_slark_shadow_dance_lua_passive",{ duration = duration })
	end
	self:GetCaster():AddNewModifier(self:GetCaster(),self,"modifier_slark_shadow_dance_lua",{ duration = duration })
end
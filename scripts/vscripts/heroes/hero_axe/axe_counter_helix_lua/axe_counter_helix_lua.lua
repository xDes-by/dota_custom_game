axe_counter_helix_lua = class({})
LinkLuaModifier( "modifier_axe_counter_helix_lua", "heroes/hero_axe/axe_counter_helix_lua/modifier_axe_counter_helix_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifire_dota_hero_axe_str8", "heroes/hero_axe/axe_counter_helix_lua/modifire_dota_hero_axe_str8", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
-- Passive Modifier
function axe_counter_helix_lua:GetIntrinsicModifierName()
	return "modifier_axe_counter_helix_lua"
end

function axe_counter_helix_lua:GetCooldown(level)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_axe_agi7") ~= nil then
		return self.BaseClass.GetCooldown(self, level) - 0.1
	end
	return self.BaseClass.GetCooldown(self, level)
end

function axe_counter_helix_lua:GetCastRange(vLocation, hTarget)
	if self:GetCaster():FindAbilityByName("npc_dota_hero_axe_agi8") then
		return self.BaseClass.GetCastRange(self, vLocation, hTarget) + 100
	end
	return self.BaseClass.GetCastRange(self, vLocation, hTarget)
end
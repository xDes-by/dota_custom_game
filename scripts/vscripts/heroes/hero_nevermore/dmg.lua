LinkLuaModifier("modifier_npc_dota_hero_nevermore_agi_last", "heroes/hero_nevermore/dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_nevermore_agi_last = class({})

function npc_dota_hero_nevermore_agi_last:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_nevermore_agi_last"
end

if modifier_npc_dota_hero_nevermore_agi_last == nil then 
    modifier_npc_dota_hero_nevermore_agi_last = class({})
end

function modifier_npc_dota_hero_nevermore_agi_last:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
	}
end

function modifier_npc_dota_hero_nevermore_agi_last:GetModifierPreAttack_CriticalStrike(keys)
	local modifier = self:GetParent():FindModifierByNameAndCaster( "modifier_shadow_fiend_necromastery_lua", self:GetParent())
	if modifier and self:GetAbility() and (keys.target and not keys.target:IsOther() and not keys.target:IsBuilding() and keys.target:GetTeamNumber() ~= self:GetParent():GetTeamNumber()) and RandomInt(1,100) <= 15 then
		return 100 + modifier:GetStackCount()
	end
end

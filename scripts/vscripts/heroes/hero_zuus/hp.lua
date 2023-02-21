LinkLuaModifier("modifier_npc_dota_hero_zuus_str8", "heroes/hero_zuus/hp", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_zuus_str8 = class({})

function npc_dota_hero_zuus_str8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_zuus_str8"
end

if modifier_npc_dota_hero_zuus_str8 == nil then 
    modifier_npc_dota_hero_zuus_str8 = class({})
end

function modifier_npc_dota_hero_zuus_str8:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_npc_dota_hero_zuus_str8:GetModifierExtraHealthBonus(params)
    return 150 * self:GetCaster():GetLevel()
end

function modifier_npc_dota_hero_zuus_str8:IsHidden()
	return true
end

function modifier_npc_dota_hero_zuus_str8:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_zuus_str8:RemoveOnDeath()
    return false
end
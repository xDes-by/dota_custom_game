npc_dota_hero_crystal_maiden_str7 = class({})

LinkLuaModifier("modifier_npc_dota_hero_crystal_maiden_str7", "heroes/hero_crystal/hp", LUA_MODIFIER_MOTION_NONE)

function npc_dota_hero_crystal_maiden_str7:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_crystal_maiden_str7"
end

if modifier_npc_dota_hero_crystal_maiden_str7 == nil then 
    modifier_npc_dota_hero_crystal_maiden_str7 = class({})
end

function modifier_npc_dota_hero_crystal_maiden_str7:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_npc_dota_hero_crystal_maiden_str7:GetModifierExtraHealthBonus(params)
    return self:GetCaster():GetLevel() * 150
end

function modifier_npc_dota_hero_crystal_maiden_str7:IsHidden()
	return false
end

function modifier_npc_dota_hero_crystal_maiden_str7:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_crystal_maiden_str7:RemoveOnDeath()
    return false
end
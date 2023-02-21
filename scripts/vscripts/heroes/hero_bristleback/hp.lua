LinkLuaModifier("modifier_npc_dota_hero_bristleback_str8", "heroes/hero_bristleback/hp", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_bristleback_str8 = class({})

function npc_dota_hero_bristleback_str8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_bristleback_str8"
end

modifier_npc_dota_hero_bristleback_str8 = class({})

function modifier_npc_dota_hero_bristleback_str8:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_npc_dota_hero_bristleback_str8:GetModifierExtraHealthBonus(params)
    return self:GetCaster():GetLevel() * 150
end

function modifier_npc_dota_hero_bristleback_str8:IsHidden()
	return false
end

function modifier_npc_dota_hero_bristleback_str8:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_bristleback_str8:RemoveOnDeath()
    return false
end

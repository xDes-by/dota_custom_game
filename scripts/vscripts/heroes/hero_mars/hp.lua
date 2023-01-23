LinkLuaModifier("modifier_npc_dota_hero_mars_str6", "heroes/hero_mars/hp", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_mars_str6 = class({})

function npc_dota_hero_mars_str6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_mars_str6"
end

if modifier_npc_dota_hero_mars_str6 == nil then 
    modifier_npc_dota_hero_mars_str6 = class({})
end

function modifier_npc_dota_hero_mars_str6:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_npc_dota_hero_mars_str6:GetModifierExtraHealthBonus(params)
    return 150 * self:GetCaster():GetLevel()
end

function modifier_npc_dota_hero_mars_str6:IsHidden()
	return true
end

function modifier_npc_dota_hero_mars_str6:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_mars_str6:RemoveOnDeath()
    return false
end
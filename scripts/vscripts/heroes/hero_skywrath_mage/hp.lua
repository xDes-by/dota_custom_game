LinkLuaModifier("modifier_npc_dota_hero_skywrath_mage_str7", "heroes/hero_skywrath_mage/hp", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_skywrath_mage_str7 = class({})

function npc_dota_hero_skywrath_mage_str7:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_skywrath_mage_str7"
end

if modifier_npc_dota_hero_skywrath_mage_str7 == nil then 
    modifier_npc_dota_hero_skywrath_mage_str7 = class({})
end

function modifier_npc_dota_hero_skywrath_mage_str7:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
    }
end

function modifier_npc_dota_hero_skywrath_mage_str7:GetModifierExtraHealthBonus(params)
    return 150 * self:GetCaster():GetLevel()
end

function modifier_npc_dota_hero_skywrath_mage_str7:IsHidden()
	return true
end

function modifier_npc_dota_hero_skywrath_mage_str7:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_skywrath_mage_str7:RemoveOnDeath()
    return false
end
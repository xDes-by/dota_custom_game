LinkLuaModifier("modifier_npc_dota_hero_alchemist_agi_last", "heroes/hero_alchemist/gold_damage", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_alchemist_agi_last = class({})

function npc_dota_hero_alchemist_agi_last:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_alchemist_agi_last"
end

if modifier_npc_dota_hero_alchemist_agi_last == nil then 
    modifier_npc_dota_hero_alchemist_agi_last = class({})
end

function modifier_npc_dota_hero_alchemist_agi_last:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_npc_dota_hero_alchemist_agi_last:GetModifierBaseAttack_BonusDamage(params)
    return self:GetCaster():GetGold()/10
end

function modifier_npc_dota_hero_alchemist_agi_last:IsHidden()
	return true
end

function modifier_npc_dota_hero_alchemist_agi_last:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_alchemist_agi_last:RemoveOnDeath()
    return false
end
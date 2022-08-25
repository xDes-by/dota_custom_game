LinkLuaModifier("modifier_npc_dota_hero_tinker_agi10", "heroes/hero_builder/bonus_dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_tinker_agi10 = class({})

function npc_dota_hero_tinker_agi10:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_tinker_agi10"
end

if modifier_npc_dota_hero_tinker_agi10 == nil then 
    modifier_npc_dota_hero_tinker_agi10 = class({})
end

function modifier_npc_dota_hero_tinker_agi10:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_npc_dota_hero_tinker_agi10:GetModifierBaseAttack_BonusDamage(params)
    return self:GetCaster():GetAgility()
end

function modifier_npc_dota_hero_tinker_agi10:IsHidden()
	return false
end

function modifier_npc_dota_hero_tinker_agi10:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_tinker_agi10:RemoveOnDeath()
    return false
end
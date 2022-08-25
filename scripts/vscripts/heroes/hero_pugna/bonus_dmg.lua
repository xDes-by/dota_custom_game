LinkLuaModifier("modifier_npc_dota_hero_pugna_agi9", "heroes/hero_pugna/bonus_dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_pugna_agi9 = class({})

function npc_dota_hero_pugna_agi9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_pugna_agi9"
end

if modifier_npc_dota_hero_pugna_agi9 == nil then 
    modifier_npc_dota_hero_pugna_agi9 = class({})
end

function modifier_npc_dota_hero_pugna_agi9:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_npc_dota_hero_pugna_agi9:GetModifierBaseAttack_BonusDamage(params)
    return self:GetCaster():GetAgility()
end

function modifier_npc_dota_hero_pugna_agi9:IsHidden()
	return false
end

function modifier_npc_dota_hero_pugna_agi9:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_pugna_agi9:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_pugna_agi9:OnCreated(kv)
end
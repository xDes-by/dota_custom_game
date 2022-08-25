LinkLuaModifier("modifier_npc_dota_hero_skywrath_mage_agi11", "heroes/hero_skywrath_mage/bonus_dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_skywrath_mage_agi11 = class({})

function npc_dota_hero_skywrath_mage_agi11:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_skywrath_mage_agi11"
end

if modifier_npc_dota_hero_skywrath_mage_agi11 == nil then 
    modifier_npc_dota_hero_skywrath_mage_agi11 = class({})
end

function modifier_npc_dota_hero_skywrath_mage_agi11:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_npc_dota_hero_skywrath_mage_agi11:GetModifierBaseAttack_BonusDamage(params)
    return self:GetCaster():GetAgility()
end

function modifier_npc_dota_hero_skywrath_mage_agi11:IsHidden()
	return false
end

function modifier_npc_dota_hero_skywrath_mage_agi11:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_skywrath_mage_agi11:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_skywrath_mage_agi11:OnCreated(kv)
end
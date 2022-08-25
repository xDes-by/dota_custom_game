LinkLuaModifier("modifier_npc_dota_hero_skywrath_mage_agi7", "heroes/hero_skywrath_mage/dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_skywrath_mage_agi7 = class({})

function npc_dota_hero_skywrath_mage_agi7:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_skywrath_mage_agi7"
end

if modifier_npc_dota_hero_skywrath_mage_agi7 == nil then 
    modifier_npc_dota_hero_skywrath_mage_agi7 = class({})
end

function modifier_npc_dota_hero_skywrath_mage_agi7:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_npc_dota_hero_skywrath_mage_agi7:GetModifierPreAttack_BonusDamage(params)
    return 5 * self:GetCaster():GetLevel()
end

function modifier_npc_dota_hero_skywrath_mage_agi7:IsHidden()
	return true
end

function modifier_npc_dota_hero_skywrath_mage_agi7:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_skywrath_mage_agi7:RemoveOnDeath()
    return false
end
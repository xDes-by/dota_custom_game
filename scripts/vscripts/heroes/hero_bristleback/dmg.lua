LinkLuaModifier("modifier_npc_dota_hero_pudge_agi7", "heroes/hero_bristleback/dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_pudge_agi7 = class({})

function npc_dota_hero_pudge_agi7:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_pudge_agi7"
end

modifier_npc_dota_hero_pudge_agi7 = class({})

function modifier_npc_dota_hero_pudge_agi7:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_npc_dota_hero_pudge_agi7:GetModifierPreAttack_BonusDamage(params)
    return 5 * self:GetCaster():GetLevel()
end

function modifier_npc_dota_hero_pudge_agi7:IsHidden()
	return true
end

function modifier_npc_dota_hero_pudge_agi7:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_pudge_agi7:RemoveOnDeath()
    return false
end
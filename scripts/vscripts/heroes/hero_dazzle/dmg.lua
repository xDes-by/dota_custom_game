LinkLuaModifier("modifier_npc_dota_hero_dazzle_agi6", "heroes/hero_dazzle/dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_dazzle_agi6 = class({})

function npc_dota_hero_dazzle_agi6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_dazzle_agi6"
end

if modifier_npc_dota_hero_dazzle_agi6 == nil then 
    modifier_npc_dota_hero_dazzle_agi6 = class({})
end

function modifier_npc_dota_hero_dazzle_agi6:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_npc_dota_hero_dazzle_agi6:GetModifierPreAttack_BonusDamage(params)
    return 5 * self:GetCaster():GetLevel()
end

function modifier_npc_dota_hero_dazzle_agi6:IsHidden()
	return true
end

function modifier_npc_dota_hero_dazzle_agi6:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_dazzle_agi6:RemoveOnDeath()
    return false
end
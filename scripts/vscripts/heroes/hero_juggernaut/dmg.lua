LinkLuaModifier("modifier_npc_dota_hero_juggernaut_agi8", "heroes/hero_juggernaut/dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_juggernaut_agi8 = class({})

function npc_dota_hero_juggernaut_agi8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_juggernaut_agi8"
end

if modifier_npc_dota_hero_juggernaut_agi8 == nil then 
    modifier_npc_dota_hero_juggernaut_agi8 = class({})
end

function modifier_npc_dota_hero_juggernaut_agi8:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
    }
end

function modifier_npc_dota_hero_juggernaut_agi8:GetModifierPreAttack_BonusDamage(params)
    return 5 * self:GetCaster():GetLevel()
end

function modifier_npc_dota_hero_juggernaut_agi8:IsHidden()
	return true
end

function modifier_npc_dota_hero_juggernaut_agi8:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_juggernaut_agi8:RemoveOnDeath()
    return false
end
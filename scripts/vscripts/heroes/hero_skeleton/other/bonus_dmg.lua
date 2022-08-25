LinkLuaModifier("modifier_npc_dota_hero_skeleton_king_agi6", "heroes/hero_skeleton/other/bonus_dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_skeleton_king_agi6 = class({})

function npc_dota_hero_skeleton_king_agi6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_skeleton_king_agi6"
end

if modifier_npc_dota_hero_skeleton_king_agi6 == nil then 
    modifier_npc_dota_hero_skeleton_king_agi6 = class({})
end

function modifier_npc_dota_hero_skeleton_king_agi6:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_npc_dota_hero_skeleton_king_agi6:GetModifierBaseAttack_BonusDamage(params)
    return self:GetCaster():GetAgility()
end

function modifier_npc_dota_hero_skeleton_king_agi6:IsHidden()
	return false
end

function modifier_npc_dota_hero_skeleton_king_agi6:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_skeleton_king_agi6:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_skeleton_king_agi6:OnCreated(kv)
end
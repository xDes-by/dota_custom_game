LinkLuaModifier("modifier_npc_dota_hero_sand_king_agi7", "heroes/hero_sand/other/bonus_dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_sand_king_agi7 = class({})

function npc_dota_hero_sand_king_agi7:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_sand_king_agi7"
end

if modifier_npc_dota_hero_sand_king_agi7 == nil then 
    modifier_npc_dota_hero_sand_king_agi7 = class({})
end

function modifier_npc_dota_hero_sand_king_agi7:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_npc_dota_hero_sand_king_agi7:GetModifierBaseAttack_BonusDamage(params)
    return self:GetCaster():GetAgility()
end

function modifier_npc_dota_hero_sand_king_agi7:IsHidden()
	return false
end

function modifier_npc_dota_hero_sand_king_agi7:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_sand_king_agi7:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_sand_king_agi7:OnCreated(kv)
end
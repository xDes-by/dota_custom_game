LinkLuaModifier("modifier_npc_dota_hero_axe_agi8", "heroes/hero_axe/bonus_dmg", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_axe_agi8 = class({})

function npc_dota_hero_axe_agi8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_axe_agi8"
end

if modifier_npc_dota_hero_axe_agi8 == nil then 
    modifier_npc_dota_hero_axe_agi8 = class({})
end

function modifier_npc_dota_hero_axe_agi8:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_npc_dota_hero_axe_agi8:GetModifierBaseAttack_BonusDamage(params)
    return self:GetCaster():GetAgility()
end

function modifier_npc_dota_hero_axe_agi8:IsHidden()
	return false
end

function modifier_npc_dota_hero_axe_agi8:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_axe_agi8:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_axe_agi8:OnCreated(kv)
end
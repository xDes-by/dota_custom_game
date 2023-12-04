LinkLuaModifier("modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50", "heroes/hero_alchemist/gold_damage_bank", LUA_MODIFIER_MOTION_NONE)

special_bonus_unique_npc_dota_hero_alchemist_agi50 = class({})

function special_bonus_unique_npc_dota_hero_alchemist_agi50:GetIntrinsicModifierName()
	return "modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50"
end

if modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50 == nil then 
    modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50 = class({})
end

function modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50:IsHidden()
    return true
end

function modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50:IsPurgable()
    return false
end

function modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50:RemoveOnDeath()
    return false
end

function modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50:OnCreated( kv )
    self.mod = self:GetCaster():FindModifierByName("modifier_gold_bank")
end

function modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
    }
end

function modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50:GetModifierBaseAttack_BonusDamage(params)
    return self.mod:GetStackCount() * 0.005
end

function modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50:IsHidden()
	return true
end

function modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50:IsPurgable()
    return false
end
 
function modifier_special_bonus_unique_npc_dota_hero_alchemist_agi50:RemoveOnDeath()
    return false
end
LinkLuaModifier("modifier_npc_dota_hero_spectre_str8", "heroes/hero_spectre/block", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_spectre_str8 = class({})

function npc_dota_hero_spectre_str8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_spectre_str8"
end

if modifier_npc_dota_hero_spectre_str8 == nil then 
    modifier_npc_dota_hero_spectre_str8 = class({})
end

function modifier_npc_dota_hero_spectre_str8:DeclareFunctions()
	return {
        MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
    }
end

function modifier_npc_dota_hero_spectre_str8:GetModifierTotal_ConstantBlock(params)
    return self:GetCaster():GetLevel()*5
end

function modifier_npc_dota_hero_spectre_str8:IsHidden()
	return false
end

function modifier_npc_dota_hero_spectre_str8:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_spectre_str8:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_spectre_str8:OnCreated(kv)
end
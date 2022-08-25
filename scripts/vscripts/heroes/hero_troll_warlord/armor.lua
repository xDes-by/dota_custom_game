LinkLuaModifier("modifier_npc_dota_hero_troll_warlord_str9", "heroes/hero_troll_warlord/armor", LUA_MODIFIER_MOTION_NONE)

npc_dota_hero_troll_warlord_str9 = class({})

function npc_dota_hero_troll_warlord_str9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_troll_warlord_str9"
end

if modifier_npc_dota_hero_troll_warlord_str9 == nil then 
    modifier_npc_dota_hero_troll_warlord_str9 = class({})
end

function modifier_npc_dota_hero_troll_warlord_str9:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_npc_dota_hero_troll_warlord_str9:GetModifierPhysicalArmorBonus(params)
    return self:GetParent():GetLevel()
end

function modifier_npc_dota_hero_troll_warlord_str9:IsHidden()
	return false
end

function modifier_npc_dota_hero_troll_warlord_str9:IsPurgable()
    return false
end
 
function modifier_npc_dota_hero_troll_warlord_str9:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_troll_warlord_str9:OnCreated(kv)
end
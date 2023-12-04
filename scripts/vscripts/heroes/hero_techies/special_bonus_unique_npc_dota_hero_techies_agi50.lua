LinkLuaModifier("special_bonus_unique_npc_dota_hero_techies_agi50_intrinsic", "heroes/hero_techies/special_bonus_unique_npc_dota_hero_techies_agi50.lua", LUA_MODIFIER_MOTION_NONE)
special_bonus_unique_npc_dota_hero_techies_agi50 = class({})

function special_bonus_unique_npc_dota_hero_techies_agi50:GetIntrinsicModifierName()
	return "special_bonus_unique_npc_dota_hero_techies_agi50_intrinsic"
end

special_bonus_unique_npc_dota_hero_techies_agi50_intrinsic = class({})

function special_bonus_unique_npc_dota_hero_techies_agi50_intrinsic:IsHidden()
	return true
end

function special_bonus_unique_npc_dota_hero_techies_agi50_intrinsic:IsPurgable()
	return false
end

function special_bonus_unique_npc_dota_hero_techies_agi50_intrinsic:RemoveOnDeath()
	return false
end

function special_bonus_unique_npc_dota_hero_techies_agi50_intrinsic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}

	return funcs
end

function special_bonus_unique_npc_dota_hero_techies_agi50_intrinsic:GetModifierPreAttack_BonusDamage()
    local level = self:GetCaster():GetLevel()
    local start_damage = 50
    return start_damage * level + (level * (level - 1)) / 2
end
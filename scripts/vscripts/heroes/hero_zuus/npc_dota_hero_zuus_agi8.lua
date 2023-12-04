LinkLuaModifier( "modifier_npc_dota_hero_zuus_agi8_intrinsic", "heroes/hero_zuus/npc_dota_hero_zuus_agi8.lua", LUA_MODIFIER_MOTION_NONE )

npc_dota_hero_zuus_agi8 = class({})

function npc_dota_hero_zuus_agi8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_zuus_agi8_intrinsic"
end

modifier_npc_dota_hero_zuus_agi8_intrinsic = class({})

function modifier_npc_dota_hero_zuus_agi8_intrinsic:IsHidden()
    return true
end

function modifier_npc_dota_hero_zuus_agi8_intrinsic:IsPurchasable()
    return false
end

function modifier_npc_dota_hero_zuus_agi8_intrinsic:RemoveOnDeath()
    return false
end

function modifier_npc_dota_hero_zuus_agi8_intrinsic:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_CAST_RANGE_BONUS,
	}
	return funcs
end

function modifier_npc_dota_hero_zuus_agi8_intrinsic:GetModifierCastRangeBonus()
    return 300
end
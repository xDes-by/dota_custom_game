npc_dota_hero_crystal_maiden_agi11 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_crystal_maiden_agi11", "heroes/hero_crystal/bonus_range", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_crystal_maiden_agi11:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_crystal_maiden_agi11"
end

modifier_npc_dota_hero_crystal_maiden_agi11 = class({})

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_crystal_maiden_agi11:IsHidden()
	return true
end

function modifier_npc_dota_hero_crystal_maiden_agi11:IsPurgable()
	return false
end

function modifier_npc_dota_hero_crystal_maiden_agi11:OnCreated( kv )
end

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_crystal_maiden_agi11:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end


function modifier_npc_dota_hero_crystal_maiden_agi11:GetModifierAttackRangeBonus()
	return 200
end
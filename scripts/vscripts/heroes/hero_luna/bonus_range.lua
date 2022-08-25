npc_dota_hero_luna_agi7 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_luna_agi7", "heroes/hero_luna/bonus_range", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_luna_agi7:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_luna_agi7"
end

modifier_npc_dota_hero_luna_agi7 = class({})

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_luna_agi7:IsHidden()
	return true
end

function modifier_npc_dota_hero_luna_agi7:IsPurgable()
	return false
end

function modifier_npc_dota_hero_luna_agi7:OnCreated( kv )
end

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_luna_agi7:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end


function modifier_npc_dota_hero_luna_agi7:GetModifierAttackRangeBonus()
	return 350
end

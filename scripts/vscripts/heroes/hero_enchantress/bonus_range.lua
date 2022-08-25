npc_dota_hero_enchantress_agi8 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_enchantress_agi8", "heroes/hero_enchantress/bonus_range", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_enchantress_agi8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_enchantress_agi8"
end

modifier_npc_dota_hero_enchantress_agi8 = class({})

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_enchantress_agi8:IsHidden()
	return true
end

function modifier_npc_dota_hero_enchantress_agi8:IsPurgable()
	return false
end

function modifier_npc_dota_hero_enchantress_agi8:OnCreated( kv )
end

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_enchantress_agi8:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end


function modifier_npc_dota_hero_enchantress_agi8:GetModifierAttackRangeBonus()
	return 350
end

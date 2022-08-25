npc_dota_hero_arc_warden_agi6 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_arc_warden_agi6", "heroes/hero_arc/bonus_range", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_arc_warden_agi6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_arc_warden_agi6"
end

modifier_npc_dota_hero_arc_warden_agi6 = class({})

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_arc_warden_agi6:IsHidden()
	return true
end

function modifier_npc_dota_hero_arc_warden_agi6:IsPurgable()
	return false
end

function modifier_npc_dota_hero_arc_warden_agi6:OnCreated( kv )
end

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_arc_warden_agi6:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
	}
	return funcs
end


function modifier_npc_dota_hero_arc_warden_agi6:GetModifierAttackRangeBonus()
	return 350
end

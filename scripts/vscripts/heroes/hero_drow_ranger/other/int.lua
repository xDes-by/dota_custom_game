npc_dota_hero_drow_ranger_int6 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_drow_ranger_int6", "heroes/hero_drow_ranger/other/int", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_drow_ranger_int6:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_drow_ranger_int6"
end

modifier_npc_dota_hero_drow_ranger_int6 = class({})

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_drow_ranger_int6:IsHidden()
	return true
end

function modifier_npc_dota_hero_drow_ranger_int6:IsPurgable()
	return false
end

function modifier_npc_dota_hero_drow_ranger_int6:OnCreated( kv )
end

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_drow_ranger_int6:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end


function modifier_npc_dota_hero_drow_ranger_int6:GetModifierPreAttack_BonusDamage()
	return self:GetCaster():GetIntellect()
end
npc_dota_hero_axe_int8 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_axe_int8", "heroes/hero_axe/cooldown", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_axe_int8:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_axe_int8"
end

modifier_npc_dota_hero_axe_int8 = class({})

function modifier_npc_dota_hero_axe_int8:IsHidden()
	return true
end

function modifier_npc_dota_hero_axe_int8:IsPurgable()
	return false
end

function modifier_npc_dota_hero_axe_int8:OnCreated( kv )
end

function modifier_npc_dota_hero_axe_int8:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

function modifier_npc_dota_hero_axe_int8:GetModifierPercentageCooldown()
	return 25
end

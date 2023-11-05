npc_dota_hero_jakiro_int13 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_jakiro_int13", "heroes/hero_jakiro/CooldownReduction", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function npc_dota_hero_jakiro_int13:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_jakiro_int13"
end

--------------------------------------------------------------------------------

modifier_npc_dota_hero_jakiro_int13 = class({})

function modifier_npc_dota_hero_jakiro_int13:IsHidden()
end

function modifier_npc_dota_hero_jakiro_int13:IsDebuff( kv )
	return false
end

function modifier_npc_dota_hero_jakiro_int13:IsPurgable( kv )
	return false
end


function modifier_npc_dota_hero_jakiro_int13:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_jakiro_int13:GetModifierPercentageCooldown(keys)
	return 50
end
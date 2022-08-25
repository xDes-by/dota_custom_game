drow_ranger_aura = class({})
LinkLuaModifier( "modifier_drow_ranger_aura", "heroes/hero_drow_ranger/drow_ranger_aura/modifier_drow_ranger_aura", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_drow_ranger_aura_effect", "heroes/hero_drow_ranger/drow_ranger_aura/modifier_drow_ranger_aura_effect", LUA_MODIFIER_MOTION_NONE )

function drow_ranger_aura:GetIntrinsicModifierName()
	return "modifier_drow_ranger_aura"
end
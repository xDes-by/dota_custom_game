-------------------------------------------
--		  HEARTSTOPPER AURA
-------------------------------------------

LinkLuaModifier("modifier_necrolyte_heartstopper_aura_intrinsic", "heroes/hero_necrolyte/necrolyte_heartstopper_aura/modifier_necrolyte_heartstopper_aura_intrinsic", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_necrolyte_heartstopper_aura_damage", "heroes/hero_necrolyte/necrolyte_heartstopper_aura/modifier_necrolyte_heartstopper_aura_damage", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_necrolyte_heartstopper_aura_buff", "heroes/hero_necrolyte/necrolyte_heartstopper_aura/modifier_necrolyte_heartstopper_aura_buff", LUA_MODIFIER_MOTION_NONE)

necrolyte_heartstopper_aura_lua = class({})
function necrolyte_heartstopper_aura_lua:GetIntrinsicModifierName()
	return "modifier_necrolyte_heartstopper_aura_intrinsic"
end

function necrolyte_heartstopper_aura_lua:GetAbilityTextureName()
	return "necrolyte_heartstopper_aura"
end

function necrolyte_heartstopper_aura_lua:GetCastRange( location , target)
	return self:GetSpecialValueFor("radius")
end
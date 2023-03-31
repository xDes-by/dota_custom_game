-- Created by Elfansoer
--[[
Ability checklist (erase if done/checked):
- Scepter Upgrade
- Break behavior
- Linken/Reflect behavior
- Spell Immune/Invulnerable/Invisible behavior
- Illusion behavior
- Stolen behavior
]]
--------------------------------------------------------------------------------
modifier_magnataur_skewer_lua_slow = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_magnataur_skewer_lua_slow:IsHidden()
	return false
end

function modifier_magnataur_skewer_lua_slow:IsDebuff()
	return true
end

function modifier_magnataur_skewer_lua_slow:IsStunDebuff()
	return false
end

function modifier_magnataur_skewer_lua_slow:IsPurgable()
	return true
end

function modifier_magnataur_skewer_lua_slow:GetTexture()
    return "magnataur_skewer"
end

--------------------------------------------------------------------------------
-- Initializations
function modifier_magnataur_skewer_lua_slow:OnCreated( kv )
	-- references
	self.as_slow = -self:GetAbility():GetSpecialValueFor( "tool_attack_slow" )
	self.ms_slow = -self:GetAbility():GetSpecialValueFor( "slow_pct" )

	if not IsServer() then return end
end

function modifier_magnataur_skewer_lua_slow:OnRefresh( kv )
	
end

function modifier_magnataur_skewer_lua_slow:OnRemoved()
end

function modifier_magnataur_skewer_lua_slow:OnDestroy()
end

--------------------------------------------------------------------------------
-- Modifier Effects
function modifier_magnataur_skewer_lua_slow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}

	return funcs
end

function modifier_magnataur_skewer_lua_slow:GetModifierAttackSpeedBonus_Constant()
	return self.as_slow
end

function modifier_magnataur_skewer_lua_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.ms_slow
end
function modifier_magnataur_skewer_lua_slow:OnTooltip()
	return self.ms_slow
end
function modifier_magnataur_skewer_lua_slow:OnTooltip2()
	return self.as_slow
end
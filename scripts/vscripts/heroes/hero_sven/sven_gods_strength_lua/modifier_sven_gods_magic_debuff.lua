LinkLuaModifier( "modifier_sven_gods_magic_debuff_child", "heroes/hero_sven/sven_gods_strength_lua/modifier_sven_gods_magic_debuff_child", LUA_MODIFIER_MOTION_NONE )

modifier_sven_gods_magic_debuff = class({})
--------------------------------------------------------------------------------

function modifier_sven_gods_magic_debuff:IsPurgable()
	return false
end


function modifier_sven_gods_magic_debuff:IsAura()
return true
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_debuff:GetModifierAura()
	return "modifier_sven_gods_magic_debuff_child"
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_debuff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_debuff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_debuff:GetAuraRadius()
	return 700
end


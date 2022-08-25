LinkLuaModifier( "modifier_sven_gods_magic_buff_child", "heroes/hero_sven/sven_gods_strength_lua/modifier_sven_gods_magic_buff_child", LUA_MODIFIER_MOTION_NONE )

modifier_sven_gods_magic_buff = class({})
--------------------------------------------------------------------------------

function modifier_sven_gods_magic_buff:IsPurgable()
	return false
end


function modifier_sven_gods_magic_buff:IsAura()
return true
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_buff:GetModifierAura()
	return "modifier_sven_gods_magic_buff_child"
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_buff:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_buff:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_buff:GetAuraRadius()
	return 700
end


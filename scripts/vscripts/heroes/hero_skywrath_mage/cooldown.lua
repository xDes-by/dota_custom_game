npc_dota_hero_skywrath_mage_int10 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_skywrath_mage_int10", "heroes/hero_skywrath_mage/cooldown", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_skywrath_mage_int10:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_skywrath_mage_int10"
end

modifier_npc_dota_hero_skywrath_mage_int10 = class({})

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_skywrath_mage_int10:IsHidden()
	return true
end

function modifier_npc_dota_hero_skywrath_mage_int10:IsPurgable()
	return false
end

function modifier_npc_dota_hero_skywrath_mage_int10:OnCreated( kv )
end

--------------------------------------------------------------------------------
function modifier_npc_dota_hero_skywrath_mage_int10:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end


function modifier_npc_dota_hero_skywrath_mage_int10:GetModifierPercentageCooldown()
	return 50
end

npc_dota_hero_ancient_apparition_str9 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_ancient_apparition_str9", "heroes/hero_ancient_apparition/inc", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_ancient_apparition_str9:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_ancient_apparition_str9"
end

modifier_npc_dota_hero_ancient_apparition_str9 = class({})

function modifier_npc_dota_hero_ancient_apparition_str9:IsHidden()
	return true
end

function modifier_npc_dota_hero_ancient_apparition_str9:IsPurgable()
	return false
end

function modifier_npc_dota_hero_ancient_apparition_str9:OnCreated( kv )
end

function modifier_npc_dota_hero_ancient_apparition_str9:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
	return funcs
end


function modifier_npc_dota_hero_ancient_apparition_str9:GetModifierIncomingDamage_Percentage()
	return -15
end

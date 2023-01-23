npc_dota_hero_ancient_apparition_int7 = class({})
LinkLuaModifier( "modifier_npc_dota_hero_ancient_apparition_int7", "heroes/hero_ancient_apparition/cd", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function npc_dota_hero_ancient_apparition_int7:GetIntrinsicModifierName()
	return "modifier_npc_dota_hero_ancient_apparition_int7"
end

modifier_npc_dota_hero_ancient_apparition_int7 = class({})

function modifier_npc_dota_hero_ancient_apparition_int7:IsHidden()
	return true
end

function modifier_npc_dota_hero_ancient_apparition_int7:IsPurgable()
	return false
end

function modifier_npc_dota_hero_ancient_apparition_int7:OnCreated( kv )
end

function modifier_npc_dota_hero_ancient_apparition_int7:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
	}
	return funcs
end


function modifier_npc_dota_hero_ancient_apparition_int7:GetModifierPercentageCooldown()
	return 50
end

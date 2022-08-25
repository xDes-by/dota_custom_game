hp_regen_ability_raid = class({})
LinkLuaModifier( "modifier_hp_regen_ability_raid", "abilities/hp_regen_ability_raid", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hp_regen_ability_raid:GetIntrinsicModifierName()
	return "modifier_hp_regen_ability_raid"
end

-------------------------------------------------------------------------------

modifier_hp_regen_ability_raid = class({})

--------------------------------------------------------------------------------

function modifier_hp_regen_ability_raid:IsHidden()
	return false
end


function modifier_hp_regen_ability_raid:IsPurgable()
    return false
end

function modifier_hp_regen_ability_raid:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifier_hp_regen_ability_raid:GetModifierHealthRegenPercentage()
	return 0.1
end
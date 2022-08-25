hp_regen_ability = class({})
LinkLuaModifier( "modifier_hp_regen_ability", "abilities/hp_regen_ability", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function hp_regen_ability:GetIntrinsicModifierName()
	return "modifier_hp_regen_ability"
end

-------------------------------------------------------------------------------

modifier_hp_regen_ability = class({})

--------------------------------------------------------------------------------

function modifier_hp_regen_ability:IsHidden()
	return false
end


function modifier_hp_regen_ability:IsPurgable()
    return false
end

function modifier_hp_regen_ability:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end

function modifier_hp_regen_ability:GetModifierHealthRegenPercentage()
	return 0.75
end
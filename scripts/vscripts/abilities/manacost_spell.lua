manacost_spell = class({})
LinkLuaModifier( "modifier_manacost_spell", "abilities/manacost_spell", LUA_MODIFIER_MOTION_NONE )

function manacost_spell:GetIntrinsicModifierName()
	return "modifier_manacost_spell"
end

modifier_manacost_spell = class({})

function modifier_manacost_spell:IsHidden()
	return true
end

function modifier_manacost_spell:IsDebuff()
	return false
end

function modifier_manacost_spell:IsPurgable()
	return false
end

function modifier_manacost_spell:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANACOST_PERCENTAGE,
		
	}
	return funcs
end

function modifier_manacost_spell:GetModifierPercentageManacost()
return 100
end
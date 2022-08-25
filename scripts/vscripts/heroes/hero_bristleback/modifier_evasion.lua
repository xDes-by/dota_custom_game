modifier_evasion = class({})

--------------------------------------------------------------------------------
-- Classifications
function modifier_evasion:IsHidden()
	return false
end

function modifier_evasion:IsDebuff()
	return true
end

function modifier_evasion:IsPurgable()
	return false
end

function modifier_evasion:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MISS_PERCENTAGE,
	}
	return funcs
end

function modifier_evasion:GetModifierMiss_Percentage()
	return 25
end
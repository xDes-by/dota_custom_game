
modifier_only_phys = class({})


function modifier_only_phys:IsHidden()
    return false
end

function modifier_only_phys:IsPurgable()
    return false
end

function modifier_only_phys:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
		MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE
	}
	return funcs
end

function modifier_only_phys:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_only_phys:GetAbsoluteNoDamagePure()
	return 1
end

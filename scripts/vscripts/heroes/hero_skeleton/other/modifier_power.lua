modifier_power = class({})

function modifier_power:IsHidden()
	return false
end

function modifier_power:IsPurgable()
	return false
end

function modifier_power:OnCreated( kv )
end

function modifier_power:DeclareFunctions()
	return {
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PHYSICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_MAGICAL,
	MODIFIER_PROPERTY_ABSOLUTE_NO_DAMAGE_PURE,
	}
end

function modifier_power:GetAbsoluteNoDamagePhysical()
	return 1
end

function modifier_power:GetAbsoluteNoDamageMagical()
	return 1
end

function modifier_power:GetAbsoluteNoDamagePure()
	return 1
end

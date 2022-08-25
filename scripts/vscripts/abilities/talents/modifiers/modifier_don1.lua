modifier_don1 = class({})

function modifier_don1:IsHidden()
	return true
end

function modifier_don1:IsPurgable()
	return false
end

function modifier_don1:RemoveOnDeath()
	return false
end

function modifier_don1:OnCreated( kv )
end

function modifier_don1:OnRefresh( kv )
end


function modifier_don1:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EXP_RATE_BOOST,
	}
	return funcs
end

function modifier_don1:GetModifierPercentageExpRateBoost()
	return 10
end
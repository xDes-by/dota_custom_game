modifier_duel = class({})

function modifier_duel:IsHidden()
    return true
end

function modifier_duel:IsPurgable()
    return false
end

function modifier_duel:OnCreated( kv )
end

function modifier_duel:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_duel:CheckState()
	local state = {
		[MODIFIER_STATE_PROVIDES_VISION] = true,
	}
	return state
end

function modifier_duel:GetModifierDamageOutgoing_Percentage()
	return 50
end

function modifier_duel:GetModifierIncomingDamage_Percentage()
	return 50
end
modifier_magic_debuff = class({})

function modifier_magic_debuff:IsHidden()
	return false
end

function modifier_magic_debuff:OnCreated( kv )
end

function modifier_magic_debuff:OnRefresh( kv )
end

function modifier_magic_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end


function modifier_magic_debuff:GetModifierMagicalResistanceBonus( params )
	return -25
end
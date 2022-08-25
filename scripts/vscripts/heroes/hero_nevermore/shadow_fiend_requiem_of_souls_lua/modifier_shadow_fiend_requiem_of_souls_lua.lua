modifier_shadow_fiend_requiem_of_souls_lua = class({})

--------------------------------------------------------------------------------

function modifier_shadow_fiend_requiem_of_souls_lua:IsDebuff()
	return true
end

function modifier_shadow_fiend_requiem_of_souls_lua:IsPurgable()
	return true
end

--------------------------------------------------------------------------------

function modifier_shadow_fiend_requiem_of_souls_lua:OnCreated( kv )
end

function modifier_shadow_fiend_requiem_of_souls_lua:OnRefresh( kv )
end

--------------------------------------------------------------------------------

function modifier_shadow_fiend_requiem_of_souls_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

function modifier_shadow_fiend_requiem_of_souls_lua:GetModifierMagicalResistanceBonus()
	return -50
end

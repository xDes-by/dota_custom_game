modifier_sven_gods_magic_buff_child = class({})
--------------------------------------------------------------------------------

function modifier_sven_gods_magic_buff_child:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_buff_child:OnCreated( kv )
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_buff_child:OnRefresh( kv )
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_buff_child:DeclareFunctions()
	local funcs = {
		func1 = MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_sven_gods_magic_buff_child:GetModifierMagicalResistanceBonus()
	return 25
end

--------------------------------------------------------------------------------

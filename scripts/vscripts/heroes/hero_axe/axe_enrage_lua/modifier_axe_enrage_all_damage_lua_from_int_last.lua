modifier_axe_enrage_all_damage_lua_from_int_last = class({})

function modifier_axe_enrage_all_damage_lua_from_int_last:IsHidden()
	return false
end

function modifier_axe_enrage_all_damage_lua_from_int_last:IsDebuff()
	return false
end

function modifier_axe_enrage_all_damage_lua_from_int_last:IsPurgable()
	return false
end

function modifier_axe_enrage_all_damage_lua_from_int_last:OnCreated( kv )
	self.caster = self:GetCaster()
end
--------------------------------------------------------------------------------

function modifier_axe_enrage_all_damage_lua_from_int_last:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_axe_enrage_all_damage_lua_from_int_last:GetModifierDamageOutgoing_Percentage( params )
	return 150
end

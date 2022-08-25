modifier_axe_enrage_all_damage_lua = class({})

function modifier_axe_enrage_all_damage_lua:IsHidden()
	return false
end

function modifier_axe_enrage_all_damage_lua:IsDebuff()
	return false
end

function modifier_axe_enrage_all_damage_lua:IsPurgable()
	return false
end

function modifier_axe_enrage_all_damage_lua:OnCreated( kv )
	self.caster = self:GetCaster()
end
--------------------------------------------------------------------------------

function modifier_axe_enrage_all_damage_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_axe_enrage_all_damage_lua:GetModifierDamageOutgoing_Percentage( params )
	return 50
end

modifier_axe_enrage_other_lua = class({})

function modifier_axe_enrage_other_lua:IsHidden()
	return false
end

function modifier_axe_enrage_other_lua:IsDebuff()
	return false
end

function modifier_axe_enrage_other_lua:IsPurgable()
	return false
end

function modifier_axe_enrage_other_lua:OnCreated( kv )
	self.caster = self:GetCaster()
	self.bonus_agi = self:GetAbility():GetSpecialValueFor("bonus_str") * (self.caster:GetAgility()/100)
	self.bonus_int = self:GetAbility():GetSpecialValueFor("bonus_str") * (self.caster:GetIntellect()/100)
end
--------------------------------------------------------------------------------

function modifier_axe_enrage_other_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
	}
	return funcs
end

function modifier_axe_enrage_other_lua:GetModifierBonusStats_Agility( params )
	return self.bonus_agi
end

function modifier_axe_enrage_other_lua:GetModifierBonusStats_Intellect( params )
	return self.bonus_int
end

modifier_axe_berserkers_rearm = class({})

function modifier_axe_berserkers_rearm:IsHidden()
	return false
end

function modifier_axe_berserkers_rearm:IsDebuff()
	return false
end

function modifier_axe_berserkers_rearm:IsPurgable()
	return true
end

function modifier_axe_berserkers_rearm:OnCreated( kv )
	self.armor = self:GetAbility():GetSpecialValueFor( "bonus_armor" ) * (-1)
end

function modifier_axe_berserkers_rearm:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}

	return funcs
end

function modifier_axe_berserkers_rearm:GetModifierPhysicalArmorBonus()
	return self.armor
end
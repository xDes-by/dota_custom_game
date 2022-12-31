modifier_creature_extra_mana = class({})

function modifier_creature_extra_mana:IsHidden()
	return true
end

function modifier_creature_extra_mana:IsDebuff()
	return false
end

function modifier_creature_extra_mana:IsPurgable()
	return false
end

function modifier_creature_extra_mana:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_BONUS
	}
	return funcs
end

function modifier_creature_extra_mana:GetModifierManaBonus()
	return self:GetStackCount() - 1
end

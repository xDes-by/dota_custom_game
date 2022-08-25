modifier_debuff_armor = class({})

function modifier_debuff_armor:IsHidden()
	return true
end

function modifier_debuff_armor:IsDebuff()
	return false
end

function modifier_debuff_armor:IsPurgable()
	return false
end

function modifier_debuff_armor:OnCreated( kv )

end

function modifier_debuff_armor:OnRefresh( kv )

end

function modifier_debuff_armor:OnIntervalThink()

end


function modifier_debuff_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

function modifier_debuff_armor:GetModifierPhysicalArmorBonus()
	return self:GetParent():GetPhysicalArmorBaseValue() * 0.2 * (-1)
end
modifier_armor_debuff = class({})

--------------------------------------------------------------------------------
function modifier_armor_debuff:IsHidden()
	return true
end

function modifier_armor_debuff:IsPurgable()
	return false
end

function modifier_armor_debuff:OnCreated( kv )
end

function modifier_armor_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end


function modifier_armor_debuff:GetModifierPhysicalArmorBonus()
	return self:GetParent():GetPhysicalArmorBaseValue()*0.2*(-1)
end

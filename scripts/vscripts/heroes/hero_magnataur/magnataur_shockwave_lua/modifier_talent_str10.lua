modifier_talent_str10 = {}

function modifier_talent_str10:IsDebuff()
    return true
end

function modifier_talent_str10:IsHidden()
    return false
end


function modifier_talent_str10:OnCreated( kv )
    if not IsServer() then return end
    self.magic_damage_reduction = kv.magic_damage_reduction * -1
end

function modifier_talent_str10:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MAGICDAMAGEOUTGOING_PERCENTAGE,
	}

	return funcs
end

function modifier_talent_str10:GetModifierMagicDamageOutgoing_Percentage()
    return self.magic_damage_reduction
end
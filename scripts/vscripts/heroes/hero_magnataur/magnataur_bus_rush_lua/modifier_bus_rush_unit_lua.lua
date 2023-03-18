modifier_bus_rush_unit_lua = {}

function modifier_bus_rush_unit_lua:GetTexture()
    return "mars"
end

function modifier_bus_rush_unit_lua:OnCreated(kv)
	self.magic_damage_amplification = kv.magic_damage_amplification
end

function modifier_bus_rush_unit_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_bus_rush_unit_lua:GetModifierMagicDamageOutgoing_Percentage()
    return 1000
end

function modifier_bus_rush_unit_lua:CheckState()
    return {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
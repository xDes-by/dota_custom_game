modifier_bus_rush_unit_lua = {}

function modifier_bus_rush_unit_lua:GetTexture()
    return "mars"
end

function modifier_bus_rush_unit_lua:OnCreated(kv)
	if not IsServer() then return end
	self.magic_damage_amplification = kv.magic_damage_amplification
end

function modifier_bus_rush_unit_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MAGICDAMAGEOUTGOING_PERCENTAGE,
	}
end

function modifier_bus_rush_unit_lua:GetModifierMagicDamageOutgoing_Percentage()
    return 100 + self.magic_damage_amplification
end

function modifier_bus_rush_unit_lua:CheckState()
    return {
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end


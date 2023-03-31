modifier_magnataur_talent_str12 = {}

-- function modifier_magnataur_talent_str12:OnCreated(table)

-- end

function modifier_magnataur_talent_str12:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
end

function modifier_magnataur_talent_str12:GetModifierIncomingDamage_Percentage()
    return 25
end

function modifier_magnataur_talent_str12:GetEffectName()
	return "particles/fountain_regen_fall_2021_lvl2.vpcf"
end

function modifier_magnataur_talent_str12:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
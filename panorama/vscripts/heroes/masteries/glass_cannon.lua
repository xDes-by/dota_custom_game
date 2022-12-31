modifier_chc_mastery_glass_cannon = class({})

function modifier_chc_mastery_glass_cannon:IsHidden() return true end
function modifier_chc_mastery_glass_cannon:IsDebuff() return false end
function modifier_chc_mastery_glass_cannon:IsPurgable() return false end
function modifier_chc_mastery_glass_cannon:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_glass_cannon:GetTexture() return "masteries/glass_cannon" end

function modifier_chc_mastery_glass_cannon:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_chc_mastery_glass_cannon:GetModifierIncomingDamage_Percentage()
	return self.damage_in
end

function modifier_chc_mastery_glass_cannon:GetModifierTotalDamageOutgoing_Percentage()
	return self.damage_out
end



modifier_chc_mastery_glass_cannon_1 = class(modifier_chc_mastery_glass_cannon)
modifier_chc_mastery_glass_cannon_2 = class(modifier_chc_mastery_glass_cannon)
modifier_chc_mastery_glass_cannon_3 = class(modifier_chc_mastery_glass_cannon)

function modifier_chc_mastery_glass_cannon_1:OnCreated(keys)
	self.damage_in = 5
	self.damage_out = 15
end

function modifier_chc_mastery_glass_cannon_2:OnCreated(keys)
	self.damage_in = 10
	self.damage_out = 30
end

function modifier_chc_mastery_glass_cannon_3:OnCreated(keys)
	self.damage_in = 20
	self.damage_out = 60
end

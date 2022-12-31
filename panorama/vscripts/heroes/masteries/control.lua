modifier_chc_mastery_control = class({})

function modifier_chc_mastery_control:IsHidden() return true end
function modifier_chc_mastery_control:IsDebuff() return false end
function modifier_chc_mastery_control:IsPurgable() return false end
function modifier_chc_mastery_control:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_control:GetTexture() return "masteries/control" end

function modifier_chc_mastery_control:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_STATUS_RESISTANCE_CASTER 
	}
end

function modifier_chc_mastery_control:GetModifierStatusResistanceCaster()
	return self.debuff_amp
end



modifier_chc_mastery_control_1 = class(modifier_chc_mastery_control)
modifier_chc_mastery_control_2 = class(modifier_chc_mastery_control)
modifier_chc_mastery_control_3 = class(modifier_chc_mastery_control)

function modifier_chc_mastery_control_1:OnCreated(keys)
	self.debuff_amp = -20
end

function modifier_chc_mastery_control_2:OnCreated(keys)
	self.debuff_amp = -40
end

function modifier_chc_mastery_control_3:OnCreated(keys)
	self.debuff_amp = -80
end

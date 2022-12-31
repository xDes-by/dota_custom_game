modifier_chc_mastery_ferocity = class({})

function modifier_chc_mastery_ferocity:IsHidden() return true end
function modifier_chc_mastery_ferocity:IsDebuff() return false end
function modifier_chc_mastery_ferocity:IsPurgable() return false end
function modifier_chc_mastery_ferocity:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_ferocity:GetTexture() return "masteries/ferocity" end

function modifier_chc_mastery_ferocity:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_BASE_ATTACK_TIME_CONSTANT
	}
end

function modifier_chc_mastery_ferocity:GetModifierBaseAttackTimeConstant()
	return self.fixed_bat
end



modifier_chc_mastery_ferocity_1 = class(modifier_chc_mastery_ferocity)
modifier_chc_mastery_ferocity_2 = class(modifier_chc_mastery_ferocity)
modifier_chc_mastery_ferocity_3 = class(modifier_chc_mastery_ferocity)

function modifier_chc_mastery_ferocity_1:OnCreated(keys)
	self.fixed_bat = 1.57
end

function modifier_chc_mastery_ferocity_2:OnCreated(keys)
	self.fixed_bat = 1.45
end

function modifier_chc_mastery_ferocity_3:OnCreated(keys)
	self.fixed_bat = 1.20
end

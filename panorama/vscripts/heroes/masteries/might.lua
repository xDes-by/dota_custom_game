modifier_chc_mastery_might = class({})

function modifier_chc_mastery_might:IsHidden() return true end
function modifier_chc_mastery_might:IsDebuff() return false end
function modifier_chc_mastery_might:IsPurgable() return false end
function modifier_chc_mastery_might:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_might:GetTexture() return "masteries/might" end

function modifier_chc_mastery_might:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE
	}
end

function modifier_chc_mastery_might:GetModifierPreAttack_BonusDamage()
	return self.base_stat + self.level_stat * (self:GetParent():GetLevel() or 0)
end



modifier_chc_mastery_might_1 = class(modifier_chc_mastery_might)
modifier_chc_mastery_might_2 = class(modifier_chc_mastery_might)
modifier_chc_mastery_might_3 = class(modifier_chc_mastery_might)

function modifier_chc_mastery_might_1:OnCreated(keys)
	self.base_stat = 30
	self.level_stat = 2.5
end

function modifier_chc_mastery_might_2:OnCreated(keys)
	self.base_stat = 60
	self.level_stat = 5
end

function modifier_chc_mastery_might_3:OnCreated(keys)
	self.base_stat = 120
	self.level_stat = 10
end

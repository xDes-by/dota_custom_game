modifier_chc_mastery_warrior = class({})

function modifier_chc_mastery_warrior:IsHidden() return true end
function modifier_chc_mastery_warrior:IsDebuff() return false end
function modifier_chc_mastery_warrior:IsPurgable() return false end
function modifier_chc_mastery_warrior:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_warrior:GetTexture() return "masteries/warrior" end

function modifier_chc_mastery_warrior:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
	}
end

function modifier_chc_mastery_warrior:GetModifierDamageOutgoing_Percentage()
	return self.bonus_damage or 0
end



modifier_chc_mastery_warrior_1 = class(modifier_chc_mastery_warrior)
modifier_chc_mastery_warrior_2 = class(modifier_chc_mastery_warrior)
modifier_chc_mastery_warrior_3 = class(modifier_chc_mastery_warrior)

function modifier_chc_mastery_warrior_1:OnCreated(keys)
	self.bonus_damage = 15
end

function modifier_chc_mastery_warrior_2:OnCreated(keys)
	self.bonus_damage = 30
end

function modifier_chc_mastery_warrior_3:OnCreated(keys)
	self.bonus_damage = 60
end

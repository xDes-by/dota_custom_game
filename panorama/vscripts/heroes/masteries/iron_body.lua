modifier_chc_mastery_iron_body = class({})

function modifier_chc_mastery_iron_body:IsHidden() return true end
function modifier_chc_mastery_iron_body:IsDebuff() return false end
function modifier_chc_mastery_iron_body:IsPurgable() return false end
function modifier_chc_mastery_iron_body:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_iron_body:GetTexture() return "masteries/iron_body" end

function modifier_chc_mastery_iron_body:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_chc_mastery_iron_body:GetModifierPhysicalArmorBonus()
	return self.str_to_armor * (self:GetParent():GetStrength() or 0)
end



modifier_chc_mastery_iron_body_1 = class(modifier_chc_mastery_iron_body)
modifier_chc_mastery_iron_body_2 = class(modifier_chc_mastery_iron_body)
modifier_chc_mastery_iron_body_3 = class(modifier_chc_mastery_iron_body)

function modifier_chc_mastery_iron_body_1:OnCreated(keys)
	self.str_to_armor = 0.025
end

function modifier_chc_mastery_iron_body_2:OnCreated(keys)
	self.str_to_armor = 0.05
end

function modifier_chc_mastery_iron_body_3:OnCreated(keys)
	self.str_to_armor = 0.10
end

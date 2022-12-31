modifier_chc_mastery_heavy_armor = class({})

function modifier_chc_mastery_heavy_armor:IsHidden() return true end
function modifier_chc_mastery_heavy_armor:IsDebuff() return false end
function modifier_chc_mastery_heavy_armor:IsPurgable() return false end
function modifier_chc_mastery_heavy_armor:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_chc_mastery_heavy_armor:GetTexture() return "masteries/heavy_armor" end

function modifier_chc_mastery_heavy_armor:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
	}
end

function modifier_chc_mastery_heavy_armor:GetModifierPhysicalArmorBonus()
	return self.base_stat + self.level_stat * (self:GetParent():GetLevel() or 0)
end



modifier_chc_mastery_heavy_armor_1 = class(modifier_chc_mastery_heavy_armor)
modifier_chc_mastery_heavy_armor_2 = class(modifier_chc_mastery_heavy_armor)
modifier_chc_mastery_heavy_armor_3 = class(modifier_chc_mastery_heavy_armor)

function modifier_chc_mastery_heavy_armor_1:OnCreated(keys)
	self.base_stat = 3
	self.level_stat = 0.2
end

function modifier_chc_mastery_heavy_armor_2:OnCreated(keys)
	self.base_stat = 6
	self.level_stat = 0.4
end

function modifier_chc_mastery_heavy_armor_3:OnCreated(keys)
	self.base_stat = 12
	self.level_stat = 0.8
end

modifier_talent_str10 = class({})

function modifier_talent_str10:OnCreated( kv )
    local armor_per_level = self:GetParent():FindAbilityByName("npc_dota_hero_magnataur_str10"):GetSpecialValueFor("armor_per_level")
    self.armor_bonus = armor_per_level * self:GetParent():GetLevel()
end

function modifier_talent_str10:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_UNIQUE,
	}
end


function modifier_talent_str10:GetModifierPhysicalArmorBonusUnique()
    if self.armor_bonus ~= nil then
	    return self.armor_bonus
    end
    return 0
end

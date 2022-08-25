if modifier_easy == nil then
	modifier_easy = class({})
end

function modifier_easy:IsHidden()
	return false
end

function modifier_easy:IsPurgable()
	return false
end

function modifier_easy:RemoveOnDeath()
	return false
end

function modifier_easy:OnCreated()	    
	self.caster = self:GetCaster()
	
    self.base_bonus_damage_perc = -25         
    self.health = -25
	self.magarmor = -25
	self.armor = -25    
	self.cd = -25    
end

function modifier_easy:GetTexture()
    return "easy"
end

function modifier_easy:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
    return funcs
end

function modifier_easy:GetModifierBaseDamageOutgoing_Percentage()	 		
	local damage_perc_increase = self.base_bonus_damage_perc
	return damage_perc_increase		
end

function modifier_easy:GetModifierExtraHealthPercentage()	
	local health_increase = self.health
	return health_increase	
end

function modifier_easy:GetModifierPhysicalArmorBonus()
	local armorcreeps = self:GetParent():GetPhysicalArmorBaseValue()
	local armor_increase = armorcreeps * self.armor / 100
	return armor_increase	
end

function modifier_easy:GetModifierMagicalResistanceBonus()	
	local magicarmorcreeps = self:GetParent():GetBaseMagicalResistanceValue()
	local magarmor_increase = magicarmorcreeps * self.magarmor / 100
	return magarmor_increase	
end

function modifier_easy:GetModifierPercentageCooldown()
	local cd = self.cd
	return cd	
end
if modifier_hard == nil then
	modifier_hard = class({})
end

function modifier_hard:IsHidden()
	return false
end

function modifier_hard:IsPurgable()
	return false
end

function modifier_hard:RemoveOnDeath()
	return false
end

function modifier_hard:OnCreated()	    
	self.caster = self:GetCaster()
	
    self.base_bonus_damage_perc = 100         
    self.health = 100
	self.magarmor = 100
	self.armor = 100  
	self.cd = 25    
end

function modifier_hard:GetTexture()
    return "hard"
end

function modifier_hard:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
    return funcs
end

function modifier_hard:GetModifierBaseDamageOutgoing_Percentage()	 		
	local damage_perc_increase = self.base_bonus_damage_perc
	return damage_perc_increase		
end

function modifier_hard:GetModifierExtraHealthPercentage()	
	local health_increase = self.health
	return health_increase	
end

function modifier_hard:GetModifierPhysicalArmorBonus()
	local armorcreeps = self:GetParent():GetPhysicalArmorBaseValue()
	local armor_increase = armorcreeps * self.armor / 100
	return armor_increase	
end

function modifier_hard:GetModifierMagicalResistanceBonus()	
	local magicarmorcreeps = self:GetParent():GetBaseMagicalResistanceValue()
	local magarmor_increase = magicarmorcreeps * self.magarmor / 100
	return magarmor_increase	
end

function modifier_hard:GetModifierPercentageCooldown()
	local cd = self.cd
	return cd	
end
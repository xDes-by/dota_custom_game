if modifier_ultra == nil then
	modifier_ultra = class({})
end

function modifier_ultra:IsHidden()
	return false
end

function modifier_ultra:IsPurgable()
	return false
end

function modifier_ultra:RemoveOnDeath()
	return false
end

function modifier_ultra:OnCreated()	    
	self.caster = self:GetCaster()
	
    self.base_bonus_damage_perc = 150         
    self.health = 150
	self.magarmor = 150
	self.armor = 150  
	self.cd = 50    
end

function modifier_ultra:GetTexture()
    return "ultra"
end

function modifier_ultra:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
    }
    return funcs
end

function modifier_ultra:GetModifierBaseDamageOutgoing_Percentage()	 		
	local damage_perc_increase = self.base_bonus_damage_perc
	return damage_perc_increase		
end

function modifier_ultra:GetModifierExtraHealthPercentage()	
	local health_increase = self.health
	return health_increase	
end

function modifier_ultra:GetModifierPhysicalArmorBonus()
	local armorcreeps = self:GetParent():GetPhysicalArmorBaseValue()
	local armor_increase = armorcreeps * self.armor / 100
	return armor_increase	
end

function modifier_ultra:GetModifierMagicalResistanceBonus()	
	local magicarmorcreeps = self:GetParent():GetBaseMagicalResistanceValue()
	local magarmor_increase = magicarmorcreeps * self.magarmor / 100
	if magarmor_increase >= 95 then
		return 0
	end
	return magarmor_increase	
end

function modifier_ultra:GetModifierPercentageCooldown()
	local cd = self.cd
	return cd	
end
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
	
    self.bonus_damage_perc_income = 25       
    self.bonus_damage_perc_outgoing = -25       
    self.health = -25
	self.cd = -25    
end

function modifier_easy:GetTexture()
    return "easy"
end

function modifier_easy:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
    return funcs
end

function modifier_easy:GetModifierDamageOutgoing_Percentage()	 		
	return self.bonus_damage_perc_outgoing	
end

function modifier_easy:GetModifierIncomingDamage_Percentage()	 		
	return self.bonus_damage_perc_income	
end

function modifier_easy:GetModifierExtraHealthPercentage()
	return self.health
end

function modifier_easy:GetModifierPercentageCooldown()
	return self.cd	
end
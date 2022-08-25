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
	
    self.bonus_damage_perc_income = -25       
    self.bonus_damage_perc_outgoing = 100      
    self.health = 100
	self.cd = 25    
end

function modifier_hard:GetTexture()
    return "hard"
end

function modifier_hard:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
    return funcs
end

function modifier_hard:GetModifierDamageOutgoing_Percentage()	 		
	return self.bonus_damage_perc_outgoing	
end

function modifier_hard:GetModifierIncomingDamage_Percentage()	 		
	return self.bonus_damage_perc_income	
end

function modifier_hard:GetModifierExtraHealthPercentage()
if self:GetCaster():GetMaxHealth() >= 2000000000 then return 0 end
	return self.health
end

function modifier_hard:GetModifierPercentageCooldown()
	return self.cd	
end
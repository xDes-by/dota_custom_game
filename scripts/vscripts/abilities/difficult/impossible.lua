if modifier_impossible == nil then
	modifier_impossible = class({})
end

function modifier_impossible:IsHidden()
	return false
end

function modifier_impossible:IsPurgable()
	return false
end

function modifier_impossible:RemoveOnDeath()
	return false
end

function modifier_impossible:OnCreated()	    
	self.caster = self:GetCaster()
	
    self.bonus_damage_perc_income = -80
    self.bonus_damage_perc_outgoing = 300      
    self.health = 300
	self.cd = 50    
end

function modifier_impossible:GetTexture()
    return "impossible"
end

function modifier_impossible:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
    return funcs
end

function modifier_impossible:GetModifierDamageOutgoing_Percentage()	 		
	return self.bonus_damage_perc_outgoing	
end

function modifier_impossible:GetModifierIncomingDamage_Percentage()	 		
	return self.bonus_damage_perc_income	
end

function modifier_impossible:GetModifierExtraHealthPercentage()
if self:GetCaster():GetMaxHealth() >= 2000000000 then return 0 end
	return self.health
end

function modifier_impossible:GetModifierPercentageCooldown()
	return self.cd	
end
if modifier_insane == nil then
	modifier_insane = class({})
end

function modifier_insane:IsHidden()
	return false
end

function modifier_insane:IsPurgable()
	return false
end

function modifier_insane:RemoveOnDeath()
	return false
end

function modifier_insane:OnCreated()	    
	self.caster = self:GetCaster()
	
    self.bonus_damage_perc_income = -75       
    self.bonus_damage_perc_outgoing = 200       
    self.health = 200
	self.cd = 50    
end

function modifier_insane:GetTexture()
    return "insane"
end

function modifier_insane:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
    return funcs
end

function modifier_insane:GetModifierDamageOutgoing_Percentage()	 		
	return self.bonus_damage_perc_outgoing	
end

function modifier_insane:GetModifierIncomingDamage_Percentage()	 		
	return self.bonus_damage_perc_income	
end

function modifier_insane:GetModifierExtraHealthPercentage()
if self:GetCaster():GetMaxHealth() >= 2000000000 then return 0 end
	return self.health
end

function modifier_insane:GetModifierPercentageCooldown()
	return self.cd	
end
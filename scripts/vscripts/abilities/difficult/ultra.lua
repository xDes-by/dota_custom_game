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
	
    self.bonus_damage_perc_income = -50      
    self.bonus_damage_perc_outgoing = 150      
    self.health = 150
	self.cd = 50    
end

function modifier_ultra:GetTexture()
    return "ultra"
end

function modifier_ultra:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE
    }
    return funcs
end

function modifier_ultra:GetModifierDamageOutgoing_Percentage()	 		
	return self.bonus_damage_perc_outgoing	
end

function modifier_ultra:GetModifierIncomingDamage_Percentage()	 		
	return self.bonus_damage_perc_income	
end

function modifier_ultra:GetModifierExtraHealthPercentage()
if self:GetCaster():GetMaxHealth() >= 2000000000 then return 0 end
	return self.health
end

function modifier_ultra:GetModifierPercentageCooldown()
	return self.cd	
end
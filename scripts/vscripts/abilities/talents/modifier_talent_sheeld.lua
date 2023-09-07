modifier_talent_sheeld = class({})

function modifier_talent_sheeld:IsHidden()
	return true
end

function modifier_talent_sheeld:IsPurgable()
	return false
end

function modifier_talent_sheeld:RemoveOnDeath()
	return false
end
modifier_talent_sheeld.value = {7.5, 10, 12.5, 15, 17.5, 20}
function modifier_talent_sheeld:OnCreated( kv )
	self.caster = self:GetCaster()
	self.IsBroken = false
	self.sheeld_max = self.value[self:GetStackCount()] * 0.01 * self.caster:GetMaxHealth()
	self.sheeld_regen = self.sheeld_max / 30
	self.current_sheeld_health = self.sheeld_max
	self:SetStackCount(self.current_sheeld_health)
	self:StartIntervalThink(0.03)
end

function modifier_talent_sheeld:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.sheeld_max = self.value[self:GetStackCount()] * 0.01 * self.caster:GetMaxHealth()
	self.sheeld_regen = self.sheeld_max / 30
end

function modifier_talent_sheeld:OnIntervalThink()
	self.current_sheeld_health = self.current_sheeld_health + self.sheeld_regen
	if self.current_sheeld_health > self.sheeld_max then
		self.current_sheeld_health = self.sheeld_max
		self:SetStackCount(self.current_sheeld_health)
		self.IsBroken = false
	end
	self:SetStackCount(self.current_sheeld_health)
end

function modifier_talent_sheeld:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT
	}
end

function modifier_talent_sheeld:GetModifierIncomingDamageConstant(data)
	if IsClient() then
		return 0 
	end
    if self.IsBroken self:GetStackCount() > 0 then
        local remain = self.current_sheeld_health - data.damage
        if remain > 0 then
            self.current_sheeld_health = self.current_sheeld_health - data.damage
            self:SetStackCount(self.current_sheeld_health)
            return -data.damage
        else
			self.IsBroken = true
            local p = data.damage - self.current_sheeld_health
            self.current_sheeld_health = 0
            self:SetStackCount(self.current_sheeld_health)
            return -p
        end
    end	
end
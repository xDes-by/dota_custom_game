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

function modifier_talent_sheeld:OnCreated( kv )
	self.value = {7.5, 10, 12.5, 15, 17.5, 20}
	self:SetStackCount(1)
	self.parent = self:GetParent()
	self.IsBroken = false
	self.sheeld_max = self.value[self:GetStackCount()] * 0.01 * self.parent:GetMaxHealth()
	self.sheeld_regen = self.sheeld_max / 5 * FrameTime()
	self.current_sheeld_health = self.sheeld_max
	if not IsServer() then
		return
	end
	self:SetHasCustomTransmitterData( true )
end

function modifier_talent_sheeld:OnRefresh( kv )
	self.sheeld_max = self.value[self:GetStackCount()] * 0.01 * self.parent:GetMaxHealth()
	self.sheeld_regen = self.sheeld_max / 5 * FrameTime()
end

function modifier_talent_sheeld:OnStackCountChanged()
	self:OnRefresh()
end

function modifier_talent_sheeld:OnIntervalThink()
	if not self.IsBroken then
		self:StartIntervalThink(FrameTime())
		self.IsBroken = true
		return
	end
	self.current_sheeld_health = self.current_sheeld_health + self.sheeld_regen
	if self.current_sheeld_health >= self.sheeld_max then
		self.current_sheeld_health = self.sheeld_max
		self.IsBroken = false
		self:StartIntervalThink(-1)
	end
	self:SendBuffRefreshToClients()
end

function modifier_talent_sheeld:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT
	}
end

function modifier_talent_sheeld:GetModifierIncomingDamageConstant(data)
    if IsClient() then
        if data.report_max then
            return self.sheeld_max
        else
            return self.current_sheeld_health
        end
    end
	if self.IsBroken then
		return 0
	end
    if not self.IsBroken and self.current_sheeld_health > 0 then
        local remain = self.current_sheeld_health - data.damage
        if remain > 0 then
            self.current_sheeld_health = self.current_sheeld_health - data.damage
			self.IsBroken = false
			self:StartIntervalThink(5)
			self:SendBuffRefreshToClients()
			return -data.damage
        else
			self.IsBroken = true
			self:StartIntervalThink(FrameTime())
            local p = data.damage - self.current_sheeld_health
            self.current_sheeld_health = 0
			self:SendBuffRefreshToClients()
			return -p
        end
    end	
end

function modifier_talent_sheeld:AddCustomTransmitterData()
	return {
		current_sheeld_health = self.current_sheeld_health,
		sheeld_max = self.sheeld_max,
	}
end

function modifier_talent_sheeld:HandleCustomTransmitterData( data )
	self.current_sheeld_health = data.current_sheeld_health
	self.sheeld_max = data.sheeld_max
end

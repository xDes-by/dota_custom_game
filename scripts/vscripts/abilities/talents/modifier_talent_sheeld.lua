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
	self.caster = self:GetCaster()
	self.IsBroken = false
	self.sheeld_max = self.value[self:GetStackCount()] * 0.01 * self.caster:GetMaxHealth()
	self.sheeld_regen = self.sheeld_max / 30
	self.current_sheeld_health = self.sheeld_max
	self:StartIntervalThink(FrameTime())
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
		self.IsBroken = false
	end
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
            return -data.damage
        else
			self.IsBroken = true
            local p = data.damage - self.current_sheeld_health
            self.current_sheeld_health = 0
            return -p
        end
    end	
end
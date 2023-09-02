status = class({})
LinkLuaModifier( "modifier_status", "abilities/talents/status", LUA_MODIFIER_MOTION_NONE )

function status:GetIntrinsicModifierName()
	return "modifier_status"
end

----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------

modifier_status = class({})

function modifier_status:IsHidden()
	return true
end

function modifier_status:IsPurgable()
	return false
end

function modifier_status:RemoveOnDeath()
	return false
end

function modifier_status:OnCreated( kv )
	self.caster = self:GetCaster()
	self.IsBroken = false
	self.sheeld_max = self:GetAbility():GetSpecialValueFor( "sheeld" ) * 0.01 * self.caster:GetMaxHealth()
	self.sheeld_regen = self.sheeld_max / 30
	self.current_sheeld_health = self.sheeld_max
	self:SetStackCount(self.current_sheeld_health)
	self:StartIntervalThink(0.03)
end

function modifier_status:OnRefresh( kv )
	self.caster = self:GetCaster()
	self.sheeld_max = self:GetAbility():GetSpecialValueFor( "sheeld" ) * 0.01 * self.caster:GetMaxHealth()
	self.sheeld_regen = self.sheeld_max / 30
end

function modifier_status:OnIntervalThink()
	self.current_sheeld_health = self.current_sheeld_health + self.sheeld_regen
	if self.current_sheeld_health > self.sheeld_max then
		self.current_sheeld_health = self.sheeld_max
		self:SetStackCount(self.current_sheeld_health)
		self.IsBroken = false
	end
	self:SetStackCount(self.current_sheeld_health)
end

function modifier_status:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_CONSTANT
	}
end

function modifier_status:GetModifierIncomingDamageConstant(data)
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
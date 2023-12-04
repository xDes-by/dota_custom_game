modifier_leshrac_pulse_nova_burn_lua = class({})

function modifier_leshrac_pulse_nova_burn_lua:IsHidden()
	return false
end

function modifier_leshrac_pulse_nova_burn_lua:IsDebuff()
	return true
end

function modifier_leshrac_pulse_nova_burn_lua:IsPurgable()
	return false
end

function modifier_leshrac_pulse_nova_burn_lua:OnCreated( kv )
    if not IsServer() then return end
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
    self:StartIntervalThink(0.2)
end

function modifier_leshrac_pulse_nova_burn_lua:OnIntervalThink()
    self:GetAbility():Hit(self:GetParent())
    self:StartIntervalThink(self.interval)
end

function modifier_leshrac_pulse_nova_burn_lua:OnDestroy()
end

modifier_leshrac_pulse_nova_burn2_lua = class({})

function modifier_leshrac_pulse_nova_burn2_lua:IsHidden()
	return false
end

function modifier_leshrac_pulse_nova_burn2_lua:IsDebuff()
	return true
end

function modifier_leshrac_pulse_nova_burn2_lua:IsPurgable()
	return false
end

function modifier_leshrac_pulse_nova_burn2_lua:OnCreated( kv )
    if not IsServer() then return end
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.interval = self:GetAbility():GetSpecialValueFor( "interval" )
    self:StartIntervalThink(self.interval)
end

function modifier_leshrac_pulse_nova_burn2_lua:OnIntervalThink()
    if self:GetParent():FindModifierByName("modifier_leshrac_pulse_nova_burn_lua") then
        self:Destroy()
    else
        self:GetAbility():Hit(self:GetParent())
    end
end
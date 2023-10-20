modifier_pips = class({})
--Classifications template
function modifier_pips:IsHidden()
    return true
end

function modifier_pips:IsDebuff()
    return false
end

function modifier_pips:IsPurgable()
    return false
end

function modifier_pips:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_pips:IsStunDebuff()
    return false
end

function modifier_pips:RemoveOnDeath()
    return true
end

function modifier_pips:DestroyOnExpire()
    return false
end

function modifier_pips:OnCreated(data)
    self.parent = self:GetParent()
    if not IsServer() then
        return
    end
    self.pips_count = data.pips_count or 1
    self.parent:SetMaxHealth(self.pips_count)
    self.parent:SetHealth(self.pips_count)
    self:SetHasCustomTransmitterData( true )
end

function modifier_pips:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTHBAR_PIPS,
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
    }
end

function modifier_pips:GetModifierHealthBarPips()
    return math.min( self.pips_count, 20 )
end

function modifier_pips:OnAttackLanded(data)
    if data.target == self.parent then
        local chealth = self.parent:GetHealth()
        if chealth - 1 == 0 then
            UTIL_Remove(self.parent)
        else
            self.parent:SetHealth(chealth - 1)
        end
    end
end

function modifier_pips:GetModifierIncomingDamage_Percentage()
    return -100
end

function modifier_pips:AddCustomTransmitterData()
    return {
        pips_count = self.pips_count,
    }
end

function modifier_pips:HandleCustomTransmitterData( data )
    self.pips_count = data.pips_count
end

modifier_wearable_pet = class({})
--Classifications template
function modifier_wearable_pet:IsHidden()
    return true
end

function modifier_wearable_pet:IsDebuff()
    return false
end

function modifier_wearable_pet:IsPurgable()
    return false
end

function modifier_wearable_pet:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_wearable_pet:IsStunDebuff()
    return false
end

function modifier_wearable_pet:RemoveOnDeath()
    return false
end

function modifier_wearable_pet:DestroyOnExpire()
    return false
end

function modifier_wearable_pet:OnCreated()
    if not IsServer() then
        return
    end
    self.iPlayerID = self:GetParent():GetPlayerID()
    self.original_model = self:GetParent():GetModelName()
    self.WearableStatus = self:GetParent().WearableStatus
end

function modifier_wearable_pet:OnRefresh()
    if not IsServer() then
        return
    end
    self.original_model = self:GetParent():GetModelName()
    self.WearableStatus = self:GetParent().WearableStatus
end

function modifier_wearable_pet:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_MODEL_CHANGED,
        MODIFIER_EVENT_ON_DEATH,
        MODIFIER_EVENT_ON_RESPAWN
    }
end

function modifier_wearable_pet:OnModelChanged(data)
    if self:GetParent() ~= data.attacker then 
        return
    end
    if self:GetParent():IsIllusion() then
        return
    end
    if not self:GetParent():IsRealHero() then
        return
    end
    if self:GetParent().WearableStatus ~= "clear" then
        Wearable:ClearWear(self:GetParent())
    else
        if self.WearableStatus == "default" then
            Wearable:SetDefault(self:GetParent())
        elseif self.WearableStatus == "alternative" then
            Wearable:SetAlternative(self:GetParent())
        end
    end
end

function modifier_wearable_pet:OnRespawn(data)
    if data.unit == self:GetParent() then
        if self.WearableStatus == "default" then
            Wearable:SetDefault(self:GetParent())
        elseif self.WearableStatus == "alternative" then
            Wearable:SetAlternative(self:GetParent())
        end
    end
end

function modifier_wearable_pet:OnDeath(data)
    if data.unit == self:GetParent() then
        Wearable:ClearWear(self:GetParent())
    end
end
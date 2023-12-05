modifier_refresh_items = class({})
--Classifications template
function modifier_refresh_items:IsHidden()
    return true
end

function modifier_refresh_items:IsDebuff()
    return false
end

function modifier_refresh_items:IsPurgable()
    return false
end

function modifier_refresh_items:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_refresh_items:IsStunDebuff()
    return false
end

function modifier_refresh_items:RemoveOnDeath()
    return false
end

function modifier_refresh_items:DestroyOnExpire()
    return false
end

function modifier_refresh_items:OnCreated()
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_refresh_items:OnIntervalThink()
    for i=0,5 do
        local item = self:GetParent():GetItemInSlot(i)
        if item then
            item:RefreshIntrinsicModifier()
        end
    end
end
modifier_gold_creep = class({})
--Classifications template
function modifier_gold_creep:IsHidden()
    return false
end

function modifier_gold_creep:IsDebuff()
    return false
end

function modifier_gold_creep:IsPurgable()
    return false
end

function modifier_gold_creep:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_gold_creep:IsStunDebuff()
    return false
end

function modifier_gold_creep:RemoveOnDeath()
    return true
end

function modifier_gold_creep:DestroyOnExpire()
    return false
end

function modifier_gold_creep:OnCreated()
    self.parent = self:GetParent()
    self.health = self.parent:GetMaxHealth() * 4
end

function modifier_gold_creep:OnDestroy()
    for iPlayerID=0,4 do
        if PlayerResource:IsValidPlayer(iPlayerID) then
            PlayerResource:ModifyGold(iPlayerID, GetGoldBounty(), true, DOTA_ModifyGold_SharedGold)
        end
    end
end

function modifier_gold_creep:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HEALTH_BONUS
    }
end

function modifier_gold_creep:GetModifierHealthBonus()
    return self.health
end
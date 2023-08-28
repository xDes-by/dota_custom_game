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
    -- self.part = ParticleManager:CreateParticle( "particles/econ/items/bounty_hunter/bounty_hunter_hunters_hoard/bounty_hunter_hoard_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
    self.part = ParticleManager:CreateParticle( "particles/econ/events/ti9/high_five/high_five_lvl3_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self.parent )
end

function modifier_gold_creep:OnDestroy()
    ParticleManager:DestroyParticle(self.part, false)
    for iPlayerID=0,4 do
        if PlayerResource:IsValidPlayer(iPlayerID) then
            PlayerResource:ModifyGold(iPlayerID, self.parent:GetGoldBounty(), true, DOTA_ModifyGold_SharedGold)
        end
    end
end

function modifier_gold_creep:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_EXTRA_HEALTH_BONUS,
        MODIFIER_PROPERTY_MODEL_SCALE
    }
end

function modifier_gold_creep:GetModifierExtraHealthBonus()
    return self.health
end

function modifier_gold_creep:GetModifierModelScale()
    return 50
end
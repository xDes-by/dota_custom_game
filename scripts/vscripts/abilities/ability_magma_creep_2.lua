magma_creep_2 = class({})

LinkLuaModifier("modifier_magma_creep_2", "abilities/ability_magma_creep_2", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_magma_creep_2_armor_curruption", "abilities/ability_magma_creep_2", LUA_MODIFIER_MOTION_NONE)

function magma_creep_2:GetIntrinsicModifierName()
    return "modifier_magma_creep_2"
end

modifier_magma_creep_2 = class({})
--Classifications template
function modifier_magma_creep_2:IsHidden()
    return true
end

function modifier_magma_creep_2:IsDebuff()
    return false
end

function modifier_magma_creep_2:IsPurgable()
    return false
end

function modifier_magma_creep_2:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_magma_creep_2:IsStunDebuff()
    return false
end

function modifier_magma_creep_2:RemoveOnDeath()
    return false
end

function modifier_magma_creep_2:DestroyOnExpire()
    return false
end

function modifier_magma_creep_2:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_LANDED,
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE
    }
end

function modifier_magma_creep_2:OnAttackLanded(data)
    if self:GetParent() ~= data.attacker then
        return
    end
    data.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_magma_creep_2_armor_curruption", {duration = 5})
end

function modifier_magma_creep_2:GetModifierPreAttack_CriticalStrike()
    if RollPercentage(15) then
        return 275
    end
end

modifier_magma_creep_2_armor_curruption = class({})
--Classifications template
function modifier_magma_creep_2_armor_curruption:IsHidden()
    return false
end

function modifier_magma_creep_2_armor_curruption:IsDebuff()
    return true
end

function modifier_magma_creep_2_armor_curruption:IsPurgable()
    return true
end

function modifier_magma_creep_2_armor_curruption:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_magma_creep_2_armor_curruption:IsStunDebuff()
    return false
end

function modifier_magma_creep_2_armor_curruption:RemoveOnDeath()
    return true
end

function modifier_magma_creep_2_armor_curruption:DestroyOnExpire()
    return true
end

function modifier_magma_creep_2_armor_curruption:OnCreated()
    if not IsServer() then
        return
    end
    self:SetStackCount(0)
end

function modifier_magma_creep_2_armor_curruption:OnRefresh()
    if not IsServer() then
        return
    end
    self:IncrementStackCount()
end

function modifier_magma_creep_2_armor_curruption:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_magma_creep_2:GetModifierPhysicalArmorBonus()
    return -10 * self:GetStackCount()
end
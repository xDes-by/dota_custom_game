ability_npc_patrool2_zoomby_crit = class({})

function ability_npc_patrool2_zoomby_crit:GetIntrinsicModifierName()
    return "modifier_ability_npc_patrool2_zoomby_crit"
end

modifier_ability_npc_patrool2_zoomby_crit = class({})

LinkLuaModifier("modifier_ability_npc_patrool2_zoomby_crit", "abilities/lane_creeps/ability_npc_patrool2_zoomby_crit.lua", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_npc_patrool2_zoomby_crit:IsHidden()
    return true
end

function modifier_ability_npc_patrool2_zoomby_crit:IsDebuff()
    return false
end

function modifier_ability_npc_patrool2_zoomby_crit:IsPurgable()
    return false
end

function modifier_ability_npc_patrool2_zoomby_crit:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_patrool2_zoomby_crit:IsStunDebuff()
    return false
end

function modifier_ability_npc_patrool2_zoomby_crit:RemoveOnDeath()
    return false
end

function modifier_ability_npc_patrool2_zoomby_crit:DestroyOnExpire()
    return false
end

function modifier_ability_npc_patrool2_zoomby_crit:OnCreated()
    self.parent = self:GetParent()
    self.crit = self:GetAbility():GetSpecialValueFor("crit")
    self.crit_chance = self:GetAbility():GetSpecialValueFor("crit_chance")
end

function modifier_ability_npc_patrool2_zoomby_crit:OnDestroy()

end

function modifier_ability_npc_patrool2_zoomby_crit:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
    }
end

function modifier_ability_npc_patrool2_zoomby_crit:GetModifierPreAttack_CriticalStrike(data)
    if RandomInt(1, 100) < self.crit_chance then
        return self.crit
    end
end
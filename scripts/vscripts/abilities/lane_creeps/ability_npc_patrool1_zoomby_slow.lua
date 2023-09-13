ability_npc_patrool1_zoomby_slow = class({})

function ability_npc_patrool1_zoomby_slow:GetTexture()
    return "troll_warlord_battle_trance"
end

function ability_npc_patrool1_zoomby_slow:GetIntrinsicModifierName()
    return "modifier_ability_npc_patrool1_zoomby_slow"
end

modifier_ability_npc_patrool1_zoomby_slow = class({})

LinkLuaModifier("modifier_ability_npc_patrool1_zoomby_slow", "abilities/lane_creeps/ability_npc_patrool1_zoomby_slow.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_ability_npc_patrool1_zoomby_slow_effect", "abilities/lane_creeps/ability_npc_patrool1_zoomby_slow.lua", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_npc_patrool1_zoomby_slow:IsHidden()
    return true
end

function modifier_ability_npc_patrool1_zoomby_slow:IsDebuff()
    return false
end

function modifier_ability_npc_patrool1_zoomby_slow:IsPurgable()
    return false
end

function modifier_ability_npc_patrool1_zoomby_slow:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_patrool1_zoomby_slow:IsStunDebuff()
    return false
end

function modifier_ability_npc_patrool1_zoomby_slow:RemoveOnDeath()
    return false
end

function modifier_ability_npc_patrool1_zoomby_slow:DestroyOnExpire()
    return false
end

function modifier_ability_npc_patrool1_zoomby_slow:OnCreated()
    self.parent = self:GetParent()
    self.slow = self:GetAbility():GetSpecialValueFor("slow") * -1
    self.slow_as = self:GetAbility():GetSpecialValueFor("slow_as") * -1
end

function modifier_ability_npc_patrool1_zoomby_slow:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_ability_npc_patrool1_zoomby_slow:GetModifierProcAttack_Feedback(data)
    data.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_ability_npc_patrool1_zoomby_slow_effect", {duration = 3, slow = self.slow, slow_as = self.slow_as})
end

modifier_ability_npc_patrool1_zoomby_slow_effect = class({})
--Classifications template
function modifier_ability_npc_patrool1_zoomby_slow_effect:IsHidden()
    return false
end

function modifier_ability_npc_patrool1_zoomby_slow_effect:IsDebuff()
    return true
end

function modifier_ability_npc_patrool1_zoomby_slow_effect:IsPurgable()
    return true
end

function modifier_ability_npc_patrool1_zoomby_slow_effect:IsPurgeException()
    return true
end

-- Optional Classifications
function modifier_ability_npc_patrool1_zoomby_slow_effect:IsStunDebuff()
    return false
end

function modifier_ability_npc_patrool1_zoomby_slow_effect:RemoveOnDeath()
    return true
end

function modifier_ability_npc_patrool1_zoomby_slow_effect:DestroyOnExpire()
    return true
end

function modifier_ability_npc_patrool1_zoomby_slow_effect:OnCreated(data)
    self.slow = data.slow
    self.slow_as = data.slow_as
end

function modifier_ability_npc_patrool1_zoomby_slow_effect:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_PERCENTAGE
    }
end

function modifier_ability_npc_patrool1_zoomby_slow_effect:GetModifierMoveSpeedBonus_Percentage()
    return self.slow
end

function modifier_ability_npc_patrool1_zoomby_slow_effect:GetModifierAttackSpeedPercentage()
    return self.slow_as
end
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

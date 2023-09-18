ability_npc_patrool3_siege = class({})

function ability_npc_patrool3_siege:GetIntrinsicModifierName()
    return "modifier_ability_npc_patrool3_siege"
end

modifier_ability_npc_patrool3_siege = class({})

LinkLuaModifier("modifier_ability_npc_patrool3_siege", "abilities/lane_creeps/ability_npc_patrool3_siege.lua", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_npc_patrool3_siege:IsHidden()
    return true
end

function modifier_ability_npc_patrool3_siege:IsDebuff()
    return false
end

function modifier_ability_npc_patrool3_siege:IsPurgable()
    return false
end

function modifier_ability_npc_patrool3_siege:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_patrool3_siege:IsStunDebuff()
    return false
end

function modifier_ability_npc_patrool3_siege:RemoveOnDeath()
    return false
end

function modifier_ability_npc_patrool3_siege:DestroyOnExpire()
    return false
end

function modifier_ability_npc_patrool3_siege:OnCreated()
    self.parent = self:GetParent()
    self.addition_damage = self:GetAbility():GetSpecialValueFor("addition_damage")
end

function modifier_ability_npc_patrool3_siege:OnDestroy()

end

function modifier_ability_npc_patrool3_siege:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_TOTALDAMAGEOUTGOING_PERCENTAGE
    }
end

function modifier_ability_npc_patrool3_siege:GetModifierTotalDamageOutgoing_Percentage(data)
    if data.target:IsBuilding() then
        return 100 + self.addition_damage
    end
    return 100
end


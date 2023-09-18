ability_npc_patrool3_dragon = class({})

function ability_npc_patrool3_dragon:GetIntrinsicModifierName()
    return "modifier_ability_npc_patrool3_dragon"
end

modifier_ability_npc_patrool3_dragon = class({})

LinkLuaModifier("modifier_ability_npc_patrool3_dragon", "abilities/lane_creeps/ability_npc_patrool3_dragon.lua", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_npc_patrool3_dragon:IsHidden()
    return true
end

function modifier_ability_npc_patrool3_dragon:IsDebuff()
    return false
end

function modifier_ability_npc_patrool3_dragon:IsPurgable()
    return false
end

function modifier_ability_npc_patrool3_dragon:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_patrool3_dragon:IsStunDebuff()
    return false
end

function modifier_ability_npc_patrool3_dragon:RemoveOnDeath()
    return false
end

function modifier_ability_npc_patrool3_dragon:DestroyOnExpire()
    return false
end

function modifier_ability_npc_patrool3_dragon:OnCreated()
    self.parent = self:GetParent()
    self.IsAbilityProcked = false
    self.chance = self:GetAbility():GetSpecialValueFor("chance")
end

function modifier_ability_npc_patrool3_dragon:OnDestroy()

end

function modifier_ability_npc_patrool3_dragon:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MIN_HEALTH,
        MODIFIER_EVENT_ON_TAKEDAMAGE,
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_ability_npc_patrool3_dragon:GetMinHealth()
    if not self.IsAbilityProcked then
        return 1
    end
end

function modifier_ability_npc_patrool3_dragon:OnTakeDamage(data)
    if data.unit == self:GetParent() and not self.IsAbilityProcked and self.parent:GetHealth() == 1 then
        self.parent:AddNewModifier(self.parent, self:GetAbility(), "modifier_troll_warlord_battle_trance", {duration = 3})
        self.IsAbilityProcked = true
    end
end

function modifier_ability_npc_patrool3_dragon:GetModifierProcAttack_Feedback(data)
    if self.IsAbilityProcked and RandomInt(1, 100) < self.chance then
        data.target:AddNewModifier(self.parent, self:GetAbility(), "modifier_troll_warlord_berserkers_rage_ensnare", {duration = 1})
    end
end
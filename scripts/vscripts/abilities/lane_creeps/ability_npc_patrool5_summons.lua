ability_npc_patrool5_summons = class({})

function ability_npc_patrool5_summons:GetIntrinsicModifierName()
    return "modifier_ability_npc_patrool5_summons"
end

modifier_ability_npc_patrool5_summons = class({})

LinkLuaModifier("modifier_ability_npc_patrool5_summons", "abilities/lane_creeps/ability_npc_patrool5_summons.lua", LUA_MODIFIER_MOTION_NONE)

--Classifications template
function modifier_ability_npc_patrool5_summons:IsHidden()
    return true
end

function modifier_ability_npc_patrool5_summons:IsDebuff()
    return false
end

function modifier_ability_npc_patrool5_summons:IsPurgable()
    return false
end

function modifier_ability_npc_patrool5_summons:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_ability_npc_patrool5_summons:IsStunDebuff()
    return false
end

function modifier_ability_npc_patrool5_summons:RemoveOnDeath()
    return true
end

function modifier_ability_npc_patrool5_summons:DestroyOnExpire()
    return false
end

function modifier_ability_npc_patrool5_summons:OnCreated()
    self.parent = self:GetParent()
    self.bonus_damage = 0
    if not IsServer() then
        return
    end
    self.ability = self.parent:AddAbility("vengefulspirit_magic_missile")
    self.ability:SetLevel(4)
    self.ability:SetOverrideCastPoint(0)
    self.parent:AddNewModifier(self.parent, self.ability, "modifier_item_aghanims_shard", {})
end

function modifier_ability_npc_patrool5_summons:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
        MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE
    }
end

function modifier_ability_npc_patrool5_summons:GetModifierProcAttack_Feedback(data)
    if RandomInt(1, 100) < 25 then
        self.bonus_damage = data.target:GetMaxHealth() * 0.03
        self.parent:CastAbilityOnTarget(data.target, self.ability, -1)
    end
end

function modifier_ability_npc_patrool5_summons:GetModifierOverrideAbilitySpecial(data)
	if data.ability == self.ability and data.ability_special_value == "magic_missile_damage" then
        return 1
    end
end

function modifier_ability_npc_patrool5_summons:GetModifierOverrideAbilitySpecialValue(data)
	if data.ability == self.ability and data.ability_special_value == "magic_missile_damage" then
        return data.ability_special_value + self.bonus_damage
    end
end
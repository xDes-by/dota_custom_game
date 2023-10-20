ability_npc_boss_hell2_spell3 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_hell2_spell3","abilities/bosses/wolf_from_rpg/ability_npc_boss_hell2_spell3", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_hell2_spell3:GetIntrinsicModifierName()
    return "modifier_ability_npc_boss_hell2_spell3"
end

modifier_ability_npc_boss_hell2_spell3 = class({})

--Classifications template
function modifier_ability_npc_boss_hell2_spell3:IsHidden()
    return true
end

function modifier_ability_npc_boss_hell2_spell3:IsPurgable()
    return false
end

function modifier_ability_npc_boss_hell2_spell3:OnCreated()
    self.chance = self:GetAbility():GetSpecialValueFor("chance")
    if IsClient() then
        return
    end
    self:SetStackCount(self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()) * self:GetAbility():GetSpecialValueFor("damage_persent") * 0.01)
end

function modifier_ability_npc_boss_hell2_spell3:OnRefresh()
    self:OnCreated()
end

function modifier_ability_npc_boss_hell2_spell3:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_ability_npc_boss_hell2_spell3:GetModifierProcAttack_Feedback(data)
    if RollPercentage(self.chance) then
        ApplyDamage({victim = data.target,
        damage = self:GetStackCount(),
        damage_type = DAMAGE_TYPE_PHYSICAL,
        damage_flags = DOTA_DAMAGE_FLAG_IGNORES_PHYSICAL_ARMOR,
        attacker = self:GetCaster(),
        ability = self:GetAbility()})
    end
end
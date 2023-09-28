ability_npc_boss_barrack1_spell3 = class({})

LinkLuaModifier( "modifier_ability_npc_boss_barrack1_spell3","abilities/bosses/npc_boss_barrack1/ability_npc_boss_barrack1_spell3", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_ability_npc_boss_barrack1_spell3_aura_effect","abilities/bosses/npc_boss_barrack1/ability_npc_boss_barrack1_spell3", LUA_MODIFIER_MOTION_NONE )

function ability_npc_boss_barrack1_spell3:GetIntrinsicModifierName()
    return "modifier_ability_npc_boss_barrack1_spell3"
end

modifier_ability_npc_boss_barrack1_spell3 = class({})

--Classifications template
function modifier_ability_npc_boss_barrack1_spell3:IsHidden()
    return true
end

function modifier_ability_npc_boss_barrack1_spell3:IsPurgable()
    return false
end

function modifier_ability_npc_boss_barrack1_spell3:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_ability_npc_boss_barrack1_spell3:OnCreated()
    self.stun_duration = self:GetAbility():GetSpecialValueFor("stun_duration")
end

function modifier_ability_npc_boss_barrack1_spell3:GetModifierProcAttack_Feedback(data)
    if self:GetAbility():IsCooldownReady() then
        EmitSoundOn("DOTA_Item.AbyssalBlade.Activate", data.target)
        data.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_stunned", {duration = self.stun_duration})
        self:GetAbility():UseResources(false, false, false, true)
    end
end

-- Aura template
function modifier_ability_npc_boss_barrack1_spell3:IsAura()
    return true
end

function modifier_ability_npc_boss_barrack1_spell3:GetModifierAura()
    return "modifier_ability_npc_boss_barrack1_spell3_aura_effect"
end

function modifier_ability_npc_boss_barrack1_spell3:GetAuraRadius()
    return 500
end

function modifier_ability_npc_boss_barrack1_spell3:GetAuraDuration()
    return 0.5
end

function modifier_ability_npc_boss_barrack1_spell3:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_ability_npc_boss_barrack1_spell3:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_ability_npc_boss_barrack1_spell3:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

modifier_ability_npc_boss_barrack1_spell3_aura_effect = class({})
--Classifications template
function modifier_ability_npc_boss_barrack1_spell3_aura_effect:IsHidden()
    return false
end

function modifier_ability_npc_boss_barrack1_spell3_aura_effect:RemoveOnDeath()
    return true
end

function modifier_ability_npc_boss_barrack1_spell3_aura_effect:OnCreated()
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.miss = self:GetAbility():GetSpecialValueFor("miss")
    if IsClient() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_ability_npc_boss_barrack1_spell3_aura_effect:OnIntervalThink()
    ApplyDamage({victim = self:GetParent(),
    damage = self.damage * 5,
    damage_type = DAMAGE_TYPE_MAGICAL,
    damage_flags = DOTA_DAMAGE_FLAG_NONE,
    attacker = self:GetCaster(),
    ability = self:GetAbility()})
end

function modifier_ability_npc_boss_barrack1_spell3_aura_effect:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MISS_PERCENTAGE
    }
end

function modifier_ability_npc_boss_barrack1_spell3_aura_effect:GetModifierMiss_Percentage()
    return self.miss
end

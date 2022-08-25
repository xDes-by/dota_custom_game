lycan_summon_wolves_critical_strike_lane_creep = class({})

LinkLuaModifier( "modifier_lycan_summon_wolves_critical_strike_lane_creep","abilities/lane_creeps/lycan_summon_wolves_critical_strike_lane_creep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_lycan_summon_wolves_critical_strike_lane_creep_effect","abilities/lane_creeps/lycan_summon_wolves_critical_strike_lane_creep", LUA_MODIFIER_MOTION_NONE )

function lycan_summon_wolves_critical_strike_lane_creep:GetIntrinsicModifierName()
    return "modifier_lycan_summon_wolves_critical_strike_lane_creep"
end

modifier_lycan_summon_wolves_critical_strike_lane_creep = class({})

--Classifications template
function modifier_lycan_summon_wolves_critical_strike_lane_creep:IsHidden()
    return true
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep:IsPurgable()
    return false
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep:RemoveOnDeath()
    return true
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep:DestroyOnExpire()
    return true
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep:OnCreated()
    self.chance = self:GetAbility():GetSpecialValueFor("chance")
    self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PROCATTACK_FEEDBACK
    }
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep:GetModifierProcAttack_Feedback(data)
    if RandomInt(1,100) < self.chance then
        data.target:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_lycan_summon_wolves_critical_strike_lane_creep_effect", {duration = self.duration})
    end
end

modifier_lycan_summon_wolves_critical_strike_lane_creep_effect = class({})
--Classifications template
function modifier_lycan_summon_wolves_critical_strike_lane_creep_effect:IsHidden()
    return false
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep_effect:IsDebuff()
    return true
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep_effect:IsPurgable()
    return true
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep_effect:RemoveOnDeath()
    return true
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep_effect:DestroyOnExpire()
    return true
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep_effect:OnCreated()
    self.damage = self:GetAbility():GetSpecialValueFor("damage")
    self.movespeed_slow = self:GetAbility():GetSpecialValueFor("movespeed_slow") * 0.01
    self.attack = self:GetParent():GetAttackSpeed() * self:GetAbility():GetSpecialValueFor("attackspeed_slow") * -0.01
    if IsClient() then
        return
    end
    self:StartIntervalThink(1)
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep_effect:OnIntervalThink()
    ApplyDamage({victim = self:GetParent(),
    damage = self.damage,
    damage_type = DAMAGE_TYPE_MAGICAL,
    damage_flags = DOTA_DAMAGE_FLAG_NONE,
    attacker = self:GetCaster(),
    ability = self:GetAbility()})
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep_effect:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
        MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
    }
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep_effect:GetModifierMoveSpeedBonus_Percentage()
    return self.movespeed_slow
end

function modifier_lycan_summon_wolves_critical_strike_lane_creep_effect:GetModifierAttackSpeedBonus_Constant()
    return self.attack
end

elder_titan_natural_order_lane_creep = class({})

LinkLuaModifier( "modifier_elder_titan_natural_order_lane_creep","abilities/lane_creeps/elder_titan_natural_order_lane_creep", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_elder_titan_natural_order_lane_creep_effect","abilities/lane_creeps/elder_titan_natural_order_lane_creep", LUA_MODIFIER_MOTION_NONE )

function elder_titan_natural_order_lane_creep:GetIntrinsicModifierName()
    return "modifier_elder_titan_natural_order_lane_creep"
end

modifier_elder_titan_natural_order_lane_creep = class({})

--Classifications template
function modifier_elder_titan_natural_order_lane_creep:IsHidden()
    return true
end

function modifier_elder_titan_natural_order_lane_creep:IsPurgable()
    return false
end

function modifier_elder_titan_natural_order_lane_creep:RemoveOnDeath()
    return true
end

-- Aura template
function modifier_elder_titan_natural_order_lane_creep:IsAura()
    return true
end

function modifier_elder_titan_natural_order_lane_creep:GetModifierAura()
    return "modifier_elder_titan_natural_order_lane_creep_effect"
end

function modifier_elder_titan_natural_order_lane_creep:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("radius")
end

function modifier_elder_titan_natural_order_lane_creep:GetAuraDuration()
    return 0.5
end

function modifier_elder_titan_natural_order_lane_creep:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_elder_titan_natural_order_lane_creep:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

function modifier_elder_titan_natural_order_lane_creep:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_NONE
end

modifier_elder_titan_natural_order_lane_creep_effect = class({})
--Classifications template
function modifier_elder_titan_natural_order_lane_creep_effect:IsHidden()
    return false
end

function modifier_elder_titan_natural_order_lane_creep_effect:IsDebuff()
    return true
end

function modifier_elder_titan_natural_order_lane_creep_effect:IsPurgable()
    return false
end

function modifier_elder_titan_natural_order_lane_creep_effect:RemoveOnDeath()
    return true
end

function modifier_elder_titan_natural_order_lane_creep_effect:OnCreated()
    self.armor = self:GetParent():GetPhysicalArmorValue(false) * self:GetAbility():GetSpecialValueFor("reduce") * -0.01
end

function modifier_elder_titan_natural_order_lane_creep_effect:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS
    }
end

function modifier_elder_titan_natural_order_lane_creep_effect:GetModifierPhysicalArmorBonus()
    return self.armor
end
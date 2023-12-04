LinkLuaModifier( "modifier_vengeful_spirit_command_aura", "heroes/hero_vengeful_spirit/command_aura/command_aura" ,LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_vengeful_spirit_command_aura_buff", "heroes/hero_vengeful_spirit/command_aura/command_aura" ,LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "modifier_vengefulspirit_bkb", "heroes/hero_vengeful_spirit/command_aura/modifier_vengefulspirit_bkb" ,LUA_MODIFIER_MOTION_NONE )

if vengeful_spirit_command_aura == nil then
    vengeful_spirit_command_aura = class({})
end

--------------------------------------------------------------------------------
-- function vengeful_spirit_command_aura:GetBehavior()
--     if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_str10") then
--         return DOTA_ABILITY_BEHAVIOR_NO_TARGET 
--     end
-- end

-- function vengeful_spirit_command_aura:GetCooldown()
-- 	if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_str10") then
-- 		return 60
-- 	end
-- end

-- function vengeful_spirit_command_aura:GetManaCost(iLevel)
--     if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_str10") then
-- 		return 100 + math.min(65000, self:GetCaster():GetIntellect() /100)
-- 	end
-- 	return 0
-- end

function vengeful_spirit_command_aura:GetIntrinsicModifierName()
    return "modifier_vengeful_spirit_command_aura"
end

function vengeful_spirit_command_aura:OnSpellStart()
	EmitSoundOn("DOTA_Item.BlackKingBar.Activate", self:GetCaster())
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_vengefulspirit_bkb", {duration = 3})
end

function vengeful_spirit_command_aura:OnOwnerDied()
    -- if self:IsTrained() and not self:GetCaster():IsIllusion() and not self:GetCaster():PassivesDisabled() then
    --     local bounty_base = self:GetCaster():GetLevel() * 2
        
    --     local illusion = CreateIllusions(self:GetCaster(), self:GetCaster(), 
    --     {
    --         outgoing_damage             = 100 - self:GetSpecialValueFor("illusion_damage_out_pct"),
    --         incoming_damage             = self:GetSpecialValueFor("illusion_damage_in_pct") - 100,
    --         bounty_base                 = bounty_base,
    --         bounty_growth               = nil,
    --         outgoing_damage_structure   = nil,
    --         outgoing_damage_roshan      = nil,
    --         duration                    = nil
    --     }
    --     , 1, self:GetCaster():GetHullRadius(), true, true)
    
    --     for _, illus in pairs(illusion) do
    --         illus:SetHealth(illus:GetMaxHealth())
    --         illus:AddNewModifier(self:GetCaster(), self, "modifier_hybrid_special", {})
    --         FindClearSpaceForUnit(illus, self:GetCaster():GetAbsOrigin() + Vector(RandomInt(0, 1), RandomInt(0, 1), 0) * 108, true)
    --     end
    -- end
end

--------------------------------------------------------------------------------


modifier_vengeful_spirit_command_aura = class({
    IsHidden                = function(self) return true end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
})


--------------------------------------------------------------------------------

function modifier_vengeful_spirit_command_aura:IsAura()
    return true
end

function modifier_vengeful_spirit_command_aura:GetModifierAura()
    return "modifier_vengeful_spirit_command_aura_buff"
end

function modifier_vengeful_spirit_command_aura:GetAuraRadius()
    return self:GetAbility():GetSpecialValueFor("aura_radius")
end

function modifier_vengeful_spirit_command_aura:GetAuraDuration()
    return 0.5
end

function modifier_vengeful_spirit_command_aura:GetAuraSearchTeam()    
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_vengeful_spirit_command_aura:GetAuraSearchType()    
    return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_vengeful_spirit_command_aura:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD
end

--------------------------------------------------------------------------------


modifier_vengeful_spirit_command_aura_buff = class({
    IsHidden                = function(self) return false end,
    IsPurgable              = function(self) return false end,
    IsDebuff                = function(self) return false end,
    IsBuff                  = function(self) return true end,
    RemoveOnDeath           = function(self) return true end,
    DeclareFunctions        = function(self)
        return {
            MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
            MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
            MODIFIER_PROPERTY_TOOLTIP,
            MODIFIER_PROPERTY_TOOLTIP2,
            MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
            MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
            MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
        }
    end,
    OnTooltip               = function(self) return self:CalculateBonusDamage() end,
    OnTooltip2               = function(self) return self:CalculateBonusStrength() end,
})


--------------------------------------------------------------------------------

function modifier_vengeful_spirit_command_aura_buff:CalculateBonusDamage()
    local base_damage_perc = self:GetAbility():GetSpecialValueFor("bonus_base_damage")
    if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi13") then
        base_damage_perc = base_damage_perc * 3
    end
    if self:GetParent() ~= self:GetCaster() then
        base_damage_perc = base_damage_perc * self:GetAbility():GetSpecialValueFor("self_multi")
    end
    return base_damage_perc
end

function modifier_vengeful_spirit_command_aura_buff:GetModifierBaseDamageOutgoing_Percentage()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi13") == nil then
        return self:CalculateBonusDamage()
    end
end

function modifier_vengeful_spirit_command_aura_buff:GetModifierDamageOutgoing_Percentage()
	if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_agi13") then
        return self:CalculateBonusDamage()
    end
end

function modifier_vengeful_spirit_command_aura_buff:CalculateBonusStrength()
    if self.lock1 then return end
    bonus = 0
    if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_str7") then
        self.lock1 = true
        local str = self:GetParent():GetStrength()
        self.lock1 = false
        bonus = str*0.30
        if self:GetParent() ~= self:GetCaster() then
            bonus = bonus * self:GetAbility():GetSpecialValueFor("self_multi")
        end
    end
    return bonus
end

function modifier_vengeful_spirit_command_aura_buff:GetModifierBonusStats_Strength()
    return self:CalculateBonusStrength()
end

function modifier_vengeful_spirit_command_aura_buff:GetModifierHealthRegenPercentage()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_str10") then
        if self:GetParent() ~= self:GetCaster() then
            return 3 * self:GetAbility():GetSpecialValueFor("self_multi")
        else
            return 3
        end
    end
end

function modifier_vengeful_spirit_command_aura_buff:GetModifierBonusStats_Intellect()
    if self:GetCaster():FindAbilityByName("npc_dota_hero_vengefulspirit_int9") and self:GetCaster() == self:GetParent() then
        return self:GetCaster():GetStrength() * 0.6
    end
end
-- function modifier_vengeful_spirit_command_aura_buff:GetModifierBonusStats_Agility()
--     if self:GetParent():GetPrimaryAttribute() == 1 and self:GetAbility() then 
--         return self:GetAbility():GetSpecialValueFor("bonus_attributes")
--     end
--     return
-- end

-- function modifier_vengeful_spirit_command_aura_buff:GetModifierBonusStats_Intellect()
--     if self:GetParent():GetPrimaryAttribute() == 2 and self:GetAbility() then 
--         return self:GetAbility():GetSpecialValueFor("bonus_attributes")
--     end
--     return
-- end
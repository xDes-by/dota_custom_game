item_spirit_vessel_lua = class({})

function item_spirit_vessel_lua:OnSpellStart()
    self:GetCursorTarget():AddNewModifier(self:GetCaster(), self, "modifier_item_spirit_vessel_lua_debuff", {duration = self:GetSpecialValueFor("duration")})
    local p = ParticleManager:CreateParticle("particles/items4_fx/spirit_vessel_cast.vpcf", PATTACH_POINT, self:GetCaster())
    ParticleManager:SetParticleControl(p, 0, self:GetCaster():GetAbsOrigin())
    ParticleManager:SetParticleControl(p, 1, self:GetCursorTarget():GetAbsOrigin())
    ParticleManager:ReleaseParticleIndex(p)
    EmitSoundOn("DOTA_Item.SpiritVessel.Cast", self:GetCaster())
    EmitSoundOn("DOTA_Item.SpiritVessel.Target.Enemy", self:GetCursorTarget())
end

function item_spirit_vessel_lua:GetIntrinsicModifierName()
    return "modifier_item_spirit_vessel_lua"
end

LinkLuaModifier("modifier_item_spirit_vessel_lua", "items/custom_items/item_spirit_vessel_lua.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_spirit_vessel_lua_debuff", "items/custom_items/item_spirit_vessel_lua.lua", LUA_MODIFIER_MOTION_NONE)

modifier_item_spirit_vessel_lua = class({})
--Classifications template
function modifier_item_spirit_vessel_lua:IsHidden()
    return true
end

function modifier_item_spirit_vessel_lua:IsDebuff()
    return false
end

function modifier_item_spirit_vessel_lua:IsPurgable()
    return false
end

function modifier_item_spirit_vessel_lua:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_item_spirit_vessel_lua:IsStunDebuff()
    return false
end

function modifier_item_spirit_vessel_lua:RemoveOnDeath()
    return false
end

function modifier_item_spirit_vessel_lua:DestroyOnExpire()
    return false
end

function modifier_item_spirit_vessel_lua:OnCreated()
    self.bonus_mana_regen = self:GetAbility():GetSpecialValueFor("bonus_mana_regen")
    self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
    self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
    self.bonus_health = self:GetAbility():GetSpecialValueFor("bonus_health")
    self.bonus_all_stats = self:GetAbility():GetSpecialValueFor("bonus_all_stats")
end

function modifier_item_spirit_vessel_lua:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
        MODIFIER_PROPERTY_HEALTH_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
    }
end

function modifier_item_spirit_vessel_lua:GetModifierConstantManaRegen()
    return self.bonus_mana_regen
end

function modifier_item_spirit_vessel_lua:GetModifierPhysicalArmorBonus()
    return self.bonus_armor
end

function modifier_item_spirit_vessel_lua:GetModifierHealthBonus()
    return self.bonus_health
end

function modifier_item_spirit_vessel_lua:GetModifierBonusStats_Intellect()
    return self.bonus_all_stats
end

function modifier_item_spirit_vessel_lua:GetModifierBonusStats_Strength()
    return self.bonus_all_stats
end

function modifier_item_spirit_vessel_lua:GetModifierBonusStats_Agility()
    return self.bonus_all_stats
end

modifier_item_spirit_vessel_lua_debuff = class({})
--Classifications template
function modifier_item_spirit_vessel_lua_debuff:IsHidden()
    return false
end

function modifier_item_spirit_vessel_lua_debuff:IsDebuff()
    return true
end

function modifier_item_spirit_vessel_lua_debuff:IsPurgable()
    return false
end

function modifier_item_spirit_vessel_lua_debuff:IsPurgeException()
    return false
end

-- Optional Classifications
function modifier_item_spirit_vessel_lua_debuff:IsStunDebuff()
    return false
end

function modifier_item_spirit_vessel_lua_debuff:RemoveOnDeath()
    return true
end

function modifier_item_spirit_vessel_lua_debuff:DestroyOnExpire()
    return true
end

function modifier_item_spirit_vessel_lua_debuff:OnCreated()
    self.hp_regen_reduction_enemy = self:GetAbility():GetSpecialValueFor("hp_regen_reduction_enemy")
    self.soul_damage_amount = self:GetAbility():GetSpecialValueFor("soul_damage_amount")
    self.enemy_hp_drain = self:GetAbility():GetSpecialValueFor("enemy_hp_drain") * 0.01
    if not IsServer() then
        return
    end
    self:StartIntervalThink(1)
    self:SetHasCustomTransmitterData( true )
end

function modifier_item_spirit_vessel_lua_debuff:OnIntervalThink()
    self.damage_amplify = self.soul_damage_amount + self:GetCaster():GetIntellect() + self:GetCaster():GetStrength() + self:GetCaster():GetAgility()
    self.damage = self:GetParent():GetHealth() * self.enemy_hp_drain + self.damage_amplify * self:GetCaster():GetSpellAmplification(false)
    self:SendBuffRefreshToClients()
    ApplyDamage({
        victim = self:GetParent(),
        attacker = self:GetCaster(),
        damage = self.damage,
        damage_type = DAMAGE_TYPE_MAGICAL,
        damage_flags = DOTA_DAMAGE_FLAG_NO_SPELL_AMPLIFICATION,
        ability = self:GetAbility()
    })
end

function modifier_item_spirit_vessel_lua_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_HP_REGEN_AMPLIFY_PERCENTAGE,
        MODIFIER_PROPERTY_TOOLTIP
    }
end

function modifier_item_spirit_vessel_lua_debuff:GetModifierHPRegenAmplify_Percentage()
    return self.hp_regen_reduction_enemy * -1
end

function modifier_item_spirit_vessel_lua_debuff:OnTooltip()
    return self.damage
end

function modifier_item_spirit_vessel_lua_debuff:GetEffectName()
    return "particles/items4_fx/spirit_vessel_damage.vpcf"
end
  
function modifier_item_spirit_vessel_lua_debuff:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_spirit_vessel_lua_debuff:AddCustomTransmitterData()
    return {
        damage = self.damage,
    }
end

function modifier_item_spirit_vessel_lua_debuff:HandleCustomTransmitterData( data )
    self.damage = data.damage
end


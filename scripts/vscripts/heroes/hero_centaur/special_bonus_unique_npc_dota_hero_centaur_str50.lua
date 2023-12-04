LinkLuaModifier("modifier_special_bonus_unique_npc_dota_hero_centaur_str50", "heroes/hero_centaur/special_bonus_unique_npc_dota_hero_centaur_str50", LUA_MODIFIER_MOTION_NONE)
special_bonus_unique_npc_dota_hero_centaur_str50 = class({})

function special_bonus_unique_npc_dota_hero_centaur_str50:GetIntrinsicModifierName()
	return "modifier_special_bonus_unique_npc_dota_hero_centaur_str50"
end

function special_bonus_unique_npc_dota_hero_centaur_str50:OnHeroLevelUp()
    local atr = self:GetCaster():GetPrimaryAttribute()
    if atr == DOTA_ATTRIBUTE_STRENGTH then
        self:GetCaster():SetBaseStrength(self:GetCaster():GetBaseStrength() + 20)
    elseif atr == DOTA_ATTRIBUTE_AGILITY then
        self:GetCaster():SetBaseAgility(self:GetCaster():GetBaseAgility() + 20)
    elseif atr == DOTA_ATTRIBUTE_INTELLECT then
        self:GetCaster():SetBaseIntellect(self:GetCaster():GetBaseIntellect() + 20)
    end
end

modifier_special_bonus_unique_npc_dota_hero_centaur_str50 = class({})

function modifier_special_bonus_unique_npc_dota_hero_centaur_str50:IsHidden()
    return true
end

function modifier_special_bonus_unique_npc_dota_hero_centaur_str50:IsPurgable()
    return false
end

function modifier_special_bonus_unique_npc_dota_hero_centaur_str50:RemoveOnDeath()
    return false
end

function modifier_special_bonus_unique_npc_dota_hero_centaur_str50:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
        MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
        MODIFIER_PROPERTY_STATS_INTELLECT_BONUS
    }
end

function modifier_special_bonus_unique_npc_dota_hero_centaur_str50:OnCreated( kv )
    self.caster = self:GetCaster()
    self.attribute = self.caster:GetPrimaryAttribute()
end

function modifier_special_bonus_unique_npc_dota_hero_centaur_str50:GetModifierBonusStats_Strength()
    if self.attribute == DOTA_ATTRIBUTE_STRENGTH then
        return self.caster:GetLevel() * 20
    end
end

function modifier_special_bonus_unique_npc_dota_hero_centaur_str50:GetModifierBonusStats_Agility()
    if self.attribute == DOTA_ATTRIBUTE_AGILITY then
        return self.caster:GetLevel() * 20
    end
end

function modifier_special_bonus_unique_npc_dota_hero_centaur_str50:GetModifierBonusStats_Intellect()
    if self.attribute == DOTA_ATTRIBUTE_INTELLECT then
        return self.caster:GetLevel() * 20
    end
end
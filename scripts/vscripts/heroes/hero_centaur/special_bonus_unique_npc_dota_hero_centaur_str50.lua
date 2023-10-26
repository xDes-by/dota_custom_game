special_bonus_unique_npc_dota_hero_centaur_str50 = class({})

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

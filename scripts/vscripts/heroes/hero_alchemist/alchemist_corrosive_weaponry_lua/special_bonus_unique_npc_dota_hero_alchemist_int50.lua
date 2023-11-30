special_bonus_unique_npc_dota_hero_alchemist_int50 = class({})

function special_bonus_unique_npc_dota_hero_alchemist_int50:OnUpgrade()
    self:GetCaster():FindAbilityByName("alchemist_corrosive_weaponry_lua"):SetHidden(false)
end
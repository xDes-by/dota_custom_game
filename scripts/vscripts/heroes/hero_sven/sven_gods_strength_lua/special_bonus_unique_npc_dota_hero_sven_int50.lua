special_bonus_unique_npc_dota_hero_sven_int50 = class({})

function special_bonus_unique_npc_dota_hero_sven_int50:OnUpgrade()
    self:GetCaster():FindAbilityByName("sven_gods_strength_lua"):RefreshCharges()
end
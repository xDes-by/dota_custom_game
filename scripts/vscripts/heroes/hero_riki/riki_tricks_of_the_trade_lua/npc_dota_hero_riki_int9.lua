npc_dota_hero_riki_int9 = class({})

function npc_dota_hero_riki_int9:OnUpgrade()
    self:GetCaster():FindAbilityByName("riki_tricks_of_the_trade_lua"):RefreshCharges()
end
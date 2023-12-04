npc_dota_hero_vengefulspirit_str12 = class({})

function npc_dota_hero_vengefulspirit_str12:OnUpgrade()
    self:GetCaster():FindAbilityByName("vengeful_tempest_double"):RefreshCharges()
end
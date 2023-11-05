npc_dota_hero_death_prophet_agi6 = class({})

function npc_dota_hero_death_prophet_agi6:OnUpgrade()
    self:GetCaster():FindAbilityByName("death_prophet_exorcism_bh"):RefreshCharges()
end